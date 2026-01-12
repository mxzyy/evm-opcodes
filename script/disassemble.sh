#!/usr/bin/env bash
set -euo pipefail

# ══════════════════════════════════════════════════════════════════════════════
# EVM Bytecode Disassembler with Advanced Analysis
# ══════════════════════════════════════════════════════════════════════════════

SRC_DIR="src"
OUT_DIR="disassembly"
MAX_PADDING=64

# Feature flags (default: OFF for backward compatibility)
ENABLE_STACK_PREVIEW=false
ENABLE_STORAGE_ANNOTATIONS=false
ENABLE_GAS_TRACKING=false
ENABLE_CFG_ASCII=false
ENABLE_MEMORY_TRACKING=false
VERBOSE=false

# ══════════════════════════════════════════════════════════════════════════════
# Usage and Help
# ══════════════════════════════════════════════════════════════════════════════
show_help() {
  cat << 'EOF'
EVM Bytecode Disassembler with Advanced Analysis

Usage: ./disassemble.sh [OPTIONS]

Options:
  --stack-preview          Enable stack simulation (shows stack state after each instruction)
  --storage-annotations    Enable storage slot annotations (maps SLOAD/SSTORE to variable names)
  --gas-tracking           Enable gas cost tracking (shows individual and cumulative costs)
  --cfg-ascii              Generate ASCII control flow graph
  --memory-tracking        Enable memory layout tracking
  --all                    Enable all analysis features
  --verbose                Enable verbose/debug output
  --help                   Show this help message

Examples:
  ./disassemble.sh                           # Basic disassembly (existing behavior)
  ./disassemble.sh --stack-preview           # With stack simulation
  ./disassemble.sh --all                     # Full analysis
  ./disassemble.sh --gas-tracking --storage-annotations  # Custom combination

Output:
  Disassembled bytecode is saved to disassembly/<SolFileName>/<ContractName>-Opcodes.asm
  Bytecode files are saved to disassembly/<SolFileName>/<ContractName>-Bytecodes.hex
EOF
  exit 0
}

# ══════════════════════════════════════════════════════════════════════════════
# Parse Command Line Arguments
# ══════════════════════════════════════════════════════════════════════════════
parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --stack-preview)
        ENABLE_STACK_PREVIEW=true
        shift
        ;;
      --storage-annotations)
        ENABLE_STORAGE_ANNOTATIONS=true
        shift
        ;;
      --gas-tracking)
        ENABLE_GAS_TRACKING=true
        shift
        ;;
      --cfg-ascii)
        ENABLE_CFG_ASCII=true
        shift
        ;;
      --memory-tracking)
        ENABLE_MEMORY_TRACKING=true
        shift
        ;;
      --all)
        ENABLE_STACK_PREVIEW=true
        ENABLE_STORAGE_ANNOTATIONS=true
        ENABLE_GAS_TRACKING=true
        ENABLE_CFG_ASCII=true
        ENABLE_MEMORY_TRACKING=true
        shift
        ;;
      --verbose)
        VERBOSE=true
        shift
        ;;
      --help|-h)
        show_help
        ;;
      *)
        echo "Unknown option: $1" >&2
        echo "Use --help for usage information" >&2
        exit 1
        ;;
    esac
  done
}

# Parse arguments before anything else
parse_args "$@"

# Debug output helper
debug() {
  if [[ "$VERBOSE" == true ]]; then
    echo "[DEBUG] $*" >&2
  fi
}

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

# Global associative arrays for function selectors
declare -A SELECTORS
declare -A FUNCTION_BODIES

# Storage layout mapping: slot -> "varName (type)"
declare -A STORAGE_SLOTS
declare -A STORAGE_TYPES

# Gas cost lookup table (EVM Cancun fork)
declare -A GAS_COSTS

# Stack simulation state
declare -a STACK
STACK_DEPTH=0

# Memory tracking state
declare -A MEMORY_STATE
FREE_MEM_PTR=128  # 0x80 default

