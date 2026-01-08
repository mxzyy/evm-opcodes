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
00000010: PUSH2 0x0125                       │ Stack: [0x0125] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x0125, 0x0125] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x0125, 0x0125] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x0125, 0x0125] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x0125] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x0125] # gas: 2 (total: 53+)
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
00000014: PUSH1 0x2f                         │ Stack: [0x2f, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
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
0000001d: PUSH3 0xdf5161                     │ Stack: [0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 3 (total: 128+)
00000021: EQ                                 │ Stack: [[cmp], 0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000022: PUSH1 0x33                         │ Stack: [0x33, [cmp], 0xdf5161, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000024: JUMPI                              │ Stack: [0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000025: DUP1                               │ Stack: [0xdf5161, 0xdf5161, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 147+)
00000026: PUSH4 0x09cdcf9b                   │ Stack: [0x09cdcf9b, 0xdf5161, 0xdf5161, [0xe0>>0xe0], ...+6]# setB(uint256) # gas: 3 (total: 150+)
0000002b: EQ                                 │ Stack: [[cmp], 0x09cdcf9b, 0xdf5161, 0xdf5161, ...+7] # gas: 3 (total: 153+)
0000002c: PUSH1 0x4d                         │ Stack: [0x4d, [cmp], 0x09cdcf9b, 0xdf5161, ...+8] # gas: 3 (total: 156+)
0000002e: JUMPI                              │ Stack: [0x09cdcf9b, 0xdf5161, 0xdf5161, [0xe0>>0xe0], ...+6] # gas: 10 (total: 166+)
0000002f: JUMPDEST                           │ Stack: [0x09cdcf9b, 0xdf5161, 0xdf5161, [0xe0>>0xe0], ...+6] # gas: 1 (total: 167+)
00000030: PUSH0                              │ Stack: [0x0, 0x09cdcf9b, 0xdf5161, 0xdf5161, ...+7] # gas: 2 (total: 169+)
00000031: PUSH0                              │ Stack: [0x0, 0x0, 0x09cdcf9b, 0xdf5161, ...+8] # gas: 2 (total: 171+)
00000032: REVERT                             │ Stack: [] # gas: 0 (total: 171+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

00000033: JUMPDEST                           │ Stack: [] # gas: 1 (total: 172+)
00000034: PUSH1 0x39                         │ Stack: [0x39] # gas: 3 (total: 175+)
00000036: PUSH1 0x65                         │ Stack: [0x65, 0x39] # gas: 3 (total: 178+)
00000038: JUMP                               │ Stack: [0x39] # gas: 8 (total: 186+)
00000039: JUMPDEST                           │ Stack: [0x39] # gas: 1 (total: 187+)
0000003a: PUSH1 0x40                         │ Stack: [0x40, 0x39] # gas: 3 (total: 190+)
0000003c: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x39] # gas: 3 (total: 193+) # memory read: free memory pointer
0000003d: PUSH1 0x44                         │ Stack: [0x44, [M@0x40], 0x40, 0x39] # gas: 3 (total: 196+)
0000003f: SWAP2                              │ Stack: [0x40, [M@0x40], 0x44, 0x39] # gas: 3 (total: 199+)
00000040: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x44, 0x39] # gas: 3 (total: 202+)
00000041: PUSH1 0x89                         │ Stack: [0x89, [M@0x40], 0x40, 0x44, ...+1] # gas: 3 (total: 205+)
00000043: JUMP                               │ Stack: [[M@0x40], 0x40, 0x44, 0x39] # gas: 8 (total: 213+)
00000044: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x44, 0x39] # gas: 1 (total: 214+)
00000045: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x44, ...+1] # gas: 3 (total: 217+)
00000047: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 220+) # memory read: free memory pointer
00000048: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 223+)
00000049: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 226+)
0000004a: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 229+)
0000004b: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 232+)
0000004c: RETURN                             │ Stack: [] # gas: 0 (total: 232+)
0000004d: JUMPDEST                           │ Stack: [] # gas: 1 (total: 233+)
0000004e: PUSH1 0x63                         │ Stack: [0x63] # gas: 3 (total: 236+)
00000050: PUSH1 0x04                         │ Stack: [0x04, 0x63] # gas: 3 (total: 239+)
00000052: DUP1                               │ Stack: [0x04, 0x04, 0x63] # gas: 3 (total: 242+)
00000053: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x63] # gas: 2 (total: 244+)
00000054: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 247+)
00000055: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 250+)
00000056: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 253+)
00000057: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 256+)
00000058: PUSH1 0x5f                         │ Stack: [0x5f, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 259+)
0000005a: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 262+)
0000005b: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 265+)
0000005c: PUSH1 0xc9                         │ Stack: [0xc9, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, ...+5] # gas: 3 (total: 268+)
0000005e: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 276+)
0000005f: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 277+)
00000060: PUSH1 0x6a                         │ Stack: [0x6a, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, ...+5] # gas: 3 (total: 280+)
00000062: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 288+)
00000063: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x5f, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 289+)
00000064: STOP                               │ Stack: [] # gas: 0 (total: 289+)
00000065: JUMPDEST                           │ Stack: [] # gas: 1 (total: 290+)
00000066: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 292+)
00000067: SLOAD                              │ Stack: [[S@0x0], 0x0] # gas: 100 (warm) / 2100 (cold) (total: 392+)
00000068: DUP2                               │ Stack: [0x0, [S@0x0], 0x0] # gas: 3 (total: 395+)
00000069: JUMP                               │ Stack: [[S@0x0], 0x0] # gas: 8 (total: 403+)
0000006a: JUMPDEST                           │ Stack: [[S@0x0], 0x0] # gas: 1 (total: 404+)
0000006b: DUP1                               │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 3 (total: 407+)
0000006c: PUSH0                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0] # gas: 2 (total: 409+)
0000006d: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], [S@0x0], ...+1] # gas: 3 (total: 412+)
0000006e: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], [S@0x0], ...+1] # gas: 3 (total: 415+)
0000006f: SSTORE                             │ Stack: [[S@0x0], [S@0x0], 0x0] # gas: 100 (warm) / 20000 (cold new) (total: 515+)
00000070: POP                                │ Stack: [[S@0x0], 0x0] # gas: 2 (total: 517+)
00000071: POP                                │ Stack: [0x0] # gas: 2 (total: 519+)
00000072: JUMP                               │ Stack: [] # gas: 8 (total: 527+)
00000073: JUMPDEST                           │ Stack: [] # gas: 1 (total: 528+)
00000074: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 530+)
00000075: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 533+)
00000076: SWAP1                              │ Stack: [0x0, ?] # gas: 3 (total: 536+)
00000077: POP                                │ Stack: [?] # gas: 2 (total: 538+)
00000078: SWAP2                              │ Stack: [?] # gas: 3 (total: 541+)
00000079: SWAP1                              │ Stack: [?] # gas: 3 (total: 544+)
0000007a: POP                                │ Stack: [] # gas: 2 (total: 546+)
0000007b: JUMP                               │ Stack: [] # gas: 8 (total: 554+)
0000007c: JUMPDEST                           │ Stack: [] # gas: 1 (total: 555+)
0000007d: PUSH1 0x83                         │ Stack: [0x83] # gas: 3 (total: 558+)
0000007f: DUP2                               │ Stack: [?, 0x83] # gas: 3 (total: 561+)
00000080: PUSH1 0x73                         │ Stack: [0x73, ?, 0x83] # gas: 3 (total: 564+)
00000082: JUMP                               │ Stack: [?, 0x83] # gas: 8 (total: 572+)
00000083: JUMPDEST                           │ Stack: [?, 0x83] # gas: 1 (total: 573+)
00000084: DUP3                               │ Stack: [?, ?, 0x83] # gas: 3 (total: 576+)
00000085: MSTORE                             │ Stack: [0x83] # gas: 3 (total: 579+)
00000086: POP                                │ Stack: [] # gas: 2 (total: 581+)
00000087: POP                                │ Stack: [] # gas: 2 (total: 583+)
00000088: JUMP                               │ Stack: [] # gas: 8 (total: 591+)
00000089: JUMPDEST                           │ Stack: [] # gas: 1 (total: 592+)
0000008a: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 594+)
0000008b: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 597+)
0000008d: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 600+)
0000008e: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 603+)
0000008f: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 606+)
00000090: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 608+)
00000091: PUSH1 0x9a                         │ Stack: [0x9a, [?+?], 0x20, 0x0] # gas: 3 (total: 611+)
00000093: PUSH0                              │ Stack: [0x0, 0x9a, [?+?], 0x20, ...+1] # gas: 2 (total: 613+)
00000094: DUP4                               │ Stack: [0x20, 0x0, 0x9a, [?+?], ...+2] # gas: 3 (total: 616+)
00000095: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x9a, ...+3] # gas: 3 (total: 619+)
00000096: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 622+)
00000097: PUSH1 0x7c                         │ Stack: [0x7c, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 625+)
00000099: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 633+)
0000009a: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 634+)
0000009b: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 637+)
0000009c: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 640+)
0000009d: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x9a, ...+3] # gas: 2 (total: 642+)
0000009e: POP                                │ Stack: [0x0, [?+?], 0x9a, [?+?], ...+2] # gas: 2 (total: 644+)
0000009f: JUMP                               │ Stack: [[?+?], 0x9a, [?+?], 0x20, ...+1] # gas: 8 (total: 652+)
000000a0: JUMPDEST                           │ Stack: [[?+?], 0x9a, [?+?], 0x20, ...+1] # gas: 1 (total: 653+)
000000a1: PUSH0                              │ Stack: [0x0, [?+?], 0x9a, [?+?], ...+2] # gas: 2 (total: 655+)
000000a2: PUSH0                              │ Stack: [0x0, 0x0, [?+?], 0x9a, ...+3] # gas: 2 (total: 657+)
000000a3: REVERT                             │ Stack: [] # gas: 0 (total: 657+)
000000a4: JUMPDEST                           │ Stack: [] # gas: 1 (total: 658+)
000000a5: PUSH1 0xab                         │ Stack: [0xab] # gas: 3 (total: 661+)
000000a7: DUP2                               │ Stack: [?, 0xab] # gas: 3 (total: 664+)
000000a8: PUSH1 0x73                         │ Stack: [0x73, ?, 0xab] # gas: 3 (total: 667+)
000000aa: JUMP                               │ Stack: [?, 0xab] # gas: 8 (total: 675+)
000000ab: JUMPDEST                           │ Stack: [?, 0xab] # gas: 1 (total: 676+)
000000ac: DUP2                               │ Stack: [0xab, ?, 0xab] # gas: 3 (total: 679+)
000000ad: EQ                                 │ Stack: [[cmp], 0xab, ?, 0xab] # gas: 3 (total: 682+)
000000ae: PUSH1 0xb4                         │ Stack: [0xb4, [cmp], 0xab, ?, ...+1] # gas: 3 (total: 685+)
000000b0: JUMPI                              │ Stack: [0xab, ?, 0xab] # gas: 10 (total: 695+)
000000b1: PUSH0                              │ Stack: [0x0, 0xab, ?, 0xab] # gas: 2 (total: 697+)
000000b2: PUSH0                              │ Stack: [0x0, 0x0, 0xab, ?, ...+1] # gas: 2 (total: 699+)
000000b3: REVERT                             │ Stack: [] # gas: 0 (total: 699+)
000000b4: JUMPDEST                           │ Stack: [] # gas: 1 (total: 700+)
000000b5: POP                                │ Stack: [] # gas: 2 (total: 702+)
000000b6: JUMP                               │ Stack: [] # gas: 8 (total: 710+)
000000b7: JUMPDEST                           │ Stack: [] # gas: 1 (total: 711+)
000000b8: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 713+)
000000b9: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 716+)
000000ba: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 719+)
000000bb: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 722+)
000000bc: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 724+)
000000bd: PUSH1 0xc3                         │ Stack: [0xc3, [CD@?], 0x0] # gas: 3 (total: 727+)
000000bf: DUP2                               │ Stack: [[CD@?], 0xc3, [CD@?], 0x0] # gas: 3 (total: 730+)
000000c0: PUSH1 0xa4                         │ Stack: [0xa4, [CD@?], 0xc3, [CD@?], ...+1] # gas: 3 (total: 733+)
000000c2: JUMP                               │ Stack: [[CD@?], 0xc3, [CD@?], 0x0] # gas: 8 (total: 741+)
000000c3: JUMPDEST                           │ Stack: [[CD@?], 0xc3, [CD@?], 0x0] # gas: 1 (total: 742+)
000000c4: SWAP3                              │ Stack: [0x0, 0xc3, [CD@?], [CD@?]] # gas: 3 (total: 745+)
000000c5: SWAP2                              │ Stack: [[CD@?], 0xc3, 0x0, [CD@?]] # gas: 3 (total: 748+)
000000c6: POP                                │ Stack: [0xc3, 0x0, [CD@?]] # gas: 2 (total: 750+)
000000c7: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 752+)
000000c8: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 760+)
000000c9: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 761+)
000000ca: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 763+)
000000cb: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?]] # gas: 3 (total: 766+)
000000cd: DUP3                               │ Stack: [[CD@?], 0x20, 0x0, [CD@?]] # gas: 3 (total: 769+)
000000ce: DUP5                               │ Stack: [?, [CD@?], 0x20, 0x0, ...+1] # gas: 3 (total: 772+)
000000cf: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x20, ...+2] # gas: 3 (total: 775+)
000000d0: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 3 (total: 778+)
000000d1: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+4] # gas: 3 (total: 781+)
000000d2: PUSH1 0xdb                         │ Stack: [0xdb, [![cmp]], [cmp], [?-?], ...+5] # gas: 3 (total: 784+)
000000d4: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 10 (total: 794+)
000000d5: PUSH1 0xda                         │ Stack: [0xda, [cmp], [?-?], ?, ...+4] # gas: 3 (total: 797+)
000000d7: PUSH1 0xa0                         │ Stack: [0xa0, 0xda, [cmp], [?-?], ...+5] # gas: 3 (total: 800+)
000000d9: JUMP                               │ Stack: [0xda, [cmp], [?-?], ?, ...+4] # gas: 8 (total: 808+)
000000da: JUMPDEST                           │ Stack: [0xda, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 809+)
000000db: JUMPDEST                           │ Stack: [0xda, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 810+)
000000dc: PUSH0                              │ Stack: [0x0, 0xda, [cmp], [?-?], ...+5] # gas: 2 (total: 812+)
000000dd: PUSH1 0xe6                         │ Stack: [0xe6, 0x0, 0xda, [cmp], ...+6] # gas: 3 (total: 815+)
000000df: DUP5                               │ Stack: [[?-?], 0xe6, 0x0, 0xda, ...+7] # gas: 3 (total: 818+)
000000e0: DUP3                               │ Stack: [0x0, [?-?], 0xe6, 0x0, ...+8] # gas: 3 (total: 821+)
000000e1: DUP6                               │ Stack: [[cmp], 0x0, [?-?], 0xe6, ...+9] # gas: 3 (total: 824+)
000000e2: ADD                                │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 3 (total: 827+)
000000e3: PUSH1 0xb7                         │ Stack: [0xb7, [[cmp]+[cmp]], [cmp], 0x0, ...+11] # gas: 3 (total: 830+)
000000e5: JUMP                               │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 8 (total: 838+)
000000e6: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 1 (total: 839+)
000000e7: SWAP2                              │ Stack: [0x0, [cmp], [[cmp]+[cmp]], [?-?], ...+10] # gas: 3 (total: 842+)
000000e8: POP                                │ Stack: [[cmp], [[cmp]+[cmp]], [?-?], 0xe6, ...+9] # gas: 2 (total: 844+)
000000e9: POP                                │ Stack: [[[cmp]+[cmp]], [?-?], 0xe6, 0x0, ...+8] # gas: 2 (total: 846+)
000000ea: SWAP3                              │ Stack: [0x0, [?-?], 0xe6, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 849+)
000000eb: SWAP2                              │ Stack: [0xe6, [?-?], 0x0, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 852+)
000000ec: POP                                │ Stack: [[?-?], 0x0, [[cmp]+[cmp]], 0xda, ...+7] # gas: 2 (total: 854+)
000000ed: POP                                │ Stack: [0x0, [[cmp]+[cmp]], 0xda, [cmp], ...+6] # gas: 2 (total: 856+)
000000ee: JUMP                               │ Stack: [[[cmp]+[cmp]], 0xda, [cmp], [?-?], ...+5] # gas: 8 (total: 864+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

