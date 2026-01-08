╔════════════════════════════════════════════════════════════════╗
║                      CREATION CODE                             ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80                         │ Stack: [0x80] # gas: 3 (total: 3)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0x80] # gas: 3 (total: 6)
00000004: MSTORE                             │ Stack: [] # gas: 3 (total: 9) # memory write: free memory pointer (free memory pointer)
00000005: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 11)
00000006: PUSH0                              │ Stack: [0x0, [CALLVALUE]] # gas: 2 (total: 13)
00000007: DUP2                               │ Stack: [[CALLVALUE], 0x0, [CALLVALUE]] # gas: 3 (total: 16)
00000008: SWAP1                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 19)
00000009: SSTORE                             │ Stack: [[CALLVALUE]] # gas: 100 (warm) / 20000 (cold new) (total: 119+)
0000000a: POP                                │ Stack: [] # gas: 2 (total: 121+)
0000000b: PUSH1 0xac                         │ Stack: [0xac] # gas: 3 (total: 124+)
0000000d: DUP1                               │ Stack: [0xac, 0xac] # gas: 3 (total: 127+)
0000000e: PUSH1 0x15                         │ Stack: [0x15, 0xac, 0xac] # gas: 3 (total: 130+)
00000010: PUSH0                              │ Stack: [0x0, 0x15, 0xac, 0xac] # gas: 2 (total: 132+)
00000011: CODECOPY                           │ Stack: [0xac] # gas: 3 (base + dynamic) (total: 135+)
00000012: PUSH0                              │ Stack: [0x0, 0xac] # gas: 2 (total: 137+)
00000013: RETURN                             │ Stack: [] # gas: 0 (total: 137+)
00000014: INVALID                            │ Stack: [] # gas: 0 (total: 137+)

