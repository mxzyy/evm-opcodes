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



# Contract Example for Disassembly

## 1. Advanced.sol - Complete Analysis

### Contract: Advanced
**Purpose:** Demonstrasi modifier patterns (access control & reentrancy guard)

**Storage Layout:**
- Slot 0: `address owner` (20 bytes) + `bool locked` (1 byte) - **PACKED dalam 1 slot!**
  - `owner` di bytes 0-19 (160 bits)
  - `locked` di byte 20 (offset 0x14 = 20 dalam decimal)

**IMPORTANT:** Solidity melakukan **storage packing** untuk variables yang muat dalam 1 slot (32 bytes). Address (20 bytes) + bool (1 byte) = 21 bytes < 32 bytes, jadi keduanya di slot 0.

---

### Bytecode Deep Dive: Advanced Contract

#### A. CREATION CODE (Constructor)

```
Bytecode Size: 1541 bytes (0x605 hex)
Creation Code: ~91 bytes | Runtime Code: ~1448 bytes
```

**Step-by-step Constructor Execution:**

```assembly
00000000: PUSH1 0x80      # Push 128 (free memory pointer start)
00000002: PUSH1 0x40      # Push 64 (free memory pointer location)
00000004: MSTORE          # Store 0x80 at memory[0x40] - STANDARD EVM INIT

# === Payable Check ===
00000005: CALLVALUE       # Get msg.value
00000006: DUP1            # Duplicate value
00000007: ISZERO          # Is it zero?
00000008: PUSH1 0x0e      # Jump destination if zero
0000000a: JUMPI           # Jump if msg.value == 0
0000000b: PUSH0           # Otherwise...
0000000c: PUSH0
0000000d: REVERT          # REVERT (constructor not payable!)

# === owner = msg.sender ===
0000000e: JUMPDEST        # Continue here if non-payable check passed
0000000f: POP             # Clean stack
00000010: CALLER          # Push msg.sender (deployer address)
00000011: PUSH0           # Push 0 (slot number untuk owner)
00000012: PUSH0           # Push 0 (byte offset - owner mulai dari byte 0)
00000013: PUSH2 0x0100    # Push 256 (2^8)
00000016: EXP             # 256^0 = 1 (shift amount untuk byte 0)
```

**Address Masking Logic:**
```assembly
0000001a: PUSH20 0xffffffffffffffffffffffffffffffffffffffff  # 20-byte mask
0000002f: MUL             # Shift mask ke posisi yang benar
00000030: NOT             # Invert mask (clear bits untuk owner)
00000031: AND             # Clear old value
00000034: PUSH20 0xffffffffffffffffffffffffffffffffffffffff  # Mask untuk new value
00000049: AND             # Mask caller address
0000004a: MUL             # Shift ke posisi
0000004b: OR              # Combine dengan existing data
0000004c: SWAP1
0000004d: SSTORE          # Store ke slot 0!
```

**Penjelasan Masking:**
- EVM storage adalah 32-byte slots
- Untuk packed variables, harus:
  1. Load slot lama
  2. Clear bits yang mau diubah (AND dengan inverted mask)
  3. Set bits baru (OR dengan shifted value)

---

#### B. RUNTIME CODE - Function Dispatcher

**Preamble (Memory Init & Non-Payable Check):**
```assembly
00000000: PUSH1 0x80      # Free memory pointer value
00000002: PUSH1 0x40      # Free memory pointer location
00000004: MSTORE          # Initialize: memory[0x40] = 0x80

00000005: CALLVALUE       # msg.value
00000006-0000000e: ...    # Non-payable check (revert if value > 0)
```

**Function Selector Extraction:**
```assembly
00000011: PUSH1 0x04      # Minimum calldata size
00000013: CALLDATASIZE    # Actual calldata size
00000014: LT              # Is calldata < 4 bytes?
00000015: PUSH2 0x004a    # Jump to fallback if true
00000018: JUMPI

0000001a: CALLDATALOAD    # Load first 32 bytes of calldata
0000001b: PUSH1 0xe0      # Push 224 (256-32)
0000001d: SHR             # Shift right 224 bits = extract first 4 bytes
```

