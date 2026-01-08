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
00000010: PUSH2 0x0171                       │ Stack: [0x0171] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x0171, 0x0171] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x0171, 0x0171] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x0171, 0x0171] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x0171] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x0171] # gas: 2 (total: 53+)
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
00000015: PUSH2 0x003f                       │ Stack: [0x003f, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 101+)
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
0000001f: PUSH4 0x20965255                   │ Stack: [0x20965255, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# getValue() # gas: 3 (total: 128+)
00000024: EQ                                 │ Stack: [[cmp], 0x20965255, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000025: PUSH2 0x0043                       │ Stack: [0x0043, [cmp], 0x20965255, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000028: JUMPI                              │ Stack: [0x20965255, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000029: DUP1                               │ Stack: [0x20965255, 0x20965255, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 147+)
0000002a: PUSH4 0x3fa4f245                   │ Stack: [0x3fa4f245, 0x20965255, 0x20965255, [0xe0>>0xe0], ...+6]# value() # gas: 3 (total: 150+)
0000002f: EQ                                 │ Stack: [[cmp], 0x3fa4f245, 0x20965255, 0x20965255, ...+7] # gas: 3 (total: 153+)
00000030: PUSH2 0x0061                       │ Stack: [0x0061, [cmp], 0x3fa4f245, 0x20965255, ...+8] # gas: 3 (total: 156+)
00000033: JUMPI                              │ Stack: [0x3fa4f245, 0x20965255, 0x20965255, [0xe0>>0xe0], ...+6] # gas: 10 (total: 166+)
00000034: DUP1                               │ Stack: [0x3fa4f245, 0x3fa4f245, 0x20965255, 0x20965255, ...+7] # gas: 3 (total: 169+)
00000035: PUSH4 0x55241077                   │ Stack: [0x55241077, 0x3fa4f245, 0x3fa4f245, 0x20965255, ...+8]# setValue(uint256) # gas: 3 (total: 172+)
0000003a: EQ                                 │ Stack: [[cmp], 0x55241077, 0x3fa4f245, 0x3fa4f245, ...+9] # gas: 3 (total: 175+)
0000003b: PUSH2 0x007f                       │ Stack: [0x007f, [cmp], 0x55241077, 0x3fa4f245, ...+10] # gas: 3 (total: 178+)
0000003e: JUMPI                              │ Stack: [0x55241077, 0x3fa4f245, 0x3fa4f245, 0x20965255, ...+8] # gas: 10 (total: 188+)
0000003f: JUMPDEST                           │ Stack: [0x55241077, 0x3fa4f245, 0x3fa4f245, 0x20965255, ...+8] # gas: 1 (total: 189+)
00000040: PUSH0                              │ Stack: [0x0, 0x55241077, 0x3fa4f245, 0x3fa4f245, ...+9] # gas: 2 (total: 191+)
00000041: PUSH0                              │ Stack: [0x0, 0x0, 0x55241077, 0x3fa4f245, ...+10] # gas: 2 (total: 193+)
00000042: REVERT                             │ Stack: [] # gas: 0 (total: 193+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

00000043: JUMPDEST                           │ Stack: [] # === getValue() === # gas: 1 (total: 194+)
00000044: PUSH2 0x004b                       │ Stack: [0x004b] # gas: 3 (total: 197+)
00000047: PUSH2 0x009b                       │ Stack: [0x009b, 0x004b] # gas: 3 (total: 200+)
0000004a: JUMP                               │ Stack: [0x004b] # gas: 8 (total: 208+)
0000004b: JUMPDEST                           │ Stack: [0x004b] # gas: 1 (total: 209+)
0000004c: PUSH1 0x40                         │ Stack: [0x40, 0x004b] # gas: 3 (total: 212+)
0000004e: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x004b] # gas: 3 (total: 215+) # memory read: free memory pointer
0000004f: PUSH2 0x0058                       │ Stack: [0x0058, [M@0x40], 0x40, 0x004b] # gas: 3 (total: 218+)
00000052: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0058, 0x004b] # gas: 3 (total: 221+)
00000053: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0058, 0x004b] # gas: 3 (total: 224+)
00000054: PUSH2 0x00c9                       │ Stack: [0x00c9, [M@0x40], 0x40, 0x0058, ...+1] # gas: 3 (total: 227+)
00000057: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0058, 0x004b] # gas: 8 (total: 235+)
00000058: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0058, 0x004b] # gas: 1 (total: 236+)
00000059: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0058, ...+1] # gas: 3 (total: 239+)
0000005b: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 242+) # memory read: free memory pointer
0000005c: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 245+)
0000005d: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 248+)
0000005e: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 251+)
0000005f: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 254+)
00000060: RETURN                             │ Stack: [] # gas: 0 (total: 254+)
00000061: JUMPDEST                           │ Stack: [] # === value() === # gas: 1 (total: 255+)
00000062: PUSH2 0x0069                       │ Stack: [0x0069] # gas: 3 (total: 258+)
00000065: PUSH2 0x00a3                       │ Stack: [0x00a3, 0x0069] # gas: 3 (total: 261+)
00000068: JUMP                               │ Stack: [0x0069] # gas: 8 (total: 269+)
00000069: JUMPDEST                           │ Stack: [0x0069] # gas: 1 (total: 270+)
0000006a: PUSH1 0x40                         │ Stack: [0x40, 0x0069] # gas: 3 (total: 273+)
0000006c: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0069] # gas: 3 (total: 276+) # memory read: free memory pointer
0000006d: PUSH2 0x0076                       │ Stack: [0x0076, [M@0x40], 0x40, 0x0069] # gas: 3 (total: 279+)
00000070: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0076, 0x0069] # gas: 3 (total: 282+)
00000071: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0076, 0x0069] # gas: 3 (total: 285+)
00000072: PUSH2 0x00c9                       │ Stack: [0x00c9, [M@0x40], 0x40, 0x0076, ...+1] # gas: 3 (total: 288+)
00000075: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0076, 0x0069] # gas: 8 (total: 296+)
00000076: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0076, 0x0069] # gas: 1 (total: 297+)
00000077: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0076, ...+1] # gas: 3 (total: 300+)
00000079: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 303+) # memory read: free memory pointer
0000007a: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 306+)
0000007b: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 309+)
0000007c: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 312+)
0000007d: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 315+)
0000007e: RETURN                             │ Stack: [] # gas: 0 (total: 315+)
0000007f: JUMPDEST                           │ Stack: [] # === setValue(uint256) === # gas: 1 (total: 316+)
00000080: PUSH2 0x0099                       │ Stack: [0x0099] # gas: 3 (total: 319+)
00000083: PUSH1 0x04                         │ Stack: [0x04, 0x0099] # gas: 3 (total: 322+)
00000085: DUP1                               │ Stack: [0x04, 0x04, 0x0099] # gas: 3 (total: 325+)
00000086: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x0099] # gas: 2 (total: 327+)
00000087: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 330+)
00000088: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 333+)
00000089: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 336+)
0000008a: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 339+)
0000008b: PUSH2 0x0094                       │ Stack: [0x0094, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 342+)
0000008e: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 345+)
0000008f: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 348+)
00000090: PUSH2 0x0110                       │ Stack: [0x0110, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, ...+5] # gas: 3 (total: 351+)
00000093: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 359+)
00000094: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 360+)
00000095: PUSH2 0x00a8                       │ Stack: [0x00a8, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, ...+5] # gas: 3 (total: 363+)
00000098: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 371+)
00000099: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0094, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 372+)
0000009a: STOP                               │ Stack: [] # gas: 0 (total: 372+)
0000009b: JUMPDEST                           │ Stack: [] # gas: 1 (total: 373+)
0000009c: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 375+)
0000009d: PUSH0                              │ Stack: [0x0, 0x0] # gas: 2 (total: 377+)
0000009e: SLOAD                              │ Stack: [[S@0x0], 0x0, 0x0] # gas: 100 (warm) / 2100 (cold) (total: 477+)
0000009f: SWAP1                              │ Stack: [0x0, [S@0x0], 0x0] # gas: 3 (total: 480+)
000000a0: POP                                │ Stack: [[S@0x0], 0x0] # gas: 2 (total: 482+)
000000a1: SWAP1                              │ Stack: [0x0, [S@0x0]] # gas: 3 (total: 485+)
000000a2: JUMP                               │ Stack: [[S@0x0]] # gas: 8 (total: 493+)
000000a3: JUMPDEST                           │ Stack: [[S@0x0]] # gas: 1 (total: 494+)
000000a4: PUSH0                              │ Stack: [0x0, [S@0x0]] # gas: 2 (total: 496+)
000000a5: SLOAD                              │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 100 (warm) / 2100 (cold) (total: 596+)
000000a6: DUP2                               │ Stack: [0x0, [S@0x0], 0x0, [S@0x0]] # gas: 3 (total: 599+)
000000a7: JUMP                               │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 8 (total: 607+)
000000a8: JUMPDEST                           │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 1 (total: 608+)
000000a9: DUP1                               │ Stack: [[S@0x0], [S@0x0], 0x0, [S@0x0]] # gas: 3 (total: 611+)
000000aa: PUSH0                              │ Stack: [0x0, [S@0x0], [S@0x0], 0x0, ...+1] # gas: 2 (total: 613+)
000000ab: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0], [S@0x0], ...+2] # gas: 3 (total: 616+)
000000ac: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0], [S@0x0], ...+2] # gas: 3 (total: 619+)
000000ad: SSTORE                             │ Stack: [[S@0x0], [S@0x0], 0x0, [S@0x0]] # gas: 100 (warm) / 20000 (cold new) (total: 719+)
000000ae: POP                                │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 2 (total: 721+)
000000af: POP                                │ Stack: [0x0, [S@0x0]] # gas: 2 (total: 723+)
000000b0: JUMP                               │ Stack: [[S@0x0]] # gas: 8 (total: 731+)
000000b1: JUMPDEST                           │ Stack: [[S@0x0]] # gas: 1 (total: 732+)
000000b2: PUSH0                              │ Stack: [0x0, [S@0x0]] # gas: 2 (total: 734+)
000000b3: DUP2                               │ Stack: [[S@0x0], 0x0, [S@0x0]] # gas: 3 (total: 737+)
000000b4: SWAP1                              │ Stack: [0x0, [S@0x0], [S@0x0]] # gas: 3 (total: 740+)
000000b5: POP                                │ Stack: [[S@0x0], [S@0x0]] # gas: 2 (total: 742+)
000000b6: SWAP2                              │ Stack: [[S@0x0], [S@0x0]] # gas: 3 (total: 745+)
000000b7: SWAP1                              │ Stack: [[S@0x0], [S@0x0]] # gas: 3 (total: 748+)
000000b8: POP                                │ Stack: [[S@0x0]] # gas: 2 (total: 750+)
000000b9: JUMP                               │ Stack: [] # gas: 8 (total: 758+)
000000ba: JUMPDEST                           │ Stack: [] # gas: 1 (total: 759+)
000000bb: PUSH2 0x00c3                       │ Stack: [0x00c3] # gas: 3 (total: 762+)
000000be: DUP2                               │ Stack: [?, 0x00c3] # gas: 3 (total: 765+)
000000bf: PUSH2 0x00b1                       │ Stack: [0x00b1, ?, 0x00c3] # gas: 3 (total: 768+)
000000c2: JUMP                               │ Stack: [?, 0x00c3] # gas: 8 (total: 776+)
000000c3: JUMPDEST                           │ Stack: [?, 0x00c3] # gas: 1 (total: 777+)
000000c4: DUP3                               │ Stack: [?, ?, 0x00c3] # gas: 3 (total: 780+)
000000c5: MSTORE                             │ Stack: [0x00c3] # gas: 3 (total: 783+)
000000c6: POP                                │ Stack: [] # gas: 2 (total: 785+)
000000c7: POP                                │ Stack: [] # gas: 2 (total: 787+)
000000c8: JUMP                               │ Stack: [] # gas: 8 (total: 795+)
000000c9: JUMPDEST                           │ Stack: [] # gas: 1 (total: 796+)
000000ca: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 798+)
000000cb: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 801+)
000000cd: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 804+)
000000ce: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 807+)
000000cf: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 810+)
000000d0: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 812+)
000000d1: PUSH2 0x00dc                       │ Stack: [0x00dc, [?+?], 0x20, 0x0] # gas: 3 (total: 815+)
000000d4: PUSH0                              │ Stack: [0x0, 0x00dc, [?+?], 0x20, ...+1] # gas: 2 (total: 817+)
000000d5: DUP4                               │ Stack: [0x20, 0x0, 0x00dc, [?+?], ...+2] # gas: 3 (total: 820+)
000000d6: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x00dc, ...+3] # gas: 3 (total: 823+)
000000d7: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 826+)
000000d8: PUSH2 0x00ba                       │ Stack: [0x00ba, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 829+)
000000db: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 837+)
000000dc: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 838+)
000000dd: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 841+)
000000de: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 844+)
000000df: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x00dc, ...+3] # gas: 2 (total: 846+)
000000e0: POP                                │ Stack: [0x0, [?+?], 0x00dc, [?+?], ...+2] # gas: 2 (total: 848+)
000000e1: JUMP                               │ Stack: [[?+?], 0x00dc, [?+?], 0x20, ...+1] # gas: 8 (total: 856+)
000000e2: JUMPDEST                           │ Stack: [[?+?], 0x00dc, [?+?], 0x20, ...+1] # gas: 1 (total: 857+)
000000e3: PUSH0                              │ Stack: [0x0, [?+?], 0x00dc, [?+?], ...+2] # gas: 2 (total: 859+)
000000e4: PUSH0                              │ Stack: [0x0, 0x0, [?+?], 0x00dc, ...+3] # gas: 2 (total: 861+)
000000e5: REVERT                             │ Stack: [] # gas: 0 (total: 861+)
000000e6: JUMPDEST                           │ Stack: [] # gas: 1 (total: 862+)
000000e7: PUSH2 0x00ef                       │ Stack: [0x00ef] # gas: 3 (total: 865+)
000000ea: DUP2                               │ Stack: [?, 0x00ef] # gas: 3 (total: 868+)
000000eb: PUSH2 0x00b1                       │ Stack: [0x00b1, ?, 0x00ef] # gas: 3 (total: 871+)
000000ee: JUMP                               │ Stack: [?, 0x00ef] # gas: 8 (total: 879+)
000000ef: JUMPDEST                           │ Stack: [?, 0x00ef] # gas: 1 (total: 880+)
000000f0: DUP2                               │ Stack: [0x00ef, ?, 0x00ef] # gas: 3 (total: 883+)
000000f1: EQ                                 │ Stack: [[cmp], 0x00ef, ?, 0x00ef] # gas: 3 (total: 886+)
000000f2: PUSH2 0x00f9                       │ Stack: [0x00f9, [cmp], 0x00ef, ?, ...+1] # gas: 3 (total: 889+)
000000f5: JUMPI                              │ Stack: [0x00ef, ?, 0x00ef] # gas: 10 (total: 899+)
000000f6: PUSH0                              │ Stack: [0x0, 0x00ef, ?, 0x00ef] # gas: 2 (total: 901+)
000000f7: PUSH0                              │ Stack: [0x0, 0x0, 0x00ef, ?, ...+1] # gas: 2 (total: 903+)
000000f8: REVERT                             │ Stack: [] # gas: 0 (total: 903+)
000000f9: JUMPDEST                           │ Stack: [] # gas: 1 (total: 904+)
000000fa: POP                                │ Stack: [] # gas: 2 (total: 906+)
000000fb: JUMP                               │ Stack: [] # gas: 8 (total: 914+)
000000fc: JUMPDEST                           │ Stack: [] # gas: 1 (total: 915+)
000000fd: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 917+)
000000fe: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 920+)
000000ff: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 923+)
00000100: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 926+)
00000101: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 928+)
00000102: PUSH2 0x010a                       │ Stack: [0x010a, [CD@?], 0x0] # gas: 3 (total: 931+)
00000105: DUP2                               │ Stack: [[CD@?], 0x010a, [CD@?], 0x0] # gas: 3 (total: 934+)
00000106: PUSH2 0x00e6                       │ Stack: [0x00e6, [CD@?], 0x010a, [CD@?], ...+1] # gas: 3 (total: 937+)
00000109: JUMP                               │ Stack: [[CD@?], 0x010a, [CD@?], 0x0] # gas: 8 (total: 945+)
0000010a: JUMPDEST                           │ Stack: [[CD@?], 0x010a, [CD@?], 0x0] # gas: 1 (total: 946+)
0000010b: SWAP3                              │ Stack: [0x0, 0x010a, [CD@?], [CD@?]] # gas: 3 (total: 949+)
0000010c: SWAP2                              │ Stack: [[CD@?], 0x010a, 0x0, [CD@?]] # gas: 3 (total: 952+)
0000010d: POP                                │ Stack: [0x010a, 0x0, [CD@?]] # gas: 2 (total: 954+)
0000010e: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 956+)
0000010f: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 964+)
00000110: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 965+)
00000111: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 967+)
00000112: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?]] # gas: 3 (total: 970+)
00000114: DUP3                               │ Stack: [[CD@?], 0x20, 0x0, [CD@?]] # gas: 3 (total: 973+)
00000115: DUP5                               │ Stack: [?, [CD@?], 0x20, 0x0, ...+1] # gas: 3 (total: 976+)
00000116: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x20, ...+2] # gas: 3 (total: 979+)
00000117: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 3 (total: 982+)
00000118: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+4] # gas: 3 (total: 985+)
00000119: PUSH2 0x0125                       │ Stack: [0x0125, [![cmp]], [cmp], [?-?], ...+5] # gas: 3 (total: 988+)
0000011c: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+3] # gas: 10 (total: 998+)
0000011d: PUSH2 0x0124                       │ Stack: [0x0124, [cmp], [?-?], ?, ...+4] # gas: 3 (total: 1001+)
00000120: PUSH2 0x00e2                       │ Stack: [0x00e2, 0x0124, [cmp], [?-?], ...+5] # gas: 3 (total: 1004+)
00000123: JUMP                               │ Stack: [0x0124, [cmp], [?-?], ?, ...+4] # gas: 8 (total: 1012+)
00000124: JUMPDEST                           │ Stack: [0x0124, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1013+)
00000125: JUMPDEST                           │ Stack: [0x0124, [cmp], [?-?], ?, ...+4] # gas: 1 (total: 1014+)
00000126: PUSH0                              │ Stack: [0x0, 0x0124, [cmp], [?-?], ...+5] # gas: 2 (total: 1016+)
00000127: PUSH2 0x0132                       │ Stack: [0x0132, 0x0, 0x0124, [cmp], ...+6] # gas: 3 (total: 1019+)
0000012a: DUP5                               │ Stack: [[?-?], 0x0132, 0x0, 0x0124, ...+7] # gas: 3 (total: 1022+)
0000012b: DUP3                               │ Stack: [0x0, [?-?], 0x0132, 0x0, ...+8] # gas: 3 (total: 1025+)
0000012c: DUP6                               │ Stack: [[cmp], 0x0, [?-?], 0x0132, ...+9] # gas: 3 (total: 1028+)
0000012d: ADD                                │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 3 (total: 1031+)
0000012e: PUSH2 0x00fc                       │ Stack: [0x00fc, [[cmp]+[cmp]], [cmp], 0x0, ...+11] # gas: 3 (total: 1034+)
00000131: JUMP                               │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 8 (total: 1042+)
00000132: JUMPDEST                           │ Stack: [[[cmp]+[cmp]], [cmp], 0x0, [?-?], ...+10] # gas: 1 (total: 1043+)
00000133: SWAP2                              │ Stack: [0x0, [cmp], [[cmp]+[cmp]], [?-?], ...+10] # gas: 3 (total: 1046+)
00000134: POP                                │ Stack: [[cmp], [[cmp]+[cmp]], [?-?], 0x0132, ...+9] # gas: 2 (total: 1048+)
00000135: POP                                │ Stack: [[[cmp]+[cmp]], [?-?], 0x0132, 0x0, ...+8] # gas: 2 (total: 1050+)
00000136: SWAP3                              │ Stack: [0x0, [?-?], 0x0132, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1053+)
00000137: SWAP2                              │ Stack: [0x0132, [?-?], 0x0, [[cmp]+[cmp]], ...+8] # gas: 3 (total: 1056+)
00000138: POP                                │ Stack: [[?-?], 0x0, [[cmp]+[cmp]], 0x0124, ...+7] # gas: 2 (total: 1058+)
00000139: POP                                │ Stack: [0x0, [[cmp]+[cmp]], 0x0124, [cmp], ...+6] # gas: 2 (total: 1060+)
0000013a: JUMP                               │ Stack: [[[cmp]+[cmp]], 0x0124, [cmp], [?-?], ...+5] # gas: 8 (total: 1068+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

