╔════════════════════════════════════════════════════════════════╗
║                      CREATION CODE                             ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80                         │ Stack: [0x80] # gas: 3 (total: 3)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0x80] # gas: 3 (total: 6)
00000004: MSTORE                             │ Stack: [] # gas: 3 (total: 9) # memory write: free memory pointer (free memory pointer)
00000005: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 11)
00000006: DUP1                               │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 3 (total: 14)
00000007: ISZERO                             │ Stack: [[![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 17)
00000008: PUSH1 0x0e                         │ Stack: [0x0e, [![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 20)
0000000a: JUMPI                              │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 10 (total: 30)
0000000b: PUSH0                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 32)
0000000c: PUSH0                              │ Stack: [0x0, 0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 34)
0000000d: REVERT                             │ Stack: [] # gas: 0 (total: 34)
0000000e: JUMPDEST                           │ Stack: [] # gas: 1 (total: 35)
0000000f: POP                                │ Stack: [] # gas: 2 (total: 37)
00000010: PUSH2 0x014e                       │ Stack: [0x014e] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x014e, 0x014e] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x014e, 0x014e] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x014e, 0x014e] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x014e] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x014e] # gas: 2 (total: 53+)
0000001a: RETURN                             │ Stack: [] # gas: 0 (total: 53+)
0000001b: INVALID                            │ Stack: [] # gas: 0 (total: 53+)

