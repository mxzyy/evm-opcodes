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
00000010: PUSH2 0x0126                       │ Stack: [0x0126] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x0126, 0x0126] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x0126, 0x0126] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x0126, 0x0126] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x0126] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x0126] # gas: 2 (total: 53+)
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
00000008: PUSH1 0x0e                         │ Stack: [0x0e, [![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 73+)
0000000a: JUMPI                              │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 10 (total: 83+)
0000000b: PUSH0                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 85+)
0000000c: PUSH0                              │ Stack: [0x0, 0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 87+)
0000000d: REVERT                             │ Stack: [] # gas: 0 (total: 87+)
0000000e: JUMPDEST                           │ Stack: [] # gas: 1 (total: 88+)
0000000f: POP                                │ Stack: [] # gas: 2 (total: 90+)
00000010: PUSH1 0x04                         │ Stack: [0x04] # gas: 3 (total: 93+)
00000012: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04] # gas: 2 (total: 95+)
00000013: LT                                 │ Stack: [[cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 98+)
00000014: PUSH1 0x30                         │ Stack: [0x30, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
00000016: JUMPI                              │ Stack: [[CALLDATASIZE], 0x04] # gas: 10 (total: 111+)
00000017: PUSH0                              │ Stack: [0x0, [CALLDATASIZE], 0x04] # gas: 2 (total: 113+)

╔════════════════════════════════════════════════════════════════╗
║                   FUNCTION DISPATCHER                          ║
║             Routes Calls to Function Bodies                    ║
╚════════════════════════════════════════════════════════════════╝

00000018: CALLDATALOAD                       │ Stack: [[CD@0x0], 0x0, [CALLDATASIZE], 0x04] # gas: 3 (total: 116+)
00000019: PUSH1 0xe0                         │ Stack: [0xe0, [CD@0x0], 0x0, [CALLDATASIZE], ...+1] # gas: 3 (total: 119+)
0000001b: SHR                                │ Stack: [[0xe0>>0xe0], 0xe0, [CD@0x0], 0x0, ...+2] # gas: 3 (total: 122+)
0000001c: DUP1                               │ Stack: [[0xe0>>0xe0], [0xe0>>0xe0], 0xe0, [CD@0x0], ...+3] # gas: 3 (total: 125+)
0000001d: PUSH4 0x6af15505                   │ Stack: [0x6af15505, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# valueA() # gas: 3 (total: 128+)
00000022: EQ                                 │ Stack: [[cmp], 0x6af15505, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000023: PUSH1 0x34                         │ Stack: [0x34, [cmp], 0x6af15505, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000025: JUMPI                              │ Stack: [0x6af15505, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000026: DUP1                               │ Stack: [0x6af15505, 0x6af15505, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 147+)
00000027: PUSH4 0xee919d50                   │ Stack: [0xee919d50, 0x6af15505, 0x6af15505, [0xe0>>0xe0], ...+6]# setA(uint256) # gas: 3 (total: 150+)
0000002c: EQ                                 │ Stack: [[cmp], 0xee919d50, 0x6af15505, 0x6af15505, ...+7] # gas: 3 (total: 153+)
0000002d: PUSH1 0x4e                         │ Stack: [0x4e, [cmp], 0xee919d50, 0x6af15505, ...+8] # gas: 3 (total: 156+)
0000002f: JUMPI                              │ Stack: [0xee919d50, 0x6af15505, 0x6af15505, [0xe0>>0xe0], ...+6] # gas: 10 (total: 166+)
00000030: JUMPDEST                           │ Stack: [0xee919d50, 0x6af15505, 0x6af15505, [0xe0>>0xe0], ...+6] # gas: 1 (total: 167+)
00000031: PUSH0                              │ Stack: [0x0, 0xee919d50, 0x6af15505, 0x6af15505, ...+7] # gas: 2 (total: 169+)
00000032: PUSH0                              │ Stack: [0x0, 0x0, 0xee919d50, 0x6af15505, ...+8] # gas: 2 (total: 171+)
00000033: REVERT                             │ Stack: [] # gas: 0 (total: 171+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

00000034: JUMPDEST                           │ Stack: [] # gas: 1 (total: 172+)
00000035: PUSH1 0x3a                         │ Stack: [0x3a] # gas: 3 (total: 175+)
00000037: PUSH1 0x66                         │ Stack: [0x66, 0x3a] # gas: 3 (total: 178+)
00000039: JUMP                               │ Stack: [0x3a] # gas: 8 (total: 186+)
0000003a: JUMPDEST                           │ Stack: [0x3a] # gas: 1 (total: 187+)
0000003b: PUSH1 0x40                         │ Stack: [0x40, 0x3a] # gas: 3 (total: 190+)
0000003d: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x3a] # gas: 3 (total: 193+) # memory read: free memory pointer
0000003e: PUSH1 0x45                         │ Stack: [0x45, [M@0x40], 0x40, 0x3a] # gas: 3 (total: 196+)
00000040: SWAP2                              │ Stack: [0x40, [M@0x40], 0x45, 0x3a] # gas: 3 (total: 199+)
00000041: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x45, 0x3a] # gas: 3 (total: 202+)
00000042: PUSH1 0x8a                         │ Stack: [0x8a, [M@0x40], 0x40, 0x45, ...+1] # gas: 3 (total: 205+)
00000044: JUMP                               │ Stack: [[M@0x40], 0x40, 0x45, 0x3a] # gas: 8 (total: 213+)
00000045: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x45, 0x3a] # gas: 1 (total: 214+)
00000046: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x45, ...+1] # gas: 3 (total: 217+)
00000048: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 220+) # memory read: free memory pointer
00000049: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 223+)
0000004a: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 226+)
0000004b: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 229+)
0000004c: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 232+)
0000004d: RETURN                             │ Stack: [] # gas: 0 (total: 232+)
0000004e: JUMPDEST                           │ Stack: [] # gas: 1 (total: 233+)
0000004f: PUSH1 0x64                         │ Stack: [0x64] # gas: 3 (total: 236+)
00000051: PUSH1 0x04                         │ Stack: [0x04, 0x64] # gas: 3 (total: 239+)
00000053: DUP1                               │ Stack: [0x04, 0x04, 0x64] # gas: 3 (total: 242+)
00000054: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x64] # gas: 2 (total: 244+)
00000055: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 247+)
00000056: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 250+)
00000057: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 253+)
00000058: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 256+)
00000059: PUSH1 0x60                         │ Stack: [0x60, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 259+)
0000005b: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 262+)
0000005c: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 265+)
0000005d: PUSH1 0xca                         │ Stack: [0xca, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, ...+5] # gas: 3 (total: 268+)
0000005f: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 276+)
00000060: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 277+)
00000061: PUSH1 0x6b                         │ Stack: [0x6b, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, ...+5] # gas: 3 (total: 280+)
00000063: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 288+)
00000064: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x60, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 289+)
00000065: STOP                               │ Stack: [] # gas: 0 (total: 289+)
00000066: JUMPDEST                           │ Stack: [] # gas: 1 (total: 290+)
00000067: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 292+)
00000068: SLOAD                              │ Stack: [[S@0x0], 0x0] # gas: 100 (warm) / 2100 (cold) (total: 392+)
00000069: DUP2                               │ Stack: [0x0, [S@0x0], 0x0] # gas: 3 (total: 395+)
0000006a: JUMP                               │ Stack: [[S@0x0], 0x0] # gas: 8 (total: 403+)
0000006b: JUMPDEST                           │ Stack: [[S@0x0], 0x0] # gas: 1 (total: 404+)
0000006c: DUP1                               │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 3 (total: 407+)
0000006d: PUSH0                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0] # gas: 2 (total: 409+)
0000006e: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], [S@0x0], ...+1] # gas: 3 (total: 412+)
0000006f: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], [S@0x0], ...+1] # gas: 3 (total: 415+)
00000070: SSTORE                             │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 100 (warm) / 20000 (cold new) (total: 515+)
00000071: POP                                │ Stack: [[S@0x0], 0x0] # gas: 2 (total: 517+)
00000072: POP                                │ Stack: [0x0] # gas: 2 (total: 519+)
00000073: JUMP                               │ Stack: [] # gas: 8 (total: 527+)
00000074: JUMPDEST                           │ Stack: [] # gas: 1 (total: 528+)
00000075: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 530+)
00000076: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 533+)
00000077: SWAP1                              │ Stack: [0x0, ?] # gas: 3 (total: 536+)
00000078: POP                                │ Stack: [?] # gas: 2 (total: 538+)
00000079: SWAP2                              │ Stack: [?] # gas: 3 (total: 541+)
0000007a: SWAP1                              │ Stack: [?] # gas: 3 (total: 544+)
0000007b: POP                                │ Stack: [] # gas: 2 (total: 546+)
0000007c: JUMP                               │ Stack: [] # gas: 8 (total: 554+)
0000007d: JUMPDEST                           │ Stack: [] # gas: 1 (total: 555+)
0000007e: PUSH1 0x84                         │ Stack: [0x84] # gas: 3 (total: 558+)
00000080: DUP2                               │ Stack: [?, 0x84] # gas: 3 (total: 561+)
00000081: PUSH1 0x74                         │ Stack: [0x74, ?, 0x84] # gas: 3 (total: 564+)
00000083: JUMP                               │ Stack: [?, 0x84] # gas: 8 (total: 572+)
00000084: JUMPDEST                           │ Stack: [?, 0x84] # gas: 1 (total: 573+)
00000085: DUP3                               │ Stack: [?, ?, 0x84] # gas: 3 (total: 576+)
00000086: MSTORE                             │ Stack: [0x84] # gas: 3 (total: 579+)
00000087: POP                                │ Stack: [] # gas: 2 (total: 581+)
00000088: POP                                │ Stack: [] # gas: 2 (total: 583+)
00000089: JUMP                               │ Stack: [] # gas: 8 (total: 591+)
0000008a: JUMPDEST                           │ Stack: [] # gas: 1 (total: 592+)
0000008b: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 594+)
0000008c: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 597+)
0000008e: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 600+)
0000008f: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 603+)
00000090: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 606+)
00000091: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 608+)
00000092: PUSH1 0x9b                         │ Stack: [0x9b, [?+?], 0x20, 0x0] # gas: 3 (total: 611+)
00000094: PUSH0                              │ Stack: [0x0, 0x9b, [?+?], 0x20, ...+1] # gas: 2 (total: 613+)
00000095: DUP4                               │ Stack: [0x20, 0x0, 0x9b, [?+?], ...+2] # gas: 3 (total: 616+)
00000096: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x9b, ...+3] # gas: 3 (total: 619+)
00000097: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 622+)
00000098: PUSH1 0x7d                         │ Stack: [0x7d, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 625+)
0000009a: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 633+)
0000009b: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 634+)
0000009c: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 637+)
0000009d: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 640+)
0000009e: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x9b, ...+3] # gas: 2 (total: 642+)
0000009f: POP                                │ Stack: [0x0, [?+?], 0x9b, [?+?], ...+2] # gas: 2 (total: 644+)
000000a0: JUMP                               │ Stack: [[?+?], 0x9b, [?+?], 0x20, ...+1] # gas: 8 (total: 652+)
000000a1: JUMPDEST                           │ Stack: [[?+?], 0x9b, [?+?], 0x20, ...+1] # gas: 1 (total: 653+)
000000a2: PUSH0                              │ Stack: [0x0, [?+?], 0x9b, [?+?], ...+2] # gas: 2 (total: 655+)
000000a3: PUSH0                              │ Stack: [0x0, 0x0, [?+?], 0x9b, ...+3] # gas: 2 (total: 657+)
000000a4: REVERT                             │ Stack: [] # gas: 0 (total: 657+)
000000a5: JUMPDEST                           │ Stack: [] # gas: 1 (total: 658+)
000000a6: PUSH1 0xac                         │ Stack: [0xac] # gas: 3 (total: 661+)
000000a8: DUP2                               │ Stack: [?, 0xac] # gas: 3 (total: 664+)
000000a9: PUSH1 0x74                         │ Stack: [0x74, ?, 0xac] # gas: 3 (total: 667+)
000000ab: JUMP                               │ Stack: [?, 0xac] # gas: 8 (total: 675+)
000000ac: JUMPDEST                           │ Stack: [?, 0xac] # gas: 1 (total: 676+)
000000ad: DUP2                               │ Stack: [0xac, ?, 0xac] # gas: 3 (total: 679+)
000000ae: EQ                                 │ Stack: [[cmp], 0xac, ?, 0xac] # gas: 3 (total: 682+)
000000af: PUSH1 0xb5                         │ Stack: [0xb5, [cmp], 0xac, ?, ...+1] # gas: 3 (total: 685+)
000000b1: JUMPI                              │ Stack: [0xac, ?, 0xac] # gas: 10 (total: 695+)
000000b2: PUSH0                              │ Stack: [0x0, 0xac, ?, 0xac] # gas: 2 (total: 697+)
000000b3: PUSH0                              │ Stack: [0x0, 0x0, 0xac, ?, ...+1] # gas: 2 (total: 699+)
000000b4: REVERT                             │ Stack: [] # gas: 0 (total: 699+)
000000b5: JUMPDEST                           │ Stack: [] # gas: 1 (total: 700+)
000000b6: POP                                │ Stack: [] # gas: 2 (total: 702+)
000000b7: JUMP                               │ Stack: [] # gas: 8 (total: 710+)
000000b8: JUMPDEST                           │ Stack: [] # gas: 1 (total: 711+)
000000b9: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 713+)
000000ba: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 716+)
000000bb: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 719+)
000000bc: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 722+)
000000bd: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 724+)
000000be: PUSH1 0xc4                         │ Stack: [0xc4, [CD@?], 0x0] # gas: 3 (total: 727+)
000000c0: DUP2                               │ Stack: [[CD@?], 0xc4, [CD@?], 0x0] # gas: 3 (total: 730+)
000000c1: PUSH1 0xa5                         │ Stack: [0xa5, [CD@?], 0xc4, [CD@?], ...+1] # gas: 3 (total: 733+)
000000c3: JUMP                               │ Stack: [[CD@?], 0xc4, [CD@?], 0x0] # gas: 8 (total: 741+)
000000c4: JUMPDEST                           │ Stack: [[CD@?], 0xc4, [CD@?], 0x0] # gas: 1 (total: 742+)
000000c5: SWAP3                              │ Stack: [0x0, 0xc4, [CD@?], [CD@?]] # gas: 3 (total: 745+)
000000c6: SWAP2                              │ Stack: [[CD@?], 0xc4, 0x0, [CD@?]] # gas: 3 (total: 748+)
000000c7: POP                                │ Stack: [0xc4, 0x0, [CD@?]] # gas: 2 (total: 750+)
000000c8: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 752+)
000000c9: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 760+)
000000ca: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 761+)
000000cb: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 763+)
000000cc: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?]] # gas: 3 (total: 766+)
000000ce: DUP3                               │ Stack: [[CD@?], 0x20, 0x0, [CD@?]] # gas: 3 (total: 769+)
000000cf: DUP5                               │ Stack: [?, [CD@?], 0x20, 0x0, ...+1] # gas: 3 (total: 772+)
000000d0: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x20, ...+2] # gas: 3 (total: 775+)
000000d1: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 3 (total: 778+)
000000d2: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+4] # gas: 3 (total: 781+)
000000d3: PUSH1 0xdc                         │ Stack: [0xdc, [![cmp]], [cmp], [?-?], ...+5] # gas: 3 (total: 784+)
000000d5: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 10 (total: 794+)
000000d6: PUSH1 0xdb                         │ Stack: [0xdb, [cmp], [?-?], ?, ...+4] # gas: 3 (total: 797+)
000000d8: PUSH1 0xa1                         │ Stack: [0xa1, 0xdb, [cmp], [?-?], ...+5] # gas: 3 (total: 800+)
000000da: JUMP                               │ Stack: [0xdb, [cmp], [?-?], ?, ...+4] # gas: 8 (total: 808+)
000000db: JUMPDEST                           │ Stack: [0xdb, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 809+)
000000dc: JUMPDEST                           │ Stack: [0xdb, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 810+)
000000dd: PUSH0                              │ Stack: [0x0, 0xdb, [cmp], [?-?], ...+5] # gas: 2 (total: 812+)
000000de: PUSH1 0xe7                         │ Stack: [0xe7, 0x0, 0xdb, [cmp], ...+6] # gas: 3 (total: 815+)
000000e0: DUP5                               │ Stack: [[?-?], 0xe7, 0x0, 0xdb, ...+7] # gas: 3 (total: 818+)
000000e1: DUP3                               │ Stack: [0x0, [?-?], 0xe7, 0x0, ...+8] # gas: 3 (total: 821+)
000000e2: DUP6                               │ Stack: [[cmp], 0x0, [?-?], 0xe7, ...+9] # gas: 3 (total: 824+)
000000e3: ADD                                │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 3 (total: 827+)
000000e4: PUSH1 0xb8                         │ Stack: [0xb8, [[cmp]+[cmp]], [cmp], 0x0, ...+11] # gas: 3 (total: 830+)
000000e6: JUMP                               │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 8 (total: 838+)
000000e7: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 1 (total: 839+)
000000e8: SWAP2                              │ Stack: [0x0, [cmp], [[cmp]+[cmp]], [?-?], ...+10] # gas: 3 (total: 842+)
000000e9: POP                                │ Stack: [[cmp], [[cmp]+[cmp]], [?-?], 0xe7, ...+9] # gas: 2 (total: 844+)
000000ea: POP                                │ Stack: [[[cmp]+[cmp]], [?-?], 0xe7, 0x0, ...+8] # gas: 2 (total: 846+)
000000eb: SWAP3                              │ Stack: [0x0, [?-?], 0xe7, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 849+)
000000ec: SWAP2                              │ Stack: [0xe7, [?-?], 0x0, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 852+)
000000ed: POP                                │ Stack: [[?-?], 0x0, [[cmp]+[cmp]], 0xdb, ...+7] # gas: 2 (total: 854+)
000000ee: POP                                │ Stack: [0x0, [[cmp]+[cmp]], 0xdb, [cmp], ...+6] # gas: 2 (total: 856+)
000000ef: JUMP                               │ Stack: [[[cmp]+[cmp]], 0xdb, [cmp], [?-?], ...+5] # gas: 8 (total: 864+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

