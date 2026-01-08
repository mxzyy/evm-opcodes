╔════════════════════════════════════════════════════════════════╗
║                      CREATION CODE                             ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0xc0                         │ Stack: [0xc0] # gas: 3 (total: 3)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0xc0] # gas: 3 (total: 6)
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
00000010: TIMESTAMP                          │ Stack: [[TIMESTAMP]] # gas: 2 (total: 39)
00000011: PUSH1 0x80                         │ Stack: [0x80, [TIMESTAMP]] # gas: 3 (total: 42)
00000013: DUP2                               │ Stack: [[TIMESTAMP], 0x80, [TIMESTAMP]] # gas: 3 (total: 45)
00000014: DUP2                               │ Stack: [0x80, [TIMESTAMP], 0x80, [TIMESTAMP]] # gas: 3 (total: 48)
00000015: MSTORE                             │ Stack: [0x80, [TIMESTAMP]] # gas: 3 (total: 51)
00000016: POP                                │ Stack: [[TIMESTAMP]] # gas: 2 (total: 53)
00000017: POP                                │ Stack: [] # gas: 2 (total: 55)
00000018: CALLER                             │ Stack: [[CALLER]] # gas: 2 (total: 57)
00000019: PUSH20 0xffffffffffffffffffffffffffffffffffffffff │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, [CALLER]] # gas: 3 (total: 60)
0000002e: AND                                │ Stack: [[0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, [CALLER]] # gas: 3 (total: 63)
0000002f: PUSH1 0xa0                         │ Stack: [0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, [CALLER]] # gas: 3 (total: 66)
00000031: DUP2                               │ Stack: [[0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, ...+1] # gas: 3 (total: 69)
00000032: PUSH20 0xffffffffffffffffffffffffffffffffffffffff │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], ...+2] # gas: 3 (total: 72)
00000047: AND                                │ Stack: [[0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xa0, ...+3] # gas: 3 (total: 75)
00000048: DUP2                               │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], ...+4] # gas: 3 (total: 78)
00000049: MSTORE                             │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], ...+2] # gas: 3 (total: 81)
0000004a: POP                                │ Stack: [[0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, ...+1] # gas: 2 (total: 83)
0000004b: POP                                │ Stack: [0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, [CALLER]] # gas: 2 (total: 85)
0000004c: PUSH1 0x80                         │ Stack: [0x80, 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], 0xffffffffffffffffffffffffffffffffffffffff, ...+1] # gas: 3 (total: 88)
0000004e: MLOAD                              │ Stack: [[M@0x80], 0x80, 0xa0, [0xffffffffffffffffffffffffffffffffffffffff&0xffffffffffffffffffffffffffffffffffffffff], ...+2] # gas: 3 (total: 91) # memory read: dynamic allocation
0000004f: PUSH1 0xa0                         │ Stack: [0xa0, [M@0x80], 0x80, 0xa0, ...+3] # gas: 3 (total: 94)
00000051: MLOAD                              │ Stack: [[M@0xa0], 0xa0, [M@0x80], 0x80, ...+4] # gas: 3 (total: 97) # memory read: dynamic allocation
00000052: PUSH2 0x01da                       │ Stack: [0x01da, [M@0xa0], 0xa0, [M@0x80], ...+5] # gas: 3 (total: 100)
00000055: PUSH2 0x006a                       │ Stack: [0x006a, 0x01da, [M@0xa0], 0xa0, ...+6] # gas: 3 (total: 103)
00000058: PUSH0                              │ Stack: [0x0, 0x006a, 0x01da, [M@0xa0], ...+7] # gas: 2 (total: 105)
00000059: CODECOPY                           │ Stack: [[M@0xa0], 0xa0, [M@0x80], 0x80, ...+4] # gas: 3 (base + dynamic) (total: 108+)
0000005a: PUSH0                              │ Stack: [0x0, [M@0xa0], 0xa0, [M@0x80], ...+5] # gas: 2 (total: 110+)
0000005b: PUSH1 0xd5                         │ Stack: [0xd5, 0x0, [M@0xa0], 0xa0, ...+6] # gas: 3 (total: 113+)
0000005d: ADD                                │ Stack: [[0xd5+0xd5], 0xd5, 0x0, [M@0xa0], ...+7] # gas: 3 (total: 116+)
0000005e: MSTORE                             │ Stack: [0x0, [M@0xa0], 0xa0, [M@0x80], ...+5] # gas: 3 (total: 119+)
0000005f: PUSH0                              │ Stack: [0x0, 0x0, [M@0xa0], 0xa0, ...+6] # gas: 2 (total: 121+)
00000060: PUSH1 0xf9                         │ Stack: [0xf9, 0x0, 0x0, [M@0xa0], ...+7] # gas: 3 (total: 124+)
00000062: ADD                                │ Stack: [[0xf9+0xf9], 0xf9, 0x0, 0x0, ...+8] # gas: 3 (total: 127+)
00000063: MSTORE                             │ Stack: [0x0, 0x0, [M@0xa0], 0xa0, ...+6] # gas: 3 (total: 130+)
00000064: PUSH2 0x01da                       │ Stack: [0x01da, 0x0, 0x0, [M@0xa0], ...+7] # gas: 3 (total: 133+)
00000067: PUSH0                              │ Stack: [0x0, 0x01da, 0x0, 0x0, ...+8] # gas: 2 (total: 135+)
00000068: RETURN                             │ Stack: [] # gas: 0 (total: 135+)
00000069: INVALID                            │ Stack: [] # gas: 0 (total: 135+)