**Function Selector Table:**
| Selector | Function | Jump Target |
|----------|----------|-------------|
| `0x021e9894` | `protectedFunction()` | `0x004e` |
| `0x777acf37` | `restrictedFunction()` | `0x006c` |
| `0x8da5cb5b` | `owner()` | `0x008a` |
| `0xf2fde38b` | `transferOwnership(address)` | `0x00a8` |

**Selector Calculation:**
```solidity
bytes4(keccak256("protectedFunction()")) = 0x021e9894
bytes4(keccak256("restrictedFunction()")) = 0x777acf37
bytes4(keccak256("owner()")) = 0x8da5cb5b
bytes4(keccak256("transferOwnership(address)")) = 0xf2fde38b
```

---

#### C. MODIFIER IMPLEMENTATION - nonReentrant

**Solidity Code:**
```solidity
modifier nonReentrant() {
    require(!locked, "Reentrant call");
    locked = true;
    _;
    locked = false;
}
```

**Bytecode Analysis (protectedFunction @ 0x00c4):**

**Step 1: Check if locked (require(!locked))**
```assembly
000000c4: JUMPDEST        # Function entry
000000c5: PUSH0           # Result placeholder
000000c6: PUSH0           # Slot 0
000000c7: PUSH1 0x14      # Offset 20 (0x14) - lokasi bool locked!
000000c9: SWAP1
000000ca: SLOAD           # Load slot 0
000000cb: SWAP1
000000cc: PUSH2 0x0100    # 256
000000cf: EXP             # 256^20 = shift 20 bytes
000000d0: SWAP1
000000d1: DIV             # Shift right 20 bytes
000000d2: PUSH1 0xff      # Mask 1 byte
000000d4: AND             # Extract bool value
000000d5: ISZERO          # Is locked == false?
000000d6: PUSH2 0x0114    # Jump if not locked
000000d9: JUMPI
# ... revert with "Reentrant call" if locked ...
```

**Step 2: Set locked = true**
```assembly
00000114: JUMPDEST
00000115: PUSH1 0x01      # true value
00000117: PUSH0           # Slot 0
00000118: PUSH1 0x14      # Offset 20
0000011a: PUSH2 0x0100    # 256
0000011d: EXP             # 256^20
# ... masking logic untuk set byte 20 = 1 ...
0000012d: SSTORE          # Store back ke slot 0
```

**Step 3: Execute function body (_;)**
```assembly
0000012f: PUSH1 0x01      # Return value (true)
00000131: SWAP1
00000132: POP
```

**Step 4: Set locked = false**
```assembly
00000133: PUSH0           # false value
00000134: PUSH0           # Slot 0
00000135: PUSH1 0x14      # Offset 20
# ... same masking logic untuk set byte 20 = 0 ...
00000149: SSTORE          # Store back
```

**Key Insight:**
- `locked` disimpan di **byte 20** (offset 0x14) dari slot 0
- Karena packed dengan `owner`, setiap akses `locked` butuh:
  - SLOAD slot 0
  - Shift right 20 bytes (DIV by 256^20)
  - Mask dengan 0xff
- Ini **lebih mahal gas** daripada pakai separate slot!

---

#### D. MODIFIER IMPLEMENTATION - onlyOwner

**Solidity Code:**
```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}
```

**Bytecode Analysis (restrictedFunction @ 0x014e):**

```assembly
0000014e: JUMPDEST        # Entry point
0000014f: PUSH0           # Return value placeholder
00000150: PUSH0           # Slot 0
00000151: PUSH0           # Offset 0
00000152: SWAP1
00000153: SLOAD           # Load slot 0
00000154: SWAP1
00000155: PUSH2 0x0100    # 256
00000158: EXP             # 256^0 = 1 (no shift needed)
00000159: SWAP1
0000015a: DIV             # Shift right 0 bytes
0000015b: PUSH20 0xfff... # 20-byte address mask
00000170: AND             # Extract owner address

00000171: PUSH20 0xfff... # Mask untuk comparison
00000186: AND

00000187: CALLER          # Push msg.sender
00000188: PUSH20 0xfff... # Mask
0000019d: AND
0000019e: EQ              # owner == msg.sender?
0000019f: PUSH2 0x01dd    # Jump if equal
000001a2: JUMPI

# === Revert Path ===
000001a3: PUSH1 0x40      # Free memory pointer
000001a5: MLOAD
000001a6: PUSH32 0x08c379a0...  # Error selector for require()
```

