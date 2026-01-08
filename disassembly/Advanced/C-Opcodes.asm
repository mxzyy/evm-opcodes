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
00000010: PUSH2 0x01db                       │ Stack: [0x01db] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x01db, 0x01db] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x01db, 0x01db] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x01db, 0x01db] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x01db] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x01db] # gas: 2 (total: 53+)
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
00000015: PUSH2 0x0054                       │ Stack: [0x0054, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
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
0000001f: PUSH3 0xdf5161                     │ Stack: [0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 3 (total: 128+)
00000023: EQ                                 │ Stack: [[cmp], 0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000024: PUSH2 0x0058                       │ Stack: [0x0058, [cmp], 0xdf5161, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000027: JUMPI                              │ Stack: [0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000028: DUP1                               │ Stack: [0xdf5161, 0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 147+)
00000029: PUSH4 0x09cdcf9b                   │ Stack: [0x09cdcf9b, 0xdf5161, 0xdf5161, [0xe0>>0xe0], ...+6]# setB(uint256) # gas: 3 (total: 150+)
0000002e: EQ                                 │ Stack: [[cmp], 0x09cdcf9b, 0xdf5161, 0xdf5161, ...+7] # gas: 3 (total: 153+)
0000002f: PUSH2 0x0076                       │ Stack: [0x0076, [cmp], 0x09cdcf9b, 0xdf5161, ...+8] # gas: 3 (total: 156+)
00000032: JUMPI                              │ Stack: [0x09cdcf9b, 0xdf5161, 0xdf5161, [0xe0>>0xe0], ...+6] # gas: 10 (total: 166+)
00000033: DUP1                               │ Stack: [0x09cdcf9b, 0x09cdcf9b, 0xdf5161, 0xdf5161, ...+7] # gas: 3 (total: 169+)
00000034: PUSH4 0x6af15505                   │ Stack: [0x6af15505, 0x09cdcf9b, 0x09cdcf9b, 0xdf5161, ...+8]# valueA() # gas: 3 (total: 172+)
00000039: EQ                                 │ Stack: [[cmp], 0x6af15505, 0x09cdcf9b, 0x09cdcf9b, ...+9] # gas: 3 (total: 175+)
0000003a: PUSH2 0x0092                       │ Stack: [0x0092, [cmp], 0x6af15505, 0x09cdcf9b, ...+10] # gas: 3 (total: 178+)
0000003d: JUMPI                              │ Stack: [0x6af15505, 0x09cdcf9b, 0x09cdcf9b, 0xdf5161, ...+8] # gas: 10 (total: 188+)
0000003e: DUP1                               │ Stack: [0x6af15505, 0x6af15505, 0x09cdcf9b, 0x09cdcf9b, ...+9] # gas: 3 (total: 191+)
0000003f: PUSH4 0x6af27355                   │ Stack: [0x6af27355, 0x6af15505, 0x6af15505, 0x09cdcf9b, ...+10]# setBoth(uint256) # gas: 3 (total: 194+)
00000044: EQ                                 │ Stack: [[cmp], 0x6af27355, 0x6af15505, 0x6af15505, ...+11] # gas: 3 (total: 197+)
00000045: PUSH2 0x00b0                       │ Stack: [0x00b0, [cmp], 0x6af27355, 0x6af15505, ...+12] # gas: 3 (total: 200+)
00000048: JUMPI                              │ Stack: [0x6af27355, 0x6af15505, 0x6af15505, 0x09cdcf9b, ...+10] # gas: 10 (total: 210+)
00000049: DUP1                               │ Stack: [0x6af27355, 0x6af27355, 0x6af15505, 0x6af15505, ...+11] # gas: 3 (total: 213+)
0000004a: PUSH4 0xee919d50                   │ Stack: [0xee919d50, 0x6af27355, 0x6af27355, 0x6af15505, ...+12]# setA(uint256) # gas: 3 (total: 216+)
0000004f: EQ                                 │ Stack: [[cmp], 0xee919d50, 0x6af27355, 0x6af27355, ...+13] # gas: 3 (total: 219+)
00000050: PUSH2 0x00cc                       │ Stack: [0x00cc, [cmp], 0xee919d50, 0x6af27355, ...+14] # gas: 3 (total: 222+)
00000053: JUMPI                              │ Stack: [0xee919d50, 0x6af27355, 0x6af27355, 0x6af15505, ...+12] # gas: 10 (total: 232+)
00000054: JUMPDEST                           │ Stack: [0xee919d50, 0x6af27355, 0x6af27355, 0x6af15505, ...+12] # gas: 1 (total: 233+)
00000055: PUSH0                              │ Stack: [0x0, 0xee919d50, 0x6af27355, 0x6af27355, ...+13] # gas: 2 (total: 235+)
00000056: PUSH0                              │ Stack: [0x0, 0x0, 0xee919d50, 0x6af27355, ...+14] # gas: 2 (total: 237+)
00000057: REVERT                             │ Stack: [] # gas: 0 (total: 237+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

00000058: JUMPDEST                           │ Stack: [] # gas: 1 (total: 238+)
00000059: PUSH2 0x0060                       │ Stack: [0x0060] # gas: 3 (total: 241+)
0000005c: PUSH2 0x00e8                       │ Stack: [0x00e8, 0x0060] # gas: 3 (total: 244+)
0000005f: JUMP                               │ Stack: [0x0060] # gas: 8 (total: 252+)
00000060: JUMPDEST                           │ Stack: [0x0060] # gas: 1 (total: 253+)
00000061: PUSH1 0x40                         │ Stack: [0x40, 0x0060] # gas: 3 (total: 256+)
00000063: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0060] # gas: 3 (total: 259+) # memory read: free memory pointer
00000064: PUSH2 0x006d                       │ Stack: [0x006d, [M@0x40], 0x40, 0x0060] # gas: 3 (total: 262+)
00000067: SWAP2                              │ Stack: [0x40, [M@0x40], 0x006d, 0x0060] # gas: 3 (total: 265+)
00000068: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x006d, 0x0060] # gas: 3 (total: 268+)
00000069: PUSH2 0x0133                       │ Stack: [0x0133, [M@0x40], 0x40, 0x006d, ...+1] # gas: 3 (total: 271+)
0000006c: JUMP                               │ Stack: [[M@0x40], 0x40, 0x006d, 0x0060] # gas: 8 (total: 279+)
0000006d: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x006d, 0x0060] # gas: 1 (total: 280+)
0000006e: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x006d, ...+1] # gas: 3 (total: 283+)
00000070: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 286+) # memory read: free memory pointer
00000071: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 289+)
00000072: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 292+)
00000073: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 295+)
00000074: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 298+)
00000075: RETURN                             │ Stack: [] # gas: 0 (total: 298+)
00000076: JUMPDEST                           │ Stack: [] # === setB(uint256) === # gas: 1 (total: 299+)
00000077: PUSH2 0x0090                       │ Stack: [0x0090] # gas: 3 (total: 302+)
0000007a: PUSH1 0x04                         │ Stack: [0x04, 0x0090] # gas: 3 (total: 305+)
0000007c: DUP1                               │ Stack: [0x04, 0x04, 0x0090] # gas: 3 (total: 308+)
0000007d: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x0090] # gas: 2 (total: 310+)
0000007e: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 313+)
0000007f: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 316+)
00000080: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 319+)
00000081: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 322+)
00000082: PUSH2 0x008b                       │ Stack: [0x008b, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 325+)
00000085: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 328+)
00000086: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 331+)
00000087: PUSH2 0x017a                       │ Stack: [0x017a, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, ...+5] # gas: 3 (total: 334+)
0000008a: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 342+)
0000008b: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 343+)
0000008c: PUSH2 0x00ee                       │ Stack: [0x00ee, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, ...+5] # gas: 3 (total: 346+)
0000008f: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 354+)
00000090: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008b, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 355+)
00000091: STOP                               │ Stack: [] # gas: 0 (total: 355+)
00000092: JUMPDEST                           │ Stack: [] # === valueA() === # gas: 1 (total: 356+)
00000093: PUSH2 0x009a                       │ Stack: [0x009a] # gas: 3 (total: 359+)
00000096: PUSH2 0x00f8                       │ Stack: [0x00f8, 0x009a] # gas: 3 (total: 362+)
00000099: JUMP                               │ Stack: [0x009a] # gas: 8 (total: 370+)
0000009a: JUMPDEST                           │ Stack: [0x009a] # gas: 1 (total: 371+)
0000009b: PUSH1 0x40                         │ Stack: [0x40, 0x009a] # gas: 3 (total: 374+)
0000009d: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x009a] # gas: 3 (total: 377+) # memory read: free memory pointer
0000009e: PUSH2 0x00a7                       │ Stack: [0x00a7, [M@0x40], 0x40, 0x009a] # gas: 3 (total: 380+)
000000a1: SWAP2                              │ Stack: [0x40, [M@0x40], 0x00a7, 0x009a] # gas: 3 (total: 383+)
000000a2: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x00a7, 0x009a] # gas: 3 (total: 386+)
000000a3: PUSH2 0x0133                       │ Stack: [0x0133, [M@0x40], 0x40, 0x00a7, ...+1] # gas: 3 (total: 389+)
000000a6: JUMP                               │ Stack: [[M@0x40], 0x40, 0x00a7, 0x009a] # gas: 8 (total: 397+)
000000a7: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x00a7, 0x009a] # gas: 1 (total: 398+)
000000a8: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x00a7, ...+1] # gas: 3 (total: 401+)
000000aa: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 404+) # memory read: free memory pointer
000000ab: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 407+)
000000ac: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 410+)
000000ad: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 413+)
000000ae: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 416+)
000000af: RETURN                             │ Stack: [] # gas: 0 (total: 416+)
000000b0: JUMPDEST                           │ Stack: [] # === setBoth(uint256) === # gas: 1 (total: 417+)
000000b1: PUSH2 0x00ca                       │ Stack: [0x00ca] # gas: 3 (total: 420+)
000000b4: PUSH1 0x04                         │ Stack: [0x04, 0x00ca] # gas: 3 (total: 423+)
000000b6: DUP1                               │ Stack: [0x04, 0x04, 0x00ca] # gas: 3 (total: 426+)
000000b7: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x00ca] # gas: 2 (total: 428+)
000000b8: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 431+)
000000b9: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 434+)
000000ba: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 437+)
000000bb: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 440+)
000000bc: PUSH2 0x00c5                       │ Stack: [0x00c5, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 443+)
000000bf: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 446+)
000000c0: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 449+)
000000c1: PUSH2 0x017a                       │ Stack: [0x017a, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, ...+5] # gas: 3 (total: 452+)
000000c4: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 460+)
000000c5: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 461+)
000000c6: PUSH2 0x00fd                       │ Stack: [0x00fd, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, ...+5] # gas: 3 (total: 464+)
000000c9: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 472+)
000000ca: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c5, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 473+)
000000cb: STOP                               │ Stack: [] # gas: 0 (total: 473+)
000000cc: JUMPDEST                           │ Stack: [] # === setA(uint256) === # gas: 1 (total: 474+)
000000cd: PUSH2 0x00e6                       │ Stack: [0x00e6] # gas: 3 (total: 477+)
000000d0: PUSH1 0x04                         │ Stack: [0x04, 0x00e6] # gas: 3 (total: 480+)
000000d2: DUP1                               │ Stack: [0x04, 0x04, 0x00e6] # gas: 3 (total: 483+)
000000d3: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x00e6] # gas: 2 (total: 485+)
000000d4: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 488+)
000000d5: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 491+)
000000d6: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 494+)
000000d7: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 497+)
000000d8: PUSH2 0x00e1                       │ Stack: [0x00e1, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 500+)
000000db: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 503+)
000000dc: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 506+)
000000dd: PUSH2 0x017a                       │ Stack: [0x017a, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, ...+5] # gas: 3 (total: 509+)
000000e0: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 517+)
000000e1: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 518+)
000000e2: PUSH2 0x0112                       │ Stack: [0x0112, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, ...+5] # gas: 3 (total: 521+)
000000e5: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 529+)
000000e6: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00e1, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 530+)
000000e7: STOP                               │ Stack: [] # gas: 0 (total: 530+)
000000e8: JUMPDEST                           │ Stack: [] # gas: 1 (total: 531+)
000000e9: PUSH1 0x01                         │ Stack: [0x01] # gas: 3 (total: 534+)
000000eb: SLOAD                              │ Stack: [[S@0x01], 0x01] # gas: 100 (warm) / 2100 (cold) (total: 634+)
000000ec: DUP2                               │ Stack: [0x01, [S@0x01], 0x01] # gas: 3 (total: 637+)
000000ed: JUMP                               │ Stack: [[S@0x01], 0x01] # gas: 8 (total: 645+)
000000ee: JUMPDEST                           │ Stack: [[S@0x01], 0x01] # gas: 1 (total: 646+)
000000ef: DUP1                               │ Stack: [[S@0x01], [S@0x01], 0x01] # gas: 3 (total: 649+)
000000f0: PUSH1 0x01                         │ Stack: [0x01, [S@0x01], [S@0x01], 0x01] # gas: 3 (total: 652+)
000000f2: DUP2                               │ Stack: [[S@0x01], 0x01, [S@0x01], [S@0x01], ...+1] # gas: 3 (total: 655+)
000000f3: SWAP1                              │ Stack: [0x01, [S@0x01], [S@0x01], [S@0x01], ...+1] # gas: 3 (total: 658+)
000000f4: SSTORE                             │ Stack: [[S@0x01], [S@0x01], 0x01] # gas: 100 (warm) / 20000 (cold new) (total: 758+)
000000f5: POP                                │ Stack: [[S@0x01], 0x01] # gas: 2 (total: 760+)
000000f6: POP                                │ Stack: [0x01] # gas: 2 (total: 762+)
000000f7: JUMP                               │ Stack: [] # gas: 8 (total: 770+)
000000f8: JUMPDEST                           │ Stack: [] # gas: 1 (total: 771+)
000000f9: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 773+)
000000fa: SLOAD                              │ Stack: [[S@0x0], 0x0] # gas: 100 (warm) / 2100 (cold) (total: 873+)
000000fb: DUP2                               │ Stack: [0x0, [S@0x0], 0x0] # gas: 3 (total: 876+)
000000fc: JUMP                               │ Stack: [[S@0x0], 0x0] # gas: 8 (total: 884+)
000000fd: JUMPDEST                           │ Stack: [[S@0x0], 0x0] # gas: 1 (total: 885+)
000000fe: PUSH2 0x0106                       │ Stack: [0x0106, [S@0x0], 0x0] # gas: 3 (total: 888+)
00000101: DUP2                               │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 3 (total: 891+)
00000102: PUSH2 0x0112                       │ Stack: [0x0112, [S@0x0], 0x0106, [S@0x0], ...+1] # gas: 3 (total: 894+)
00000105: JUMP                               │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 8 (total: 902+)
00000106: JUMPDEST                           │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 1 (total: 903+)
00000107: PUSH2 0x010f                       │ Stack: [0x010f, [S@0x0], 0x0106, [S@0x0], ...+1] # gas: 3 (total: 906+)
0000010a: DUP2                               │ Stack: [[S@0x0], 0x010f, [S@0x0], 0x0106, ...+2] # gas: 3 (total: 909+)
0000010b: PUSH2 0x00ee                       │ Stack: [0x00ee, [S@0x0], 0x010f, [S@0x0], ...+3] # gas: 3 (total: 912+)
0000010e: JUMP                               │ Stack: [[S@0x0], 0x010f, [S@0x0], 0x0106, ...+2] # gas: 8 (total: 920+)
0000010f: JUMPDEST                           │ Stack: [[S@0x0], 0x010f, [S@0x0], 0x0106, ...+2] # gas: 1 (total: 921+)
00000110: POP                                │ Stack: [0x010f, [S@0x0], 0x0106, [S@0x0], ...+1] # gas: 2 (total: 923+)
00000111: JUMP                               │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 8 (total: 931+)
00000112: JUMPDEST                           │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 1 (total: 932+)
00000113: DUP1                               │ Stack: [[S@0x0], [S@0x0], 0x0106, [S@0x0], ...+1] # gas: 3 (total: 935+)
00000114: PUSH0                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0106, ...+2] # gas: 2 (total: 937+)
00000115: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], [S@0x0], ...+3] # gas: 3 (total: 940+)
00000116: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], [S@0x0], ...+3] # gas: 3 (total: 943+)
00000117: SSTORE                             │ Stack: [[S@0x0], [S@0x0], 0x0106, [S@0x0], ...+1] # gas: 100 (warm) / 20000 (cold new) (total: 1043+)
00000118: POP                                │ Stack: [[S@0x0], 0x0106, [S@0x0], 0x0] # gas: 2 (total: 1045+)
00000119: POP                                │ Stack: [0x0106, [S@0x0], 0x0] # gas: 2 (total: 1047+)
0000011a: JUMP                               │ Stack: [[S@0x0], 0x0] # gas: 8 (total: 1055+)
0000011b: JUMPDEST                           │ Stack: [[S@0x0], 0x0] # gas: 1 (total: 1056+)
0000011c: PUSH0                              │ Stack: [0x0, [S@0x0], 0x0] # gas: 2 (total: 1058+)
0000011d: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], 0x0] # gas: 3 (total: 1061+)
0000011e: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0] # gas: 3 (total: 1064+)
0000011f: POP                                │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 2 (total: 1066+)
00000120: SWAP2                              │ Stack: [0x0, [S@0x0], [S@0x0]] # gas: 3 (total: 1069+)
00000121: SWAP1                              │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 3 (total: 1072+)
00000122: POP                                │ Stack: [0x0, [S@0x0]] # gas: 2 (total: 1074+)
00000123: JUMP                               │ Stack: [[S@0x0]] # gas: 8 (total: 1082+)
00000124: JUMPDEST                           │ Stack: [[S@0x0]] # gas: 1 (total: 1083+)
00000125: PUSH2 0x012d                       │ Stack: [0x012d, [S@0x0]] # gas: 3 (total: 1086+)
00000128: DUP2                               │ Stack: [[S@0x0], 0x012d, [S@0x0]] # gas: 3 (total: 1089+)
00000129: PUSH2 0x011b                       │ Stack: [0x011b, [S@0x0], 0x012d, [S@0x0]] # gas: 3 (total: 1092+)
0000012c: JUMP                               │ Stack: [[S@0x0], 0x012d, [S@0x0]] # gas: 8 (total: 1100+)
0000012d: JUMPDEST                           │ Stack: [[S@0x0], 0x012d, [S@0x0]] # gas: 1 (total: 1101+)
0000012e: DUP3                               │ Stack: [[S@0x0], [S@0x0], 0x012d, [S@0x0]] # gas: 3 (total: 1104+)
0000012f: MSTORE                             │ Stack: [0x012d, [S@0x0]] # gas: 3 (total: 1107+)
00000130: POP                                │ Stack: [[S@0x0]] # gas: 2 (total: 1109+)
00000131: POP                                │ Stack: [] # gas: 2 (total: 1111+)
00000132: JUMP                               │ Stack: [] # gas: 8 (total: 1119+)
00000133: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1120+)
00000134: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1122+)
00000135: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 1125+)
00000137: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 1128+)
00000138: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 1131+)
00000139: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 1134+)
0000013a: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 1136+)
0000013b: PUSH2 0x0146                       │ Stack: [0x0146, [?+?], 0x20, 0x0] # gas: 3 (total: 1139+)
0000013e: PUSH0                              │ Stack: [0x0, 0x0146, [?+?], 0x20, ...+1] # gas: 2 (total: 1141+)
0000013f: DUP4                               │ Stack: [0x20, 0x0, 0x0146, [?+?], ...+2] # gas: 3 (total: 1144+)
00000140: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x0146, ...+3] # gas: 3 (total: 1147+)
00000141: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 1150+)
00000142: PUSH2 0x0124                       │ Stack: [0x0124, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 1153+)
00000145: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 1161+)
00000146: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 1162+)
00000147: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 1165+)
00000148: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 1168+)
00000149: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x0146, ...+3] # gas: 2 (total: 1170+)
0000014a: POP                                │ Stack: [0x0, [?+?], 0x0146, [?+?], ...+2] # gas: 2 (total: 1172+)
0000014b: JUMP                               │ Stack: [[?+?], 0x0146, [?+?], 0x20, ...+1] # gas: 8 (total: 1180+)
0000014c: JUMPDEST                           │ Stack: [[?+?], 0x0146, [?+?], 0x20, ...+1] # gas: 1 (total: 1181+)
0000014d: PUSH0                              │ Stack: [0x0, [?+?], 0x0146, [?+?], ...+2] # gas: 2 (total: 1183+)
0000014e: PUSH0                              │ Stack: [0x0, 0x0, [?+?], 0x0146, ...+3] # gas: 2 (total: 1185+)
0000014f: REVERT                             │ Stack: [] # gas: 0 (total: 1185+)
00000150: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1186+)
00000151: PUSH2 0x0159                       │ Stack: [0x0159] # gas: 3 (total: 1189+)
00000154: DUP2                               │ Stack: [?, 0x0159] # gas: 3 (total: 1192+)
00000155: PUSH2 0x011b                       │ Stack: [0x011b, ?, 0x0159] # gas: 3 (total: 1195+)
00000158: JUMP                               │ Stack: [?, 0x0159] # gas: 8 (total: 1203+)
00000159: JUMPDEST                           │ Stack: [?, 0x0159] # gas: 1 (total: 1204+)
0000015a: DUP2                               │ Stack: [0x0159, ?, 0x0159] # gas: 3 (total: 1207+)
0000015b: EQ                                 │ Stack: [[cmp], 0x0159, ?, 0x0159] # gas: 3 (total: 1210+)
0000015c: PUSH2 0x0163                       │ Stack: [0x0163, [cmp], 0x0159, ?, ...+1] # gas: 3 (total: 1213+)
0000015f: JUMPI                              │ Stack: [0x0159, ?, 0x0159] # gas: 10 (total: 1223+)
00000160: PUSH0                              │ Stack: [0x0, 0x0159, ?, 0x0159] # gas: 2 (total: 1225+)
00000161: PUSH0                              │ Stack: [0x0, 0x0, 0x0159, ?, ...+1] # gas: 2 (total: 1227+)
00000162: REVERT                             │ Stack: [] # gas: 0 (total: 1227+)
00000163: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1228+)
00000164: POP                                │ Stack: [] # gas: 2 (total: 1230+)
00000165: JUMP                               │ Stack: [] # gas: 8 (total: 1238+)
00000166: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1239+)
00000167: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1241+)
00000168: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 1244+)
00000169: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 1247+)
0000016a: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 1250+)
0000016b: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 1252+)
0000016c: PUSH2 0x0174                       │ Stack: [0x0174, [CD@?], 0x0] # gas: 3 (total: 1255+)
0000016f: DUP2                               │ Stack: [[CD@?], 0x0174, [CD@?], 0x0] # gas: 3 (total: 1258+)
00000170: PUSH2 0x0150                       │ Stack: [0x0150, [CD@?], 0x0174, [CD@?], ...+1] # gas: 3 (total: 1261+)
00000173: JUMP                               │ Stack: [[CD@?], 0x0174, [CD@?], 0x0] # gas: 8 (total: 1269+)
00000174: JUMPDEST                           │ Stack: [[CD@?], 0x0174, [CD@?], 0x0] # gas: 1 (total: 1270+)
00000175: SWAP3                              │ Stack: [0x0, 0x0174, [CD@?], [CD@?]] # gas: 3 (total: 1273+)
00000176: SWAP2                              │ Stack: [[CD@?], 0x0174, 0x0, [CD@?]] # gas: 3 (total: 1276+)
00000177: POP                                │ Stack: [0x0174, 0x0, [CD@?]] # gas: 2 (total: 1278+)
00000178: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1280+)
00000179: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 1288+)
0000017a: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 1289+)
0000017b: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1291+)
0000017c: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?]] # gas: 3 (total: 1294+)
0000017e: DUP3                               │ Stack: [[CD@?], 0x20, 0x0, [CD@?]] # gas: 3 (total: 1297+)
0000017f: DUP5                               │ Stack: [?, [CD@?], 0x20, 0x0, ...+1] # gas: 3 (total: 1300+)
00000180: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x20, ...+2] # gas: 3 (total: 1303+)
00000181: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 3 (total: 1306+)
00000182: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+4] # gas: 3 (total: 1309+)
00000183: PUSH2 0x018f                       │ Stack: [0x018f, [![cmp]], [cmp], [?-?], ...+5] # gas: 3 (total: 1312+)
00000186: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 10 (total: 1322+)
00000187: PUSH2 0x018e                       │ Stack: [0x018e, [cmp], [?-?], ?, ...+4] # gas: 3 (total: 1325+)
0000018a: PUSH2 0x014c                       │ Stack: [0x014c, 0x018e, [cmp], [?-?], ...+5] # gas: 3 (total: 1328+)
0000018d: JUMP                               │ Stack: [0x018e, [cmp], [?-?], ?, ...+4] # gas: 8 (total: 1336+)
0000018e: JUMPDEST                           │ Stack: [0x018e, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1337+)
0000018f: JUMPDEST                           │ Stack: [0x018e, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1338+)
00000190: PUSH0                              │ Stack: [0x0, 0x018e, [cmp], [?-?], ...+5] # gas: 2 (total: 1340+)
00000191: PUSH2 0x019c                       │ Stack: [0x019c, 0x0, 0x018e, [cmp], ...+6] # gas: 3 (total: 1343+)
00000194: DUP5                               │ Stack: [[?-?], 0x019c, 0x0, 0x018e, ...+7] # gas: 3 (total: 1346+)
00000195: DUP3                               │ Stack: [0x0, [?-?], 0x019c, 0x0, ...+8] # gas: 3 (total: 1349+)
00000196: DUP6                               │ Stack: [[cmp], 0x0, [?-?], 0x019c, ...+9] # gas: 3 (total: 1352+)
00000197: ADD                                │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 3 (total: 1355+)
00000198: PUSH2 0x0166                       │ Stack: [0x0166, [[cmp]+[cmp]], [cmp], 0x0, ...+11] # gas: 3 (total: 1358+)
0000019b: JUMP                               │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 8 (total: 1366+)
0000019c: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 1 (total: 1367+)
0000019d: SWAP2                              │ Stack: [0x0, [cmp], [[cmp]+[cmp]], [?-?], ...+10] # gas: 3 (total: 1370+)
0000019e: POP                                │ Stack: [[cmp], [[cmp]+[cmp]], [?-?], 0x019c, ...+9] # gas: 2 (total: 1372+)
0000019f: POP                                │ Stack: [[[cmp]+[cmp]], [?-?], 0x019c, 0x0, ...+8] # gas: 2 (total: 1374+)
000001a0: SWAP3                              │ Stack: [0x0, [?-?], 0x019c, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1377+)
000001a1: SWAP2                              │ Stack: [0x019c, [?-?], 0x0, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1380+)
000001a2: POP                                │ Stack: [[?-?], 0x0, [[cmp]+[cmp]], 0x018e, ...+7] # gas: 2 (total: 1382+)
000001a3: POP                                │ Stack: [0x0, [[cmp]+[cmp]], 0x018e, [cmp], ...+6] # gas: 2 (total: 1384+)
000001a4: JUMP                               │ Stack: [[[cmp]+[cmp]], 0x018e, [cmp], [?-?], ...+5] # gas: 8 (total: 1392+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

