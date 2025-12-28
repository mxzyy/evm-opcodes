#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="src"
OUT_DIR="disassembly"
MAX_PADDING=64

for cmd in forge cast; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
done

if command -v rg >/dev/null 2>&1; then
  search_tool="rg"
elif command -v grep >/dev/null 2>&1; then
  search_tool="grep"
else
  echo "Missing required search tool: install ripgrep (rg) or ensure grep is available" >&2
  exit 1
fi

# Check for jq (optional, for JSON parsing)
if command -v jq >/dev/null 2>&1; then
  json_parser="jq"
else
  json_parser="sed"
fi

# Global associative array for function selectors
declare -A SELECTORS
declare -A FUNCTION_BODIES

get_contracts() {
  local file="$1"
  if [[ "$search_tool" == "rg" ]]; then
    rg --no-heading --pcre2 -o 'contract\s+([A-Za-z_][A-Za-z0-9_]*)' "$file" | sed -E 's/contract\s+//'
  else
    grep -oE 'contract\s+[A-Za-z_][A-Za-z0-9_]*' "$file" | sed -E 's/contract\s+//'
  fi
}

# ══════════════════════════════════════════════════════════════════
# Extract function selectors from contract using forge inspect
# Populates SELECTORS associative array: selector -> signature
# ══════════════════════════════════════════════════════════════════
extract_selectors() {
  local target="$1"

  # Clear previous selectors
  SELECTORS=()

  local json_output
  json_output=$(forge inspect "$target" methodIdentifiers --json 2>/dev/null) || return 1

  if [[ "$json_parser" == "jq" ]]; then
    # Use jq for parsing
    while IFS=: read -r selector sig; do
      if [[ -n "$selector" && -n "$sig" ]]; then
        SELECTORS["$selector"]="$sig"
      fi
    done < <(echo "$json_output" | jq -r 'to_entries[] | "\(.value):\(.key)"')
  else
    # Fallback to sed parsing
    # Input format: {"func(type)":"selector",...}
    # Remove braces and split by comma
    local cleaned
    cleaned=$(echo "$json_output" | tr -d '{}' | tr ',' '\n')
    while IFS=: read -r sig selector; do
      # Remove quotes
      sig=$(echo "$sig" | tr -d '"')
      selector=$(echo "$selector" | tr -d '"' | tr -d ' ')
      if [[ -n "$selector" && -n "$sig" ]]; then
        SELECTORS["$selector"]="$sig"
      fi
    done <<< "$cleaned"
  fi
}

# ══════════════════════════════════════════════════════════════════
# Annotate PUSH4 instructions with function signatures
# ══════════════════════════════════════════════════════════════════
annotate_push4() {
  local input_file="$1"
  local output_file="$2"

  while IFS= read -r line; do
    # Match PUSH4 0xXXXXXXXX pattern (without existing comment)
    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+(PUSH4)[[:space:]]+(0x[0-9a-fA-F]{8})$ ]]; then
      local offset="${BASH_REMATCH[1]}"
      local opcode="${BASH_REMATCH[2]}"
      local selector="${BASH_REMATCH[3]}"

      # Remove 0x prefix for lookup
      local selector_clean="${selector:2}"

      # Look up in SELECTORS array
      if [[ -n "${SELECTORS[$selector_clean]:-}" ]]; then
        local sig="${SELECTORS[$selector_clean]}"
        echo "${offset}: ${opcode} ${selector} # ${sig}"
      else
        echo "$line"
      fi
    else
      echo "$line"
    fi
  done < "$input_file" > "$output_file"
}