**Error String Storage:**
```assembly
000004a2: JUMPDEST
000004a3: PUSH32 0x4e6f74206f776e6572...  # "Not owner" in hex
#         N  o  t     o  w  n  e  r
#         4e 6f 74 20 6f 77 6e 65 72
```

---

#### E. ERROR MESSAGES IN BYTECODE

Error strings di-embed langsung dalam bytecode:

| Hex | ASCII | Used In |
|-----|-------|---------|
| `0x5265656e7472616e742063616c6c` | "Reentrant call" | nonReentrant modifier |
| `0x4e6f74206f776e6572` | "Not owner" | onlyOwner modifier |
| `0x5a65726f2061646472657373` | "Zero address" | transferOwnership |

**Error Encoding Format (ABI):**
```
0x08c379a0                           # Function selector untuk Error(string)
0x0000...0020                        # Offset ke string data
0x0000...000e                        # String length (14 untuk "Reentrant call")
0x5265656e7472616e742063616c6c00...  # String data (padded to 32 bytes)
```

---

#### F. transferOwnership DEEP DIVE

**Solidity:**
```solidity
function transferOwnership(address newOwner) external onlyOwner {
    require(newOwner != address(0), "Zero address");
    owner = newOwner;
}
```

**Bytecode @ 0x0208:**

**1. onlyOwner Check (inline - modifier code duplicated)**
```assembly
00000208: JUMPDEST
00000209-00000295: ... # Same onlyOwner logic as restrictedFunction
```

**2. Zero Address Check**
```assembly
00000296: JUMPDEST        # After onlyOwner passed
00000297: PUSH0           # address(0)
00000298: PUSH20 0xfff... # Mask
000002ad: AND
000002ae: DUP2            # newOwner argument
000002af: PUSH20 0xfff...
000002c4: AND
000002c5: SUB             # newOwner - address(0)
000002c6: PUSH2 0x0304    # Jump if not zero
000002c9: JUMPI
# ... revert with "Zero address" ...
```

**3. Update Owner**
```assembly
00000304: JUMPDEST
00000305: DUP1            # newOwner
00000306: PUSH0           # Slot 0
00000307: PUSH0           # Offset 0
00000308: PUSH2 0x0100    # 256
0000030b: EXP             # 256^0 = 1
# ... masking logic ...
00000342: SSTORE          # Store newOwner ke slot 0
```

---

#### G. GAS ANALYSIS

| Operation | Gas Cost |
|-----------|----------|
| SLOAD (cold) | 2100 |
| SLOAD (warm) | 100 |
| SSTORE (cold, 0→non-0) | 22100 |
| SSTORE (warm) | 100 |
| CALLER | 2 |
| EQ | 3 |

**nonReentrant Modifier Gas Breakdown:**
- Check locked: SLOAD(100-2100) + DIV + AND + ISZERO = ~105-2105 gas
- Set locked=true: SLOAD + masking + SSTORE = ~200-22200 gas
- Set locked=false: SLOAD + masking + SSTORE = ~200-22200 gas
- **Total overhead: ~505-46505 gas per call** (depending on cold/warm access)

**onlyOwner Modifier:**
- Load owner: SLOAD + masking = ~105-2105 gas
- CALLER: 2 gas
- EQ: 3 gas
- **Total overhead: ~110-2110 gas per call**

---

#### H. METADATA (CBOR)

Bytecode ends dengan CBOR-encoded metadata:
```
00000572: INVALID (0xfe)  # Sentinel - marks start of metadata
00000573: LOG2            # Part of CBOR encoding
...
a2646970667358221220...   # CBOR data: IPFS hash, solc version
...64736f6c634300081c0033 # "solc" version 0.8.28
```

Decoded:
- `6970667358`: "ipfs" in hex
- `736f6c63`: "solc" in hex
- `00081c`: version 0.8.28

---

**Key Features:**
1. **Constructor:** Set `owner = msg.sender` (deployer menjadi owner)
2. **Modifiers:**
   - `onlyOwner`: Access control (require-based)
   - `onlyOwnerAsm`: Same thing tapi pake assembly (lebih gas efficient)
   - `nonReentrant`: Reentrancy guard (require-based) - set locked = true sebelum execute, reset ke false setelahnya
   - `nonReentrantAsm`: Same thing tapi pake assembly