╔════════════════════════════════════════════════════════════════╗
║                      RUNTIME CODE                              ║
║                  (Deployed Contract Code)                      ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║                        PREAMBLE                                ║
║              Memory Init & Callvalue Check                     ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80                         │ Stack: [0x80] # gas: 3 (total: 140+)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0x80] # gas: 3 (total: 143+)
00000004: MSTORE                             │ Stack: [] # gas: 3 (total: 146+) # memory write: free memory pointer (free memory pointer)
00000005: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 148+)
00000006: DUP1                               │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 3 (total: 151+)
00000007: ISZERO                             │ Stack: [[![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 154+)
00000008: PUSH1 0x0e                         │ Stack: [0x0e, [![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 157+)
0000000a: JUMPI                              │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 10 (total: 167+)
0000000b: PUSH0                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 169+)
0000000c: PUSH0                              │ Stack: [0x0, 0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 171+)
0000000d: REVERT                             │ Stack: [] # gas: 0 (total: 171+)
0000000e: JUMPDEST                           │ Stack: [] # gas: 1 (total: 172+)
0000000f: POP                                │ Stack: [] # gas: 2 (total: 174+)
00000010: PUSH1 0x04                         │ Stack: [0x04] # gas: 3 (total: 177+)
00000012: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04] # gas: 2 (total: 179+)
00000013: LT                                 │ Stack: [[cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 182+)
00000014: PUSH1 0x26                         │ Stack: [0x26, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 185+)
00000016: JUMPI                              │ Stack: [[CALLDATASIZE], 0x04] # gas: 10 (total: 195+)
00000017: PUSH0                              │ Stack: [0x0, [CALLDATASIZE], 0x04] # gas: 2 (total: 197+)

╔════════════════════════════════════════════════════════════════╗
║                   FUNCTION DISPATCHER                          ║
║             Routes Calls to Function Bodies                    ║
╚════════════════════════════════════════════════════════════════╝

00000018: CALLDATALOAD                       │ Stack: [[CD@0x0], 0x0, [CALLDATASIZE], 0x04] # gas: 3 (total: 200+)
00000019: PUSH1 0xe0                         │ Stack: [0xe0, [CD@0x0], 0x0, [CALLDATASIZE], ...+1] # gas: 3 (total: 203+)
0000001b: SHR                                │ Stack: [[0xe0>>0xe0], 0xe0, [CD@0x0], 0x0, ...+2] # gas: 3 (total: 206+)
0000001c: DUP1                               │ Stack: [[0xe0>>0xe0], [0xe0>>0xe0], 0xe0, [CD@0x0], ...+3] # gas: 3 (total: 209+)
0000001d: PUSH4 0x9632e720                   │ Stack: [0x9632e720, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# receivedAmount() # gas: 3 (total: 212+)
00000022: EQ                                 │ Stack: [[cmp], 0x9632e720, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 215+)
00000023: PUSH1 0x2a                         │ Stack: [0x2a, [cmp], 0x9632e720, [0xe0>>0xe0], ...+6] # gas: 3 (total: 218+)
00000025: JUMPI                              │ Stack: [0x9632e720, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 228+)
00000026: JUMPDEST                           │ Stack: [0x9632e720, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 1 (total: 229+)
00000027: PUSH0                              │ Stack: [0x0, 0x9632e720, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 2 (total: 231+)
00000028: PUSH0                              │ Stack: [0x0, 0x0, 0x9632e720, [0xe0>>0xe0], ...+6] # gas: 2 (total: 233+)
00000029: REVERT                             │ Stack: [] # gas: 0 (total: 233+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

0000002a: JUMPDEST                           │ Stack: [] # gas: 1 (total: 234+)
0000002b: PUSH1 0x30                         │ Stack: [0x30] # gas: 3 (total: 237+)
0000002d: PUSH1 0x44                         │ Stack: [0x44, 0x30] # gas: 3 (total: 240+)
0000002f: JUMP                               │ Stack: [0x30] # gas: 8 (total: 248+)
00000030: JUMPDEST                           │ Stack: [0x30] # gas: 1 (total: 249+)
00000031: PUSH1 0x40                         │ Stack: [0x40, 0x30] # gas: 3 (total: 252+)
00000033: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x30] # gas: 3 (total: 255+) # memory read: free memory pointer
00000034: PUSH1 0x3b                         │ Stack: [0x3b, [M@0x40], 0x40, 0x30] # gas: 3 (total: 258+)
00000036: SWAP2                              │ Stack: [0x40, [M@0x40], 0x3b, 0x30] # gas: 3 (total: 261+)
00000037: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x3b, 0x30] # gas: 3 (total: 264+)
00000038: PUSH1 0x5f                         │ Stack: [0x5f, [M@0x40], 0x40, 0x3b, ...+1] # gas: 3 (total: 267+)
0000003a: JUMP                               │ Stack: [[M@0x40], 0x40, 0x3b, 0x30] # gas: 8 (total: 275+)
0000003b: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x3b, 0x30] # gas: 1 (total: 276+)
0000003c: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x3b, ...+1] # gas: 3 (total: 279+)
0000003e: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 282+) # memory read: free memory pointer
0000003f: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 285+)
00000040: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 288+)
00000041: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 291+)
00000042: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 294+)
00000043: RETURN                             │ Stack: [] # gas: 0 (total: 294+)
00000044: JUMPDEST                           │ Stack: [] # gas: 1 (total: 295+)
00000045: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 297+)
00000046: SLOAD                              │ Stack: [[S@0x0], 0x0] # gas: 100 (warm) / 2100 (cold) (total: 397+)
00000047: DUP2                               │ Stack: [0x0, [S@0x0], 0x0] # gas: 3 (total: 400+)
00000048: JUMP                               │ Stack: [[S@0x0], 0x0] # gas: 8 (total: 408+)
00000049: JUMPDEST                           │ Stack: [[S@0x0], 0x0] # gas: 1 (total: 409+)
0000004a: PUSH0                              │ Stack: [0x0, [S@0x0], 0x0] # gas: 2 (total: 411+)
0000004b: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], 0x0] # gas: 3 (total: 414+)
0000004c: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0] # gas: 3 (total: 417+)
0000004d: POP                                │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 2 (total: 419+)
0000004e: SWAP2                              │ Stack: [0x0, [S@0x0], [S@0x0]] # gas: 3 (total: 422+)
0000004f: SWAP1                              │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 3 (total: 425+)
00000050: POP                                │ Stack: [0x0, [S@0x0]] # gas: 2 (total: 427+)
00000051: JUMP                               │ Stack: [[S@0x0]] # gas: 8 (total: 435+)
00000052: JUMPDEST                           │ Stack: [[S@0x0]] # gas: 1 (total: 436+)
00000053: PUSH1 0x59                         │ Stack: [0x59, [S@0x0]] # gas: 3 (total: 439+)
00000055: DUP2                               │ Stack: [[S@0x0], 0x59, [S@0x0]] # gas: 3 (total: 442+)
00000056: PUSH1 0x49                         │ Stack: [0x49, [S@0x0], 0x59, [S@0x0]] # gas: 3 (total: 445+)
00000058: JUMP                               │ Stack: [[S@0x0], 0x59, [S@0x0]] # gas: 8 (total: 453+)
00000059: JUMPDEST                           │ Stack: [[S@0x0], 0x59, [S@0x0]] # gas: 1 (total: 454+)
0000005a: DUP3                               │ Stack: [[S@0x0], [S@0x0], 0x59, [S@0x0]] # gas: 3 (total: 457+)
0000005b: MSTORE                             │ Stack: [0x59, [S@0x0]] # gas: 3 (total: 460+)
0000005c: POP                                │ Stack: [[S@0x0]] # gas: 2 (total: 462+)
0000005d: POP                                │ Stack: [] # gas: 2 (total: 464+)
0000005e: JUMP                               │ Stack: [] # gas: 8 (total: 472+)
0000005f: JUMPDEST                           │ Stack: [] # gas: 1 (total: 473+)
00000060: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 475+)
00000061: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 478+)
00000063: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 481+)
00000064: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 484+)
00000065: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 487+)
00000066: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 489+)
00000067: PUSH1 0x70                         │ Stack: [0x70, [?+?], 0x20, 0x0] # gas: 3 (total: 492+)
00000069: PUSH0                              │ Stack: [0x0, 0x70, [?+?], 0x20, ...+1] # gas: 2 (total: 494+)
0000006a: DUP4                               │ Stack: [0x20, 0x0, 0x70, [?+?], ...+2] # gas: 3 (total: 497+)
0000006b: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x70, ...+3] # gas: 3 (total: 500+)
0000006c: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 503+)
0000006d: PUSH1 0x52                         │ Stack: [0x52, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 506+)
0000006f: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 514+)
00000070: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 515+)
00000071: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 518+)
00000072: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 521+)
00000073: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x70, ...+3] # gas: 2 (total: 523+)
00000074: POP                                │ Stack: [0x0, [?+?], 0x70, [?+?], ...+2] # gas: 2 (total: 525+)
00000075: JUMP                               │ Stack: [[?+?], 0x70, [?+?], 0x20, ...+1] # gas: 8 (total: 533+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