0000013b: INVALID                            │ Stack: [] # gas: 0 (total: 1068+)
0000013c: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 2193+)
0000013d: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 2196+)
00000143: INVALID                            │ Stack: [] # gas: 0 (total: 2196+)
00000144: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 2199+)
00000145: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2229+) # mapping/array slot computation
00000146: DUPN 0xad                          │ Stack: [[KECCAK]] # gas: ? (total: 2229+)
00000148: DUP16                              │ Stack: [?, [KECCAK]] # gas: 3 (total: 2232+)
00000149: INVALID                            │ Stack: [] # gas: 0 (total: 2232+)
0000014a: ORIGIN                             │ Stack: [[ORIGIN]] # gas: 2 (total: 2234+)
0000014b: INVALID                            │ Stack: [] # gas: 0 (total: 2234+)
0000014c: DUP3                               │ Stack: [?] # gas: 3 (total: 2237+)
0000014d: INVALID                            │ Stack: [] # gas: 0 (total: 2237+)
0000014e: INVALID                            │ Stack: [] # gas: 0 (total: 2237+)
0000014f: DUP9                               │ Stack: [?] # gas: 3 (total: 2240+)
00000150: INVALID                            │ Stack: [] # gas: 0 (total: 2240+)
00000151: INVALID                            │ Stack: [] # gas: 0 (total: 2240+)
00000152: PUSH6 0xdb57ed6b0a34               │ Stack: [0xdb57ed6b0a34] # gas: 3 (total: 2243+)
00000159: SELFDESTRUCT                       │ Stack: [] # gas: 5000 (total: 7243+)
0000015a: INVALID                            │ Stack: [] # gas: 0 (total: 7243+)
0000015b: INVALID                            │ Stack: [] # gas: 0 (total: 7243+)
0000015c: PUSH27 0x3f1b84c44be47a96f964736f6c634300081c003300000000000000 │ Stack: [0x3f1b84c44be47a96f964736f6c634300081c003300000000000000] # gas: 3 (total: 7246+)

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
│ Function: getValue()
│ Entry: 0x00000043
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x0000009b] block

┌────────────────────────────────────────┐
│ Function: value()
│ Entry: 0x00000061
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000a3] block

┌────────────────────────────────────────┐
│ Function: setValue(uint256)
│ Entry: 0x0000007f
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x00000110] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x0000003f
  • 0x00000043
  • 0x0000004b
  • 0x00000058
  • 0x00000061
  • 0x00000069
  • 0x00000076
  • 0x0000007f
  • 0x00000094
  • 0x00000099
  • 0x0000009b
  • 0x000000a3
  • 0x000000a8
  • 0x000000b1
  • 0x000000ba
  • 0x000000c3
  • 0x000000c9
  • 0x000000dc
  • 0x000000e2
  ... and 9 more