3. **Functions:**
   - `restrictedFunction()`: Protected by `onlyOwner` - cuma owner yang bisa call
   - `protectedFunction()`: Protected by `nonReentrant` - cegah recursive call
   - `transferOwnership()`: Transfer ownership ke address baru

**IMPORTANT CONCEPT:**
- `onlyOwner` dan `nonReentrant` itu **2 HAL BERBEDA**:
  - `onlyOwner` = **Access control** (siapa yang boleh akses)
  - `nonReentrant` = **Reentrancy protection** (cegah recursive/nested calls)
- Mereka bisa dikombinasikan atau dipakai terpisah sesuai kebutuhan
- Bukan berarti satu modifier udah include yang lain!

---

### Contract: Base (Abstract)
**Purpose:** Base contract untuk demonstrasi inheritance

**Storage Layout:**
- Slot 0: `uint256 baseValue`

**Key Features:**
1. `setBaseValue()`: Function dengan modifier `virtual` - artinya **bisa di-override** di derived contract
2. `getBaseValue()`: View function untuk baca baseValue

**IMPORTANT CONCEPT:**
- `virtual` ≠ "gabisa dipanggil langsung"
- `virtual` = "bisa di-override oleh child contract" (tapi masih bisa dipanggil langsung kalau ga di-override)
- Kalau function di-mark `virtual`, derived contract bisa replace implementasinya

---

### Contract: Derived
**Purpose:** Child contract yang override parent behavior

**Storage Layout:**
- Slot 0: `uint256 baseValue` (inherited dari Base)
- Slot 1: `uint256 derivedValue` (variable baru)

**IMPORTANT:** Storage dari parent contract **dipertahankan** di slot yang sama! Derived contract nambah variable baru di slot berikutnya.

**Key Features:**
1. `setDerivedValue()`: Set variable milik derived contract
2. `setBaseValue()`: **Override** parent function - kali value dengan 2 sebelum store
   - Function ini **replace** implementasi parent
   - Parent punya: `baseValue = value`
   - Derived punya: `baseValue = value * 2`

**Why "Derived"?** Karena contract ini **diturunkan/derived** dari Base contract.

---

### Contract: InterfaceUser
**Purpose:** Demonstrasi cara pakai interface untuk interact dengan contract lain

**Key Features:**
1. `getBalance()`: Call `balanceOf()` dari external ERC20 token
2. `transferTokens()`: Call `transfer()` dari external ERC20 token

**Pattern:** Interface-based interaction (ga perlu tau implementasi detail, cuma perlu tau function signature)

---

### Contract: AbstractToken (Abstract)
**Purpose:** Base contract untuk token implementation (defines structure, tapi ga implement semua function)

**Storage Layout:**
- Slot 0: `string name`
- Slot 1: `string symbol`
- Slot 2: `uint8 decimals`

**Key Features:**
- Define function signature yang **wajib** diimplementasi child:
  - `totalSupply()` → virtual (harus di-override)
  - `balanceOf()` → virtual (harus di-override)

---

### Contract: ConcreteToken
**Purpose:** Concrete implementation of AbstractToken

**Storage Layout:**
- Slot 0-2: Inherited dari AbstractToken (name, symbol, decimals)
- Slot 3: `uint256 _totalSupply`
- Slot 4: `mapping(address => uint256) balances` (mapping base slot, actual data di keccak256(key, slot))

**Key Features:**
1. Constructor: Mint 1M tokens ke deployer
2. `totalSupply()`: Override - return total supply
3. `balanceOf()`: Override - return balance of address

**Note:** Contract ini simplified ERC20 (belum ada transfer function, cuma tracking balance)

---

### Contract: UsingLibrary
**Purpose:** Demonstrasi cara pakai library functions

**Key Features:**
- `using Math for uint256`: Attach library Math ke type uint256
- `calculate()`: Chaining library calls: `a.add(b).mul(2)`

**Pattern:** Library functions jadi "methods" dari type yang di-attach

---

### Contract: UsingForExample
**Purpose:** Demonstrasi `using for` dengan array operations