# CFG data structures
declare -A CFG_NODES      # offset -> "opcode info"
declare -A CFG_EDGES      # source -> "target1,target2,..."
declare -A JUMP_TARGETS   # target offset -> 1 (for JUMPDEST validation)
declare -A BASIC_BLOCKS   # block_start -> "block_end"

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
# Initialize Gas Cost Lookup Table (EVM Cancun fork)
# ══════════════════════════════════════════════════════════════════
init_gas_costs() {
  # Zero gas
  GAS_COSTS["STOP"]=0

  # Arithmetic (3 gas)
  GAS_COSTS["ADD"]=3
  GAS_COSTS["SUB"]=3
  GAS_COSTS["LT"]=3
  GAS_COSTS["GT"]=3
  GAS_COSTS["SLT"]=3
  GAS_COSTS["SGT"]=3
  GAS_COSTS["EQ"]=3
  GAS_COSTS["ISZERO"]=3
  GAS_COSTS["AND"]=3
  GAS_COSTS["OR"]=3
  GAS_COSTS["XOR"]=3
  GAS_COSTS["NOT"]=3
  GAS_COSTS["BYTE"]=3
  GAS_COSTS["SHL"]=3
  GAS_COSTS["SHR"]=3
  GAS_COSTS["SAR"]=3
  GAS_COSTS["SIGNEXTEND"]=5

  # Arithmetic (5 gas)
  GAS_COSTS["MUL"]=5
  GAS_COSTS["DIV"]=5
  GAS_COSTS["SDIV"]=5
  GAS_COSTS["MOD"]=5
  GAS_COSTS["SMOD"]=5

  # Arithmetic (8 gas)
  GAS_COSTS["ADDMOD"]=8
  GAS_COSTS["MULMOD"]=8

  # Exp (10 + 50*bytes)
  GAS_COSTS["EXP"]="10+"

  # Keccak256 (30 + 6*words)
  GAS_COSTS["KECCAK256"]="30+"
  GAS_COSTS["SHA3"]="30+"

  # Environment (2 gas)
  GAS_COSTS["ADDRESS"]=2
  GAS_COSTS["ORIGIN"]=2
  GAS_COSTS["CALLER"]=2
  GAS_COSTS["CALLVALUE"]=2
  GAS_COSTS["CALLDATASIZE"]=2
  GAS_COSTS["CODESIZE"]=2
  GAS_COSTS["GASPRICE"]=2
  GAS_COSTS["RETURNDATASIZE"]=2
  GAS_COSTS["COINBASE"]=2
  GAS_COSTS["TIMESTAMP"]=2
  GAS_COSTS["NUMBER"]=2
  GAS_COSTS["PREVRANDAO"]=2
  GAS_COSTS["GASLIMIT"]=2
  GAS_COSTS["CHAINID"]=2
  GAS_COSTS["SELFBALANCE"]=5
  GAS_COSTS["BASEFEE"]=2
  GAS_COSTS["BLOBHASH"]=3
  GAS_COSTS["BLOBBASEFEE"]=2

  # Calldataload (3 gas)
  GAS_COSTS["CALLDATALOAD"]=3
  GAS_COSTS["CALLDATACOPY"]="3+"
  GAS_COSTS["CODECOPY"]="3+"
  GAS_COSTS["RETURNDATACOPY"]="3+"
  GAS_COSTS["EXTCODESIZE"]=2600
  GAS_COSTS["EXTCODECOPY"]="2600+"
  GAS_COSTS["EXTCODEHASH"]=2600

  # Balance (warm/cold)
  GAS_COSTS["BALANCE"]="100/2600"

  # Block info
  GAS_COSTS["BLOCKHASH"]=20

  # Stack operations (2-3 gas)
  GAS_COSTS["POP"]=2
  GAS_COSTS["MLOAD"]=3
  GAS_COSTS["MSTORE"]=3
  GAS_COSTS["MSTORE8"]=3

  # Storage (warm/cold)
  GAS_COSTS["SLOAD"]="100/2100"
  GAS_COSTS["SSTORE"]="100/20000"
  GAS_COSTS["TLOAD"]=100
  GAS_COSTS["TSTORE"]=100

  # Jump operations
  GAS_COSTS["JUMP"]=8
  GAS_COSTS["JUMPI"]=10
  GAS_COSTS["PC"]=2
  GAS_COSTS["MSIZE"]=2
  GAS_COSTS["GAS"]=2
  GAS_COSTS["JUMPDEST"]=1
  GAS_COSTS["MCOPY"]="3+"

  # Push operations (3 gas)
  for i in {0..32}; do
    GAS_COSTS["PUSH$i"]=3
  done
  GAS_COSTS["PUSH0"]=2

  # Dup operations (3 gas)
  for i in {1..16}; do
    GAS_COSTS["DUP$i"]=3
  done

  # Swap operations (3 gas)
  for i in {1..16}; do
    GAS_COSTS["SWAP$i"]=3
  done

  # Log operations (375 + 375*topics + 8*data)
  GAS_COSTS["LOG0"]="375+"
  GAS_COSTS["LOG1"]="750+"
  GAS_COSTS["LOG2"]="1125+"
  GAS_COSTS["LOG3"]="1500+"
  GAS_COSTS["LOG4"]="1875+"

  # Create operations
  GAS_COSTS["CREATE"]=32000
  GAS_COSTS["CREATE2"]="32000+"

  # Call operations (warm/cold)
  GAS_COSTS["CALL"]="100/2600"
  GAS_COSTS["CALLCODE"]="100/2600"
  GAS_COSTS["DELEGATECALL"]="100/2600"
  GAS_COSTS["STATICCALL"]="100/2600"

  # Return operations
  GAS_COSTS["RETURN"]=0
  GAS_COSTS["REVERT"]=0
  GAS_COSTS["INVALID"]=0
  GAS_COSTS["SELFDESTRUCT"]=5000
}

