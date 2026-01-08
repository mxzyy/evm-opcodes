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
00000010: PUSH2 0x0197                       │ Stack: [0x0197] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x0197, 0x0197] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x0197, 0x0197] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x0197, 0x0197] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x0197] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x0197] # gas: 2 (total: 53+)
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
0000001f: PUSH4 0x9a9627ff                   │ Stack: [0x9a9627ff, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# efficientTransfer(address,address,uint256) # gas: 3 (total: 128+)
00000024: EQ                                 │ Stack: [[cmp], 0x9a9627ff, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 131+)
00000025: PUSH2 0x002d                       │ Stack: [0x002d, [cmp], 0x9a9627ff, [0xe0>>0xe0], ...+6] # gas: 3 (total: 134+)
00000028: JUMPI                              │ Stack: [0x9a9627ff, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 144+)
00000029: JUMPDEST                           │ Stack: [0x9a9627ff, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 1 (total: 145+)
0000002a: PUSH0                              │ Stack: [0x0, 0x9a9627ff, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 2 (total: 147+)
0000002b: PUSH0                              │ Stack: [0x0, 0x0, 0x9a9627ff, [0xe0>>0xe0], ...+6] # gas: 2 (total: 149+)
0000002c: REVERT                             │ Stack: [] # gas: 0 (total: 149+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

0000002d: JUMPDEST                           │ Stack: [] # === efficientTransfer(address,address,uint256) === # gas: 1 (total: 150+)
0000002e: PUSH2 0x0047                       │ Stack: [0x0047] # gas: 3 (total: 153+)
00000031: PUSH1 0x04                         │ Stack: [0x04, 0x0047] # gas: 3 (total: 156+)
00000033: DUP1                               │ Stack: [0x04, 0x04, 0x0047] # gas: 3 (total: 159+)
00000034: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04, 0x04, 0x0047] # gas: 2 (total: 161+)
00000035: SUB                                │ Stack: [[[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, 0x04, ...+1] # gas: 3 (total: 164+)
00000036: DUP2                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], 0x04, ...+2] # gas: 3 (total: 167+)
00000037: ADD                                │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 170+)
00000038: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], [CALLDATASIZE], ...+3] # gas: 3 (total: 173+)
00000039: PUSH2 0x0042                       │ Stack: [0x0042, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 176+)
0000003c: SWAP2                              │ Stack: [[[CALLDATASIZE]+[CALLDATASIZE]], [CALLDATASIZE], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 179+)
0000003d: SWAP1                              │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 3 (total: 182+)
0000003e: PUSH2 0x0111                       │ Stack: [0x0111, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, ...+5] # gas: 3 (total: 185+)
00000041: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 193+)
00000042: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 194+)
00000043: PUSH2 0x0049                       │ Stack: [0x0049, [CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, ...+5] # gas: 3 (total: 197+)
00000046: JUMP                               │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 8 (total: 205+)
00000047: JUMPDEST                           │ Stack: [[CALLDATASIZE], [[CALLDATASIZE]+[CALLDATASIZE]], 0x0042, [[CALLDATASIZE]-[CALLDATASIZE]], ...+4] # gas: 1 (total: 206+)
00000048: STOP                               │ Stack: [] # gas: 0 (total: 206+)
00000049: JUMPDEST                           │ Stack: [] # gas: 1 (total: 207+)
0000004a: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 209+)
0000004b: DUP4                               │ Stack: [?, 0x0] # gas: 3 (total: 212+)
0000004c: PUSH0                              │ Stack: [0x0, ?, 0x0] # gas: 2 (total: 214+)
0000004d: MSTORE                             │ Stack: [0x0] # gas: 3 (total: 217+)
0000004e: DUP1                               │ Stack: [0x0, 0x0] # gas: 3 (total: 220+)
0000004f: PUSH1 0x20                         │ Stack: [0x20, 0x0, 0x0] # gas: 3 (total: 223+)
00000051: MSTORE                             │ Stack: [0x0] # gas: 3 (total: 226+) # memory write: scratch space
00000052: PUSH1 0x40                         │ Stack: [0x40, 0x0] # gas: 3 (total: 229+)
00000054: PUSH0                              │ Stack: [0x0, 0x40, 0x0] # gas: 2 (total: 231+)
00000055: KECCAK256                          │ Stack: [[KECCAK], 0x0] # gas: 30 (base + dynamic) (total: 261+) # mapping/array slot computation
00000056: DUP1                               │ Stack: [[KECCAK], [KECCAK], 0x0] # gas: 3 (total: 264+)
00000057: SLOAD                              │ Stack: [[S@[KECCAK]], [KECCAK], [KECCAK], 0x0] # gas: 100 (warm) / 2100 (cold) (total: 364+)
00000058: DUP4                               │ Stack: [0x0, [S@[KECCAK]], [KECCAK], [KECCAK], ...+1] # gas: 3 (total: 367+)
00000059: DUP2                               │ Stack: [[S@[KECCAK]], 0x0, [S@[KECCAK]], [KECCAK], ...+2] # gas: 3 (total: 370+)
0000005a: LT                                 │ Stack: [[cmp], [S@[KECCAK]], 0x0, [S@[KECCAK]], ...+3] # gas: 3 (total: 373+)
0000005b: ISZERO                             │ Stack: [[![cmp]], [cmp], [S@[KECCAK]], 0x0, ...+4] # gas: 3 (total: 376+)
0000005c: PUSH2 0x0063                       │ Stack: [0x0063, [![cmp]], [cmp], [S@[KECCAK]], ...+5] # gas: 3 (total: 379+)
0000005f: JUMPI                              │ Stack: [[cmp], [S@[KECCAK]], 0x0, [S@[KECCAK]], ...+3] # gas: 10 (total: 389+)
00000060: PUSH0                              │ Stack: [0x0, [cmp], [S@[KECCAK]], 0x0, ...+4] # gas: 2 (total: 391+)
00000061: PUSH0                              │ Stack: [0x0, 0x0, [cmp], [S@[KECCAK]], ...+5] # gas: 2 (total: 393+)
00000062: REVERT                             │ Stack: [] # gas: 0 (total: 393+)
00000063: JUMPDEST                           │ Stack: [] # gas: 1 (total: 394+)
00000064: DUP5                               │ Stack: [?] # gas: 3 (total: 397+)
00000065: PUSH0                              │ Stack: [0x0, ?] # gas: 2 (total: 399+)
00000066: MSTORE                             │ Stack: [] # gas: 3 (total: 402+)
00000067: PUSH1 0x40                         │ Stack: [0x40] # gas: 3 (total: 405+)
00000069: PUSH0                              │ Stack: [0x0, 0x40] # gas: 2 (total: 407+)
0000006a: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 437+) # mapping/array slot computation
0000006b: DUP1                               │ Stack: [[KECCAK], [KECCAK]] # gas: 3 (total: 440+)
0000006c: SLOAD                              │ Stack: [[S@[KECCAK]], [KECCAK], [KECCAK]] # gas: 100 (warm) / 2100 (cold) (total: 540+)
0000006d: DUP6                               │ Stack: [?, [S@[KECCAK]], [KECCAK], [KECCAK]] # gas: 3 (total: 543+)
0000006e: DUP4                               │ Stack: [[KECCAK], ?, [S@[KECCAK]], [KECCAK], ...+1] # gas: 3 (total: 546+)
0000006f: SUB                                │ Stack: [[[KECCAK]-[KECCAK]], [KECCAK], ?, [S@[KECCAK]], ...+2] # gas: 3 (total: 549+)
00000070: DUP5                               │ Stack: [[KECCAK], [[KECCAK]-[KECCAK]], [KECCAK], ?, ...+3] # gas: 3 (total: 552+)
00000071: SSTORE                             │ Stack: [[KECCAK], ?, [S@[KECCAK]], [KECCAK], ...+1] # gas: 100 (warm) / 20000 (cold new) (total: 652+)
00000072: DUP6                               │ Stack: [?, [KECCAK], ?, [S@[KECCAK]], ...+2] # gas: 3 (total: 655+)
00000073: DUP2                               │ Stack: [[KECCAK], ?, [KECCAK], ?, ...+3] # gas: 3 (total: 658+)
00000074: ADD                                │ Stack: [[[KECCAK]+[KECCAK]], [KECCAK], ?, [KECCAK], ...+4] # gas: 3 (total: 661+)
00000075: DUP3                               │ Stack: [?, [[KECCAK]+[KECCAK]], [KECCAK], ?, ...+5] # gas: 3 (total: 664+)
00000076: SSTORE                             │ Stack: [[KECCAK], ?, [KECCAK], ?, ...+3] # gas: 100 (warm) / 20000 (cold new) (total: 764+)
00000077: POP                                │ Stack: [?, [KECCAK], ?, [S@[KECCAK]], ...+2] # gas: 2 (total: 766+)
00000078: POP                                │ Stack: [[KECCAK], ?, [S@[KECCAK]], [KECCAK], ...+1] # gas: 2 (total: 768+)
00000079: POP                                │ Stack: [?, [S@[KECCAK]], [KECCAK], [KECCAK]] # gas: 2 (total: 770+)
0000007a: POP                                │ Stack: [[S@[KECCAK]], [KECCAK], [KECCAK]] # gas: 2 (total: 772+)
0000007b: POP                                │ Stack: [[KECCAK], [KECCAK]] # gas: 2 (total: 774+)
0000007c: POP                                │ Stack: [[KECCAK]] # gas: 2 (total: 776+)
0000007d: POP                                │ Stack: [] # gas: 2 (total: 778+)
0000007e: POP                                │ Stack: [] # gas: 2 (total: 780+)
0000007f: JUMP                               │ Stack: [] # gas: 8 (total: 788+)
00000080: JUMPDEST                           │ Stack: [] # gas: 1 (total: 789+)
00000081: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 791+)
00000082: PUSH0                              │ Stack: [0x0, 0x0] # gas: 2 (total: 793+)
00000083: REVERT                             │ Stack: [] # gas: 0 (total: 793+)
00000084: JUMPDEST                           │ Stack: [] # gas: 1 (total: 794+)
00000085: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 796+)
00000086: PUSH20 0xffffffffffffffffffffffffffffffffffffffff │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, 0x0] # gas: 3 (total: 799+)
0000009b: DUP3                               │ Stack: [?, 0xffffffffffffffffffffffffffffffffffffffff, 0x0] # gas: 3 (total: 802+)
0000009c: AND                                │ Stack: [[?&?], ?, 0xffffffffffffffffffffffffffffffffffffffff, 0x0] # gas: 3 (total: 805+)
0000009d: SWAP1                              │ Stack: [?, [?&?], 0xffffffffffffffffffffffffffffffffffffffff, 0x0] # gas: 3 (total: 808+)
0000009e: POP                                │ Stack: [[?&?], 0xffffffffffffffffffffffffffffffffffffffff, 0x0] # gas: 2 (total: 810+)
0000009f: SWAP2                              │ Stack: [0x0, 0xffffffffffffffffffffffffffffffffffffffff, [?&?]] # gas: 3 (total: 813+)
000000a0: SWAP1                              │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, 0x0, [?&?]] # gas: 3 (total: 816+)
000000a1: POP                                │ Stack: [0x0, [?&?]] # gas: 2 (total: 818+)
000000a2: JUMP                               │ Stack: [[?&?]] # gas: 8 (total: 826+)
000000a3: JUMPDEST                           │ Stack: [[?&?]] # gas: 1 (total: 827+)
000000a4: PUSH0                              │ Stack: [0x0, [?&?]] # gas: 2 (total: 829+)
000000a5: PUSH2 0x00ad                       │ Stack: [0x00ad, 0x0, [?&?]] # gas: 3 (total: 832+)
000000a8: DUP3                               │ Stack: [[?&?], 0x00ad, 0x0, [?&?]] # gas: 3 (total: 835+)
000000a9: PUSH2 0x0084                       │ Stack: [0x0084, [?&?], 0x00ad, 0x0, ...+1] # gas: 3 (total: 838+)
000000ac: JUMP                               │ Stack: [[?&?], 0x00ad, 0x0, [?&?]] # gas: 8 (total: 846+)
000000ad: JUMPDEST                           │ Stack: [[?&?], 0x00ad, 0x0, [?&?]] # gas: 1 (total: 847+)
000000ae: SWAP1                              │ Stack: [0x00ad, [?&?], 0x0, [?&?]] # gas: 3 (total: 850+)
000000af: POP                                │ Stack: [[?&?], 0x0, [?&?]] # gas: 2 (total: 852+)
000000b0: SWAP2                              │ Stack: [[?&?], 0x0, [?&?]] # gas: 3 (total: 855+)
000000b1: SWAP1                              │ Stack: [0x0, [?&?], [?&?]] # gas: 3 (total: 858+)
000000b2: POP                                │ Stack: [[?&?], [?&?]] # gas: 2 (total: 860+)
000000b3: JUMP                               │ Stack: [[?&?]] # gas: 8 (total: 868+)
000000b4: JUMPDEST                           │ Stack: [[?&?]] # gas: 1 (total: 869+)
000000b5: PUSH2 0x00bd                       │ Stack: [0x00bd, [?&?]] # gas: 3 (total: 872+)
000000b8: DUP2                               │ Stack: [[?&?], 0x00bd, [?&?]] # gas: 3 (total: 875+)
000000b9: PUSH2 0x00a3                       │ Stack: [0x00a3, [?&?], 0x00bd, [?&?]] # gas: 3 (total: 878+)
000000bc: JUMP                               │ Stack: [[?&?], 0x00bd, [?&?]] # gas: 8 (total: 886+)
000000bd: JUMPDEST                           │ Stack: [[?&?], 0x00bd, [?&?]] # gas: 1 (total: 887+)
000000be: DUP2                               │ Stack: [0x00bd, [?&?], 0x00bd, [?&?]] # gas: 3 (total: 890+)
000000bf: EQ                                 │ Stack: [[cmp], 0x00bd, [?&?], 0x00bd, ...+1] # gas: 3 (total: 893+)
000000c0: PUSH2 0x00c7                       │ Stack: [0x00c7, [cmp], 0x00bd, [?&?], ...+2] # gas: 3 (total: 896+)
000000c3: JUMPI                              │ Stack: [0x00bd, [?&?], 0x00bd, [?&?]] # gas: 10 (total: 906+)
000000c4: PUSH0                              │ Stack: [0x0, 0x00bd, [?&?], 0x00bd, ...+1] # gas: 2 (total: 908+)
000000c5: PUSH0                              │ Stack: [0x0, 0x0, 0x00bd, [?&?], ...+2] # gas: 2 (total: 910+)
000000c6: REVERT                             │ Stack: [] # gas: 0 (total: 910+)
000000c7: JUMPDEST                           │ Stack: [] # gas: 1 (total: 911+)
000000c8: POP                                │ Stack: [] # gas: 2 (total: 913+)
000000c9: JUMP                               │ Stack: [] # gas: 8 (total: 921+)
000000ca: JUMPDEST                           │ Stack: [] # gas: 1 (total: 922+)
000000cb: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 924+)
000000cc: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 927+)
000000cd: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 930+)
000000ce: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 933+)
000000cf: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 935+)
000000d0: PUSH2 0x00d8                       │ Stack: [0x00d8, [CD@?], 0x0] # gas: 3 (total: 938+)
000000d3: DUP2                               │ Stack: [[CD@?], 0x00d8, [CD@?], 0x0] # gas: 3 (total: 941+)
000000d4: PUSH2 0x00b4                       │ Stack: [0x00b4, [CD@?], 0x00d8, [CD@?], ...+1] # gas: 3 (total: 944+)
000000d7: JUMP                               │ Stack: [[CD@?], 0x00d8, [CD@?], 0x0] # gas: 8 (total: 952+)
000000d8: JUMPDEST                           │ Stack: [[CD@?], 0x00d8, [CD@?], 0x0] # gas: 1 (total: 953+)
000000d9: SWAP3                              │ Stack: [0x0, 0x00d8, [CD@?], [CD@?]] # gas: 3 (total: 956+)
000000da: SWAP2                              │ Stack: [[CD@?], 0x00d8, 0x0, [CD@?]] # gas: 3 (total: 959+)
000000db: POP                                │ Stack: [0x00d8, 0x0, [CD@?]] # gas: 2 (total: 961+)
000000dc: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 963+)
000000dd: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 971+)
000000de: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 972+)
000000df: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 974+)
000000e0: DUP2                               │ Stack: [[CD@?], 0x0, [CD@?]] # gas: 3 (total: 977+)
000000e1: SWAP1                              │ Stack: [0x0, [CD@?], [CD@?]] # gas: 3 (total: 980+)
000000e2: POP                                │ Stack: [[CD@?], [CD@?]] # gas: 2 (total: 982+)
000000e3: SWAP2                              │ Stack: [[CD@?], [CD@?]] # gas: 3 (total: 985+)
000000e4: SWAP1                              │ Stack: [[CD@?], [CD@?]] # gas: 3 (total: 988+)
000000e5: POP                                │ Stack: [[CD@?]] # gas: 2 (total: 990+)
000000e6: JUMP                               │ Stack: [] # gas: 8 (total: 998+)
000000e7: JUMPDEST                           │ Stack: [] # gas: 1 (total: 999+)
000000e8: PUSH2 0x00f0                       │ Stack: [0x00f0] # gas: 3 (total: 1002+)
000000eb: DUP2                               │ Stack: [?, 0x00f0] # gas: 3 (total: 1005+)
000000ec: PUSH2 0x00de                       │ Stack: [0x00de, ?, 0x00f0] # gas: 3 (total: 1008+)
000000ef: JUMP                               │ Stack: [?, 0x00f0] # gas: 8 (total: 1016+)
000000f0: JUMPDEST                           │ Stack: [?, 0x00f0] # gas: 1 (total: 1017+)
000000f1: DUP2                               │ Stack: [0x00f0, ?, 0x00f0] # gas: 3 (total: 1020+)
000000f2: EQ                                 │ Stack: [[cmp], 0x00f0, ?, 0x00f0] # gas: 3 (total: 1023+)
000000f3: PUSH2 0x00fa                       │ Stack: [0x00fa, [cmp], 0x00f0, ?, ...+1] # gas: 3 (total: 1026+)
000000f6: JUMPI                              │ Stack: [0x00f0, ?, 0x00f0] # gas: 10 (total: 1036+)
000000f7: PUSH0                              │ Stack: [0x0, 0x00f0, ?, 0x00f0] # gas: 2 (total: 1038+)
000000f8: PUSH0                              │ Stack: [0x0, 0x0, 0x00f0, ?, ...+1] # gas: 2 (total: 1040+)
000000f9: REVERT                             │ Stack: [] # gas: 0 (total: 1040+)
000000fa: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1041+)
000000fb: POP                                │ Stack: [] # gas: 2 (total: 1043+)
000000fc: JUMP                               │ Stack: [] # gas: 8 (total: 1051+)
000000fd: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1052+)
000000fe: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1054+)
000000ff: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 1057+)
00000100: CALLDATALOAD                       │ Stack: [[CD@?], ?, 0x0] # gas: 3 (total: 1060+)
00000101: SWAP1                              │ Stack: [?, [CD@?], 0x0] # gas: 3 (total: 1063+)
00000102: POP                                │ Stack: [[CD@?], 0x0] # gas: 2 (total: 1065+)
00000103: PUSH2 0x010b                       │ Stack: [0x010b, [CD@?], 0x0] # gas: 3 (total: 1068+)
00000106: DUP2                               │ Stack: [[CD@?], 0x010b, [CD@?], 0x0] # gas: 3 (total: 1071+)
00000107: PUSH2 0x00e7                       │ Stack: [0x00e7, [CD@?], 0x010b, [CD@?], ...+1] # gas: 3 (total: 1074+)
0000010a: JUMP                               │ Stack: [[CD@?], 0x010b, [CD@?], 0x0] # gas: 8 (total: 1082+)
0000010b: JUMPDEST                           │ Stack: [[CD@?], 0x010b, [CD@?], 0x0] # gas: 1 (total: 1083+)
0000010c: SWAP3                              │ Stack: [0x0, 0x010b, [CD@?], [CD@?]] # gas: 3 (total: 1086+)
0000010d: SWAP2                              │ Stack: [[CD@?], 0x010b, 0x0, [CD@?]] # gas: 3 (total: 1089+)
0000010e: POP                                │ Stack: [0x010b, 0x0, [CD@?]] # gas: 2 (total: 1091+)
0000010f: POP                                │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1093+)
00000110: JUMP                               │ Stack: [[CD@?]] # gas: 8 (total: 1101+)
00000111: JUMPDEST                           │ Stack: [[CD@?]] # gas: 1 (total: 1102+)
00000112: PUSH0                              │ Stack: [0x0, [CD@?]] # gas: 2 (total: 1104+)
00000113: PUSH0                              │ Stack: [0x0, 0x0, [CD@?]] # gas: 2 (total: 1106+)
00000114: PUSH0                              │ Stack: [0x0, 0x0, 0x0, [CD@?]] # gas: 2 (total: 1108+)
00000115: PUSH1 0x60                         │ Stack: [0x60, 0x0, 0x0, 0x0, ...+1] # gas: 3 (total: 1111+)
00000117: DUP5                               │ Stack: [[CD@?], 0x60, 0x0, 0x0, ...+2] # gas: 3 (total: 1114+)
00000118: DUP7                               │ Stack: [?, [CD@?], 0x60, 0x0, ...+3] # gas: 3 (total: 1117+)
00000119: SUB                                │ Stack: [[?-?], ?, [CD@?], 0x60, ...+4] # gas: 3 (total: 1120+)
0000011a: SLT                                │ Stack: [[cmp], [?-?], ?, [CD@?], ...+5] # gas: 3 (total: 1123+)
0000011b: ISZERO                             │ Stack: [[![cmp]], [cmp], [?-?], ?, ...+6] # gas: 3 (total: 1126+)
0000011c: PUSH2 0x0128                       │ Stack: [0x0128, [![cmp]], [cmp], [?-?], ...+7] # gas: 3 (total: 1129+)
0000011f: JUMPI                              │ Stack: [[cmp], [?-?], ?, [CD@?], ...+5] # gas: 10 (total: 1139+)
00000120: PUSH2 0x0127                       │ Stack: [0x0127, [cmp], [?-?], ?, ...+6] # gas: 3 (total: 1142+)
00000123: PUSH2 0x0080                       │ Stack: [0x0080, 0x0127, [cmp], [?-?], ...+7] # gas: 3 (total: 1145+)
00000126: JUMP                               │ Stack: [0x0127, [cmp], [?-?], ?, ...+6] # gas: 8 (total: 1153+)
00000127: JUMPDEST                           │ Stack: [0x0127, [cmp], [?-?], ?, ...+6] # gas: 1 (total: 1154+)
00000128: JUMPDEST                           │ Stack: [0x0127, [cmp], [?-?], ?, ...+6] # gas: 1 (total: 1155+)
00000129: PUSH0                              │ Stack: [0x0, 0x0127, [cmp], [?-?], ...+7] # gas: 2 (total: 1157+)
0000012a: PUSH2 0x0135                       │ Stack: [0x0135, 0x0, 0x0127, [cmp], ...+8] # gas: 3 (total: 1160+)
0000012d: DUP7                               │ Stack: [[CD@?], 0x0135, 0x0, 0x0127, ...+9] # gas: 3 (total: 1163+)
0000012e: DUP3                               │ Stack: [0x0, [CD@?], 0x0135, 0x0, ...+10] # gas: 3 (total: 1166+)
0000012f: DUP8                               │ Stack: [?, 0x0, [CD@?], 0x0135, ...+11] # gas: 3 (total: 1169+)
00000130: ADD                                │ Stack: [[?+?], ?, 0x0, [CD@?], ...+12] # gas: 3 (total: 1172+)
00000131: PUSH2 0x00ca                       │ Stack: [0x00ca, [?+?], ?, 0x0, ...+13] # gas: 3 (total: 1175+)
00000134: JUMP                               │ Stack: [[?+?], ?, 0x0, [CD@?], ...+12] # gas: 8 (total: 1183+)
00000135: JUMPDEST                           │ Stack: [[?+?], ?, 0x0, [CD@?], ...+12] # gas: 1 (total: 1184+)
00000136: SWAP4                              │ Stack: [0x0135, ?, 0x0, [CD@?], ...+12] # gas: 3 (total: 1187+)
00000137: POP                                │ Stack: [?, 0x0, [CD@?], [?+?], ...+11] # gas: 2 (total: 1189+)
00000138: POP                                │ Stack: [0x0, [CD@?], [?+?], 0x0, ...+10] # gas: 2 (total: 1191+)
00000139: PUSH1 0x20                         │ Stack: [0x20, 0x0, [CD@?], [?+?], ...+11] # gas: 3 (total: 1194+)
0000013b: PUSH2 0x0146                       │ Stack: [0x0146, 0x20, 0x0, [CD@?], ...+12] # gas: 3 (total: 1197+)
0000013e: DUP7                               │ Stack: [0x0127, 0x0146, 0x20, 0x0, ...+13] # gas: 3 (total: 1200+)
0000013f: DUP3                               │ Stack: [0x20, 0x0127, 0x0146, 0x20, ...+14] # gas: 3 (total: 1203+)
00000140: DUP8                               │ Stack: [0x0, 0x20, 0x0127, 0x0146, ...+15] # gas: 3 (total: 1206+)
00000141: ADD                                │ Stack: [[0x0+0x0], 0x0, 0x20, 0x0127, ...+16] # gas: 3 (total: 1209+)
00000142: PUSH2 0x00ca                       │ Stack: [0x00ca, [0x0+0x0], 0x0, 0x20, ...+17] # gas: 3 (total: 1212+)
00000145: JUMP                               │ Stack: [[0x0+0x0], 0x0, 0x20, 0x0127, ...+16] # gas: 8 (total: 1220+)
00000146: JUMPDEST                           │ Stack: [[0x0+0x0], 0x0, 0x20, 0x0127, ...+16] # gas: 1 (total: 1221+)
00000147: SWAP3                              │ Stack: [0x0127, 0x0, 0x20, [0x0+0x0], ...+16] # gas: 3 (total: 1224+)
00000148: POP                                │ Stack: [0x0, 0x20, [0x0+0x0], 0x0146, ...+15] # gas: 2 (total: 1226+)
00000149: POP                                │ Stack: [0x20, [0x0+0x0], 0x0146, 0x20, ...+14] # gas: 2 (total: 1228+)
0000014a: PUSH1 0x40                         │ Stack: [0x40, 0x20, [0x0+0x0], 0x0146, ...+15] # gas: 3 (total: 1231+)
0000014c: PUSH2 0x0157                       │ Stack: [0x0157, 0x40, 0x20, [0x0+0x0], ...+16] # gas: 3 (total: 1234+)
0000014f: DUP7                               │ Stack: [0x0, 0x0157, 0x40, 0x20, ...+17] # gas: 3 (total: 1237+)
00000150: DUP3                               │ Stack: [0x40, 0x0, 0x0157, 0x40, ...+18] # gas: 3 (total: 1240+)
00000151: DUP8                               │ Stack: [0x20, 0x40, 0x0, 0x0157, ...+19] # gas: 3 (total: 1243+)
00000152: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x40, 0x0, ...+20] # gas: 3 (total: 1246+)
00000153: PUSH2 0x00fd                       │ Stack: [0x00fd, [0x20+0x20], 0x20, 0x40, ...+21] # gas: 3 (total: 1249+)
00000156: JUMP                               │ Stack: [[0x20+0x20], 0x20, 0x40, 0x0, ...+20] # gas: 8 (total: 1257+)
00000157: JUMPDEST                           │ Stack: [[0x20+0x20], 0x20, 0x40, 0x0, ...+20] # gas: 1 (total: 1258+)
00000158: SWAP2                              │ Stack: [0x40, 0x20, [0x20+0x20], 0x0, ...+20] # gas: 3 (total: 1261+)
00000159: POP                                │ Stack: [0x20, [0x20+0x20], 0x0, 0x0157, ...+19] # gas: 2 (total: 1263+)
0000015a: POP                                │ Stack: [[0x20+0x20], 0x0, 0x0157, 0x40, ...+18] # gas: 2 (total: 1265+)
0000015b: SWAP3                              │ Stack: [0x40, 0x0, 0x0157, [0x20+0x20], ...+18] # gas: 3 (total: 1268+)
0000015c: POP                                │ Stack: [0x0, 0x0157, [0x20+0x20], 0x20, ...+17] # gas: 2 (total: 1270+)
0000015d: SWAP3                              │ Stack: [0x20, 0x0157, [0x20+0x20], 0x0, ...+17] # gas: 3 (total: 1273+)
0000015e: POP                                │ Stack: [0x0157, [0x20+0x20], 0x0, [0x0+0x0], ...+16] # gas: 2 (total: 1275+)
0000015f: SWAP3                              │ Stack: [[0x0+0x0], [0x20+0x20], 0x0, 0x0157, ...+16] # gas: 3 (total: 1278+)
00000160: JUMP                               │ Stack: [[0x20+0x20], 0x0, 0x0157, 0x0146, ...+15] # gas: 8 (total: 1286+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