**Key Features:**
- `using ArrayLib for uint256[]`: Attach library ke array type
- Functions dapat dipanggil directly dari array: `numbers.sum()`

---

### Contract: A & B
**Purpose:** Base contracts untuk multiple inheritance demo

**IMPORTANT CONCEPT:**
- Function `setA()` dan `setB()` adalah `public virtual`
- `public` = bisa dipanggil langsung (external atau internal)
- `virtual` = bisa di-override (OPTIONAL, bukan mandatory)
- Function ini **BISA dipanggil langsung** tanpa inheritance!

---

### Contract: C (Multiple Inheritance)
**Purpose:** Demonstrasi multiple inheritance

**Storage Layout:**
- Slot 0: `uint256 valueA` (dari A)
- Slot 1: `uint256 valueB` (dari B)

**Key Features:**
- `setBoth()`: Function **BARU** (bukan override)
- Internal call ke `setA()` dan `setB()` dari parent contracts

**Why no override modifier?**
- `setBoth()` adalah function baru, bukan replacement dari parent function
- `override` cuma diperlukan kalau kita **replace** function yang udah exist di parent
- Function ini cuma **call** parent functions, bukan replace

---

### Contract: Base1 & Base2 (Diamond Problem Setup)
**Purpose:** Setup untuk demonstrasi diamond inheritance problem

**Key Features:**
- Keduanya punya function `foo()` dengan signature sama
- Return value berbeda: "Base1" vs "Base2"

---

### Contract: Diamond (Diamond Inheritance Resolution)
**Purpose:** Resolve diamond problem dari multiple inheritance

**Key Features:**
- `function foo() override(Base1, Base2)`: **WAJIB** specify semua parent yang di-override
- Return "Diamond" (custom implementation)

**IMPORTANT CONCEPT:**
- Function dari Base1 dan Base2 **TETAP BISA di-call** via type casting:
  ```solidity
  Diamond d = new Diamond();
  d.foo(); // "Diamond"
  Base1(address(d)).foo(); // Still accessible (compile time dispatch)
  ```
- Override **WAJIB** karena ada ambiguity (2 parent punya function sama)
- Ini namanya **Diamond Problem** dalam multiple inheritance

---

### Contract: Implementation
**Purpose:** Logic contract untuk proxy pattern

**Storage Layout:**
- Slot 0: `uint256 value`

**Key Features:**
- Simple read/write storage
- Contract ini akan dipanggil via `delegatecall` dari Proxy

---

### Contract: Proxy
**Purpose:** Simple proxy pattern using delegatecall

**Storage Layout:**
- Slot 0: `address implementation`

**Key Features:**
1. **Constructor:** Set implementation address
2. **fallback():** Forward semua calls ke implementation via `delegatecall`
   - Copy calldata ke memory
   - Delegatecall to implementation
   - Copy return data dan return/revert accordingly
3. **receive():** Accept plain ETH transfers (tanpa calldata)

**Why receive() function?**
- `receive()`: Dipanggil ketika ETH dikirim **TANPA DATA** (msg.data kosong)
- `fallback()`: Dipanggil ketika:
  1. Function tidak exist, ATAU
  2. ETH dikirim **DENGAN DATA**
- **Tanpa receive()**, contract **TIDAK BISA** terima plain ETH transfer seperti `address.transfer()`

**IMPORTANT:** Delegatecall = execute code dari implementation tapi use storage dari Proxy

---

### Contract: UpgradeableProxy (EIP-1967)
**Purpose:** Upgradeable proxy using EIP-1967 standard storage slots

**Storage Layout (EIP-1967):**
- Slot `0x360894a...`: Implementation address
- Slot `0xb53127...`: Admin address

**Why these weird slots?**
- Calculate via: `keccak256("eip1967.proxy.implementation") - 1`
- Slot ini **fixed** dan sangat tinggi (hampir impossible collision dengan implementation storage)
- Ini **STANDARD** untuk upgradeable proxies (bukan "hardcode")

**Key Features:**
1. **Constructor:** Set implementation & admin di EIP-1967 slots (via assembly)
2. **upgradeTo():** Only admin can upgrade implementation
   - Check caller == admin
   - Update implementation slot
3. **fallback():** Forward calls via delegatecall (same as simple proxy)

