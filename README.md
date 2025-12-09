# EVM Opcode Playground 🔬

Mini contracts to poke at how Solidity turns into bytecode/opcodes. Run the disassembly script, then read the opcode dump to see what's really happening.

## Learning Contracts 📜
- `src/ArithmeticOps.sol` — basic arithmetic (add, sub, mul, div, mod, addmod, mulmod, pow) plus unchecked variants to spot opcode differences when overflow checks are off.

## Disassembly Helper 🛠️
- Need `forge`, `cast`, and either `rg` or `grep` in PATH.
- Run it:
  ```bash
  bash script/disassemble.sh
  ```
- What it does:
  - Auto-scan every `.sol` in `src/`, grab `contract ...` names.
  - Pull bytecode via `forge inspect <file>:<Contract> bytecode` → save to `disassembly/<Contract> Bytecodes.txt`.
  - Bruteforce pad `00` on disassembly errors (`Error: incomplete sequence of bytecode`), then save opcodes to `disassembly/<Contract> Opcodes.txt`.

## Handy Commands 🚀
- Build: `forge build`
- Test: `forge test`
- Format: `forge fmt`
- Gas snapshot: `forge snapshot`
- Inspect bytecode (manual): `forge inspect src/ArithmeticOps.sol:ArithmeticOpcodes bytecode`
- Disassemble inline (manual): `cast disassemble 0x...`
- Local node: `anvil`
- Sample deploy: `forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>`
- Cast swiss army knife: `cast <subcommand>`
- Help: `forge --help`, `anvil --help`, `cast --help`

## Docs 📖
- https://book.getfoundry.sh/