# ══════════════════════════════════════════════════════════════════
# Extract storage layout from contract using forge inspect
# Populates STORAGE_SLOTS and STORAGE_TYPES arrays
# ══════════════════════════════════════════════════════════════════
extract_storage_layout() {
  local target="$1"

  # Clear previous storage layout
  STORAGE_SLOTS=()
  STORAGE_TYPES=()

  local json_output
  json_output=$(forge inspect "$target" storageLayout --json 2>/dev/null) || {
    debug "Could not extract storage layout for $target"
    return 1
  }

  if [[ "$json_parser" == "jq" ]]; then
    # Parse storage layout using jq
    while IFS='|' read -r slot label type_name; do
      if [[ -n "$slot" && -n "$label" ]]; then
        STORAGE_SLOTS["$slot"]="$label"
        STORAGE_TYPES["$slot"]="$type_name"
        debug "Storage slot $slot -> $label ($type_name)"
      fi
    done < <(echo "$json_output" | jq -r '.storage[]? | "\(.slot)|\(.label)|\(.type)"' 2>/dev/null)
  else
    # Fallback parsing without jq (basic extraction)
    # This is a simplified parser for the storage layout
    local in_storage=false
    while IFS= read -r line; do
      if [[ "$line" =~ \"storage\" ]]; then
        in_storage=true
      fi
      if [[ "$in_storage" == true ]]; then
        if [[ "$line" =~ \"slot\":.*\"([0-9]+)\" ]]; then
          current_slot="${BASH_REMATCH[1]}"
        fi
        if [[ "$line" =~ \"label\":.*\"([^\"]+)\" ]]; then
          STORAGE_SLOTS["$current_slot"]="${BASH_REMATCH[1]}"
        fi
        if [[ "$line" =~ \"type\":.*\"([^\"]+)\" ]]; then
          STORAGE_TYPES["$current_slot"]="${BASH_REMATCH[1]}"
        fi
      fi
    done <<< "$json_output"
  fi

  debug "Extracted ${#STORAGE_SLOTS[@]} storage slots"
  return 0
}

# ══════════════════════════════════════════════════════════════════
# Get gas cost for an opcode
# Returns: gas cost string (may include + for dynamic costs)
# ══════════════════════════════════════════════════════════════════
get_gas_cost() {
  local opcode="$1"

  # Handle PUSH with value (e.g., "PUSH4" from "PUSH4 0x...")
  if [[ "$opcode" =~ ^PUSH([0-9]+)$ ]]; then
    local n="${BASH_REMATCH[1]}"
    if [[ "$n" == "0" ]]; then
      echo "2"
    else
      echo "3"
    fi
    return
  fi

  # Handle DUP and SWAP
  if [[ "$opcode" =~ ^DUP([0-9]+)$ ]] || [[ "$opcode" =~ ^SWAP([0-9]+)$ ]]; then
    echo "3"
    return
  fi

  # Handle LOG
  if [[ "$opcode" =~ ^LOG([0-4])$ ]]; then
    local n="${BASH_REMATCH[1]}"
    local base=$((375 + 375 * n))
    echo "${base}+"
    return
  fi

  # Lookup in table
  if [[ -n "${GAS_COSTS[$opcode]:-}" ]]; then
    echo "${GAS_COSTS[$opcode]}"
  else
    echo "?"
  fi
}

# ══════════════════════════════════════════════════════════════════
# Format gas cost for display
# ══════════════════════════════════════════════════════════════════
format_gas_display() {
  local gas="$1"
  local opcode="$2"

  case "$gas" in
    "100/2100")
      echo "100 (warm) / 2100 (cold)"
      ;;
    "100/2600")
      echo "100 (warm) / 2600 (cold)"
      ;;
    "100/20000")
      if [[ "$opcode" == "SSTORE" ]]; then
        echo "100 (warm) / 20000 (cold new)"
      else
        echo "100 (warm) / 20000 (cold)"
      fi
      ;;
    *"+")
      echo "${gas%+} (base + dynamic)"
      ;;
    *)
      echo "$gas"
      ;;
  esac
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - initialize/reset stack
# ══════════════════════════════════════════════════════════════════
stack_reset() {
  STACK=()
  STACK_DEPTH=0
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - push value onto stack
# ══════════════════════════════════════════════════════════════════
stack_push() {
  local value="$1"
  if ((STACK_DEPTH < 1024)); then
    STACK[$STACK_DEPTH]="$value"
    ((STACK_DEPTH++)) || true
  fi
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - pop value from stack
# Returns: the popped value or "UNDERFLOW"
# ══════════════════════════════════════════════════════════════════
stack_pop() {
  if ((STACK_DEPTH > 0)); then
    local idx=$((STACK_DEPTH - 1))
    local value="${STACK[$idx]:-?}"
    unset 'STACK[$idx]'
    ((STACK_DEPTH--)) || true
    echo "$value"
  else
    echo "UNDERFLOW"
  fi
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - peek at stack position (0 = top)
# ══════════════════════════════════════════════════════════════════
stack_peek() {
  local pos="${1:-0}"
  local idx=$((STACK_DEPTH - 1 - pos))
  if ((idx >= 0 && idx < STACK_DEPTH)); then
    echo "${STACK[$idx]}"
  else
    echo "?"
  fi
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - get current stack display (top 4 items)
# Optimized for performance - uses direct array access
# ══════════════════════════════════════════════════════════════════
stack_display() {
  if ((STACK_DEPTH == 0)); then
    echo "[]"
    return
  fi

  local result="["
  local idx=$((STACK_DEPTH - 1))

  # Show top item
  result+="${STACK[$idx]:-?}"

  # Show up to 3 more items
  if ((STACK_DEPTH > 1)); then
    result+=", ${STACK[$((idx-1))]:-?}"
  fi
  if ((STACK_DEPTH > 2)); then
    result+=", ${STACK[$((idx-2))]:-?}"
  fi
  if ((STACK_DEPTH > 3)); then
    result+=", ${STACK[$((idx-3))]:-?}"
  fi
  if ((STACK_DEPTH > 4)); then
    result+=", ...+$((STACK_DEPTH - 4))"
  fi

  result+="]"
  echo "$result"
}

# ══════════════════════════════════════════════════════════════════
# Stack simulation - simulate opcode execution
# Updates stack state based on opcode
# ══════════════════════════════════════════════════════════════════
simulate_opcode() {
  local opcode="$1"
  local operand="${2:-}"

  case "$opcode" in
    STOP|RETURN|REVERT|INVALID|SELFDESTRUCT)
      stack_reset
      ;;

    # Push operations
    PUSH0)
      stack_push "0x0"
      ;;
    PUSH1|PUSH2|PUSH3|PUSH4|PUSH5|PUSH6|PUSH7|PUSH8|PUSH9|PUSH10|\
    PUSH11|PUSH12|PUSH13|PUSH14|PUSH15|PUSH16|PUSH17|PUSH18|PUSH19|PUSH20|\
    PUSH21|PUSH22|PUSH23|PUSH24|PUSH25|PUSH26|PUSH27|PUSH28|PUSH29|PUSH30|\
    PUSH31|PUSH32)
      stack_push "$operand"
      ;;

    # Pop-only operations
    POP)
      stack_pop >/dev/null
      ;;

    # Dup operations
    DUP1)
      local v=$(stack_peek 0)
      stack_push "$v"
      ;;
    DUP2)
      local v=$(stack_peek 1)
      stack_push "$v"
      ;;
    DUP3)
      local v=$(stack_peek 2)
      stack_push "$v"
      ;;
    DUP4)
      local v=$(stack_peek 3)
      stack_push "$v"
      ;;
    DUP5|DUP6|DUP7|DUP8|DUP9|DUP10|DUP11|DUP12|DUP13|DUP14|DUP15|DUP16)
      local n="${opcode#DUP}"
      local v=$(stack_peek $((n - 1)))
      stack_push "$v"
      ;;

    # Swap operations
    SWAP1)
      if ((STACK_DEPTH >= 2)); then
        local tmp="${STACK[-1]}"
        STACK[-1]="${STACK[-2]}"
        STACK[-2]="$tmp"
      fi
      ;;
    SWAP2|SWAP3|SWAP4|SWAP5|SWAP6|SWAP7|SWAP8|SWAP9|SWAP10|SWAP11|SWAP12|SWAP13|SWAP14|SWAP15|SWAP16)
      local n="${opcode#SWAP}"
      local idx=$((STACK_DEPTH - 1 - n))
      if ((idx >= 0)); then
        local tmp="${STACK[-1]}"
        STACK[-1]="${STACK[$idx]}"
        STACK[$idx]="$tmp"
      fi
      ;;

    # Binary operations (pop 2, push 1)
    ADD|SUB|MUL|DIV|SDIV|MOD|SMOD|EXP|SIGNEXTEND|LT|GT|SLT|SGT|EQ|AND|OR|XOR|BYTE|SHL|SHR|SAR)
      local a=$(stack_pop)
      local b=$(stack_pop)
      # Push symbolic result
      case "$opcode" in
        ADD) stack_push "[${a}+${b}]" ;;
        SUB) stack_push "[${a}-${b}]" ;;
        MUL) stack_push "[${a}*${b}]" ;;
        DIV|SDIV) stack_push "[${a}/${b}]" ;;
        MOD|SMOD) stack_push "[${a}%${b}]" ;;
        LT|GT|SLT|SGT|EQ) stack_push "[cmp]" ;;
        AND) stack_push "[${a}&${b}]" ;;
        OR) stack_push "[${a}|${b}]" ;;
        XOR) stack_push "[${a}^${b}]" ;;
        SHL) stack_push "[${b}<<${a}]" ;;
        SHR) stack_push "[${b}>>${a}]" ;;
        SAR) stack_push "[${b}>>>${a}]" ;;
        *) stack_push "[arith]" ;;
      esac
      ;;

    # Ternary operations (pop 3, push 1)
    ADDMOD|MULMOD)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_push "[mod_arith]"
      ;;

    # Unary operations (pop 1, push 1)
    ISZERO|NOT)
      local a=$(stack_pop)
      if [[ "$opcode" == "ISZERO" ]]; then
        stack_push "[!${a}]"
      else
        stack_push "[~${a}]"
      fi
      ;;

    # Environment info (push 1)
    ADDRESS)
      stack_push "[ADDRESS]"
      ;;
    BALANCE)
      stack_pop >/dev/null
      stack_push "[BALANCE]"
      ;;
    ORIGIN)
      stack_push "[ORIGIN]"
      ;;
    CALLER)
      stack_push "[CALLER]"
      ;;
    CALLVALUE)
      stack_push "[CALLVALUE]"
      ;;
    CALLDATASIZE)
      stack_push "[CALLDATASIZE]"
      ;;
    CALLDATALOAD)
      local offset=$(stack_pop)
      stack_push "[CD@${offset}]"
      ;;
    CALLDATACOPY)
      stack_pop >/dev/null  # destOffset
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # size
      ;;
    CODESIZE)
      stack_push "[CODESIZE]"
      ;;
    CODECOPY)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    GASPRICE)
      stack_push "[GASPRICE]"
      ;;
    EXTCODESIZE)
      stack_pop >/dev/null
      stack_push "[EXTCODESIZE]"
      ;;
    EXTCODECOPY)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    RETURNDATASIZE)
      stack_push "[RETSIZE]"
      ;;
    RETURNDATACOPY)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    EXTCODEHASH)
      stack_pop >/dev/null
      stack_push "[EXTCODEHASH]"
      ;;

    # Block info (push 1)
    BLOCKHASH)
      stack_pop >/dev/null
      stack_push "[BLOCKHASH]"
      ;;
    COINBASE)
      stack_push "[COINBASE]"
      ;;
    TIMESTAMP)
      stack_push "[TIMESTAMP]"
      ;;
    NUMBER)
      stack_push "[BLOCKNUMBER]"
      ;;
    PREVRANDAO)
      stack_push "[PREVRANDAO]"
      ;;
    GASLIMIT)
      stack_push "[GASLIMIT]"
      ;;
    CHAINID)
      stack_push "[CHAINID]"
      ;;
    SELFBALANCE)
      stack_push "[SELFBALANCE]"
      ;;
    BASEFEE)
      stack_push "[BASEFEE]"
      ;;
    BLOBHASH)
      stack_pop >/dev/null
      stack_push "[BLOBHASH]"
      ;;
    BLOBBASEFEE)
      stack_push "[BLOBBASEFEE]"
      ;;

    # Memory operations
    MLOAD)
      local offset=$(stack_pop)
      stack_push "[M@${offset}]"
      ;;
    MSTORE|MSTORE8)
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # value
      ;;
    MSIZE)
      stack_push "[MSIZE]"
      ;;
    MCOPY)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;

    # Storage operations
    SLOAD)
      local slot=$(stack_pop)
      stack_push "[S@${slot}]"
      ;;
    SSTORE)
      stack_pop >/dev/null  # key
      stack_pop >/dev/null  # value
      ;;
    TLOAD)
      local slot=$(stack_pop)
      stack_push "[T@${slot}]"
      ;;
    TSTORE)
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;

    # Control flow
    JUMP)
      stack_pop >/dev/null  # target
      ;;
    JUMPI)
      stack_pop >/dev/null  # target
      stack_pop >/dev/null  # condition
      ;;
    JUMPDEST)
      # No stack change
      ;;
    PC)
      stack_push "[PC]"
      ;;
    GAS)
      stack_push "[GAS]"
      ;;

    # Logging (pop 2+topics)
    LOG0)
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # size
      ;;
    LOG1)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    LOG2)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    LOG3)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;
    LOG4)
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      stack_pop >/dev/null
      ;;

    # Create operations
    CREATE)
      stack_pop >/dev/null  # value
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # size
      stack_push "[CREATE]"
      ;;
    CREATE2)
      stack_pop >/dev/null  # value
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # size
      stack_pop >/dev/null  # salt
      stack_push "[CREATE2]"
      ;;

    # Call operations
    CALL|CALLCODE)
      stack_pop >/dev/null  # gas
      stack_pop >/dev/null  # addr
      stack_pop >/dev/null  # value
      stack_pop >/dev/null  # argsOffset
      stack_pop >/dev/null  # argsSize
      stack_pop >/dev/null  # retOffset
      stack_pop >/dev/null  # retSize
      stack_push "[CALL_RET]"
      ;;
    DELEGATECALL|STATICCALL)
      stack_pop >/dev/null  # gas
      stack_pop >/dev/null  # addr
      stack_pop >/dev/null  # argsOffset
      stack_pop >/dev/null  # argsSize
      stack_pop >/dev/null  # retOffset
      stack_pop >/dev/null  # retSize
      stack_push "[CALL_RET]"
      ;;

    # Keccak
    KECCAK256|SHA3)
      stack_pop >/dev/null  # offset
      stack_pop >/dev/null  # size
      stack_push "[KECCAK]"
      ;;

    *)
      debug "Unknown opcode for stack simulation: $opcode"
      ;;
  esac
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
# Memory tracking - reset state
# ══════════════════════════════════════════════════════════════════
memory_reset() {
  MEMORY_STATE=()
  FREE_MEM_PTR=128  # 0x80
}