╔════════════════════════════════════════════════════════════════╗
║                      RUNTIME CODE                              ║
║                  (Deployed Contract Code)                      ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║                        PREAMBLE                                ║
║              Memory Init & Callvalue Check                     ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80                         │ Stack: [0x80] # gas: 3 (total: 56+)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0x80] # gas: 3 (total: 59+)
00000004: MSTORE                             │ Stack: [] # gas: 3 (total: 62+) # memory write: free memory pointer (free memory pointer)
00000005: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 64+)
00000006: DUP1                               │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 3 (total: 67+)
00000007: ISZERO                             │ Stack: [[![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 70+)
00000008: PUSH2 0x000f                       │ Stack: [0x000f, [![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 73+)
0000000b: JUMPI                              │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 10 (total: 83+)
0000000c: PUSH0                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 85+)
0000000d: PUSH0                              │ Stack: [0x0, 0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 87+)
0000000e: REVERT                             │ Stack: [] # gas: 0 (total: 87+)
0000000f: JUMPDEST                           │ Stack: [] # gas: 1 (total: 88+)
00000010: POP                                │ Stack: [] # gas: 2 (total: 90+)
00000011: PUSH1 0x04                         │ Stack: [0x04] # gas: 3 (total: 93+)
00000013: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04] # gas: 2 (total: 95+)
00000014: LT                                 │ Stack: [[cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 98+)
00000015: PUSH2 0x0029                       │ Stack: [0x0029, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
00000018: JUMPI                              │ Stack: [[CALLDATASIZE], 0x04] # gas: 10 (total: 111+)
00000019: PUSH0                              │ Stack: [0x0, [CALLDATASIZE], 0x04] # gas: 2 (total: 113+)

╔════════════════════════════════════════════════════════════════╗
║                   FUNCTION DISPATCHER                          ║
║             Routes Calls to Function Bodies                    ║
╚════════════════════════════════════════════════════════════════╝

0000001a: CALLDATALOAD                       │ Stack: [[CD@0x0], 0x0, [CALLDATASIZE], 0x04] # gas: 3 (total: 116+)
0000001b: PUSH1 0xe0                         │ Stack: [0xe0, [CD@0x0], 0x0, [CALLDATASIZE], ...+1] # gas: 3 (total: 119+)
0000001d: SHR                                │ Stack: [[0xe0>>0xe0], 0xe0, [CD@0x0], 0x0, ...+2] # gas: 3 (total: 122+)
0000001e: DUP1                               │ Stack: [[0xe0>>0xe0], [0xe0>>0xe0], 0xe0, [CD@0x0], ...+3] # gas: 3 (total: 125+)
0000001f: PUSH4 0xc2985578                   │ Stack: [0xc2985578, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# foo() # gas: 3 (total: 128+)
00000024: EQ                                 │ Stack: [[cmp], 0xc2985578, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000025: PUSH2 0x002d                       │ Stack: [0x002d, [cmp], 0xc2985578, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000028: JUMPI                              │ Stack: [0xc2985578, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000029: JUMPDEST                           │ Stack: [0xc2985578, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 1 (total: 145+)
0000002a: PUSH0                              │ Stack: [0x0, 0xc2985578, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 2 (total: 147+)
0000002b: PUSH0                              │ Stack: [0x0, 0x0, 0xc2985578, [0xe0>>0xe0], ...+6] # gas: 2 (total: 149+)
0000002c: REVERT                             │ Stack: [] # gas: 0 (total: 149+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

0000002d: JUMPDEST                           │ Stack: [] # === foo() === # gas: 1 (total: 150+)
0000002e: PUSH2 0x0035                       │ Stack: [0x0035] # gas: 3 (total: 153+)
00000031: PUSH2 0x004b                       │ Stack: [0x004b, 0x0035] # gas: 3 (total: 156+)
00000034: JUMP                               │ Stack: [0x0035] # gas: 8 (total: 164+)
00000035: JUMPDEST                           │ Stack: [0x0035] # gas: 1 (total: 165+)
00000036: PUSH1 0x40                         │ Stack: [0x40, 0x0035] # gas: 3 (total: 168+)
00000038: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0035] # gas: 3 (total: 171+) # memory read: free memory pointer
00000039: PUSH2 0x0042                       │ Stack: [0x0042, [M@0x40], 0x40, 0x0035] # gas: 3 (total: 174+)
0000003c: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0042, 0x0035] # gas: 3 (total: 177+)
0000003d: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0042, 0x0035] # gas: 3 (total: 180+)
0000003e: PUSH2 0x00f8                       │ Stack: [0x00f8, [M@0x40], 0x40, 0x0042, ...+1] # gas: 3 (total: 183+)
00000041: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0042, 0x0035] # gas: 8 (total: 191+)
00000042: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0042, 0x0035] # gas: 1 (total: 192+)
00000043: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0042, ...+1] # gas: 3 (total: 195+)
00000045: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 198+) # memory read: free memory pointer
00000046: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 201+)
00000047: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 204+)
00000048: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 207+)
00000049: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 210+)
0000004a: RETURN                             │ Stack: [] # gas: 0 (total: 210+)
0000004b: JUMPDEST                           │ Stack: [] # gas: 1 (total: 211+)
0000004c: PUSH1 0x60                         │ Stack: [0x60] # gas: 3 (total: 214+)
0000004e: PUSH1 0x40                         │ Stack: [0x40, 0x60] # gas: 3 (total: 217+)
00000050: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x60] # gas: 3 (total: 220+) # memory read: free memory pointer
00000051: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, 0x60] # gas: 3 (total: 223+)
00000052: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], [M@0x40], 0x40, ...+1] # gas: 3 (total: 226+)
00000054: ADD                                │ Stack: [[0x40+0x40], 0x40, [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 229+)
00000055: PUSH1 0x40                         │ Stack: [0x40, [0x40+0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 232+)
00000057: MSTORE                             │ Stack: [0x40, [M@0x40], [M@0x40], 0x40, ...+1] # gas: 3 (total: 235+) # memory write: free memory pointer (free memory pointer)
00000058: DUP1                               │ Stack: [0x40, 0x40, [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 238+)
00000059: PUSH1 0x05                         │ Stack: [0x05, 0x40, 0x40, [M@0x40], ...+3] # gas: 3 (total: 241+)
0000005b: DUP2                               │ Stack: [0x40, 0x05, 0x40, 0x40, ...+4] # gas: 3 (total: 244+)
0000005c: MSTORE                             │ Stack: [0x40, 0x40, [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 247+)
0000005d: PUSH1 0x20                         │ Stack: [0x20, 0x40, 0x40, [M@0x40], ...+3] # gas: 3 (total: 250+)
0000005f: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x40, 0x40, ...+4] # gas: 3 (total: 253+)
00000060: PUSH32 0x4261736532000000000000000000000000000000000000000000000000000000 │ Stack: [0x4261736532000000000000000000000000000000000000000000000000000000, [0x20+0x20], 0x20, 0x40, ...+5] # gas: 3 (total: 256+)
00000081: DUP2                               │ Stack: [[0x20+0x20], 0x4261736532000000000000000000000000000000000000000000000000000000, [0x20+0x20], 0x20, ...+6] # gas: 3 (total: 259+)
00000082: MSTORE                             │ Stack: [[0x20+0x20], 0x20, 0x40, 0x40, ...+4] # gas: 3 (total: 262+)
00000083: POP                                │ Stack: [0x20, 0x40, 0x40, [M@0x40], ...+3] # gas: 2 (total: 264+)
00000084: SWAP1                              │ Stack: [0x40, 0x20, 0x40, [M@0x40], ...+3] # gas: 3 (total: 267+)
00000085: POP                                │ Stack: [0x20, 0x40, [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 269+)
00000086: SWAP1                              │ Stack: [0x40, 0x20, [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 272+)
00000087: JUMP                               │ Stack: [0x20, [M@0x40], [M@0x40], 0x40, ...+1] # gas: 8 (total: 280+)
00000088: JUMPDEST                           │ Stack: [0x20, [M@0x40], [M@0x40], 0x40, ...+1] # gas: 1 (total: 281+)
00000089: PUSH0                              │ Stack: [0x0, 0x20, [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 283+)
0000008a: DUP2                               │ Stack: [0x20, 0x0, 0x20, [M@0x40], ...+3] # gas: 3 (total: 286+)
0000008b: MLOAD                              │ Stack: [[M@0x20], 0x20, 0x0, 0x20, ...+4] # gas: 3 (total: 289+)
0000008c: SWAP1                              │ Stack: [0x20, [M@0x20], 0x0, 0x20, ...+4] # gas: 3 (total: 292+)
0000008d: POP                                │ Stack: [[M@0x20], 0x0, 0x20, [M@0x40], ...+3] # gas: 2 (total: 294+)
0000008e: SWAP2                              │ Stack: [0x20, 0x0, [M@0x20], [M@0x40], ...+3] # gas: 3 (total: 297+)
0000008f: SWAP1                              │ Stack: [0x0, 0x20, [M@0x20], [M@0x40], ...+3] # gas: 3 (total: 300+)
00000090: POP                                │ Stack: [0x20, [M@0x20], [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 302+)
00000091: JUMP                               │ Stack: [[M@0x20], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 8 (total: 310+)
00000092: JUMPDEST                           │ Stack: [[M@0x20], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 1 (total: 311+)
00000093: PUSH0                              │ Stack: [0x0, [M@0x20], [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 313+)
00000094: DUP3                               │ Stack: [[M@0x40], 0x0, [M@0x20], [M@0x40], ...+3] # gas: 3 (total: 316+)
00000095: DUP3                               │ Stack: [[M@0x20], [M@0x40], 0x0, [M@0x20], ...+4] # gas: 3 (total: 319+)
00000096: MSTORE                             │ Stack: [0x0, [M@0x20], [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 322+)
00000097: PUSH1 0x20                         │ Stack: [0x20, 0x0, [M@0x20], [M@0x40], ...+3] # gas: 3 (total: 325+)
00000099: DUP3                               │ Stack: [[M@0x20], 0x20, 0x0, [M@0x20], ...+4] # gas: 3 (total: 328+)
0000009a: ADD                                │ Stack: [[[M@0x20]+[M@0x20]], [M@0x20], 0x20, 0x0, ...+5] # gas: 3 (total: 331+)
0000009b: SWAP1                              │ Stack: [[M@0x20], [[M@0x20]+[M@0x20]], 0x20, 0x0, ...+5] # gas: 3 (total: 334+)
0000009c: POP                                │ Stack: [[[M@0x20]+[M@0x20]], 0x20, 0x0, [M@0x20], ...+4] # gas: 2 (total: 336+)
0000009d: SWAP3                              │ Stack: [[M@0x20], 0x20, 0x0, [[M@0x20]+[M@0x20]], ...+4] # gas: 3 (total: 339+)
0000009e: SWAP2                              │ Stack: [0x0, 0x20, [M@0x20], [[M@0x20]+[M@0x20]], ...+4] # gas: 3 (total: 342+)
0000009f: POP                                │ Stack: [0x20, [M@0x20], [[M@0x20]+[M@0x20]], [M@0x40], ...+3] # gas: 2 (total: 344+)
000000a0: POP                                │ Stack: [[M@0x20], [[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 346+)
000000a1: JUMP                               │ Stack: [[[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 8 (total: 354+)
000000a2: JUMPDEST                           │ Stack: [[[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 1 (total: 355+)
000000a3: DUP3                               │ Stack: [[M@0x40], [[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], ...+2] # gas: 3 (total: 358+)
000000a4: DUP2                               │ Stack: [[[M@0x20]+[M@0x20]], [M@0x40], [[M@0x20]+[M@0x20]], [M@0x40], ...+3] # gas: 3 (total: 361+)
000000a5: DUP4                               │ Stack: [[M@0x40], [[M@0x20]+[M@0x20]], [M@0x40], [[M@0x20]+[M@0x20]], ...+4] # gas: 3 (total: 364+)
000000a6: MCOPY                              │ Stack: [[[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 3 (base + dynamic) (total: 367+)
000000a7: PUSH0                              │ Stack: [0x0, [[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 369+)
000000a8: DUP4                               │ Stack: [[M@0x40], 0x0, [[M@0x20]+[M@0x20]], [M@0x40], ...+3] # gas: 3 (total: 372+)
000000a9: DUP4                               │ Stack: [[M@0x40], [M@0x40], 0x0, [[M@0x20]+[M@0x20]], ...+4] # gas: 3 (total: 375+)
000000aa: ADD                                │ Stack: [[[M@0x40]+[M@0x40]], [M@0x40], [M@0x40], 0x0, ...+5] # gas: 3 (total: 378+)
000000ab: MSTORE                             │ Stack: [[M@0x40], 0x0, [[M@0x20]+[M@0x20]], [M@0x40], ...+3] # gas: 3 (total: 381+)
000000ac: POP                                │ Stack: [0x0, [[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], ...+2] # gas: 2 (total: 383+)
000000ad: POP                                │ Stack: [[[M@0x20]+[M@0x20]], [M@0x40], [M@0x40], 0x40, ...+1] # gas: 2 (total: 385+)
000000ae: POP                                │ Stack: [[M@0x40], [M@0x40], 0x40, 0x60] # gas: 2 (total: 387+)
000000af: JUMP                               │ Stack: [[M@0x40], 0x40, 0x60] # gas: 8 (total: 395+)
000000b0: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x60] # gas: 1 (total: 396+)
000000b1: PUSH0                              │ Stack: [0x0, [M@0x40], 0x40, 0x60] # gas: 2 (total: 398+)
000000b2: PUSH1 0x1f                         │ Stack: [0x1f, 0x0, [M@0x40], 0x40, ...+1] # gas: 3 (total: 401+)
000000b4: NOT                                │ Stack: [[~0x1f], 0x1f, 0x0, [M@0x40], ...+2] # gas: 3 (total: 404+)
000000b5: PUSH1 0x1f                         │ Stack: [0x1f, [~0x1f], 0x1f, 0x0, ...+3] # gas: 3 (total: 407+)
000000b7: DUP4                               │ Stack: [0x0, 0x1f, [~0x1f], 0x1f, ...+4] # gas: 3 (total: 410+)
000000b8: ADD                                │ Stack: [[0x0+0x0], 0x0, 0x1f, [~0x1f], ...+5] # gas: 3 (total: 413+)
000000b9: AND                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], [0x0+0x0], 0x0, 0x1f, ...+6] # gas: 3 (total: 416+)
000000ba: SWAP1                              │ Stack: [[0x0+0x0], [[0x0+0x0]&[0x0+0x0]], 0x0, 0x1f, ...+6] # gas: 3 (total: 419+)
000000bb: POP                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x0, 0x1f, [~0x1f], ...+5] # gas: 2 (total: 421+)
000000bc: SWAP2                              │ Stack: [0x1f, 0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 424+)
000000bd: SWAP1                              │ Stack: [0x0, 0x1f, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 427+)
000000be: POP                                │ Stack: [0x1f, [[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, ...+4] # gas: 2 (total: 429+)
000000bf: JUMP                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, 0x0, ...+3] # gas: 8 (total: 437+)
000000c0: JUMPDEST                           │ Stack: [[[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, 0x0, ...+3] # gas: 1 (total: 438+)
000000c1: PUSH0                              │ Stack: [0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, ...+4] # gas: 2 (total: 440+)
000000c2: PUSH2 0x00ca                       │ Stack: [0x00ca, 0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 443+)
000000c5: DUP3                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00ca, 0x0, [[0x0+0x0]&[0x0+0x0]], ...+6] # gas: 3 (total: 446+)
000000c6: PUSH2 0x0088                       │ Stack: [0x0088, [[0x0+0x0]&[0x0+0x0]], 0x00ca, 0x0, ...+7] # gas: 3 (total: 449+)
000000c9: JUMP                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00ca, 0x0, [[0x0+0x0]&[0x0+0x0]], ...+6] # gas: 8 (total: 457+)
000000ca: JUMPDEST                           │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00ca, 0x0, [[0x0+0x0]&[0x0+0x0]], ...+6] # gas: 1 (total: 458+)
000000cb: PUSH2 0x00d4                       │ Stack: [0x00d4, [[0x0+0x0]&[0x0+0x0]], 0x00ca, 0x0, ...+7] # gas: 3 (total: 461+)
000000ce: DUP2                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], 0x00ca, ...+8] # gas: 3 (total: 464+)
000000cf: DUP6                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], ...+9] # gas: 3 (total: 467+)
000000d0: PUSH2 0x0092                       │ Stack: [0x0092, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00d4, ...+10] # gas: 3 (total: 470+)
000000d3: JUMP                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], ...+9] # gas: 8 (total: 478+)
000000d4: JUMPDEST                           │ Stack: [[[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], ...+9] # gas: 1 (total: 479+)
000000d5: SWAP4                              │ Stack: [0x00ca, [[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], ...+9] # gas: 3 (total: 482+)
000000d6: POP                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], ...+8] # gas: 2 (total: 484+)
000000d7: PUSH2 0x00e4                       │ Stack: [0x00e4, [[0x0+0x0]&[0x0+0x0]], 0x00d4, [[0x0+0x0]&[0x0+0x0]], ...+9] # gas: 3 (total: 487+)
000000da: DUP2                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00e4, [[0x0+0x0]&[0x0+0x0]], 0x00d4, ...+10] # gas: 3 (total: 490+)
000000db: DUP6                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00e4, [[0x0+0x0]&[0x0+0x0]], ...+11] # gas: 3 (total: 493+)
000000dc: PUSH1 0x20                         │ Stack: [0x20, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], 0x00e4, ...+12] # gas: 3 (total: 496+)
000000de: DUP7                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x20, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], ...+13] # gas: 3 (total: 499+)
000000df: ADD                                │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], 0x20, [[0x0+0x0]&[0x0+0x0]], ...+14] # gas: 3 (total: 502+)
000000e0: PUSH2 0x00a2                       │ Stack: [0x00a2, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], 0x20, ...+15] # gas: 3 (total: 505+)
000000e3: JUMP                               │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], 0x20, [[0x0+0x0]&[0x0+0x0]], ...+14] # gas: 8 (total: 513+)
000000e4: JUMPDEST                           │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], 0x20, [[0x0+0x0]&[0x0+0x0]], ...+14] # gas: 1 (total: 514+)
000000e5: PUSH2 0x00ed                       │ Stack: [0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], 0x20, ...+15] # gas: 3 (total: 517+)
000000e8: DUP2                               │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], ...+16] # gas: 3 (total: 520+)
000000e9: PUSH2 0x00b0                       │ Stack: [0x00b0, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], ...+17] # gas: 3 (total: 523+)
000000ec: JUMP                               │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], ...+16] # gas: 8 (total: 531+)
000000ed: JUMPDEST                           │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], ...+16] # gas: 1 (total: 532+)
000000ee: DUP5                               │ Stack: [0x20, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], ...+17] # gas: 3 (total: 535+)
000000ef: ADD                                │ Stack: [[0x20+0x20], 0x20, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, ...+18] # gas: 3 (total: 538+)
000000f0: SWAP2                              │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x20, [0x20+0x20], 0x00ed, ...+18] # gas: 3 (total: 541+)
000000f1: POP                                │ Stack: [0x20, [0x20+0x20], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], ...+17] # gas: 2 (total: 543+)
000000f2: POP                                │ Stack: [[0x20+0x20], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [[0x0+0x0]&[0x0+0x0]], ...+16] # gas: 2 (total: 545+)
000000f3: SWAP3                              │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x00ed, [[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], [0x20+0x20], ...+16] # gas: 3 (total: 548+)
000000f4: SWAP2                              │ Stack: [[[[0x0+0x0]&[0x0+0x0]]+[[0x0+0x0]&[0x0+0x0]]], 0x00ed, [[0x0+0x0]&[0x0+0x0]], [0x20+0x20], ...+16] # gas: 3 (total: 551+)
000000f5: POP                                │ Stack: [0x00ed, [[0x0+0x0]&[0x0+0x0]], [0x20+0x20], 0x20, ...+15] # gas: 2 (total: 553+)
000000f6: POP                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], [0x20+0x20], 0x20, [[0x0+0x0]&[0x0+0x0]], ...+14] # gas: 2 (total: 555+)
000000f7: JUMP                               │ Stack: [[0x20+0x20], 0x20, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], ...+13] # gas: 8 (total: 563+)
000000f8: JUMPDEST                           │ Stack: [[0x20+0x20], 0x20, [[0x0+0x0]&[0x0+0x0]], [[0x0+0x0]&[0x0+0x0]], ...+13] # gas: 1 (total: 564+)
000000f9: PUSH0                              │ Stack: [0x0, [0x20+0x20], 0x20, [[0x0+0x0]&[0x0+0x0]], ...+14] # gas: 2 (total: 566+)
000000fa: PUSH1 0x20                         │ Stack: [0x20, 0x0, [0x20+0x20], 0x20, ...+15] # gas: 3 (total: 569+)
000000fc: DUP3                               │ Stack: [[0x20+0x20], 0x20, 0x0, [0x20+0x20], ...+16] # gas: 3 (total: 572+)
000000fd: ADD                                │ Stack: [[[0x20+0x20]+[0x20+0x20]], [0x20+0x20], 0x20, 0x0, ...+17] # gas: 3 (total: 575+)
000000fe: SWAP1                              │ Stack: [[0x20+0x20], [[0x20+0x20]+[0x20+0x20]], 0x20, 0x0, ...+17] # gas: 3 (total: 578+)
000000ff: POP                                │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x20, 0x0, [0x20+0x20], ...+16] # gas: 2 (total: 580+)
00000100: DUP2                               │ Stack: [0x20, [[0x20+0x20]+[0x20+0x20]], 0x20, 0x0, ...+17] # gas: 3 (total: 583+)
00000101: DUP2                               │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x20, [[0x20+0x20]+[0x20+0x20]], 0x20, ...+18] # gas: 3 (total: 586+)
00000102: SUB                                │ Stack: [[[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], 0x20, [[0x20+0x20]+[0x20+0x20]], ...+19] # gas: 3 (total: 589+)
00000103: PUSH0                              │ Stack: [0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], 0x20, ...+20] # gas: 2 (total: 591+)
00000104: DUP4                               │ Stack: [0x20, 0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], ...+21] # gas: 3 (total: 594+)
00000105: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], ...+22] # gas: 3 (total: 597+)
00000106: MSTORE                             │ Stack: [0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], 0x20, ...+20] # gas: 3 (total: 600+)
00000107: PUSH2 0x0110                       │ Stack: [0x0110, 0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], ...+21] # gas: 3 (total: 603+)
0000010a: DUP2                               │ Stack: [0x0, 0x0110, 0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], ...+22] # gas: 3 (total: 606+)
0000010b: DUP5                               │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x0, 0x0110, 0x0, ...+23] # gas: 3 (total: 609+)
0000010c: PUSH2 0x00c0                       │ Stack: [0x00c0, [[0x20+0x20]+[0x20+0x20]], 0x0, 0x0110, ...+24] # gas: 3 (total: 612+)
0000010f: JUMP                               │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x0, 0x0110, 0x0, ...+23] # gas: 8 (total: 620+)
00000110: JUMPDEST                           │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x0, 0x0110, 0x0, ...+23] # gas: 1 (total: 621+)
00000111: SWAP1                              │ Stack: [0x0, [[0x20+0x20]+[0x20+0x20]], 0x0110, 0x0, ...+23] # gas: 3 (total: 624+)
00000112: POP                                │ Stack: [[[0x20+0x20]+[0x20+0x20]], 0x0110, 0x0, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], ...+22] # gas: 2 (total: 626+)
00000113: SWAP3                              │ Stack: [[[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], 0x0110, 0x0, [[0x20+0x20]+[0x20+0x20]], ...+22] # gas: 3 (total: 629+)
00000114: SWAP2                              │ Stack: [0x0, 0x0110, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], ...+22] # gas: 3 (total: 632+)
00000115: POP                                │ Stack: [0x0110, [[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], [[0x20+0x20]+[0x20+0x20]], ...+21] # gas: 2 (total: 634+)
00000116: POP                                │ Stack: [[[[0x20+0x20]+[0x20+0x20]]-[[0x20+0x20]+[0x20+0x20]]], [[0x20+0x20]+[0x20+0x20]], [[0x20+0x20]+[0x20+0x20]], 0x20, ...+20] # gas: 2 (total: 636+)
00000117: JUMP                               │ Stack: [[[0x20+0x20]+[0x20+0x20]], [[0x20+0x20]+[0x20+0x20]], 0x20, [[0x20+0x20]+[0x20+0x20]], ...+19] # gas: 8 (total: 644+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

00000118: INVALID                            │ Stack: [] # gas: 0 (total: 644+)
00000119: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 1769+)
0000011a: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 1772+)
00000120: INVALID                            │ Stack: [] # gas: 0 (total: 1772+)
00000121: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 1775+)
00000122: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 1805+) # mapping/array slot computation
00000123: INVALID                            │ Stack: [] # gas: 0 (total: 1805+)
00000124: INVALID                            │ Stack: [] # gas: 0 (total: 1805+)
00000125: CALLDATACOPY                       │ Stack: [] # gas: 3 (base + dynamic) (total: 1808+)
00000126: PUSH1 0xd0                         │ Stack: [0xd0] # gas: 3 (total: 1811+)
00000128: MSTORE                             │ Stack: [] # gas: 3 (total: 1814+) # memory write: dynamic allocation
00000129: CREATE                             │ Stack: [[CREATE]] # gas: 32000 (total: 33814+)
0000012a: MSTORE                             │ Stack: [] # gas: 3 (total: 33817+)
0000012b: INVALID                            │ Stack: [] # gas: 0 (total: 33817+)
0000012c: SIGNEXTEND                         │ Stack: [[arith]] # gas: 5 (total: 33822+)
0000012d: CALLF 0x6734                       │ Stack: [[arith]] # gas: ? (total: 33822+)
00000130: PUSH10 0xb967d4baf7b53e017b4d      │ Stack: [0xb967d4baf7b53e017b4d, [arith]] # gas: 3 (total: 33825+)
0000013b: PUSH15 0x95a333f3ee605964736f6c63430008 │ Stack: [0x95a333f3ee605964736f6c63430008, 0xb967d4baf7b53e017b4d, [arith]] # gas: 3 (total: 33828+)
0000014b: SHR                                │ Stack: [[0x95a333f3ee605964736f6c63430008>>0x95a333f3ee605964736f6c63430008], 0x95a333f3ee605964736f6c63430008, 0xb967d4baf7b53e017b4d, [arith]] # gas: 3 (total: 33831+)
0000014c: STOP                               │ Stack: [] # gas: 0 (total: 33831+)
0000014d: CALLER                             │ Stack: [[CALLER]] # gas: 2 (total: 33833+)

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
│ Function: foo()
│ Entry: 0x0000002d
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000004b] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x00000029
  • 0x0000002d
  • 0x00000035
  • 0x00000042
  • 0x0000004b
  • 0x00000088
  • 0x00000092
  • 0x000000a2
  • 0x000000b0
  • 0x000000c0
  • 0x000000ca
  • 0x000000d4
  • 0x000000e4
  • 0x000000ed
  • 0x000000f8
  • 0x00000110

