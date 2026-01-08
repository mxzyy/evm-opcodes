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
00000010: PUSH2 0x024b                       │ Stack: [0x024b] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x024b, 0x024b] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x024b, 0x024b] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x024b, 0x024b] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x024b] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x024b] # gas: 2 (total: 53+)
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
00000015: PUSH2 0x0055                       │ Stack: [0x0055, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
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
0000001f: PUSH4 0x13f1a030                   │ Stack: [0x13f1a030, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# derivedValue() # gas: 3 (total: 128+)
00000024: EQ                                 │ Stack: [[cmp], 0x13f1a030, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000025: PUSH2 0x0059                       │ Stack: [0x0059, [cmp], 0x13f1a030, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000028: JUMPI                              │ Stack: [0x13f1a030, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000029: DUP1                               │ Stack: [0x13f1a030, 0x13f1a030, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 147+)
0000002a: PUSH4 0x3faf24a1                   │ Stack: [0x3faf24a1, 0x13f1a030, 0x13f1a030, [0xe0>>0xe0], ...+6]# setBaseValue(uint256) # gas: 3 (total: 150+)
0000002f: EQ                                 │ Stack: [[cmp], 0x3faf24a1, 0x13f1a030, 0x13f1a030, ...+7] # gas: 3 (total: 153+)
00000030: PUSH2 0x0077                       │ Stack: [0x0077, [cmp], 0x3faf24a1, 0x13f1a030, ...+8] # gas: 3 (total: 156+)
00000033: JUMPI                              │ Stack: [0x3faf24a1, 0x13f1a030, 0x13f1a030, [0xe0>>0xe0], ...+6] # gas: 10 (total: 166+)
00000034: DUP1                               │ Stack: [0x3faf24a1, 0x3faf24a1, 0x13f1a030, 0x13f1a030, ...+7] # gas: 3 (total: 169+)
00000035: PUSH4 0x61bb9c52                   │ Stack: [0x61bb9c52, 0x3faf24a1, 0x3faf24a1, 0x13f1a030, ...+8]# baseValue() # gas: 3 (total: 172+)
0000003a: EQ                                 │ Stack: [[cmp], 0x61bb9c52, 0x3faf24a1, 0x3faf24a1, ...+9] # gas: 3 (total: 175+)
0000003b: PUSH2 0x0093                       │ Stack: [0x0093, [cmp], 0x61bb9c52, 0x3faf24a1, ...+10] # gas: 3 (total: 178+)
0000003e: JUMPI                              │ Stack: [0x61bb9c52, 0x3faf24a1, 0x3faf24a1, 0x13f1a030, ...+8] # gas: 10 (total: 188+)
0000003f: DUP1                               │ Stack: [0x61bb9c52, 0x61bb9c52, 0x3faf24a1, 0x3faf24a1, ...+9] # gas: 3 (total: 191+)
00000040: PUSH4 0xa7c17257                   │ Stack: [0xa7c17257, 0x61bb9c52, 0x61bb9c52, 0x3faf24a1, ...+10]# setDerivedValue(uint256) # gas: 3 (total: 194+)
00000045: EQ                                 │ Stack: [[cmp], 0xa7c17257, 0x61bb9c52, 0x61bb9c52, ...+11] # gas: 3 (total: 197+)
00000046: PUSH2 0x00b1                       │ Stack: [0x00b1, [cmp], 0xa7c17257, 0x61bb9c52, ...+12] # gas: 3 (total: 200+)
00000049: JUMPI                              │ Stack: [0xa7c17257, 0x61bb9c52, 0x61bb9c52, 0x3faf24a1, ...+10] # gas: 10 (total: 210+)
0000004a: DUP1                               │ Stack: [0xa7c17257, 0xa7c17257, 0x61bb9c52, 0x61bb9c52, ...+11] # gas: 3 (total: 213+)
0000004b: PUSH4 0xb592a138                   │ Stack: [0xb592a138, 0xa7c17257, 0xa7c17257, 0x61bb9c52, ...+12]# getBaseValue() # gas: 3 (total: 216+)
00000050: EQ                                 │ Stack: [[cmp], 0xb592a138, 0xa7c17257, 0xa7c17257, ...+13] # gas: 3 (total: 219+)
00000051: PUSH2 0x00cd                       │ Stack: [0x00cd, [cmp], 0xb592a138, 0xa7c17257, ...+14] # gas: 3 (total: 222+)
00000054: JUMPI                              │ Stack: [0xb592a138, 0xa7c17257, 0xa7c17257, 0x61bb9c52, ...+12] # gas: 10 (total: 232+)
00000055: JUMPDEST                           │ Stack: [0xb592a138, 0xa7c17257, 0xa7c17257, 0x61bb9c52, ...+12] # gas: 1 (total: 233+)
00000056: PUSH0                              │ Stack: [0x0, 0xb592a138, 0xa7c17257, 0xa7c17257, ...+13] # gas: 2 (total: 235+)
00000057: PUSH0                              │ Stack: [0x0, 0x0, 0xb592a138, 0xa7c17257, ...+14] # gas: 2 (total: 237+)
00000058: REVERT                             │ Stack: [] # gas: 0 (total: 237+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

00000059: JUMPDEST                           │ Stack: [] # === derivedValue() === # gas: 1 (total: 238+)
0000005a: PUSH2 0x0061                       │ Stack: [0x0061] # gas: 3 (total: 241+)
0000005d: PUSH2 0x00eb                       │ Stack: [0x00eb, 0x0061] # gas: 3 (total: 244+)
00000060: JUMP                               │ Stack: [0x0061] # gas: 8 (total: 252+)
00000061: JUMPDEST                           │ Stack: [0x0061] # gas: 1 (total: 253+)
00000062: PUSH1 0x40                         │ Stack: [0x40, 0x0061] # gas: 3 (total: 256+)
00000064: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0061] # gas: 3 (total: 259+) # memory read: free memory pointer
00000065: PUSH2 0x006e                       │ Stack: [0x006e, [M@0x40], 0x40, 0x0061] # gas: 3 (total: 262+)
00000068: SWAP2                              │ Stack: [0x40, [M@0x40], 0x006e, 0x0061] # gas: 3 (total: 265+)
00000069: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x006e, 0x0061] # gas: 3 (total: 268+)
0000006a: PUSH2 0x0135                       │ Stack: [0x0135, [M@0x40], 0x40, 0x006e, ...+1] # gas: 3 (total: 271+)
0000006d: JUMP                               │ Stack: [[M@0x40], 0x40, 0x006e, 0x0061] # gas: 8 (total: 279+)
0000006e: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x006e, 0x0061] # gas: 1 (total: 280+)
0000006f: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x006e, ...+1] # gas: 3 (total: 283+)
00000071: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 286+) # memory read: free memory pointer
00000072: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 289+)
00000073: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 292+)
00000074: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 295+)
00000075: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 298+)
00000076: RETURN                             │ Stack: [] # gas: 0 (total: 298+)
00000077: JUMPDEST                           │ Stack: [] # === setBaseValue(uint256) === # gas: 1 (total: 299+)
00000078: PUSH2 0x0091                       │ Stack: [0x0091] # gas: 3 (total: 302+)
0000007b: PUSH1 0x04                         │ Stack: [0x04, 0x0091] # gas: 3 (total: 305+)
0000007d: DUP1                               │ Stack: [0x04, 0x04, 0x0091] # gas: 3 (total: 308+)
0000007e: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x0091] # gas: 2 (total: 310+)
0000007f: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 313+)
00000080: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 316+)
00000081: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 319+)
00000082: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 322+)
00000083: PUSH2 0x008c                       │ Stack: [0x008c, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 325+)
00000086: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 328+)
00000087: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 331+)
00000088: PUSH2 0x017c                       │ Stack: [0x017c, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, ...+5] # gas: 3 (total: 334+)
0000008b: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 342+)
0000008c: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 343+)
0000008d: PUSH2 0x00f1                       │ Stack: [0x00f1, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, ...+5] # gas: 3 (total: 346+)
00000090: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 354+)
00000091: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x008c, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 355+)
00000092: STOP                               │ Stack: [] # gas: 0 (total: 355+)
00000093: JUMPDEST                           │ Stack: [] # === baseValue() === # gas: 1 (total: 356+)
00000094: PUSH2 0x009b                       │ Stack: [0x009b] # gas: 3 (total: 359+)
00000097: PUSH2 0x0106                       │ Stack: [0x0106, 0x009b] # gas: 3 (total: 362+)
0000009a: JUMP                               │ Stack: [0x009b] # gas: 8 (total: 370+)
0000009b: JUMPDEST                           │ Stack: [0x009b] # gas: 1 (total: 371+)
0000009c: PUSH1 0x40                         │ Stack: [0x40, 0x009b] # gas: 3 (total: 374+)
0000009e: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x009b] # gas: 3 (total: 377+) # memory read: free memory pointer
0000009f: PUSH2 0x00a8                       │ Stack: [0x00a8, [M@0x40], 0x40, 0x009b] # gas: 3 (total: 380+)
000000a2: SWAP2                              │ Stack: [0x40, [M@0x40], 0x00a8, 0x009b] # gas: 3 (total: 383+)
000000a3: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x00a8, 0x009b] # gas: 3 (total: 386+)
000000a4: PUSH2 0x0135                       │ Stack: [0x0135, [M@0x40], 0x40, 0x00a8, ...+1] # gas: 3 (total: 389+)
000000a7: JUMP                               │ Stack: [[M@0x40], 0x40, 0x00a8, 0x009b] # gas: 8 (total: 397+)
000000a8: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x00a8, 0x009b] # gas: 1 (total: 398+)
000000a9: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x00a8, ...+1] # gas: 3 (total: 401+)
000000ab: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 404+) # memory read: free memory pointer
000000ac: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 407+)
000000ad: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 410+)
000000ae: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 413+)
000000af: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 416+)
000000b0: RETURN                             │ Stack: [] # gas: 0 (total: 416+)
000000b1: JUMPDEST                           │ Stack: [] # === setDerivedValue(uint256) === # gas: 1 (total: 417+)
000000b2: PUSH2 0x00cb                       │ Stack: [0x00cb] # gas: 3 (total: 420+)
000000b5: PUSH1 0x04                         │ Stack: [0x04, 0x00cb] # gas: 3 (total: 423+)
000000b7: DUP1                               │ Stack: [0x04, 0x04, 0x00cb] # gas: 3 (total: 426+)
000000b8: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x00cb] # gas: 2 (total: 428+)
000000b9: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 431+)
000000ba: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 434+)
000000bb: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 437+)
000000bc: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 440+)
000000bd: PUSH2 0x00c6                       │ Stack: [0x00c6, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 443+)
000000c0: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 446+)
000000c1: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 449+)
000000c2: PUSH2 0x017c                       │ Stack: [0x017c, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, ...+5] # gas: 3 (total: 452+)
000000c5: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 460+)
000000c6: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 461+)
000000c7: PUSH2 0x010b                       │ Stack: [0x010b, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, ...+5] # gas: 3 (total: 464+)
000000ca: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 472+)
000000cb: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x00c6, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 473+)
000000cc: STOP                               │ Stack: [] # gas: 0 (total: 473+)
000000cd: JUMPDEST                           │ Stack: [] # === getBaseValue() === # gas: 1 (total: 474+)
000000ce: PUSH2 0x00d5                       │ Stack: [0x00d5] # gas: 3 (total: 477+)
000000d1: PUSH2 0x0115                       │ Stack: [0x0115, 0x00d5] # gas: 3 (total: 480+)
000000d4: JUMP                               │ Stack: [0x00d5] # gas: 8 (total: 488+)
000000d5: JUMPDEST                           │ Stack: [0x00d5] # gas: 1 (total: 489+)
000000d6: PUSH1 0x40                         │ Stack: [0x40, 0x00d5] # gas: 3 (total: 492+)
000000d8: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x00d5] # gas: 3 (total: 495+) # memory read: free memory pointer
000000d9: PUSH2 0x00e2                       │ Stack: [0x00e2, [M@0x40], 0x40, 0x00d5] # gas: 3 (total: 498+)
000000dc: SWAP2                              │ Stack: [0x40, [M@0x40], 0x00e2, 0x00d5] # gas: 3 (total: 501+)
000000dd: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x00e2, 0x00d5] # gas: 3 (total: 504+)
000000de: PUSH2 0x0135                       │ Stack: [0x0135, [M@0x40], 0x40, 0x00e2, ...+1] # gas: 3 (total: 507+)
000000e1: JUMP                               │ Stack: [[M@0x40], 0x40, 0x00e2, 0x00d5] # gas: 8 (total: 515+)
000000e2: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x00e2, 0x00d5] # gas: 1 (total: 516+)
000000e3: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x00e2, ...+1] # gas: 3 (total: 519+)
000000e5: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 522+) # memory read: free memory pointer
000000e6: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 525+)
000000e7: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 528+)
000000e8: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 531+)
000000e9: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 534+)
000000ea: RETURN                             │ Stack: [] # gas: 0 (total: 534+)
000000eb: JUMPDEST                           │ Stack: [] # gas: 1 (total: 535+)
000000ec: PUSH1 0x01                         │ Stack: [0x01] # gas: 3 (total: 538+)
000000ee: SLOAD                              │ Stack: [[S@0x01], 0x01] # gas: 100 (warm) / 2100 (cold) (total: 638+)
000000ef: DUP2                               │ Stack: [0x01, [S@0x01], 0x01] # gas: 3 (total: 641+)
000000f0: JUMP                               │ Stack: [[S@0x01], 0x01] # gas: 8 (total: 649+)
000000f1: JUMPDEST                           │ Stack: [[S@0x01], 0x01] # gas: 1 (total: 650+)
000000f2: PUSH1 0x02                         │ Stack: [0x02, [S@0x01], 0x01] # gas: 3 (total: 653+)
000000f4: DUP2                               │ Stack: [[S@0x01], 0x02, [S@0x01], 0x01] # gas: 3 (total: 656+)
000000f5: PUSH2 0x00fe                       │ Stack: [0x00fe, [S@0x01], 0x02, [S@0x01], ...+1] # gas: 3 (total: 659+)
000000f8: SWAP2                              │ Stack: [0x02, [S@0x01], 0x00fe, [S@0x01], ...+1] # gas: 3 (total: 662+)
000000f9: SWAP1                              │ Stack: [[S@0x01], 0x02, 0x00fe, [S@0x01], ...+1] # gas: 3 (total: 665+)
000000fa: PUSH2 0x01d4                       │ Stack: [0x01d4, [S@0x01], 0x02, 0x00fe, ...+2] # gas: 3 (total: 668+)
000000fd: JUMP                               │ Stack: [[S@0x01], 0x02, 0x00fe, [S@0x01], ...+1] # gas: 8 (total: 676+)
000000fe: JUMPDEST                           │ Stack: [[S@0x01], 0x02, 0x00fe, [S@0x01], ...+1] # gas: 1 (total: 677+)
000000ff: PUSH0                              │ Stack: [0x0, [S@0x01], 0x02, 0x00fe, ...+2] # gas: 2 (total: 679+)
00000100: DUP2                               │ Stack: [[S@0x01], 0x0, [S@0x01], 0x02, ...+3] # gas: 3 (total: 682+)
00000101: SWAP1                              │ Stack: [0x0, [S@0x01], [S@0x01], 0x02, ...+3] # gas: 3 (total: 685+)
00000102: SSTORE                             │ Stack: [[S@0x01], 0x02, 0x00fe, [S@0x01], ...+1] # gas: 100 (warm) / 20000 (cold new) (total: 785+)
00000103: POP                                │ Stack: [0x02, 0x00fe, [S@0x01], 0x01] # gas: 2 (total: 787+)
00000104: POP                                │ Stack: [0x00fe, [S@0x01], 0x01] # gas: 2 (total: 789+)
00000105: JUMP                               │ Stack: [[S@0x01], 0x01] # gas: 8 (total: 797+)
00000106: JUMPDEST                           │ Stack: [[S@0x01], 0x01] # gas: 1 (total: 798+)
00000107: PUSH0                              │ Stack: [0x0, [S@0x01], 0x01] # gas: 2 (total: 800+)
00000108: SLOAD                              │ Stack: [[S@0x0], 0x0, [S@0x01], 0x01] # gas: 100 (warm) / 2100 (cold) (total: 900+)
00000109: DUP2                               │ Stack: [0x0, [S@0x0], 0x0, [S@0x01], ...+1] # gas: 3 (total: 903+)
0000010a: JUMP                               │ Stack: [[S@0x0], 0x0, [S@0x01], 0x01] # gas: 8 (total: 911+)
0000010b: JUMPDEST                           │ Stack: [[S@0x0], 0x0, [S@0x01], 0x01] # gas: 1 (total: 912+)
0000010c: DUP1                               │ Stack: [[S@0x0], [S@0x0], 0x0, [S@0x01], ...+1] # gas: 3 (total: 915+)
0000010d: PUSH1 0x01                         │ Stack: [0x01, [S@0x0], [S@0x0], 0x0, ...+2] # gas: 3 (total: 918+)
0000010f: DUP2                               │ Stack: [[S@0x0], 0x01, [S@0x0], [S@0x0], ...+3] # gas: 3 (total: 921+)
00000110: SWAP1                              │ Stack: [0x01, [S@0x0], [S@0x0], [S@0x0], ...+3] # gas: 3 (total: 924+)
00000111: SSTORE                             │ Stack: [[S@0x0], [S@0x0], 0x0, [S@0x01], ...+1] # gas: 100 (warm) / 20000 (cold new) (total: 1024+)
00000112: POP                                │ Stack: [[S@0x0], 0x0, [S@0x01], 0x01] # gas: 2 (total: 1026+)
00000113: POP                                │ Stack: [0x0, [S@0x01], 0x01] # gas: 2 (total: 1028+)
00000114: JUMP                               │ Stack: [[S@0x01], 0x01] # gas: 8 (total: 1036+)
00000115: JUMPDEST                           │ Stack: [[S@0x01], 0x01] # gas: 1 (total: 1037+)
00000116: PUSH0                              │ Stack: [0x0, [S@0x01], 0x01] # gas: 2 (total: 1039+)
00000117: PUSH0                              │ Stack: [0x0, 0x0, [S@0x01], 0x01] # gas: 2 (total: 1041+)
00000118: SLOAD                              │ Stack: [[S@0x0], 0x0, 0x0, [S@0x01], ...+1] # gas: 100 (warm) / 2100 (cold) (total: 1141+)
00000119: SWAP1                              │ Stack: [0x0, [S@0x0], 0x0, [S@0x01], ...+1] # gas: 3 (total: 1144+)
0000011a: POP                                │ Stack: [[S@0x0], 0x0, [S@0x01], 0x01] # gas: 2 (total: 1146+)
0000011b: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x01], 0x01] # gas: 3 (total: 1149+)
0000011c: JUMP                               │ Stack: [[S@0x0], [S@0x01], 0x01] # gas: 8 (total: 1157+)
0000011d: JUMPDEST                           │ Stack: [[S@0x0], [S@0x01], 0x01] # gas: 1 (total: 1158+)
0000011e: PUSH0                              │ Stack: [0x0, [S@0x0], [S@0x01], 0x01] # gas: 2 (total: 1160+)
0000011f: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], [S@0x01], ...+1] # gas: 3 (total: 1163+)
00000120: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], [S@0x01], ...+1] # gas: 3 (total: 1166+)
00000121: POP                                │ Stack: [[S@0x0], [S@0x0], [S@0x01], 0x01] # gas: 2 (total: 1168+)
00000122: SWAP2                              │ Stack: [[S@0x01], [S@0x0], [S@0x0], 0x01] # gas: 3 (total: 1171+)
00000123: SWAP1                              │ Stack: [[S@0x0], [S@0x01], [S@0x0], 0x01] # gas: 3 (total: 1174+)
00000124: POP                                │ Stack: [[S@0x01], [S@0x0], 0x01] # gas: 2 (total: 1176+)
00000125: JUMP                               │ Stack: [[S@0x0], 0x01] # gas: 8 (total: 1184+)
00000126: JUMPDEST                           │ Stack: [[S@0x0], 0x01] # gas: 1 (total: 1185+)
00000127: PUSH2 0x012f                       │ Stack: [0x012f, [S@0x0], 0x01] # gas: 3 (total: 1188+)
0000012a: DUP2                               │ Stack: [[S@0x0], 0x012f, [S@0x0], 0x01] # gas: 3 (total: 1191+)
0000012b: PUSH2 0x011d                       │ Stack: [0x011d, [S@0x0], 0x012f, [S@0x0], ...+1] # gas: 3 (total: 1194+)
0000012e: JUMP                               │ Stack: [[S@0x0], 0x012f, [S@0x0], 0x01] # gas: 8 (total: 1202+)
0000012f: JUMPDEST                           │ Stack: [[S@0x0], 0x012f, [S@0x0], 0x01] # gas: 1 (total: 1203+)
00000130: DUP3                               │ Stack: [[S@0x0], [S@0x0], 0x012f, [S@0x0], ...+1] # gas: 3 (total: 1206+)
00000131: MSTORE                             │ Stack: [0x012f, [S@0x0], 0x01] # gas: 3 (total: 1209+)
00000132: POP                                │ Stack: [[S@0x0], 0x01] # gas: 2 (total: 1211+)
00000133: POP                                │ Stack: [0x01] # gas: 2 (total: 1213+)
00000134: JUMP                               │ Stack: [] # gas: 8 (total: 1221+)
00000135: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1222+)
00000136: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1224+)
00000137: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 1227+)
00000139: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 1230+)
0000013a: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 1233+)
0000013b: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 1236+)
0000013c: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 1238+)
0000013d: PUSH2 0x0148                       │ Stack: [0x0148, [?+?], 0x20, 0x0] # gas: 3 (total: 1241+)
00000140: PUSH0                              │ Stack: [0x0, 0x0148, [?+?], 0x20, ...+1] # gas: 2 (total: 1243+)
00000141: DUP4                               │ Stack: [0x20, 0x0, 0x0148, [?+?], ...+2] # gas: 3 (total: 1246+)
00000142: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x0148, ...+3] # gas: 3 (total: 1249+)
00000143: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 1252+)
00000144: PUSH2 0x0126                       │ Stack: [0x0126, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 1255+)
00000147: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 1263+)
00000148: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 1264+)
00000149: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 1267+)
0000014a: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 1270+)
0000014b: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x0148, ...+3] # gas: 2 (total: 1272+)
0000014c: POP                                │ Stack: [0x0, [?+?], 0x0148, [?+?], ...+2] # gas: 2 (total: 1274+)
0000014d: JUMP                               │ Stack: [[?+?], 0x0148, [?+?], 0x20, ...+1] # gas: 8 (total: 1282+)
0000014e: JUMPDEST                           │ Stack: [[?+?], 0x0148, [?+?], 0x20, ...+1] # gas: 1 (total: 1283+)
0000014f: PUSH0                              │ Stack: [0x0, [?+?], 0x0148, [?+?], ...+2] # gas: 2 (total: 1285+)
00000150: PUSH0                              │ Stack: [0x0, 0x0, [?+?], 0x0148, ...+3] # gas: 2 (total: 1287+)
00000151: REVERT                             │ Stack: [] # gas: 0 (total: 1287+)
00000152: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1288+)
00000153: PUSH2 0x015b                       │ Stack: [0x015b] # gas: 3 (total: 1291+)
00000156: DUP2                               │ Stack: [?, 0x015b] # gas: 3 (total: 1294+)
00000157: PUSH2 0x011d                       │ Stack: [0x011d, ?, 0x015b] # gas: 3 (total: 1297+)
0000015a: JUMP                               │ Stack: [?, 0x015b] # gas: 8 (total: 1305+)
0000015b: JUMPDEST                           │ Stack: [?, 0x015b] # gas: 1 (total: 1306+)
0000015c: DUP2                               │ Stack: [0x015b, ?, 0x015b] # gas: 3 (total: 1309+)
0000015d: EQ                                 │ Stack: [[cmp], 0x015b, ?, 0x015b] # gas: 3 (total: 1312+)
0000015e: PUSH2 0x0165                       │ Stack: [0x0165, [cmp], 0x015b, ?, ...+1] # gas: 3 (total: 1315+)
00000161: JUMPI                              │ Stack: [0x015b, ?, 0x015b] # gas: 10 (total: 1325+)
00000162: PUSH0                              │ Stack: [0x0, 0x015b, ?, 0x015b] # gas: 2 (total: 1327+)
00000163: PUSH0                              │ Stack: [0x0, 0x0, 0x015b, ?, ...+1] # gas: 2 (total: 1329+)
00000164: REVERT                             │ Stack: [] # gas: 0 (total: 1329+)
00000165: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1330+)
00000166: POP                                │ Stack: [] # gas: 2 (total: 1332+)
00000167: JUMP                               │ Stack: [] # gas: 8 (total: 1340+)
00000168: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1341+)
00000169: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1343+)
0000016a: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 1346+)
0000016b: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 1349+)
0000016c: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 1352+)
0000016d: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 1354+)
0000016e: PUSH2 0x0176                       │ Stack: [0x0176, [CD@?], 0x0] # gas: 3 (total: 1357+)
00000171: DUP2                               │ Stack: [[CD@?], 0x0176, [CD@?], 0x0] # gas: 3 (total: 1360+)
00000172: PUSH2 0x0152                       │ Stack: [0x0152, [CD@?], 0x0176, [CD@?], ...+1] # gas: 3 (total: 1363+)
00000175: JUMP                               │ Stack: [[CD@?], 0x0176, [CD@?], 0x0] # gas: 8 (total: 1371+)
00000176: JUMPDEST                           │ Stack: [[CD@?], 0x0176, [CD@?], 0x0] # gas: 1 (total: 1372+)
00000177: SWAP3                              │ Stack: [0x0, 0x0176, [CD@?], [CD@?]] # gas: 3 (total: 1375+)
00000178: SWAP2                              │ Stack: [[CD@?], 0x0176, 0x0, [CD@?]] # gas: 3 (total: 1378+)
00000179: POP                                │ Stack: [0x0176, 0x0, [CD@?]] # gas: 2 (total: 1380+)
0000017a: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1382+)
0000017b: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 1390+)
0000017c: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 1391+)
0000017d: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1393+)
0000017e: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?]] # gas: 3 (total: 1396+)
00000180: DUP3                               │ Stack: [[CD@?], 0x20, 0x0, [CD@?]] # gas: 3 (total: 1399+)
00000181: DUP5                               │ Stack: [?, [CD@?], 0x20, 0x0, ...+1] # gas: 3 (total: 1402+)
00000182: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x20, ...+2] # gas: 3 (total: 1405+)
00000183: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 3 (total: 1408+)
00000184: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+4] # gas: 3 (total: 1411+)
00000185: PUSH2 0x0191                       │ Stack: [0x0191, [![cmp]], [cmp], [?-?], ...+5] # gas: 3 (total: 1414+)
00000188: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 10 (total: 1424+)
00000189: PUSH2 0x0190                       │ Stack: [0x0190, [cmp], [?-?], ?, ...+4] # gas: 3 (total: 1427+)
0000018c: PUSH2 0x014e                       │ Stack: [0x014e, 0x0190, [cmp], [?-?], ...+5] # gas: 3 (total: 1430+)
0000018f: JUMP                               │ Stack: [0x0190, [cmp], [?-?], ?, ...+4] # gas: 8 (total: 1438+)
00000190: JUMPDEST                           │ Stack: [0x0190, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1439+)
00000191: JUMPDEST                           │ Stack: [0x0190, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1440+)
00000192: PUSH0                              │ Stack: [0x0, 0x0190, [cmp], [?-?], ...+5] # gas: 2 (total: 1442+)
00000193: PUSH2 0x019e                       │ Stack: [0x019e, 0x0, 0x0190, [cmp], ...+6] # gas: 3 (total: 1445+)
00000196: DUP5                               │ Stack: [[?-?], 0x019e, 0x0, 0x0190, ...+7] # gas: 3 (total: 1448+)
00000197: DUP3                               │ Stack: [0x0, [?-?], 0x019e, 0x0, ...+8] # gas: 3 (total: 1451+)
00000198: DUP6                               │ Stack: [[cmp], 0x0, [?-?], 0x019e, ...+9] # gas: 3 (total: 1454+)
00000199: ADD                                │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 3 (total: 1457+)
0000019a: PUSH2 0x0168                       │ Stack: [0x0168, [[cmp]+[cmp]], [cmp], 0x0, ...+11] # gas: 3 (total: 1460+)
0000019d: JUMP                               │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 8 (total: 1468+)
0000019e: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 1 (total: 1469+)
0000019f: SWAP2                              │ Stack: [0x0, [cmp], [[cmp]+[cmp]], [?-?], ...+10] # gas: 3 (total: 1472+)
000001a0: POP                                │ Stack: [[cmp], [[cmp]+[cmp]], [?-?], 0x019e, ...+9] # gas: 2 (total: 1474+)
000001a1: POP                                │ Stack: [[[cmp]+[cmp]], [?-?], 0x019e, 0x0, ...+8] # gas: 2 (total: 1476+)
000001a2: SWAP3                              │ Stack: [0x0, [?-?], 0x019e, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1479+)
000001a3: SWAP2                              │ Stack: [0x019e, [?-?], 0x0, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1482+)
000001a4: POP                                │ Stack: [[?-?], 0x0, [[cmp]+[cmp]], 0x0190, ...+7] # gas: 2 (total: 1484+)
000001a5: POP                                │ Stack: [0x0, [[cmp]+[cmp]], 0x0190, [cmp], ...+6] # gas: 2 (total: 1486+)
000001a6: JUMP                               │ Stack: [[[cmp]+[cmp]], 0x0190, [cmp], [?-?], ...+5] # gas: 8 (total: 1494+)
000001a7: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], 0x0190, [cmp], [?-?], ...+5] # gas: 1 (total: 1495+)