000000f0: INVALID                            │ Stack: [] # gas: 0 (total: 864+)
000000f1: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 1989+)
000000f2: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 1992+)
000000f8: INVALID                            │ Stack: [] # gas: 0 (total: 1992+)
000000f9: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 1995+)
000000fa: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2025+) # mapping/array slot computation
000000fb: MCOPY                              │ Stack: [] # gas: 3 (base + dynamic) (total: 2028+)
000000fc: BLOBBASEFEE                        │ Stack: [[BLOBBASEFEE]] # gas: 2 (total: 2030+)
000000fd: PUSH27 0x204e46aa1e09868af7a0e182c9aa73616992f379fd9de82a9f09ed │ Stack: [0x204e46aa1e09868af7a0e182c9aa73616992f379fd9de82a9f09ed, [BLOBBASEFEE]] # gas: 3 (total: 2033+)
00000119: JUMPF 0xf064                       │ Stack: [0x204e46aa1e09868af7a0e182c9aa73616992f379fd9de82a9f09ed, [BLOBBASEFEE]] # gas: ? (total: 2033+)
0000011c: PUSH20 0x6f6c634300081c00330000000000000000000000 │ Stack: [0x6f6c634300081c00330000000000000000000000, 0x204e46aa1e09868af7a0e182c9aa73616992f379fd9de82a9f09ed, [BLOBBASEFEE]] # gas: 3 (total: 2036+)

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
  • 0x00000030
  • 0x00000034
  • 0x0000003a
  • 0x00000045
  • 0x0000004e
  • 0x00000060
  • 0x00000064
  • 0x00000066
  • 0x0000006b
  • 0x00000074
  • 0x0000007d
  • 0x00000084
  • 0x0000008a
  • 0x0000009b
  • 0x000000a1
  • 0x000000a5
  • 0x000000ac
  • 0x000000b5
  • 0x000000b8
  ... and 5 more

