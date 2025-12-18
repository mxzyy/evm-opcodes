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
# FIX: Function to adjust offset from 1-indexed to 0-indexed
# ══════════════════════════════════════════════════════════════════
fix_offsets() {
  local input_file="$1"
  local output_file="$2"
  
  # Read each line, parse offset, subtract 1, reformat
  while IFS= read -r line; do
    if [[ "$line" =~ ^([0-9a-fA-F]+):(.*)$ ]]; then
      # Extract hex offset and rest of line
      hex_offset="${BASH_REMATCH[1]}"
      rest="${BASH_REMATCH[2]}"
      
      # Convert to decimal, subtract 1, convert back to hex
      decimal_offset=$((16#$hex_offset))
      if ((decimal_offset > 0)); then
        new_decimal=$((decimal_offset - 1))
      else
        new_decimal=0
      fi
      
      # Format as 8-digit hex (like original)
      new_hex=$(printf '%08x' "$new_decimal")
      
      echo "${new_hex}:${rest}"
    else
      # Line doesn't match pattern, output as-is
      echo "$line"
    fi
  done < "$input_file" > "$output_file"
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
    opcode_file_tmp="${OUT_DIR}/${contract} Opcodes.tmp"

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
        # Save raw output to temp file
        echo "$output" >"$opcode_file_tmp"
        
        # Fix offsets (subtract 1) and save to final file
        fix_offsets "$opcode_file_tmp" "$opcode_file"
        
        # Clean up temp file
        rm -f "$opcode_file_tmp"
        
        echo "Saved opcodes to ${opcode_file} (offsets fixed)"
        break
      fi

      if [[ "$output" == *"Error: incomplete sequence of bytecode"* ]]; then
        candidate="${candidate}00"
        ((++pad_count))
        if ((pad_count > MAX_PADDING)); then
          echo "Giving up after ${MAX_PADDING} padding attempts for ${target}" >&2
          break
        fi
        continue
      else
        echo "Disassembly failed for ${target}: ${output}" >&2
        break
      fi
    done
  done
done