# ══════════════════════════════════════════════════════════════════
# Map function body entry points from dispatcher
# Extracts PUSH4 selector -> PUSH2 target offset mapping
# Only maps targets from the pattern: PUSH4 -> EQ -> PUSH2 -> JUMPI
# ══════════════════════════════════════════════════════════════════
map_function_bodies() {
  local input_file="$1"

  # Clear previous mappings
  FUNCTION_BODIES=()

  local prev_selector=""
  local eq_seen=false
  local in_dispatcher=false
  local dispatcher_done=false

  while IFS= read -r line; do
    # Detect dispatcher section header
    if [[ "$line" =~ "FUNCTION DISPATCHER" ]]; then
      in_dispatcher=true
      continue
    fi

    # Detect function bodies section header - stop processing
    if [[ "$line" =~ "FUNCTION BODIES" ]]; then
      break
    fi

    if [[ "$in_dispatcher" == false ]]; then
      continue
    fi

    # Track PUSH4 selectors
    if [[ "$line" =~ PUSH4[[:space:]]+(0x[0-9a-fA-F]{8}) ]]; then
      prev_selector="${BASH_REMATCH[1]:2}"  # Remove 0x
      eq_seen=false
    fi

    # Track EQ instruction
    if [[ "$line" =~ ^[0-9a-fA-F]+:[[:space:]]+EQ$ ]] && [[ -n "$prev_selector" ]]; then
      eq_seen=true
    fi

    # Capture PUSH2 target only after EQ (the actual function body offset)
    if [[ "$line" =~ PUSH2[[:space:]]+(0x[0-9a-fA-F]+) ]] && [[ "$eq_seen" == true ]]; then
      local target="${BASH_REMATCH[1]}"
      # Convert to decimal for lookup
      local target_dec=$((16#${target:2}))
      local target_hex=$(printf '%08x' "$target_dec")

      if [[ -n "${SELECTORS[$prev_selector]:-}" ]]; then
        FUNCTION_BODIES["$target_hex"]="${SELECTORS[$prev_selector]}"
      fi
      # Reset state after capturing
      eq_seen=false
    fi

    # Reset eq_seen on JUMPI (we've passed the pattern)
    if [[ "$line" =~ JUMPI ]] && [[ "$eq_seen" == true ]]; then
      eq_seen=false
    fi

    # GT resets selector tracking (new comparison branch)
    if [[ "$line" =~ ^[0-9a-fA-F]+:[[:space:]]+GT$ ]]; then
      eq_seen=false
    fi
  done < "$input_file"
}

# ══════════════════════════════════════════════════════════════════
# Annotate function body entry points (JUMPDEST)
# ══════════════════════════════════════════════════════════════════
annotate_function_bodies() {
  local input_file="$1"
  local output_file="$2"

  while IFS= read -r line; do
    # Match JUMPDEST at offset
    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+JUMPDEST$ ]]; then
      local offset="${BASH_REMATCH[1]}"

      # Check if this offset is a function entry point
      if [[ -n "${FUNCTION_BODIES[$offset]:-}" ]]; then
        local sig="${FUNCTION_BODIES[$offset]}"
        echo "${offset}: JUMPDEST # === ${sig} ==="
      else
        echo "$line"
      fi
    else
      echo "$line"
    fi
  done < "$input_file" > "$output_file"
}

# ══════════════════════════════════════════════════════════════════
# Detect metadata section offset (CBOR encoded)
# Returns offset where metadata starts (INVALID opcode)
# ══════════════════════════════════════════════════════════════════
detect_metadata_offset() {
  local input_file="$1"

  while IFS= read -r line; do
    # Look for INVALID followed by LOG2 (CBOR signature 0xa2)
    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+INVALID$ ]]; then
      echo "${BASH_REMATCH[1]}"
      return
    fi
  done < "$input_file"
}

# ══════════════════════════════════════════════════════════════════
# Detect error handler offsets (Panic handlers)
# ══════════════════════════════════════════════════════════════════
detect_error_handlers() {
  local input_file="$1"

  while IFS= read -r line; do
    # Look for PUSH32 with panic signature 0x4e487b71
    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+PUSH32[[:space:]]+0x4e487b71 ]]; then
      echo "${BASH_REMATCH[1]}"
    fi
  done < "$input_file"
}

# ══════════════════════════════════════════════════════════════════
# Add section headers to runtime code
# Detects metadata (INVALID) and error handlers (panic signature)
# ══════════════════════════════════════════════════════════════════
add_section_headers() {
  local input_file="$1"
  local output_file="$2"

  # State tracking
  local in_runtime=false
  local error_header_printed=false
  local metadata_header_printed=false

  {
    while IFS= read -r line; do
      # Detect RUNTIME CODE or FUNCTION BODIES section
      if [[ "$line" =~ "RUNTIME CODE" ]] || [[ "$line" =~ "FUNCTION BODIES" ]]; then
        in_runtime=true
      fi

      if [[ "$in_runtime" == true ]]; then
        # Detect error handler section (Panic signature: 0x4e487b71)
        if [[ "$line" =~ PUSH32[[:space:]]+0x4e487b71 ]] && [[ "$error_header_printed" == false ]]; then
          echo ""
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║                      ERROR HANDLERS                            ║"
          echo "║                  (Panic & Revert Logic)                        ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          error_header_printed=true
        fi

        # Detect metadata section (INVALID opcode followed by LOG2)
        if [[ "$line" =~ ^[0-9a-fA-F]+:[[:space:]]+INVALID$ ]] && [[ "$metadata_header_printed" == false ]]; then
          echo ""
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║                         METADATA                               ║"
          echo "║                    (CBOR Encoded Data)                         ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          metadata_header_printed=true
        fi
      fi

      echo "$line"
    done < "$input_file"
  } > "$output_file"
}