╔════════════════════════════════════════════════════════════════╗
║                      ERROR HANDLERS                            ║
║                  (Panic & Revert Logic)                        ║
╚════════════════════════════════════════════════════════════════╝

000001a8: PUSH32 0x4e487b7100000000000000000000000000000000000000000000000000000000 │ Stack: [0x4e487b7100000000000000000000000000000000000000000000000000000000, [[cmp]+[cmp]], 0x0190, [cmp], ...+6] # gas: 3 (total: 1498+)
000001c9: PUSH0                              │ Stack: [0x0, 0x4e487b7100000000000000000000000000000000000000000000000000000000, [[cmp]+[cmp]], 0x0190, ...+7] # gas: 2 (total: 1500+)
000001ca: MSTORE                             │ Stack: [[[cmp]+[cmp]], 0x0190, [cmp], [?-?], ...+5] # gas: 3 (total: 1503+) # memory write: scratch space
000001cb: PUSH1 0x11                         │ Stack: [0x11, [[cmp]+[cmp]], 0x0190, [cmp], ...+6] # gas: 3 (total: 1506+)
000001cd: PUSH1 0x04                         │ Stack: [0x04, 0x11, [[cmp]+[cmp]], 0x0190, ...+7] # gas: 3 (total: 1509+)
000001cf: MSTORE                             │ Stack: [[[cmp]+[cmp]], 0x0190, [cmp], [?-?], ...+5] # gas: 3 (total: 1512+) # memory write: scratch space
000001d0: PUSH1 0x24                         │ Stack: [0x24, [[cmp]+[cmp]], 0x0190, [cmp], ...+6] # gas: 3 (total: 1515+)
000001d2: PUSH0                              │ Stack: [0x0, 0x24, [[cmp]+[cmp]], 0x0190, ...+7] # gas: 2 (total: 1517+)
000001d3: REVERT                             │ Stack: [] # gas: 0 (total: 1517+)
000001d4: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1518+)
000001d5: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1520+)
000001d6: PUSH2 0x01de                       │ Stack: [0x01de, 0x0] # gas: 3 (total: 1523+)
000001d9: DUP3                               │ Stack: [?, 0x01de, 0x0] # gas: 3 (total: 1526+)
000001da: PUSH2 0x011d                       │ Stack: [0x011d, ?, 0x01de, 0x0] # gas: 3 (total: 1529+)
000001dd: JUMP                               │ Stack: [?, 0x01de, 0x0] # gas: 8 (total: 1537+)
000001de: JUMPDEST                           │ Stack: [?, 0x01de, 0x0] # gas: 1 (total: 1538+)
000001df: SWAP2                              │ Stack: [0x0, 0x01de, ?] # gas: 3 (total: 1541+)
000001e0: POP                                │ Stack: [0x01de, ?] # gas: 2 (total: 1543+)
000001e1: PUSH2 0x01e9                       │ Stack: [0x01e9, 0x01de, ?] # gas: 3 (total: 1546+)
000001e4: DUP4                               │ Stack: [?, 0x01e9, 0x01de, ?] # gas: 3 (total: 1549+)
000001e5: PUSH2 0x011d                       │ Stack: [0x011d, ?, 0x01e9, 0x01de, ...+1] # gas: 3 (total: 1552+)
000001e8: JUMP                               │ Stack: [?, 0x01e9, 0x01de, ?] # gas: 8 (total: 1560+)
000001e9: JUMPDEST                           │ Stack: [?, 0x01e9, 0x01de, ?] # gas: 1 (total: 1561+)
000001ea: SWAP3                              │ Stack: [?, 0x01e9, 0x01de, ?] # gas: 3 (total: 1564+)
000001eb: POP                                │ Stack: [0x01e9, 0x01de, ?] # gas: 2 (total: 1566+)
000001ec: DUP3                               │ Stack: [?, 0x01e9, 0x01de, ?] # gas: 3 (total: 1569+)
000001ed: DUP3                               │ Stack: [0x01de, ?, 0x01e9, 0x01de, ...+1] # gas: 3 (total: 1572+)
000001ee: MUL                                │ Stack: [[0x01de*0x01de], 0x01de, ?, 0x01e9, ...+2] # gas: 5 (total: 1577+)
000001ef: PUSH2 0x01f7                       │ Stack: [0x01f7, [0x01de*0x01de], 0x01de, ?, ...+3] # gas: 3 (total: 1580+)
000001f2: DUP2                               │ Stack: [[0x01de*0x01de], 0x01f7, [0x01de*0x01de], 0x01de, ...+4] # gas: 3 (total: 1583+)
000001f3: PUSH2 0x011d                       │ Stack: [0x011d, [0x01de*0x01de], 0x01f7, [0x01de*0x01de], ...+5] # gas: 3 (total: 1586+)
000001f6: JUMP                               │ Stack: [[0x01de*0x01de], 0x01f7, [0x01de*0x01de], 0x01de, ...+4] # gas: 8 (total: 1594+)
000001f7: JUMPDEST                           │ Stack: [[0x01de*0x01de], 0x01f7, [0x01de*0x01de], 0x01de, ...+4] # gas: 1 (total: 1595+)
000001f8: SWAP2                              │ Stack: [[0x01de*0x01de], 0x01f7, [0x01de*0x01de], 0x01de, ...+4] # gas: 3 (total: 1598+)
000001f9: POP                                │ Stack: [0x01f7, [0x01de*0x01de], 0x01de, ?, ...+3] # gas: 2 (total: 1600+)
000001fa: DUP3                               │ Stack: [0x01de, 0x01f7, [0x01de*0x01de], 0x01de, ...+4] # gas: 3 (total: 1603+)
000001fb: DUP3                               │ Stack: [[0x01de*0x01de], 0x01de, 0x01f7, [0x01de*0x01de], ...+5] # gas: 3 (total: 1606+)
000001fc: DIV                                │ Stack: [[[0x01de*0x01de]/[0x01de*0x01de]], [0x01de*0x01de], 0x01de, 0x01f7, ...+6] # gas: 5 (total: 1611+)
000001fd: DUP5                               │ Stack: [[0x01de*0x01de], [[0x01de*0x01de]/[0x01de*0x01de]], [0x01de*0x01de], 0x01de, ...+7] # gas: 3 (total: 1614+)
000001fe: EQ                                 │ Stack: [[cmp], [0x01de*0x01de], [[0x01de*0x01de]/[0x01de*0x01de]], [0x01de*0x01de], ...+8] # gas: 3 (total: 1617+)
000001ff: DUP4                               │ Stack: [[0x01de*0x01de], [cmp], [0x01de*0x01de], [[0x01de*0x01de]/[0x01de*0x01de]], ...+9] # gas: 3 (total: 1620+)
00000200: ISZERO                             │ Stack: [[![0x01de*0x01de]], [0x01de*0x01de], [cmp], [0x01de*0x01de], ...+10] # gas: 3 (total: 1623+)
00000201: OR                                 │ Stack: [[[![0x01de*0x01de]]|[![0x01de*0x01de]]], [![0x01de*0x01de]], [0x01de*0x01de], [cmp], ...+11] # gas: 3 (total: 1626+)
00000202: PUSH2 0x020e                       │ Stack: [0x020e, [[![0x01de*0x01de]]|[![0x01de*0x01de]]], [![0x01de*0x01de]], [0x01de*0x01de], ...+12] # gas: 3 (total: 1629+)
00000205: JUMPI                              │ Stack: [[![0x01de*0x01de]], [0x01de*0x01de], [cmp], [0x01de*0x01de], ...+10] # gas: 10 (total: 1639+)
00000206: PUSH2 0x020d                       │ Stack: [0x020d, [![0x01de*0x01de]], [0x01de*0x01de], [cmp], ...+11] # gas: 3 (total: 1642+)
00000209: PUSH2 0x01a7                       │ Stack: [0x01a7, 0x020d, [![0x01de*0x01de]], [0x01de*0x01de], ...+12] # gas: 3 (total: 1645+)
0000020c: JUMP                               │ Stack: [0x020d, [![0x01de*0x01de]], [0x01de*0x01de], [cmp], ...+11] # gas: 8 (total: 1653+)
0000020d: JUMPDEST                           │ Stack: [0x020d, [![0x01de*0x01de]], [0x01de*0x01de], [cmp], ...+11] # gas: 1 (total: 1654+)
0000020e: JUMPDEST                           │ Stack: [0x020d, [![0x01de*0x01de]], [0x01de*0x01de], [cmp], ...+11] # gas: 1 (total: 1655+)
0000020f: POP                                │ Stack: [[![0x01de*0x01de]], [0x01de*0x01de], [cmp], [0x01de*0x01de], ...+10] # gas: 2 (total: 1657+)
00000210: SWAP3                              │ Stack: [[0x01de*0x01de], [0x01de*0x01de], [cmp], [![0x01de*0x01de]], ...+10] # gas: 3 (total: 1660+)
00000211: SWAP2                              │ Stack: [[cmp], [0x01de*0x01de], [0x01de*0x01de], [![0x01de*0x01de]], ...+10] # gas: 3 (total: 1663+)
00000212: POP                                │ Stack: [[0x01de*0x01de], [0x01de*0x01de], [![0x01de*0x01de]], [[0x01de*0x01de]/[0x01de*0x01de]], ...+9] # gas: 2 (total: 1665+)
00000213: POP                                │ Stack: [[0x01de*0x01de], [![0x01de*0x01de]], [[0x01de*0x01de]/[0x01de*0x01de]], [0x01de*0x01de], ...+8] # gas: 2 (total: 1667+)
00000214: JUMP                               │ Stack: [[![0x01de*0x01de]], [[0x01de*0x01de]/[0x01de*0x01de]], [0x01de*0x01de], 0x01de, ...+7] # gas: 8 (total: 1675+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