00000161: INVALID                            │ Stack: [] # gas: 0 (total: 1286+)
00000162: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 2411+)
00000163: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 2414+)
00000169: INVALID                            │ Stack: [] # gas: 0 (total: 2414+)
0000016a: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 2417+)
0000016b: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2447+) # mapping/array slot computation
0000016c: BASEFEE                            │ Stack: [[BASEFEE], [KECCAK]] # gas: 2 (total: 2449+)
0000016d: DUP12                              │ Stack: [?, [BASEFEE], [KECCAK]] # gas: 3 (total: 2452+)
0000016e: INVALID                            │ Stack: [] # gas: 0 (total: 2452+)
0000016f: POP                                │ Stack: [] # gas: 2 (total: 2454+)
00000170: RETURNDATASIZE                     │ Stack: [[RETSIZE]] # gas: 2 (total: 2456+)
00000171: INVALID                            │ Stack: [] # gas: 0 (total: 2456+)
00000172: PUSH32 0x00300298a7f8904497a356f52a4904e7cdd263cc99a91b251f64736f6c634300 │ Stack: [0x00300298a7f8904497a356f52a4904e7cdd263cc99a91b251f64736f6c634300] # gas: 3 (total: 2459+)
00000193: ADDMOD                             │ Stack: [[mod_arith]] # gas: 8 (total: 2467+)
00000194: SHR                                │ Stack: [[[mod_arith]>>[mod_arith]], [mod_arith]] # gas: 3 (total: 2470+)
00000195: STOP                               │ Stack: [] # gas: 0 (total: 2470+)
00000196: CALLER                             │ Stack: [[CALLER]] # gas: 2 (total: 2472+)

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
│ Function: efficientTransfer(address,address,uint256)
│ Entry: 0x0000002d
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x00000111] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x00000029
  • 0x0000002d
  • 0x00000042
  • 0x00000047
  • 0x00000049
  • 0x00000063
  • 0x00000080
  • 0x00000084
  • 0x000000a3
  • 0x000000ad
  • 0x000000b4
  • 0x000000bd
  • 0x000000c7
  • 0x000000ca
  • 0x000000d8
  • 0x000000de
  • 0x000000e7
  • 0x000000f0
  • 0x000000fa
  ... and 8 more