# ══════════════════════════════════════════════════════════════════
# Memory tracking - update memory state based on opcode
# ══════════════════════════════════════════════════════════════════
memory_update() {
  local opcode="$1"
  local offset="${2:-}"
  local value="${3:-}"

  case "$opcode" in
    MSTORE)
      if [[ -n "$offset" && -n "$value" ]]; then
        # Track memory write
        if [[ "$offset" == "0x40" ]]; then
          # Free memory pointer update
          FREE_MEM_PTR="$value"
        fi
        MEMORY_STATE["$offset"]="$value"
      fi
      ;;
    MSTORE8)
      if [[ -n "$offset" && -n "$value" ]]; then
        MEMORY_STATE["$offset"]="${value:0:4}"  # Only 1 byte
      fi
      ;;
  esac
}

# ══════════════════════════════════════════════════════════════════
# Memory tracking - get memory region description
# ══════════════════════════════════════════════════════════════════
get_memory_region() {
  local offset_hex="$1"
  local offset_dec=$((16#${offset_hex#0x}))

  if ((offset_dec >= 0 && offset_dec < 64)); then
    echo "scratch space"
  elif ((offset_dec >= 64 && offset_dec < 96)); then
    echo "free memory pointer"
  elif ((offset_dec >= 96 && offset_dec < 128)); then
    echo "zero slot"
  else
    echo "dynamic allocation"
  fi
}

# ══════════════════════════════════════════════════════════════════
# Memory tracking - generate memory map display
# ══════════════════════════════════════════════════════════════════
memory_map_display() {
  local fmp="${FREE_MEM_PTR:-0x80}"

  cat << EOF
┌─────────────────────────────────────────┐
│ 0x00-0x3f: Scratch space                │
│ 0x40-0x5f: Free memory pointer [$fmp]   │
│ 0x60-0x7f: Zero slot                    │
│ 0x80+    : Dynamic allocations          │
└─────────────────────────────────────────┘
EOF
}

# ══════════════════════════════════════════════════════════════════
# CFG - collect jump targets and basic blocks
# ══════════════════════════════════════════════════════════════════
cfg_collect_data() {
  local input_file="$1"

  # Reset CFG data
  CFG_NODES=()
  CFG_EDGES=()
  JUMP_TARGETS=()
  BASIC_BLOCKS=()

  local prev_offset=""
  local block_start=""
  local in_runtime=false

  while IFS= read -r line; do
    # Skip until we're in runtime code
    if [[ "$line" =~ "RUNTIME CODE" ]] || [[ "$line" =~ "FUNCTION BODIES" ]]; then
      in_runtime=true
      continue
    fi

    if [[ "$in_runtime" == false ]]; then
      continue
    fi

    # Skip section headers and empty lines
    if [[ ! "$line" =~ ^[0-9a-fA-F]+: ]]; then
      continue
    fi

    # Parse offset and opcode
    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+([A-Z0-9]+)(.*)$ ]]; then
      local offset="${BASH_REMATCH[1]}"
      local opcode="${BASH_REMATCH[2]}"
      local rest="${BASH_REMATCH[3]}"

      CFG_NODES["$offset"]="$opcode$rest"

      # Start new basic block
      if [[ -z "$block_start" ]]; then
        block_start="$offset"
      fi

      # JUMPDEST marks a potential jump target
      if [[ "$opcode" == "JUMPDEST" ]]; then
        JUMP_TARGETS["$offset"]=1
        # End previous block if there was one
        if [[ -n "$prev_offset" && "$prev_offset" != "$offset" ]]; then
          BASIC_BLOCKS["$block_start"]="$prev_offset"
          block_start="$offset"
        fi
      fi

      # JUMP/JUMPI/STOP/RETURN/REVERT end basic blocks
      if [[ "$opcode" =~ ^(JUMP|JUMPI|STOP|RETURN|REVERT|INVALID|SELFDESTRUCT)$ ]]; then
        BASIC_BLOCKS["$block_start"]="$offset"
        block_start=""

        # For JUMP/JUMPI, try to extract target
        if [[ "$opcode" == "JUMP" || "$opcode" == "JUMPI" ]]; then
          # Target should be in previous PUSH
          # We'll collect this in a second pass for simplicity
          :
        fi
      fi

      prev_offset="$offset"
    fi
  done < "$input_file"

  # Close last block
  if [[ -n "$block_start" && -n "$prev_offset" ]]; then
    BASIC_BLOCKS["$block_start"]="$prev_offset"
  fi

  debug "CFG: Collected ${#CFG_NODES[@]} nodes, ${#BASIC_BLOCKS[@]} basic blocks"
}