000001a5: INVALID                            │ Stack: [] # gas: 0 (total: 1392+)
000001a6: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 2517+)
000001a7: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 2520+)
000001ad: INVALID                            │ Stack: [] # gas: 0 (total: 2520+)
000001ae: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 2523+)
000001af: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2553+) # mapping/array slot computation
000001b0: INVALID                            │ Stack: [] # gas: 0 (total: 2553+)
000001b1: INVALID                            │ Stack: [] # gas: 0 (total: 2553+)
000001b2: LOG1                               │ Stack: [] # gas: 750 (base + dynamic) (total: 3303+)
000001b3: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001b4: EXTSTATICCALL                      │ Stack: [] # gas: ? (total: 3303+)
000001b5: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001b6: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001b7: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001b8: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001b9: INVALID                            │ Stack: [] # gas: 0 (total: 3303+)
000001ba: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 3305+)
000001bb: SLOAD                              │ Stack: [[S@[CALLVALUE]], [CALLVALUE]] # gas: 100 (warm) / 2100 (cold) (total: 3405+)
000001bc: JUMPF 0x0ed2                       │ Stack: [[S@[CALLVALUE]], [CALLVALUE]] # gas: ? (total: 3405+)
000001bf: INVALID                            │ Stack: [] # gas: 0 (total: 3405+)
000001c0: PUSH9 0xb908d793fed21721d9         │ Stack: [0xb908d793fed21721d9] # gas: 3 (total: 3408+)
000001ca: PUSH21 0xf6cf5dc15664736f6c634300081c00330000000000 │ Stack: [0xf6cf5dc15664736f6c634300081c00330000000000, 0xb908d793fed21721d9] # gas: 3 (total: 3411+)

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
│ Function: setB(uint256)
│ Entry: 0x00000076
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000017a] block

┌────────────────────────────────────────┐
│ Function: valueA()
│ Entry: 0x00000092
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000f8] block

┌────────────────────────────────────────┐
│ Function: setBoth(uint256)
│ Entry: 0x000000b0
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000017a] block

┌────────────────────────────────────────┐
│ Function: setA(uint256)
│ Entry: 0x000000cc
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000017a] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x00000054
  • 0x00000058
  • 0x00000060
  • 0x0000006d
  • 0x00000076
  • 0x0000008b
  • 0x00000090
  • 0x00000092
  • 0x0000009a
  • 0x000000a7
  • 0x000000b0
  • 0x000000c5
  • 0x000000ca
  • 0x000000cc
  • 0x000000e1
  • 0x000000e6
  • 0x000000e8
  • 0x000000ee
  • 0x000000f8
  ... and 19 more