000000ef: INVALID                            │ Stack: [] # gas: 0 (total: 864+)
000000f0: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 1989+)
000000f1: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 1992+)
000000f7: INVALID                            │ Stack: [] # gas: 0 (total: 1992+)
000000f8: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 1995+)
000000f9: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2025+) # mapping/array slot computation
000000fa: EOFCREATE 0xc0                     │ Stack: [[KECCAK]] # gas: ? (total: 2025+)
000000fc: INVALID                            │ Stack: [] # gas: 0 (total: 2025+)
000000fd: INVALID                            │ Stack: [] # gas: 0 (total: 2025+)
000000fe: INVALID                            │ Stack: [] # gas: 0 (total: 2025+)
000000ff: SWAP9                              │ Stack: [] # gas: 3 (total: 2028+)
00000100: DUP11                              │ Stack: [?] # gas: 3 (total: 2031+)
00000101: INVALID                            │ Stack: [] # gas: 0 (total: 2031+)
00000102: DUP4                               │ Stack: [?] # gas: 3 (total: 2034+)
00000103: DIV                                │ Stack: [[?/?], ?] # gas: 5 (total: 2039+)
00000104: INVALID                            │ Stack: [] # gas: 0 (total: 2039+)
00000105: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 3164+)
00000106: SUB                                │ Stack: [[UNDERFLOW-UNDERFLOW]] # gas: 3 (total: 3167+)
00000107: INVALID                            │ Stack: [] # gas: 0 (total: 3167+)
00000108: INVALID                            │ Stack: [] # gas: 0 (total: 3167+)
00000109: GAS                                │ Stack: [[GAS]] # gas: 2 (total: 3169+)
0000010a: SLT                                │ Stack: [[cmp], [GAS]] # gas: 3 (total: 3172+)
0000010b: RETURNDATALOAD                     │ Stack: [[cmp], [GAS]] # gas: ? (total: 3172+)
0000010c: GASLIMIT                           │ Stack: [[GASLIMIT], [cmp], [GAS]] # gas: 2 (total: 3174+)
0000010d: POP                                │ Stack: [[cmp], [GAS]] # gas: 2 (total: 3176+)
0000010e: RETURN                             │ Stack: [] # gas: 0 (total: 3176+)
0000010f: PUSH25 0x90752d53e0b93e9cd1e564736f6c634300081c003300000000 │ Stack: [0x90752d53e0b93e9cd1e564736f6c634300081c003300000000] # gas: 3 (total: 3179+)

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
  • 0x0000002f
  • 0x00000033
  • 0x00000039
  • 0x00000044
  • 0x0000004d
  • 0x0000005f
  • 0x00000063
  • 0x00000065
  • 0x0000006a
  • 0x00000073
  • 0x0000007c
  • 0x00000083
  • 0x00000089
  • 0x0000009a
  • 0x000000a0
  • 0x000000a4
  • 0x000000ab
  • 0x000000b4
  • 0x000000b7
  ... and 5 more