# ══════════════════════════════════════════════════════════════════
# CFG - build edges by tracking PUSH+JUMP patterns
# ══════════════════════════════════════════════════════════════════
cfg_build_edges() {
  local input_file="$1"

  local in_runtime=false
  local prev_push_target=""
  local prev_offset=""

  while IFS= read -r line; do
    if [[ "$line" =~ "RUNTIME CODE" ]] || [[ "$line" =~ "FUNCTION BODIES" ]]; then
      in_runtime=true
      continue
    fi

    if [[ "$in_runtime" == false ]]; then
      continue
    fi

    if [[ ! "$line" =~ ^[0-9a-fA-F]+: ]]; then
      continue
    fi

    if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+([A-Z0-9]+)[[:space:]]*(0x[0-9a-fA-F]+)?(.*)$ ]]; then
      local offset="${BASH_REMATCH[1]}"
      local opcode="${BASH_REMATCH[2]}"
      local operand="${BASH_REMATCH[3]}"

      # Track PUSH values for jump targets
      if [[ "$opcode" =~ ^PUSH[0-9]+$ && -n "$operand" ]]; then
        prev_push_target="$operand"
      fi

      # JUMP - unconditional
      if [[ "$opcode" == "JUMP" && -n "$prev_push_target" ]]; then
        local target_dec=$((16#${prev_push_target#0x}))
        local target_hex=$(printf '%08x' "$target_dec")
        CFG_EDGES["$offset"]="$target_hex"
        prev_push_target=""
      fi

      # JUMPI - conditional (has two targets: jump target and fall-through)
      if [[ "$opcode" == "JUMPI" ]]; then
        if [[ -n "$prev_push_target" ]]; then
          local target_dec=$((16#${prev_push_target#0x}))
          local target_hex=$(printf '%08x' "$target_dec")
          # Fall-through target: need to find next instruction
          # For now, mark as conditional branch
          CFG_EDGES["$offset"]="$target_hex,fallthrough"
        fi
        prev_push_target=""
      fi

      # Reset on other opcodes that consume the value
      if [[ "$opcode" =~ ^(ADD|SUB|MUL|DIV|EQ|LT|GT|AND|OR|XOR|SLOAD|MLOAD|CALL)$ ]]; then
        prev_push_target=""
      fi

      prev_offset="$offset"
    fi
  done < "$input_file"
}

# ══════════════════════════════════════════════════════════════════
# CFG - generate ASCII control flow graph
# ══════════════════════════════════════════════════════════════════
cfg_generate_ascii() {
  local input_file="$1"

  echo ""
  echo "╔════════════════════════════════════════════════════════════════╗"
  echo "║                    CONTROL FLOW GRAPH                          ║"
  echo "╚════════════════════════════════════════════════════════════════╝"
  echo ""

  # For each function, show its basic blocks and edges
  local current_func=""

  for offset in $(echo "${!FUNCTION_BODIES[@]}" | tr ' ' '\n' | sort); do
    local func="${FUNCTION_BODIES[$offset]}"
    echo "┌────────────────────────────────────────┐"
    echo "│ Function: $func"
    echo "│ Entry: 0x$offset"
    echo "└────────────────────────────────────────┘"
    echo "    │"

    # Find edges from this block
    local block_end=""
    for bs in "${!BASIC_BLOCKS[@]}"; do
      if [[ "$bs" == "$offset" ]]; then
        block_end="${BASIC_BLOCKS[$bs]}"
        break
      fi
    done

    if [[ -n "$block_end" ]]; then
      # Check if there's a jump edge
      if [[ -n "${CFG_EDGES[$block_end]:-}" ]]; then
        local targets="${CFG_EDGES[$block_end]}"
        IFS=',' read -ra target_arr <<< "$targets"
        for t in "${target_arr[@]}"; do
          if [[ "$t" == "fallthrough" ]]; then
            echo "    ├──[continue]──→ [next instruction]"
          else
            local target_name="${FUNCTION_BODIES[$t]:-block}"
            echo "    ├──[JUMP]──→ [0x$t] $target_name"
          fi
        done
      fi
    fi
    echo ""
  done

  # Show detected loops (back edges)
  echo "┌────────────────────────────────────────┐"
  echo "│ Jump Targets (JUMPDEST locations):     │"
  echo "└────────────────────────────────────────┘"

  local count=0
  for target in $(echo "${!JUMP_TARGETS[@]}" | tr ' ' '\n' | sort); do
    echo "  • 0x$target"
    ((count++)) || true
    if ((count >= 20)); then
      echo "  ... and $((${#JUMP_TARGETS[@]} - count)) more"
      break
    fi
  done
  echo ""
}

# ══════════════════════════════════════════════════════════════════
# CFG - generate DOT format graph
# ══════════════════════════════════════════════════════════════════
cfg_generate_dot() {
  local output_file="$1"

  {
    echo "digraph CFG {"
    echo "  rankdir=TB;"
    echo "  node [shape=box, fontname=\"Courier\"];"
    echo "  edge [fontname=\"Courier\"];"
    echo ""

    # Add function entry nodes
    for offset in "${!FUNCTION_BODIES[@]}"; do
      local func="${FUNCTION_BODIES[$offset]}"
      local safe_func=$(echo "$func" | tr '(),' '_' | tr -d ' ')
      echo "  node_${offset} [label=\"${func}\\n0x${offset}\", style=filled, fillcolor=lightblue];"
    done
    echo ""

    # Add edges
    for src in "${!CFG_EDGES[@]}"; do
      local targets="${CFG_EDGES[$src]}"
      IFS=',' read -ra target_arr <<< "$targets"
      for t in "${target_arr[@]}"; do
        if [[ "$t" == "fallthrough" ]]; then
          # Skip fallthrough for now - need proper next-instruction tracking
          :
        else
          local src_label="${FUNCTION_BODIES[$src]:-block_$src}"
          local tgt_label="${FUNCTION_BODIES[$t]:-block_$t}"
          echo "  node_${src} -> node_${t};"
        fi
      done
    done
    echo ""

    # Add basic block clusters (optional, for better visualization)
    echo "  // Basic blocks"
    local cluster_id=0
    for block_start in "${!BASIC_BLOCKS[@]}"; do
      local block_end="${BASIC_BLOCKS[$block_start]}"
      if [[ -n "${FUNCTION_BODIES[$block_start]:-}" ]]; then
        # This is a function entry - already added
        :
      else
        echo "  node_${block_start} [label=\"0x${block_start}-0x${block_end}\"];"
      fi
      ((cluster_id++)) || true
    done

    echo "}"
  } > "$output_file"

  debug "CFG: Generated DOT file at $output_file"
}

# ══════════════════════════════════════════════════════════════════
# Advanced Analysis Pass - apply all enabled analysis features
# Adds gas costs, stack preview, storage annotations, memory tracking
# ══════════════════════════════════════════════════════════════════
apply_advanced_analysis() {
  local input_file="$1"
  local output_file="$2"

  # Initialize state
  stack_reset
  memory_reset
  local cumulative_gas=0
  local gas_uncertain=false
  local prev_push_value=""
  local prev_push_slot=""

  {
    while IFS= read -r line; do
      # Skip non-opcode lines (headers, empty lines)
      if [[ ! "$line" =~ ^[0-9a-fA-F]+: ]]; then
        echo "$line"
        continue
      fi

      # Parse the line: offset: OPCODE [operand] [# comment]
      local offset=""
      local opcode=""
      local operand=""
      local comment=""

      if [[ "$line" =~ ^([0-9a-fA-F]+):[[:space:]]+([A-Z0-9]+)([[:space:]]+[^#]+)?([[:space:]]*#.*)?$ ]]; then
        offset="${BASH_REMATCH[1]}"
        opcode="${BASH_REMATCH[2]}"
        operand="${BASH_REMATCH[3]:-}"
        comment="${BASH_REMATCH[4]:-}"
        # Trim whitespace from operand (avoid xargs as it may hang on empty input)
        operand="${operand#"${operand%%[![:space:]]*}"}"  # Trim leading
        operand="${operand%"${operand##*[![:space:]]}"}"  # Trim trailing
      else
        echo "$line"
        continue
      fi

      local annotations=""

      # ═══ Gas Cost Tracking ═══
      if [[ "$ENABLE_GAS_TRACKING" == true ]]; then
        local gas_cost=$(get_gas_cost "$opcode")
        local gas_display=$(format_gas_display "$gas_cost" "$opcode")

        # Update cumulative (simplified - just add base cost)
        if [[ "$gas_cost" =~ ^[0-9]+$ ]]; then
          cumulative_gas=$((cumulative_gas + gas_cost))
        elif [[ "$gas_cost" =~ ^([0-9]+)/ ]]; then
          # Warm/cold - use warm cost for estimate
          local warm="${BASH_REMATCH[1]}"
          cumulative_gas=$((cumulative_gas + warm))
          gas_uncertain=true
        elif [[ "$gas_cost" =~ ^([0-9]+)\+$ ]]; then
          local base="${BASH_REMATCH[1]}"
          cumulative_gas=$((cumulative_gas + base))
          gas_uncertain=true
        fi

        local total_display="$cumulative_gas"
        if [[ "$gas_uncertain" == true ]]; then
          total_display="${cumulative_gas}+"
        fi

        annotations+=" # gas: ${gas_display} (total: ${total_display})"
      fi

      # ═══ Storage Annotations ═══
      if [[ "$ENABLE_STORAGE_ANNOTATIONS" == true ]]; then
        # Track PUSH values for slot lookup
        if [[ "$opcode" =~ ^PUSH[0-9]+$ && -n "$operand" ]]; then
          prev_push_value="$operand"
          # Check if this is a known storage slot
          local slot_dec=$((16#${operand#0x}))
          if [[ -n "${STORAGE_SLOTS[$slot_dec]:-}" ]]; then
            prev_push_slot="$slot_dec"
            local var_name="${STORAGE_SLOTS[$slot_dec]}"
            local var_type="${STORAGE_TYPES[$slot_dec]:-}"
            annotations+=" # slot $slot_dec: $var_name"
            if [[ -n "$var_type" ]]; then
              annotations+=" ($var_type)"
            fi
          fi
        fi

        # Annotate SLOAD/SSTORE with variable names
        if [[ "$opcode" == "SLOAD" && -n "$prev_push_slot" ]]; then
          local var_name="${STORAGE_SLOTS[$prev_push_slot]}"
          annotations+=" # load: $var_name"
          prev_push_slot=""
        fi

        if [[ "$opcode" == "SSTORE" && -n "$prev_push_slot" ]]; then
          local var_name="${STORAGE_SLOTS[$prev_push_slot]}"
          annotations+=" # store: $var_name"
          prev_push_slot=""
        fi

        # Detect KECCAK256 for mapping access
        if [[ "$opcode" == "KECCAK256" || "$opcode" == "SHA3" ]]; then
          annotations+=" # mapping/array slot computation"
        fi
      fi

      # ═══ Memory Tracking ═══
      if [[ "$ENABLE_MEMORY_TRACKING" == true ]]; then
        # Annotate memory operations
        if [[ "$opcode" == "MLOAD" && -n "$prev_push_value" ]]; then
          local region=$(get_memory_region "$prev_push_value")
          annotations+=" # memory read: $region"
        fi

        if [[ "$opcode" == "MSTORE" && -n "$prev_push_value" ]]; then
          local region=$(get_memory_region "$prev_push_value")
          annotations+=" # memory write: $region"
          if [[ "$prev_push_value" == "0x40" ]]; then
            annotations+=" (free memory pointer)"
          fi
        fi
      fi

      # ═══ Stack Simulation ═══
      if [[ "$ENABLE_STACK_PREVIEW" == true ]]; then
        # Simulate this opcode
        simulate_opcode "$opcode" "$operand"

        # Get stack display
        local stack_state=$(stack_display)

        # Format output with stack column
        local base_line="${offset}: ${opcode}"
        if [[ -n "$operand" ]]; then
          base_line+=" ${operand}"
        fi

        # Combine existing comment with annotations
        local full_comment=""
        if [[ -n "$comment" ]]; then
          full_comment="${comment}"
        fi
        if [[ -n "$annotations" ]]; then
          if [[ -n "$full_comment" ]]; then
            full_comment+="${annotations}"
          else
            full_comment="${annotations}"
          fi
        fi

        # Calculate padding for alignment
        local base_len=${#base_line}
        local pad_len=$((45 - base_len))
        if ((pad_len < 1)); then
          pad_len=1
        fi
        local padding=$(printf '%*s' "$pad_len" '')

        # Output with stack preview
        if [[ -n "$full_comment" ]]; then
          echo "${base_line}${padding}│ Stack: ${stack_state}${full_comment}"
        else
          echo "${base_line}${padding}│ Stack: ${stack_state}"
        fi
      else
        # Output without stack preview
        local output_line="${offset}: ${opcode}"
        if [[ -n "$operand" ]]; then
          output_line+=" ${operand}"
        fi
        if [[ -n "$comment" ]]; then
          output_line+="${comment}"
        fi
        if [[ -n "$annotations" ]]; then
          output_line+="${annotations}"
        fi
        echo "$output_line"
      fi

      # Reset push tracking on non-push opcodes
      if [[ ! "$opcode" =~ ^PUSH ]]; then
        prev_push_value=""
      fi
    done < "$input_file"
  } > "$output_file"

  # Append memory map if memory tracking is enabled
  if [[ "$ENABLE_MEMORY_TRACKING" == true ]]; then
    {
      echo ""
      echo "╔════════════════════════════════════════════════════════════════╗"
      echo "║                      MEMORY LAYOUT                             ║"
      echo "╚════════════════════════════════════════════════════════════════╝"
      echo ""
      memory_map_display
    } >> "$output_file"
  fi
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

# ══════════════════════════════════════════════════════════════════
# Initialize analysis features
# ══════════════════════════════════════════════════════════════════

# Show enabled features
any_analysis_enabled=false
if [[ "$ENABLE_STACK_PREVIEW" == true ]] || [[ "$ENABLE_STORAGE_ANNOTATIONS" == true ]] || \
   [[ "$ENABLE_GAS_TRACKING" == true ]] || [[ "$ENABLE_CFG_ASCII" == true ]] || \
   [[ "$ENABLE_MEMORY_TRACKING" == true ]]; then
  any_analysis_enabled=true
  echo "════════════════════════════════════════════════════════════════"
  echo "Advanced Analysis Features Enabled:"
  [[ "$ENABLE_STACK_PREVIEW" == true ]] && echo "  ✓ Stack simulation"
  [[ "$ENABLE_STORAGE_ANNOTATIONS" == true ]] && echo "  ✓ Storage annotations"
  [[ "$ENABLE_GAS_TRACKING" == true ]] && echo "  ✓ Gas cost tracking"
  [[ "$ENABLE_MEMORY_TRACKING" == true ]] && echo "  ✓ Memory layout tracking"
  [[ "$ENABLE_CFG_ASCII" == true ]] && echo "  ✓ Control flow graph (ASCII)"
  echo "════════════════════════════════════════════════════════════════"
  echo ""
fi

# Initialize gas costs if gas tracking is enabled
if [[ "$ENABLE_GAS_TRACKING" == true ]]; then
  debug "Initializing gas cost lookup table..."
  init_gas_costs
fi

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

  # Extract base name of .sol file (without extension)
  sol_basename=$(basename "$sol_file" .sol)
  sol_output_dir="${OUT_DIR}/${sol_basename}"

  # Create subdirectory for this .sol file
  mkdir -p "$sol_output_dir"

  for contract in "${contracts[@]}"; do
    target="${sol_file}:${contract}"
    bytecode_file="${sol_output_dir}/${contract}-Bytecodes.hex"
    opcode_file="${sol_output_dir}/${contract}-Opcodes.asm"
    opcode_file_tmp="${sol_output_dir}/${contract}--Opcodes.tmp"
    opcode_file_fixed="${sol_output_dir}/${contract}--Opcodes-fixed.tmp"
    opcode_file_split="${sol_output_dir}/${contract}--Opcodes-split.tmp"
    opcode_file_push4="${sol_output_dir}/${contract}--Opcodes-push4.tmp"
    opcode_file_bodies="${sol_output_dir}/${contract}--Opcodes-bodies.tmp"
    opcode_file_sections="${sol_output_dir}/${contract}--Opcodes-sections.tmp"
    opcode_file_analysis="${sol_output_dir}/${contract}--Opcodes-analysis.tmp"

    echo "Inspecting ${target}"

    # Step 0: Extract function selectors
    echo "  ↳ Extracting function selectors..."
    if ! extract_selectors "$target"; then
      echo "  ⚠ Could not extract selectors for ${target}" >&2
    else
      echo "  ✓ Found ${#SELECTORS[@]} function selectors"
    fi

    # Step 0.5: Extract storage layout if storage annotations are enabled
    if [[ "$ENABLE_STORAGE_ANNOTATIONS" == true ]]; then
      echo "  ↳ Extracting storage layout..."
      if extract_storage_layout "$target"; then
        echo "  ✓ Found ${#STORAGE_SLOTS[@]} storage slots"
      else
        echo "  ⚠ Could not extract storage layout (annotations will be limited)"
      fi
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
        add_section_headers "$opcode_file_bodies" "$opcode_file_sections"

        # Step 9: Apply advanced analysis features if any are enabled
        if [[ "$any_analysis_enabled" == true ]]; then
          echo "  ↳ Applying advanced analysis..."
          apply_advanced_analysis "$opcode_file_sections" "$opcode_file_analysis"

          # Step 10: Generate CFG if enabled
          if [[ "$ENABLE_CFG_ASCII" == true ]]; then
            echo "  ↳ Building control flow graph..."
            cfg_collect_data "$opcode_file_analysis"
            cfg_build_edges "$opcode_file_analysis"

            # Append ASCII CFG to output
            cfg_generate_ascii "$opcode_file_analysis" >> "$opcode_file_analysis"
          fi

          # Move final analysis output to opcode file
          mv "$opcode_file_analysis" "$opcode_file"
        else
          # No advanced analysis, use sections output directly
          mv "$opcode_file_sections" "$opcode_file"
        fi

        # Clean up temp files
        rm -f "$opcode_file_tmp" "$opcode_file_fixed" "$opcode_file_split" \
              "$opcode_file_push4" "$opcode_file_bodies" "$opcode_file_sections" \
              "$opcode_file_analysis"

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
echo "  - Output organized by Solidity file in disassembly/<SolFileName>/"
echo "  - Offsets converted to 0-based (EVM standard)"
echo "  - Creation and Runtime code separated"
echo "  - Runtime code offsets reset to 0"
echo "  - Section headers added (Preamble, Dispatcher, Bodies, etc.)"
echo "  - Function selectors annotated with signatures"
echo "  - Function body entry points marked"
if [[ "$any_analysis_enabled" == true ]]; then
  echo ""
  echo "Advanced Analysis Applied:"
  [[ "$ENABLE_STACK_PREVIEW" == true ]] && echo "  - Stack simulation with state tracking"
  [[ "$ENABLE_STORAGE_ANNOTATIONS" == true ]] && echo "  - Storage slot annotations (SLOAD/SSTORE)"
  [[ "$ENABLE_GAS_TRACKING" == true ]] && echo "  - Gas cost tracking (individual + cumulative)"
  [[ "$ENABLE_MEMORY_TRACKING" == true ]] && echo "  - Memory layout tracking"
  [[ "$ENABLE_CFG_ASCII" == true ]] && echo "  - ASCII control flow graph"
fi
echo "════════════════════════════════════════════════════════════════"