**How it works:**
1. All storage operations go to Proxy's storage (karena delegatecall)
2. Implementation contract TIDAK BOLEH punya storage di slot rendah (collision risk)
3. Admin bisa ganti implementation address kapanpun (upgrade logic without losing data)

---

### Contract: FallbackExample
**Purpose:** Demonstrasi perbedaan receive() vs fallback()

**Key Features:**
1. **receive():** Emit event ketika terima ETH **tanpa data**
2. **fallback():** Emit event ketika:
   - Function call ke non-existent function
   - ETH sent **with calldata**

**Test Cases:**
- `address.transfer(1 ether)` → trigger `receive()`
- `address.call{value: 1 ether}("")` → trigger `receive()` (empty calldata)
- `address.call{value: 1 ether}("0x1234")` → trigger `fallback()` (ada calldata)
- `address.call("nonExistentFunction()")` → trigger `fallback()`

---

### Contract: Constants
**Purpose:** Demonstrasi constant vs immutable

**Storage/Bytecode:**
- `constant MAX_SUPPLY`: Replaced at **compile time** (0 gas untuk read, value di-inline di bytecode)
- `constant DEAD_ADDRESS`: Same, replaced saat compile
- `immutable deploymentTime`: Set di **constructor**, stored in **bytecode** (bukan storage!)
- `immutable deployer`: Same, set once in constructor

**Difference:**
- `constant`: Must be known at compile time (literals, expressions of constants)
- `immutable`: Can be set using constructor parameters/logic, but only once

**Gas:** Keduanya lebih murah dari storage variable (ga perlu SLOAD)

---

### Contract: AssemblyHeavy
**Purpose:** Demonstrasi low-level assembly untuk mapping operations

**Function: efficientTransfer(from, to, amount)**

**Step-by-step:**
1. **balancesSlot := 0**: Base slot untuk mapping (slot 0)

2. **Calculate FROM balance slot:**
   ```
   mstore(0x0, from)           // Put 'from' address at memory 0x0
   mstore(0x20, balancesSlot)  // Put slot number at memory 0x20 (32 bytes offset)
   fromSlot := keccak256(0x0, 0x40)  // Hash 64 bytes (0x40 = 64 in hex)
   ```
   **Explanation:** Mapping slot = `keccak256(abi.encodePacked(key, baseSlot))`
   - Memory 0x0-0x1F: from address (20 bytes, padded to 32)
   - Memory 0x20-0x3F: slot number (32 bytes)
   - Hash both (total 64 bytes = 0x40) to get storage slot

3. **Load FROM balance:** `fromBalance := sload(fromSlot)` - read 32 bytes (uint256) dari storage

4. **Check balance:** `if lt(fromBalance, amount) { revert(0, 0) }` - revert kalau insufficient

5. **Calculate TO balance slot:** (same process, tapi pake 'to' address)

6. **Update balances:**
   ```
   sstore(fromSlot, sub(fromBalance, amount))  // Deduct from sender
   sstore(toSlot, add(toBalance, amount))      // Add to receiver
   ```

**Why assembly?**
- More gas efficient (skip Solidity's safety checks)
- Direct storage manipulation
- Full control over memory and storage operations

**Note:** uint256 = 32 bytes (256 bits) - standard Solidity storage size

---

## Summary: Key Concepts

1. **Storage Layout:** Inherited storage slots dipertahankan, child contract nambah di slot berikutnya
2. **Virtual vs Override:** Virtual = bisa di-override (optional), Override = replace parent implementation
3. **Multiple Inheritance:** Storage slots gabungan dari semua parents, resolving order matters
4. **Diamond Problem:** Butuh explicit override(Parent1, Parent2) untuk resolve ambiguity
5. **Proxy Patterns:**
   - Simple: hardcoded implementation
   - Upgradeable: dynamic implementation dengan EIP-1967 slots
6. **Delegatecall:** Execute code from target, but use caller's storage
7. **Receive vs Fallback:**
   - receive(): ETH tanpa data
   - fallback(): Function not found OR ETH dengan data
8. **Constant vs Immutable:**
   - constant: compile-time value (inline)
   - immutable: constructor-time value (stored in bytecode)
9. **Assembly Mapping:** `keccak256(key + baseSlot)` untuk calculate storage location
