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
- Slot 0: `address owner` (20 bytes)
- Slot 1: `bool locked` (1 byte)

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