╔════════════════════════════════════════════════════════════════╗
║                      RUNTIME CODE                              ║
║                  (Deployed Contract Code)                      ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║                        PREAMBLE                                ║
║              Memory Init & Callvalue Check                     ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80                         │ Stack: [0x80] # gas: 3 (total: 138+)
00000002: PUSH1 0x40                         │ Stack: [0x40, 0x80] # gas: 3 (total: 141+)
00000004: MSTORE                             │ Stack: [] # gas: 3 (total: 144+) # memory write: free memory pointer (free memory pointer)
00000005: CALLVALUE                          │ Stack: [[CALLVALUE]] # gas: 2 (total: 146+)
00000006: DUP1                               │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 3 (total: 149+)
00000007: ISZERO                             │ Stack: [[![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 152+)
00000008: PUSH2 0x000f                       │ Stack: [0x000f, [![CALLVALUE]], [CALLVALUE], [CALLVALUE]] # gas: 3 (total: 155+)
0000000b: JUMPI                              │ Stack: [[CALLVALUE], [CALLVALUE]] # gas: 10 (total: 165+)
0000000c: PUSH0                              │ Stack: [0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 167+)
0000000d: PUSH0                              │ Stack: [0x0, 0x0, [CALLVALUE], [CALLVALUE]] # gas: 2 (total: 169+)
0000000e: REVERT                             │ Stack: [] # gas: 0 (total: 169+)
0000000f: JUMPDEST                           │ Stack: [] # gas: 1 (total: 170+)
00000010: POP                                │ Stack: [] # gas: 2 (total: 172+)
00000011: PUSH1 0x04                         │ Stack: [0x04] # gas: 3 (total: 175+)
00000013: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x04] # gas: 2 (total: 177+)
00000014: LT                                 │ Stack: [[cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 180+)
00000015: PUSH2 0x004a                       │ Stack: [0x004a, [cmp], [CALLDATASIZE], 0x04] # gas: 3 (total: 183+)
00000018: JUMPI                              │ Stack: [[CALLDATASIZE], 0x04] # gas: 10 (total: 193+)
00000019: PUSH0                              │ Stack: [0x0, [CALLDATASIZE], 0x04] # gas: 2 (total: 195+)

╔════════════════════════════════════════════════════════════════╗
║                   FUNCTION DISPATCHER                          ║
║             Routes Calls to Function Bodies                    ║
╚════════════════════════════════════════════════════════════════╝

0000001a: CALLDATALOAD                       │ Stack: [[CD@0x0], 0x0, [CALLDATASIZE], 0x04] # gas: 3 (total: 198+)
0000001b: PUSH1 0xe0                         │ Stack: [0xe0, [CD@0x0], 0x0, [CALLDATASIZE], ...+1] # gas: 3 (total: 201+)
0000001d: SHR                                │ Stack: [[0xe0>>0xe0], 0xe0, [CD@0x0], 0x0, ...+2] # gas: 3 (total: 204+)
0000001e: DUP1                               │ Stack: [[0xe0>>0xe0], [0xe0>>0xe0], 0xe0, [CD@0x0], ...+3] # gas: 3 (total: 207+)
0000001f: PUSH4 0x32cb6b0c                   │ Stack: [0x32cb6b0c, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4]# MAX_SUPPLY() # gas: 3 (total: 210+)
00000024: EQ                                 │ Stack: [[cmp], 0x32cb6b0c, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 213+)
00000025: PUSH2 0x004e                       │ Stack: [0x004e, [cmp], 0x32cb6b0c, [0xe0>>0xe0], ...+6] # gas: 3 (total: 216+)
00000028: JUMPI                              │ Stack: [0x32cb6b0c, [0xe0>>0xe0], [0xe0>>0xe0], 0xe0, ...+4] # gas: 10 (total: 226+)
00000029: DUP1                               │ Stack: [0x32cb6b0c, 0x32cb6b0c, [0xe0>>0xe0], [0xe0>>0xe0], ...+5] # gas: 3 (total: 229+)
0000002a: PUSH4 0x4e6fd6c4                   │ Stack: [0x4e6fd6c4, 0x32cb6b0c, 0x32cb6b0c, [0xe0>>0xe0], ...+6]# DEAD_ADDRESS() # gas: 3 (total: 232+)
0000002f: EQ                                 │ Stack: [[cmp], 0x4e6fd6c4, 0x32cb6b0c, 0x32cb6b0c, ...+7] # gas: 3 (total: 235+)
00000030: PUSH2 0x006c                       │ Stack: [0x006c, [cmp], 0x4e6fd6c4, 0x32cb6b0c, ...+8] # gas: 3 (total: 238+)
00000033: JUMPI                              │ Stack: [0x4e6fd6c4, 0x32cb6b0c, 0x32cb6b0c, [0xe0>>0xe0], ...+6] # gas: 10 (total: 248+)
00000034: DUP1                               │ Stack: [0x4e6fd6c4, 0x4e6fd6c4, 0x32cb6b0c, 0x32cb6b0c, ...+7] # gas: 3 (total: 251+)
00000035: PUSH4 0xd5f39488                   │ Stack: [0xd5f39488, 0x4e6fd6c4, 0x4e6fd6c4, 0x32cb6b0c, ...+8]# deployer() # gas: 3 (total: 254+)
0000003a: EQ                                 │ Stack: [[cmp], 0xd5f39488, 0x4e6fd6c4, 0x4e6fd6c4, ...+9] # gas: 3 (total: 257+)
0000003b: PUSH2 0x008a                       │ Stack: [0x008a, [cmp], 0xd5f39488, 0x4e6fd6c4, ...+10] # gas: 3 (total: 260+)
0000003e: JUMPI                              │ Stack: [0xd5f39488, 0x4e6fd6c4, 0x4e6fd6c4, 0x32cb6b0c, ...+8] # gas: 10 (total: 270+)
0000003f: DUP1                               │ Stack: [0xd5f39488, 0xd5f39488, 0x4e6fd6c4, 0x4e6fd6c4, ...+9] # gas: 3 (total: 273+)
00000040: PUSH4 0xecda10f5                   │ Stack: [0xecda10f5, 0xd5f39488, 0xd5f39488, 0x4e6fd6c4, ...+10]# deploymentTime() # gas: 3 (total: 276+)
00000045: EQ                                 │ Stack: [[cmp], 0xecda10f5, 0xd5f39488, 0xd5f39488, ...+11] # gas: 3 (total: 279+)
00000046: PUSH2 0x00a8                       │ Stack: [0x00a8, [cmp], 0xecda10f5, 0xd5f39488, ...+12] # gas: 3 (total: 282+)
00000049: JUMPI                              │ Stack: [0xecda10f5, 0xd5f39488, 0xd5f39488, 0x4e6fd6c4, ...+10] # gas: 10 (total: 292+)
0000004a: JUMPDEST                           │ Stack: [0xecda10f5, 0xd5f39488, 0xd5f39488, 0x4e6fd6c4, ...+10] # gas: 1 (total: 293+)
0000004b: PUSH0                              │ Stack: [0x0, 0xecda10f5, 0xd5f39488, 0xd5f39488, ...+11] # gas: 2 (total: 295+)
0000004c: PUSH0                              │ Stack: [0x0, 0x0, 0xecda10f5, 0xd5f39488, ...+12] # gas: 2 (total: 297+)
0000004d: REVERT                             │ Stack: [] # gas: 0 (total: 297+)

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

0000004e: JUMPDEST                           │ Stack: [] # === MAX_SUPPLY() === # gas: 1 (total: 298+)
0000004f: PUSH2 0x0056                       │ Stack: [0x0056] # gas: 3 (total: 301+)
00000052: PUSH2 0x00c6                       │ Stack: [0x00c6, 0x0056] # gas: 3 (total: 304+)
00000055: JUMP                               │ Stack: [0x0056] # gas: 8 (total: 312+)
00000056: JUMPDEST                           │ Stack: [0x0056] # gas: 1 (total: 313+)
00000057: PUSH1 0x40                         │ Stack: [0x40, 0x0056] # gas: 3 (total: 316+)
00000059: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0056] # gas: 3 (total: 319+) # memory read: free memory pointer
0000005a: PUSH2 0x0063                       │ Stack: [0x0063, [M@0x40], 0x40, 0x0056] # gas: 3 (total: 322+)
0000005d: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0063, 0x0056] # gas: 3 (total: 325+)
0000005e: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0063, 0x0056] # gas: 3 (total: 328+)
0000005f: PUSH2 0x0133                       │ Stack: [0x0133, [M@0x40], 0x40, 0x0063, ...+1] # gas: 3 (total: 331+)
00000062: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0063, 0x0056] # gas: 8 (total: 339+)
00000063: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0063, 0x0056] # gas: 1 (total: 340+)
00000064: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0063, ...+1] # gas: 3 (total: 343+)
00000066: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 346+) # memory read: free memory pointer
00000067: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 349+)
00000068: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 352+)
00000069: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 355+)
0000006a: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 358+)
0000006b: RETURN                             │ Stack: [] # gas: 0 (total: 358+)
0000006c: JUMPDEST                           │ Stack: [] # === DEAD_ADDRESS() === # gas: 1 (total: 359+)
0000006d: PUSH2 0x0074                       │ Stack: [0x0074] # gas: 3 (total: 362+)
00000070: PUSH2 0x00cd                       │ Stack: [0x00cd, 0x0074] # gas: 3 (total: 365+)
00000073: JUMP                               │ Stack: [0x0074] # gas: 8 (total: 373+)
00000074: JUMPDEST                           │ Stack: [0x0074] # gas: 1 (total: 374+)
00000075: PUSH1 0x40                         │ Stack: [0x40, 0x0074] # gas: 3 (total: 377+)
00000077: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0074] # gas: 3 (total: 380+) # memory read: free memory pointer
00000078: PUSH2 0x0081                       │ Stack: [0x0081, [M@0x40], 0x40, 0x0074] # gas: 3 (total: 383+)
0000007b: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0081, 0x0074] # gas: 3 (total: 386+)
0000007c: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0081, 0x0074] # gas: 3 (total: 389+)
0000007d: PUSH2 0x018b                       │ Stack: [0x018b, [M@0x40], 0x40, 0x0081, ...+1] # gas: 3 (total: 392+)
00000080: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0081, 0x0074] # gas: 8 (total: 400+)
00000081: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0081, 0x0074] # gas: 1 (total: 401+)
00000082: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0081, ...+1] # gas: 3 (total: 404+)
00000084: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 407+) # memory read: free memory pointer
00000085: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 410+)
00000086: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 413+)
00000087: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 416+)
00000088: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 419+)
00000089: RETURN                             │ Stack: [] # gas: 0 (total: 419+)
0000008a: JUMPDEST                           │ Stack: [] # === deployer() === # gas: 1 (total: 420+)
0000008b: PUSH2 0x0092                       │ Stack: [0x0092] # gas: 3 (total: 423+)
0000008e: PUSH2 0x00d3                       │ Stack: [0x00d3, 0x0092] # gas: 3 (total: 426+)
00000091: JUMP                               │ Stack: [0x0092] # gas: 8 (total: 434+)
00000092: JUMPDEST                           │ Stack: [0x0092] # gas: 1 (total: 435+)
00000093: PUSH1 0x40                         │ Stack: [0x40, 0x0092] # gas: 3 (total: 438+)
00000095: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x0092] # gas: 3 (total: 441+) # memory read: free memory pointer
00000096: PUSH2 0x009f                       │ Stack: [0x009f, [M@0x40], 0x40, 0x0092] # gas: 3 (total: 444+)
00000099: SWAP2                              │ Stack: [0x40, [M@0x40], 0x009f, 0x0092] # gas: 3 (total: 447+)
0000009a: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x009f, 0x0092] # gas: 3 (total: 450+)
0000009b: PUSH2 0x018b                       │ Stack: [0x018b, [M@0x40], 0x40, 0x009f, ...+1] # gas: 3 (total: 453+)
0000009e: JUMP                               │ Stack: [[M@0x40], 0x40, 0x009f, 0x0092] # gas: 8 (total: 461+)
0000009f: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x009f, 0x0092] # gas: 1 (total: 462+)
000000a0: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x009f, ...+1] # gas: 3 (total: 465+)
000000a2: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 468+) # memory read: free memory pointer
000000a3: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 471+)
000000a4: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 474+)
000000a5: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 477+)
000000a6: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 480+)
000000a7: RETURN                             │ Stack: [] # gas: 0 (total: 480+)
000000a8: JUMPDEST                           │ Stack: [] # === deploymentTime() === # gas: 1 (total: 481+)
000000a9: PUSH2 0x00b0                       │ Stack: [0x00b0] # gas: 3 (total: 484+)
000000ac: PUSH2 0x00f7                       │ Stack: [0x00f7, 0x00b0] # gas: 3 (total: 487+)
000000af: JUMP                               │ Stack: [0x00b0] # gas: 8 (total: 495+)
000000b0: JUMPDEST                           │ Stack: [0x00b0] # gas: 1 (total: 496+)
000000b1: PUSH1 0x40                         │ Stack: [0x40, 0x00b0] # gas: 3 (total: 499+)
000000b3: MLOAD                              │ Stack: [[M@0x40], 0x40, 0x00b0] # gas: 3 (total: 502+) # memory read: free memory pointer
000000b4: PUSH2 0x00bd                       │ Stack: [0x00bd, [M@0x40], 0x40, 0x00b0] # gas: 3 (total: 505+)
000000b7: SWAP2                              │ Stack: [0x40, [M@0x40], 0x00bd, 0x00b0] # gas: 3 (total: 508+)
000000b8: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x00bd, 0x00b0] # gas: 3 (total: 511+)
000000b9: PUSH2 0x0133                       │ Stack: [0x0133, [M@0x40], 0x40, 0x00bd, ...+1] # gas: 3 (total: 514+)
000000bc: JUMP                               │ Stack: [[M@0x40], 0x40, 0x00bd, 0x00b0] # gas: 8 (total: 522+)
000000bd: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x00bd, 0x00b0] # gas: 1 (total: 523+)
000000be: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x00bd, ...+1] # gas: 3 (total: 526+)
000000c0: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+2] # gas: 3 (total: 529+) # memory read: free memory pointer
000000c1: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+3] # gas: 3 (total: 532+)
000000c2: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+3] # gas: 3 (total: 535+)
000000c3: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 538+)
000000c4: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 541+)
000000c5: RETURN                             │ Stack: [] # gas: 0 (total: 541+)
000000c6: JUMPDEST                           │ Stack: [] # gas: 1 (total: 542+)
000000c7: PUSH3 0x0f4240                     │ Stack: [0x0f4240] # gas: 3 (total: 545+)
000000cb: DUP2                               │ Stack: [?, 0x0f4240] # gas: 3 (total: 548+)
000000cc: JUMP                               │ Stack: [0x0f4240] # gas: 8 (total: 556+)
000000cd: JUMPDEST                           │ Stack: [0x0f4240] # gas: 1 (total: 557+)
000000ce: PUSH2 0xdead                       │ Stack: [0xdead, 0x0f4240] # gas: 3 (total: 560+)
000000d1: DUP2                               │ Stack: [0x0f4240, 0xdead, 0x0f4240] # gas: 3 (total: 563+)
000000d2: JUMP                               │ Stack: [0xdead, 0x0f4240] # gas: 8 (total: 571+)
000000d3: JUMPDEST                           │ Stack: [0xdead, 0x0f4240] # gas: 1 (total: 572+)
000000d4: PUSH32 0x0000000000000000000000000000000000000000000000000000000000000000 │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 3 (total: 575+)
000000f5: DUP2                               │ Stack: [0xdead, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 3 (total: 578+)
000000f6: JUMP                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 8 (total: 586+)
000000f7: JUMPDEST                           │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 1 (total: 587+)
000000f8: PUSH32 0x0000000000000000000000000000000000000000000000000000000000000000 │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 3 (total: 590+)
00000119: DUP2                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 3 (total: 593+)
0000011a: JUMP                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 8 (total: 601+)
0000011b: JUMPDEST                           │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 1 (total: 602+)
0000011c: PUSH0                              │ Stack: [0x0, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 2 (total: 604+)
0000011d: DUP2                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, ...+2] # gas: 3 (total: 607+)
0000011e: SWAP1                              │ Stack: [0x0, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, ...+2] # gas: 3 (total: 610+)
0000011f: POP                                │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 2 (total: 612+)
00000120: SWAP2                              │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 3 (total: 615+)
00000121: SWAP1                              │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 3 (total: 618+)
00000122: POP                                │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 2 (total: 620+)
00000123: JUMP                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 8 (total: 628+)
00000124: JUMPDEST                           │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 1 (total: 629+)
00000125: PUSH2 0x012d                       │ Stack: [0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 3 (total: 632+)
00000128: DUP2                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 3 (total: 635+)
00000129: PUSH2 0x011b                       │ Stack: [0x011b, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, ...+2] # gas: 3 (total: 638+)
0000012c: JUMP                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 8 (total: 646+)
0000012d: JUMPDEST                           │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, ...+1] # gas: 1 (total: 647+)
0000012e: DUP3                               │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0x0000000000000000000000000000000000000000000000000000000000000000, 0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, ...+2] # gas: 3 (total: 650+)
0000012f: MSTORE                             │ Stack: [0x012d, 0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 3 (total: 653+)
00000130: POP                                │ Stack: [0x0000000000000000000000000000000000000000000000000000000000000000, 0xdead, 0x0f4240] # gas: 2 (total: 655+)
00000131: POP                                │ Stack: [0xdead, 0x0f4240] # gas: 2 (total: 657+)
00000132: JUMP                               │ Stack: [0x0f4240] # gas: 8 (total: 665+)
00000133: JUMPDEST                           │ Stack: [0x0f4240] # gas: 1 (total: 666+)
00000134: PUSH0                              │ Stack: [0x0, 0x0f4240] # gas: 2 (total: 668+)
00000135: PUSH1 0x20                         │ Stack: [0x20, 0x0, 0x0f4240] # gas: 3 (total: 671+)
00000137: DUP3                               │ Stack: [0x0f4240, 0x20, 0x0, 0x0f4240] # gas: 3 (total: 674+)
00000138: ADD                                │ Stack: [[0x0f4240+0x0f4240], 0x0f4240, 0x20, 0x0, ...+1] # gas: 3 (total: 677+)
00000139: SWAP1                              │ Stack: [0x0f4240, [0x0f4240+0x0f4240], 0x20, 0x0, ...+1] # gas: 3 (total: 680+)
0000013a: POP                                │ Stack: [[0x0f4240+0x0f4240], 0x20, 0x0, 0x0f4240] # gas: 2 (total: 682+)
0000013b: PUSH2 0x0146                       │ Stack: [0x0146, [0x0f4240+0x0f4240], 0x20, 0x0, ...+1] # gas: 3 (total: 685+)
0000013e: PUSH0                              │ Stack: [0x0, 0x0146, [0x0f4240+0x0f4240], 0x20, ...+2] # gas: 2 (total: 687+)
0000013f: DUP4                               │ Stack: [0x20, 0x0, 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 3 (total: 690+)
00000140: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x0146, ...+4] # gas: 3 (total: 693+)
00000141: DUP5                               │ Stack: [[0x0f4240+0x0f4240], [0x20+0x20], 0x20, 0x0, ...+5] # gas: 3 (total: 696+)
00000142: PUSH2 0x0124                       │ Stack: [0x0124, [0x0f4240+0x0f4240], [0x20+0x20], 0x20, ...+6] # gas: 3 (total: 699+)
00000145: JUMP                               │ Stack: [[0x0f4240+0x0f4240], [0x20+0x20], 0x20, 0x0, ...+5] # gas: 8 (total: 707+)
00000146: JUMPDEST                           │ Stack: [[0x0f4240+0x0f4240], [0x20+0x20], 0x20, 0x0, ...+5] # gas: 1 (total: 708+)
00000147: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 711+)
00000148: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 714+)
00000149: POP                                │ Stack: [[0x20+0x20], 0x0, [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 2 (total: 716+)
0000014a: POP                                │ Stack: [0x0, [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 2 (total: 718+)
0000014b: JUMP                               │ Stack: [[0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], 0x20, ...+2] # gas: 8 (total: 726+)
0000014c: JUMPDEST                           │ Stack: [[0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], 0x20, ...+2] # gas: 1 (total: 727+)
0000014d: PUSH0                              │ Stack: [0x0, [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 2 (total: 729+)
0000014e: PUSH20 0xffffffffffffffffffffffffffffffffffffffff │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, 0x0, [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 3 (total: 732+)
00000163: DUP3                               │ Stack: [[0x0f4240+0x0f4240], 0xffffffffffffffffffffffffffffffffffffffff, 0x0, [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 735+)
00000164: AND                                │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0xffffffffffffffffffffffffffffffffffffffff, 0x0, ...+6] # gas: 3 (total: 738+)
00000165: SWAP1                              │ Stack: [[0x0f4240+0x0f4240], [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0xffffffffffffffffffffffffffffffffffffffff, 0x0, ...+6] # gas: 3 (total: 741+)
00000166: POP                                │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0xffffffffffffffffffffffffffffffffffffffff, 0x0, [0x0f4240+0x0f4240], ...+5] # gas: 2 (total: 743+)
00000167: SWAP2                              │ Stack: [0x0, 0xffffffffffffffffffffffffffffffffffffffff, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 746+)
00000168: SWAP1                              │ Stack: [0xffffffffffffffffffffffffffffffffffffffff, 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 749+)
00000169: POP                                │ Stack: [0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 2 (total: 751+)
0000016a: JUMP                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 8 (total: 759+)
0000016b: JUMPDEST                           │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 1 (total: 760+)
0000016c: PUSH0                              │ Stack: [0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 2 (total: 762+)
0000016d: PUSH2 0x0175                       │ Stack: [0x0175, 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 765+)
00000170: DUP3                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0175, 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 3 (total: 768+)
00000171: PUSH2 0x014c                       │ Stack: [0x014c, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0175, 0x0, ...+7] # gas: 3 (total: 771+)
00000174: JUMP                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0175, 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 8 (total: 779+)
00000175: JUMPDEST                           │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0175, 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 1 (total: 780+)
00000176: SWAP1                              │ Stack: [0x0175, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 3 (total: 783+)
00000177: POP                                │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 2 (total: 785+)
00000178: SWAP2                              │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 788+)
00000179: SWAP1                              │ Stack: [0x0, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 791+)
0000017a: POP                                │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 2 (total: 793+)
0000017b: JUMP                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 8 (total: 801+)
0000017c: JUMPDEST                           │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 1 (total: 802+)
0000017d: PUSH2 0x0185                       │ Stack: [0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 3 (total: 805+)
00000180: DUP2                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 3 (total: 808+)
00000181: PUSH2 0x016b                       │ Stack: [0x016b, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 3 (total: 811+)
00000184: JUMP                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 8 (total: 819+)
00000185: JUMPDEST                           │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], ...+5] # gas: 1 (total: 820+)
00000186: DUP3                               │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], 0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], ...+6] # gas: 3 (total: 823+)
00000187: MSTORE                             │ Stack: [0x0185, [[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, ...+4] # gas: 3 (total: 826+)
00000188: POP                                │ Stack: [[[0x0f4240+0x0f4240]&[0x0f4240+0x0f4240]], [0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 2 (total: 828+)
00000189: POP                                │ Stack: [[0x0f4240+0x0f4240], 0x0146, [0x0f4240+0x0f4240], 0x20, ...+2] # gas: 2 (total: 830+)
0000018a: JUMP                               │ Stack: [0x0146, [0x0f4240+0x0f4240], 0x20, 0x0, ...+1] # gas: 8 (total: 838+)
0000018b: JUMPDEST                           │ Stack: [0x0146, [0x0f4240+0x0f4240], 0x20, 0x0, ...+1] # gas: 1 (total: 839+)
0000018c: PUSH0                              │ Stack: [0x0, 0x0146, [0x0f4240+0x0f4240], 0x20, ...+2] # gas: 2 (total: 841+)
0000018d: PUSH1 0x20                         │ Stack: [0x20, 0x0, 0x0146, [0x0f4240+0x0f4240], ...+3] # gas: 3 (total: 844+)
0000018f: DUP3                               │ Stack: [0x0146, 0x20, 0x0, 0x0146, ...+4] # gas: 3 (total: 847+)
00000190: ADD                                │ Stack: [[0x0146+0x0146], 0x0146, 0x20, 0x0, ...+5] # gas: 3 (total: 850+)
00000191: SWAP1                              │ Stack: [0x0146, [0x0146+0x0146], 0x20, 0x0, ...+5] # gas: 3 (total: 853+)
00000192: POP                                │ Stack: [[0x0146+0x0146], 0x20, 0x0, 0x0146, ...+4] # gas: 2 (total: 855+)
00000193: PUSH2 0x019e                       │ Stack: [0x019e, [0x0146+0x0146], 0x20, 0x0, ...+5] # gas: 3 (total: 858+)
00000196: PUSH0                              │ Stack: [0x0, 0x019e, [0x0146+0x0146], 0x20, ...+6] # gas: 2 (total: 860+)
00000197: DUP4                               │ Stack: [0x20, 0x0, 0x019e, [0x0146+0x0146], ...+7] # gas: 3 (total: 863+)
00000198: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x019e, ...+8] # gas: 3 (total: 866+)
00000199: DUP5                               │ Stack: [[0x0146+0x0146], [0x20+0x20], 0x20, 0x0, ...+9] # gas: 3 (total: 869+)
0000019a: PUSH2 0x017c                       │ Stack: [0x017c, [0x0146+0x0146], [0x20+0x20], 0x20, ...+10] # gas: 3 (total: 872+)
0000019d: JUMP                               │ Stack: [[0x0146+0x0146], [0x20+0x20], 0x20, 0x0, ...+9] # gas: 8 (total: 880+)
0000019e: JUMPDEST                           │ Stack: [[0x0146+0x0146], [0x20+0x20], 0x20, 0x0, ...+9] # gas: 1 (total: 881+)
0000019f: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [0x0146+0x0146], ...+9] # gas: 3 (total: 884+)
000001a0: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [0x0146+0x0146], ...+9] # gas: 3 (total: 887+)
000001a1: POP                                │ Stack: [[0x20+0x20], 0x0, [0x0146+0x0146], 0x019e, ...+8] # gas: 2 (total: 889+)
000001a2: POP                                │ Stack: [0x0, [0x0146+0x0146], 0x019e, [0x0146+0x0146], ...+7] # gas: 2 (total: 891+)
000001a3: JUMP                               │ Stack: [[0x0146+0x0146], 0x019e, [0x0146+0x0146], 0x20, ...+6] # gas: 8 (total: 899+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

000001a4: INVALID                            │ Stack: [] # gas: 0 (total: 899+)
000001a5: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 2024+)
000001a6: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 2027+)
000001ac: INVALID                            │ Stack: [] # gas: 0 (total: 2027+)
000001ad: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 2030+)
000001ae: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 2060+) # mapping/array slot computation
000001af: PUSH1 0x8d                         │ Stack: [0x8d, [KECCAK]] # gas: 3 (total: 2063+)
000001b1: INVALID                            │ Stack: [] # gas: 0 (total: 2063+)
000001b2: RETURNDATACOPY                     │ Stack: [] # gas: 3 (base + dynamic) (total: 2066+)
000001b3: PUSH25 0x75935644b7cfcafab60139bf2bf7c16d7fa3fcee14672ec319 │ Stack: [0x75935644b7cfcafab60139bf2bf7c16d7fa3fcee14672ec319] # gas: 3 (total: 2069+)
000001cd: INVALID                            │ Stack: [] # gas: 0 (total: 2069+)
000001ce: PUSH32 0x64736f6c634300081c0033000000000000000000000000000000000000000000 │ Stack: [0x64736f6c634300081c0033000000000000000000000000000000000000000000] # gas: 3 (total: 2072+)

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
│ Function: MAX_SUPPLY()
│ Entry: 0x0000004e
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000c6] block

┌────────────────────────────────────────┐
│ Function: DEAD_ADDRESS()
│ Entry: 0x0000006c
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000cd] block

┌────────────────────────────────────────┐
│ Function: deployer()
│ Entry: 0x0000008a
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000d3] block

┌────────────────────────────────────────┐
│ Function: deploymentTime()
│ Entry: 0x000000a8
└────────────────────────────────────────┘
    │
    ├──[JUMP]──→ [0x000000f7] block

┌────────────────────────────────────────┐
│ Jump Targets (JUMPDEST locations):     │
└────────────────────────────────────────┘
  • 0x0000000f
  • 0x0000004a
  • 0x0000004e
  • 0x00000056
  • 0x00000063
  • 0x0000006c
  • 0x00000074
  • 0x00000081
  • 0x0000008a
  • 0x00000092
  • 0x0000009f
  • 0x000000a8
  • 0x000000b0
  • 0x000000bd
  • 0x000000c6
  • 0x000000cd
  • 0x000000d3
  • 0x000000f7
  • 0x0000011b
  • 0x00000124
  ... and 10 more