# ══════════════════════════════════════════════════════════════════
# Convert cast's 1-based offsets to EVM's 0-based offsets
# ══════════════════════════════════════════════════════════════════
fix_offsets() {
  local input_file="$1"
  local output_file="$2"
  
  while IFS= read -r line; do
    if [[ "$line" =~ ^([0-9a-fA-F]+):(.*)$ ]]; then
      hex_offset="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
      
      decimal_offset=$((16#$hex_offset))
      
      if ((decimal_offset > 0)); then
        new_decimal=$((decimal_offset - 1))
      else
        new_decimal=0
      fi
      
      new_hex=$(printf '%08x' "$new_decimal")
      
      echo "${new_hex}:${rest}"
    else
      echo "$line"
    fi
  done < "$input_file" > "$output_file"
}

# ══════════════════════════════════════════════════════════════════
# Detect runtime code offset by finding CODECOPY pattern
# Returns the offset where runtime code starts, or empty if not found
# ══════════════════════════════════════════════════════════════════
detect_runtime_offset() {
  local opcode_file="$1"
  local runtime_offset=""
  local prev_line=""
  local prev_prev_line=""
  
  while IFS= read -r line; do
    # Look for pattern: PUSH2/PUSH1 0xXXXX ... CODECOPY
    # The PUSH before CODECOPY usually contains runtime code offset
    if [[ "$line" =~ CODECOPY ]]; then
      # Check previous line for PUSH0 or PUSH1
      if [[ "$prev_line" =~ ^([0-9a-fA-F]+):[[:space:]]+(PUSH0|PUSH1) ]]; then
        # Look two lines back for PUSH2 with the offset
        if [[ "$prev_prev_line" =~ ^([0-9a-fA-F]+):[[:space:]]+PUSH[1-9][[:space:]]+0x([0-9a-fA-F]+) ]]; then
          runtime_offset="${BASH_REMATCH[2]}"
          break
        fi
      fi
    fi
    
    prev_prev_line="$prev_line"
    prev_line="$line"
  done < "$opcode_file"
  
  echo "$runtime_offset"
}

# ══════════════════════════════════════════════════════════════════
# Split opcodes into creation and runtime code sections
# Also adds preamble, dispatcher, and function bodies section headers
# ══════════════════════════════════════════════════════════════════
split_opcodes() {
  local input_file="$1"
  local output_file="$2"
  local runtime_offset_hex="$3"

  if [[ -z "$runtime_offset_hex" ]]; then
    # No split needed, just copy
    cp "$input_file" "$output_file"
    return
  fi

  local runtime_offset_dec=$((16#$runtime_offset_hex))
  local in_creation=true
  local in_runtime=false
  local preamble_header_printed=false
  local dispatcher_header_printed=false
  local bodies_header_printed=false
  local dispatcher_revert_seen=false

  {
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║                      CREATION CODE                             ║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""

    while IFS= read -r line; do
      if [[ "$line" =~ ^([0-9a-fA-F]+):(.*)$ ]]; then
        hex_offset="${BASH_REMATCH[1]}"
        rest="${BASH_REMATCH[2]}"
        decimal_offset=$((16#$hex_offset))

        if $in_creation && ((decimal_offset >= runtime_offset_dec)); then
          # Switch to runtime section
          in_creation=false
          in_runtime=true
          echo ""
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║                      RUNTIME CODE                              ║"
          echo "║                  (Deployed Contract Code)                      ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
        fi

        if $in_creation; then
          # Keep original offset for creation code
          echo "$line"
        else
          # Reset offset for runtime code
          new_offset=$((decimal_offset - runtime_offset_dec))
          new_hex=$(printf '%08x' "$new_offset")
          local new_line="${new_hex}:${rest}"

          # Add preamble header at start of runtime code
          if [[ "$preamble_header_printed" == false ]]; then
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                        PREAMBLE                                ║"
            echo "║              Memory Init & Callvalue Check                     ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            preamble_header_printed=true
          fi

          # Detect dispatcher start (CALLDATALOAD)
          if [[ "$rest" =~ CALLDATALOAD ]] && [[ "$dispatcher_header_printed" == false ]]; then
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                   FUNCTION DISPATCHER                          ║"
            echo "║             Routes Calls to Function Bodies                    ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            dispatcher_header_printed=true
          fi

          # Detect dispatcher end (REVERT after JUMPDEST in dispatcher section)
          if [[ "$rest" =~ ^[[:space:]]*REVERT$ ]] && [[ "$dispatcher_header_printed" == true ]] && [[ "$bodies_header_printed" == false ]]; then
            dispatcher_revert_seen=true
          fi

          # Detect function bodies start (JUMPDEST after dispatcher REVERT)
          if [[ "$rest" =~ ^[[:space:]]*JUMPDEST ]] && [[ "$dispatcher_revert_seen" == true ]] && [[ "$bodies_header_printed" == false ]]; then
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                    FUNCTION BODIES                             ║"
            echo "║              External Function Implementations                 ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            bodies_header_printed=true
          fi

          echo "$new_line"
        fi
      else
        echo "$line"
      fi
    done < "$input_file"
  } > "$output_file"
}

mkdir -p "$OUT_DIR"

mapfile -t solidity_files < <(find "$SRC_DIR" -type f -name '*.sol' | sort)
if ((${#solidity_files[@]} == 0)); then
  echo "No Solidity files found in ${SRC_DIR}" >&2
  exit 1
fi

for sol_file in "${solidity_files[@]}"; do
  mapfile -t contracts < <(get_contracts "$sol_file")
  if ((${#contracts[@]} == 0)); then
    continue
  fi

  for contract in "${contracts[@]}"; do
    target="${sol_file}:${contract}"
    bytecode_file="${OUT_DIR}/${contract}-Bytecodes.evm"
    opcode_file="${OUT_DIR}/${contract}-Opcodes.evm"
    opcode_file_tmp="${OUT_DIR}/${contract}--Opcodes.tmp"
    opcode_file_fixed="${OUT_DIR}/${contract}--Opcodes-fixed.tmp"
    opcode_file_split="${OUT_DIR}/${contract}--Opcodes-split.tmp"
    opcode_file_push4="${OUT_DIR}/${contract}--Opcodes-push4.tmp"
    opcode_file_bodies="${OUT_DIR}/${contract}--Opcodes-bodies.tmp"

    echo "Inspecting ${target}"

    # Step 0: Extract function selectors
    echo "  ↳ Extracting function selectors..."
    if ! extract_selectors "$target"; then
      echo "  ⚠ Could not extract selectors for ${target}" >&2
    else
      echo "  ✓ Found ${#SELECTORS[@]} function selectors"
    fi

    if ! bytecode=$(forge inspect "$target" bytecode 2>&1); then
      echo "forge inspect failed for ${target}: ${bytecode}" >&2
      continue
    fi

    bytecode="$(printf '%s' "$bytecode" | tr -d '\n\r')"
    echo "$bytecode" >"$bytecode_file"

    candidate="$bytecode"
    pad_count=0
    while :; do
      if output=$(cast disassemble "$candidate" 2>&1); then
        # Step 1: Save raw output
        echo "$output" >"$opcode_file_tmp"

        # Step 2: Fix offsets (1-based to 0-based)
        fix_offsets "$opcode_file_tmp" "$opcode_file_fixed"

        # Step 3: Detect runtime code offset
        runtime_offset=$(detect_runtime_offset "$opcode_file_fixed")

        # Step 4: Split and reset offsets + add section headers
        split_opcodes "$opcode_file_fixed" "$opcode_file_split" "$runtime_offset"

        # Step 5: Annotate PUSH4 instructions with function signatures
        echo "  ↳ Annotating function selectors..."
        annotate_push4 "$opcode_file_split" "$opcode_file_push4"

        # Step 6: Map function body entry points from dispatcher
        map_function_bodies "$opcode_file_push4"

        # Step 7: Annotate function body entry points (JUMPDEST)
        echo "  ↳ Annotating function body entry points..."
        annotate_function_bodies "$opcode_file_push4" "$opcode_file_bodies"

        # Step 8: Add metadata and error handler section headers
        echo "  ↳ Adding section headers..."
        add_section_headers "$opcode_file_bodies" "$opcode_file"

        # Clean up temp files
        rm -f "$opcode_file_tmp" "$opcode_file_fixed" "$opcode_file_split" \
              "$opcode_file_push4" "$opcode_file_bodies"

        if [[ -n "$runtime_offset" ]]; then
          echo "✓ Saved opcodes to ${opcode_file} (split at 0x${runtime_offset})"
        else
          echo "✓ Saved opcodes to ${opcode_file}"
        fi
        break
      fi

      if [[ "$output" == *"Error: incomplete sequence of bytecode"* ]]; then
        candidate="${candidate}00"
        ((++pad_count))
        if ((pad_count > MAX_PADDING)); then
          echo "⚠ Giving up after ${MAX_PADDING} padding attempts for ${target}" >&2
          break
        fi
        continue
      else
        echo "✗ Disassembly failed for ${target}: ${output}" >&2
        break
      fi
    done
  done
done

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✓ Disassembly complete"
echo "  - Offsets converted to 0-based (EVM standard)"
echo "  - Creation and Runtime code separated"
echo "  - Runtime code offsets reset to 0"
echo "  - Section headers added (Preamble, Dispatcher, Bodies, etc.)"
echo "  - Function selectors annotated with signatures"
echo "  - Function body entry points marked"
echo "════════════════════════════════════════════════════════════════"