00000076: INVALID                            │ Stack: [] # gas: 0 (total: 533+)
00000077: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 1658+)
00000078: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 1661+)
0000007e: INVALID                            │ Stack: [] # gas: 0 (total: 1661+)
0000007f: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 1664+)
00000080: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 1694+) # mapping/array slot computation
00000081: NUMBER                             │ Stack: [[BLOCKNUMBER], [KECCAK]] # gas: 2 (total: 1696+)
00000082: INVALID                            │ Stack: [] # gas: 0 (total: 1696+)
00000083: CODESIZE                           │ Stack: [[CODESIZE]] # gas: 2 (total: 1698+)
00000084: DUP1                               │ Stack: [[CODESIZE], [CODESIZE]] # gas: 3 (total: 1701+)
00000085: PUSH24 0x74b9ea0c58974a6b81bf2f27cb38f8c57e4b9199cc95d400 │ Stack: [0x74b9ea0c58974a6b81bf2f27cb38f8c57e4b9199cc95d400, [CODESIZE], [CODESIZE]] # gas: 3 (total: 1704+)
0000009e: PUSH2 0x8650                       │ Stack: [0x8650, 0x74b9ea0c58974a6b81bf2f27cb38f8c57e4b9199cc95d400, [CODESIZE], [CODESIZE]] # gas: 3 (total: 1707+)
000000a1: PUSH5 0x736f6c6343                 │ Stack: [0x736f6c6343, 0x8650, 0x74b9ea0c58974a6b81bf2f27cb38f8c57e4b9199cc95d400, [CODESIZE], ...+1] # gas: 3 (total: 1710+)
000000a7: STOP                               │ Stack: [] # gas: 0 (total: 1710+)
000000a8: ADDMOD                             │ Stack: [[mod_arith]] # gas: 8 (total: 1718+)
000000a9: SHR                                │ Stack: [[[mod_arith]>>[mod_arith]], [mod_arith]] # gas: 3 (total: 1721+)
000000aa: STOP                               │ Stack: [] # gas: 0 (total: 1721+)
000000ab: CALLER                             │ Stack: [[CALLER]] # gas: 2 (total: 1723+)

╔════════════════════════════════════════════════════════════════╗
║                      MEMORY LAYOUT                             ║
╚════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────┐
│ 0x00-0x3f: Scratch space                │
│ 0x40-0x5f: Free memory pointer [128]   │
│ 0x60-0x7f: Zero slot                    │
│ 0x80+    : Dynamic allocations          │
└─────────────────────────────────────────┘

╔════════════════════════════════════════════════════════════════╗
║                    CONTROL FLOW GRAPH                          ║
╚════════════════════════════════════════════════════════════════╝

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000e
  • 0x00000026
  • 0x0000002a
  • 0x00000030
  • 0x0000003b
  • 0x00000044
  • 0x00000049
  • 0x00000052
  • 0x00000059
  • 0x0000005f
  • 0x00000070