00000215: INVALID                            │ Stack: [] # gas: 0 (total: 1675+)
00000216: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 2800+)
00000217: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 2803+)
0000021d: INVALID                            │ Stack: [] # gas: 0 (total: 2803+)
0000021e: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 2806+)
0000021f: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2836+) # mapping/array slot computation
00000220: INVALID                            │ Stack: [] # gas: 0 (total: 2836+)
00000221: INVALID                            │ Stack: [] # gas: 0 (total: 2836+)
00000222: BALANCE                            │ Stack: [[BALANCE]] # gas: 100 (warm) / 2600 (cold) (total: 2936+)
00000223: INVALID                            │ Stack: [] # gas: 0 (total: 2936+)
00000224: SMOD                               │ Stack: [[UNDERFLOW%UNDERFLOW]] # gas: 5 (total: 2941+)
00000225: DATALOAD                           │ Stack: [[UNDERFLOW%UNDERFLOW]] # gas: ? (total: 2941+)
00000226: PUSH25 0x97975da4f7305a5858330ec38162ec23d092a4f1e44b39c171 │ Stack: [0x97975da4f7305a5858330ec38162ec23d092a4f1e44b39c171, [UNDERFLOW%UNDERFLOW]] # gas: 3 (total: 2944+)
00000240: PUSH5 0x736f6c6343                 │ Stack: [0x736f6c6343, 0x97975da4f7305a5858330ec38162ec23d092a4f1e44b39c171, [UNDERFLOW%UNDERFLOW]] # gas: 3 (total: 2947+)
00000246: STOP                               │ Stack: [] # gas: 0 (total: 2947+)
00000247: ADDMOD                             │ Stack: [[mod_arith]] # gas: 8 (total: 2955+)
00000248: SHR                                │ Stack: [[[mod_arith]>>[mod_arith]], [mod_arith]] # gas: 3 (total: 2958+)
00000249: STOP                               │ Stack: [] # gas: 0 (total: 2958+)
0000024a: CALLER                             │ Stack: [[CALLER]] # gas: 2 (total: 2960+)

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
│ Function: derivedValue()
│ Entry: 0x00000059
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000eb] block

┌────────────────────────────────────────┐
│ Function: setBaseValue(uint256)
│ Entry: 0x00000077
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000017c] block

┌────────────────────────────────────────┐
│ Function: baseValue()
│ Entry: 0x00000093
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x00000106] block

┌────────────────────────────────────────┐
│ Function: setDerivedValue(uint256)
│ Entry: 0x000000b1
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000017c] block

┌────────────────────────────────────────┐
│ Function: getBaseValue()
│ Entry: 0x000000cd
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x00000115] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x00000055
  • 0x00000059
  • 0x00000061
  • 0x0000006e
  • 0x00000077
  • 0x0000008c
  • 0x00000091
  • 0x00000093
  • 0x0000009b
  • 0x000000a8
  • 0x000000b1
  • 0x000000c6
  • 0x000000cb
  • 0x000000cd
  • 0x000000d5
  • 0x000000e2
  • 0x000000eb
  • 0x000000f1
  • 0x000000fe
  ... and 25 more

