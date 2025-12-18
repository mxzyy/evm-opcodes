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

get_contracts() {
  local file="$1"
  if [[ "$search_tool" == "rg" ]]; then
    rg --no-heading --pcre2 -o 'contract\s+([A-Za-z_][A-Za-z0-9_]*)' "$file" | sed -E 's/contract\s+//'
  else
    grep -oE 'contract\s+[A-Za-z_][A-Za-z0-9_]*' "$file" | sed -E 's/contract\s+//'
  fi
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
          echo ""
          echo "╔════════════════════════════════════════════════════════════════╗"
          echo "║                      RUNTIME CODE                              ║"
          echo "║                  (Deployed Contract Code)                      ║"
          echo "╚════════════════════════════════════════════════════════════════╝"
          echo ""
          
          # Reset offset to 0 for runtime code
          new_offset=$((decimal_offset - runtime_offset_dec))
          new_hex=$(printf '%08x' "$new_offset")
          echo "${new_hex}:${rest}"
        else
          echo "$line"
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
    bytecode_file="${OUT_DIR}/${contract}--Bytecodes.txt"
    opcode_file="${OUT_DIR}/${contract}--Opcodes.txt"
    opcode_file_tmp="${OUT_DIR}/${contract}--Opcodes.tmp"
    opcode_file_fixed="${OUT_DIR}/${contract}--Opcodes-fixed.tmp"

    echo "Inspecting ${target}"
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
        
        # Step 4: Split and reset offsets
        split_opcodes "$opcode_file_fixed" "$opcode_file" "$runtime_offset"
        
        # Clean up temp files
        rm -f "$opcode_file_tmp" "$opcode_file_fixed"
        
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
echo "════════════════════════════════════════════════════════════════"