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
00000010: PUSH2 0x0160                       │ Stack: [0x0160] # gas: 3 (total: 40)
00000013: DUP1                               │ Stack: [0x0160, 0x0160] # gas: 3 (total: 43)
00000014: PUSH2 0x001c                       │ Stack: [0x001c, 0x0160, 0x0160] # gas: 3 (total: 46)
00000017: PUSH0                              │ Stack: [0x0, 0x001c, 0x0160, 0x0160] # gas: 2 (total: 48)
00000018: CODECOPY                           │ Stack: [0x0160] # gas: 3 (base + dynamic) (total: 51+)
00000019: PUSH0                              │ Stack: [0x0, 0x0160] # gas: 2 (total: 53+)
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
00000005: CALLDATASIZE                       │ Stack: [[CALLDATASIZE]] # gas: 2 (total: 64+)
00000006: PUSH2 0x0042                       │ Stack: [0x0042, [CALLDATASIZE]] # gas: 3 (total: 67+)
00000009: JUMPI                              │ Stack: [] # gas: 10 (total: 77+)
0000000a: PUSH32 0x0dfaf7b3ed67d555d65df6729365ea7ab2ac8d2128fb556359e11039b374976f │ Stack: [0x0dfaf7b3ed67d555d65df6729365ea7ab2ac8d2128fb556359e11039b374976f] # gas: 3 (total: 80+)
0000002b: CALLVALUE                          │ Stack: [[CALLVALUE], 0x0dfaf7b3ed67d555d65df6729365ea7ab2ac8d2128fb556359e11039b374976f] # gas: 2 (total: 82+)
0000002c: PUSH1 0x40                         │ Stack: [0x40, [CALLVALUE], 0x0dfaf7b3ed67d555d65df6729365ea7ab2ac8d2128fb556359e11039b374976f] # gas: 3 (total: 85+)
0000002e: MLOAD                              │ Stack: [[M@0x40], 0x40, [CALLVALUE], 0x0dfaf7b3ed67d555d65df6729365ea7ab2ac8d2128fb556359e11039b374976f] # gas: 3 (total: 88+) # memory read: free memory pointer
0000002f: PUSH2 0x0038                       │ Stack: [0x0038, [M@0x40], 0x40, [CALLVALUE], ...+1] # gas: 3 (total: 91+)
00000032: SWAP2                              │ Stack: [0x40, [M@0x40], 0x0038, [CALLVALUE], ...+1] # gas: 3 (total: 94+)
00000033: SWAP1                              │ Stack: [[M@0x40], 0x40, 0x0038, [CALLVALUE], ...+1] # gas: 3 (total: 97+)
00000034: PUSH2 0x0095                       │ Stack: [0x0095, [M@0x40], 0x40, 0x0038, ...+2] # gas: 3 (total: 100+)
00000037: JUMP                               │ Stack: [[M@0x40], 0x40, 0x0038, [CALLVALUE], ...+1] # gas: 8 (total: 108+)
00000038: JUMPDEST                           │ Stack: [[M@0x40], 0x40, 0x0038, [CALLVALUE], ...+1] # gas: 1 (total: 109+)
00000039: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, 0x0038, ...+2] # gas: 3 (total: 112+)
0000003b: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+3] # gas: 3 (total: 115+) # memory read: free memory pointer
0000003c: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+4] # gas: 3 (total: 118+)
0000003d: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+4] # gas: 3 (total: 121+)
0000003e: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+5] # gas: 3 (total: 124+)
0000003f: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+5] # gas: 3 (total: 127+)
00000040: LOG1                               │ Stack: [[M@0x40], [M@0x40], 0x40, 0x0038, ...+2] # gas: 750 (base + dynamic) (total: 877+)
00000041: STOP                               │ Stack: [] # gas: 0 (total: 877+)
00000042: JUMPDEST                           │ Stack: [] # gas: 1 (total: 878+)
00000043: PUSH32 0x17c1956f6e992470102c5fc953bf560fda31fabee8737cf8e77bdde00eb5698d │ Stack: [0x17c1956f6e992470102c5fc953bf560fda31fabee8737cf8e77bdde00eb5698d] # gas: 3 (total: 881+)
00000064: PUSH0                              │ Stack: [0x0, 0x17c1956f6e992470102c5fc953bf560fda31fabee8737cf8e77bdde00eb5698d] # gas: 2 (total: 883+)
00000065: CALLDATASIZE                       │ Stack: [[CALLDATASIZE], 0x0, 0x17c1956f6e992470102c5fc953bf560fda31fabee8737cf8e77bdde00eb5698d] # gas: 2 (total: 885+)
00000066: PUSH1 0x40                         │ Stack: [0x40, [CALLDATASIZE], 0x0, 0x17c1956f6e992470102c5fc953bf560fda31fabee8737cf8e77bdde00eb5698d] # gas: 3 (total: 888+)
00000068: MLOAD                              │ Stack: [[M@0x40], 0x40, [CALLDATASIZE], 0x0, ...+1] # gas: 3 (total: 891+) # memory read: free memory pointer
00000069: PUSH2 0x0073                       │ Stack: [0x0073, [M@0x40], 0x40, [CALLDATASIZE], ...+2] # gas: 3 (total: 894+)
0000006c: SWAP3                              │ Stack: [[CALLDATASIZE], [M@0x40], 0x40, 0x0073, ...+2] # gas: 3 (total: 897+)
0000006d: SWAP2                              │ Stack: [0x40, [M@0x40], [CALLDATASIZE], 0x0073, ...+2] # gas: 3 (total: 900+)
0000006e: SWAP1                              │ Stack: [[M@0x40], 0x40, [CALLDATASIZE], 0x0073, ...+2] # gas: 3 (total: 903+)
0000006f: PUSH2 0x0108                       │ Stack: [0x0108, [M@0x40], 0x40, [CALLDATASIZE], ...+3] # gas: 3 (total: 906+)
00000072: JUMP                               │ Stack: [[M@0x40], 0x40, [CALLDATASIZE], 0x0073, ...+2] # gas: 8 (total: 914+)
00000073: JUMPDEST                           │ Stack: [[M@0x40], 0x40, [CALLDATASIZE], 0x0073, ...+2] # gas: 1 (total: 915+)
00000074: PUSH1 0x40                         │ Stack: [0x40, [M@0x40], 0x40, [CALLDATASIZE], ...+3] # gas: 3 (total: 918+)
00000076: MLOAD                              │ Stack: [[M@0x40], 0x40, [M@0x40], 0x40, ...+4] # gas: 3 (total: 921+) # memory read: free memory pointer
00000077: DUP1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [M@0x40], ...+5] # gas: 3 (total: 924+)
00000078: SWAP2                              │ Stack: [0x40, [M@0x40], [M@0x40], [M@0x40], ...+5] # gas: 3 (total: 927+)
00000079: SUB                                │ Stack: [[0x40-0x40], 0x40, [M@0x40], [M@0x40], ...+6] # gas: 3 (total: 930+)
0000007a: SWAP1                              │ Stack: [0x40, [0x40-0x40], [M@0x40], [M@0x40], ...+6] # gas: 3 (total: 933+)
0000007b: LOG1                               │ Stack: [[M@0x40], [M@0x40], 0x40, [CALLDATASIZE], ...+3] # gas: 750 (base + dynamic) (total: 1683+)
0000007c: STOP                               │ Stack: [] # gas: 0 (total: 1683+)
0000007d: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1684+)
0000007e: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1686+)
0000007f: DUP2                               │ Stack: [?, 0x0] # gas: 3 (total: 1689+)
00000080: SWAP1                              │ Stack: [0x0, ?] # gas: 3 (total: 1692+)
00000081: POP                                │ Stack: [?] # gas: 2 (total: 1694+)
00000082: SWAP2                              │ Stack: [?] # gas: 3 (total: 1697+)
00000083: SWAP1                              │ Stack: [?] # gas: 3 (total: 1700+)
00000084: POP                                │ Stack: [] # gas: 2 (total: 1702+)
00000085: JUMP                               │ Stack: [] # gas: 8 (total: 1710+)
00000086: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1711+)
00000087: PUSH2 0x008f                       │ Stack: [0x008f] # gas: 3 (total: 1714+)
0000008a: DUP2                               │ Stack: [?, 0x008f] # gas: 3 (total: 1717+)
0000008b: PUSH2 0x007d                       │ Stack: [0x007d, ?, 0x008f] # gas: 3 (total: 1720+)
0000008e: JUMP                               │ Stack: [?, 0x008f] # gas: 8 (total: 1728+)
0000008f: JUMPDEST                           │ Stack: [?, 0x008f] # gas: 1 (total: 1729+)
00000090: DUP3                               │ Stack: [?, ?, 0x008f] # gas: 3 (total: 1732+)
00000091: MSTORE                             │ Stack: [0x008f] # gas: 3 (total: 1735+)
00000092: POP                                │ Stack: [] # gas: 2 (total: 1737+)
00000093: POP                                │ Stack: [] # gas: 2 (total: 1739+)
00000094: JUMP                               │ Stack: [] # gas: 8 (total: 1747+)
00000095: JUMPDEST                           │ Stack: [] # gas: 1 (total: 1748+)
00000096: PUSH0                              │ Stack: [0x0] # gas: 2 (total: 1750+)
00000097: PUSH1 0x20                         │ Stack: [0x20, 0x0] # gas: 3 (total: 1753+)
00000099: DUP3                               │ Stack: [?, 0x20, 0x0] # gas: 3 (total: 1756+)
0000009a: ADD                                │ Stack: [[?+?], ?, 0x20, 0x0] # gas: 3 (total: 1759+)
0000009b: SWAP1                              │ Stack: [?, [?+?], 0x20, 0x0] # gas: 3 (total: 1762+)
0000009c: POP                                │ Stack: [[?+?], 0x20, 0x0] # gas: 2 (total: 1764+)
0000009d: PUSH2 0x00a8                       │ Stack: [0x00a8, [?+?], 0x20, 0x0] # gas: 3 (total: 1767+)
000000a0: PUSH0                              │ Stack: [0x0, 0x00a8, [?+?], 0x20, ...+1] # gas: 2 (total: 1769+)
000000a1: DUP4                               │ Stack: [0x20, 0x0, 0x00a8, [?+?], ...+2] # gas: 3 (total: 1772+)
000000a2: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, 0x00a8, ...+3] # gas: 3 (total: 1775+)
000000a3: DUP5                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 3 (total: 1778+)
000000a4: PUSH2 0x0086                       │ Stack: [0x0086, [?+?], [0x20+0x20], 0x20, ...+5] # gas: 3 (total: 1781+)
000000a7: JUMP                               │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 8 (total: 1789+)
000000a8: JUMPDEST                           │ Stack: [[?+?], [0x20+0x20], 0x20, 0x0, ...+4] # gas: 1 (total: 1790+)
000000a9: SWAP3                              │ Stack: [0x0, [0x20+0x20], 0x20, [?+?], ...+4] # gas: 3 (total: 1793+)
000000aa: SWAP2                              │ Stack: [0x20, [0x20+0x20], 0x0, [?+?], ...+4] # gas: 3 (total: 1796+)
000000ab: POP                                │ Stack: [[0x20+0x20], 0x0, [?+?], 0x00a8, ...+3] # gas: 2 (total: 1798+)
000000ac: POP                                │ Stack: [0x0, [?+?], 0x00a8, [?+?], ...+2] # gas: 2 (total: 1800+)
000000ad: JUMP                               │ Stack: [[?+?], 0x00a8, [?+?], 0x20, ...+1] # gas: 8 (total: 1808+)
000000ae: JUMPDEST                           │ Stack: [[?+?], 0x00a8, [?+?], 0x20, ...+1] # gas: 1 (total: 1809+)
000000af: PUSH0                              │ Stack: [0x0, [?+?], 0x00a8, [?+?], ...+2] # gas: 2 (total: 1811+)
000000b0: DUP3                               │ Stack: [0x00a8, 0x0, [?+?], 0x00a8, ...+3] # gas: 3 (total: 1814+)
000000b1: DUP3                               │ Stack: [[?+?], 0x00a8, 0x0, [?+?], ...+4] # gas: 3 (total: 1817+)
000000b2: MSTORE                             │ Stack: [0x0, [?+?], 0x00a8, [?+?], ...+2] # gas: 3 (total: 1820+)
000000b3: PUSH1 0x20                         │ Stack: [0x20, 0x0, [?+?], 0x00a8, ...+3] # gas: 3 (total: 1823+)
000000b5: DUP3                               │ Stack: [[?+?], 0x20, 0x0, [?+?], ...+4] # gas: 3 (total: 1826+)
000000b6: ADD                                │ Stack: [[[?+?]+[?+?]], [?+?], 0x20, 0x0, ...+5] # gas: 3 (total: 1829+)
000000b7: SWAP1                              │ Stack: [[?+?], [[?+?]+[?+?]], 0x20, 0x0, ...+5] # gas: 3 (total: 1832+)
000000b8: POP                                │ Stack: [[[?+?]+[?+?]], 0x20, 0x0, [?+?], ...+4] # gas: 2 (total: 1834+)
000000b9: SWAP3                              │ Stack: [[?+?], 0x20, 0x0, [[?+?]+[?+?]], ...+4] # gas: 3 (total: 1837+)
000000ba: SWAP2                              │ Stack: [0x0, 0x20, [?+?], [[?+?]+[?+?]], ...+4] # gas: 3 (total: 1840+)
000000bb: POP                                │ Stack: [0x20, [?+?], [[?+?]+[?+?]], 0x00a8, ...+3] # gas: 2 (total: 1842+)
000000bc: POP                                │ Stack: [[?+?], [[?+?]+[?+?]], 0x00a8, [?+?], ...+2] # gas: 2 (total: 1844+)
000000bd: JUMP                               │ Stack: [[[?+?]+[?+?]], 0x00a8, [?+?], 0x20, ...+1] # gas: 8 (total: 1852+)
000000be: JUMPDEST                           │ Stack: [[[?+?]+[?+?]], 0x00a8, [?+?], 0x20, ...+1] # gas: 1 (total: 1853+)
000000bf: DUP3                               │ Stack: [[?+?], [[?+?]+[?+?]], 0x00a8, [?+?], ...+2] # gas: 3 (total: 1856+)
000000c0: DUP2                               │ Stack: [[[?+?]+[?+?]], [?+?], [[?+?]+[?+?]], 0x00a8, ...+3] # gas: 3 (total: 1859+)
000000c1: DUP4                               │ Stack: [0x00a8, [[?+?]+[?+?]], [?+?], [[?+?]+[?+?]], ...+4] # gas: 3 (total: 1862+)
000000c2: CALLDATACOPY                       │ Stack: [[[?+?]+[?+?]], 0x00a8, [?+?], 0x20, ...+1] # gas: 3 (base + dynamic) (total: 1865+)
000000c3: PUSH0                              │ Stack: [0x0, [[?+?]+[?+?]], 0x00a8, [?+?], ...+2] # gas: 2 (total: 1867+)
000000c4: DUP4                               │ Stack: [[?+?], 0x0, [[?+?]+[?+?]], 0x00a8, ...+3] # gas: 3 (total: 1870+)
000000c5: DUP4                               │ Stack: [0x00a8, [?+?], 0x0, [[?+?]+[?+?]], ...+4] # gas: 3 (total: 1873+)
000000c6: ADD                                │ Stack: [[0x00a8+0x00a8], 0x00a8, [?+?], 0x0, ...+5] # gas: 3 (total: 1876+)
000000c7: MSTORE                             │ Stack: [[?+?], 0x0, [[?+?]+[?+?]], 0x00a8, ...+3] # gas: 3 (total: 1879+)
000000c8: POP                                │ Stack: [0x0, [[?+?]+[?+?]], 0x00a8, [?+?], ...+2] # gas: 2 (total: 1881+)
000000c9: POP                                │ Stack: [[[?+?]+[?+?]], 0x00a8, [?+?], 0x20, ...+1] # gas: 2 (total: 1883+)
000000ca: POP                                │ Stack: [0x00a8, [?+?], 0x20, 0x0] # gas: 2 (total: 1885+)
000000cb: JUMP                               │ Stack: [[?+?], 0x20, 0x0] # gas: 8 (total: 1893+)
000000cc: JUMPDEST                           │ Stack: [[?+?], 0x20, 0x0] # gas: 1 (total: 1894+)
000000cd: PUSH0                              │ Stack: [0x0, [?+?], 0x20, 0x0] # gas: 2 (total: 1896+)
000000ce: PUSH1 0x1f                         │ Stack: [0x1f, 0x0, [?+?], 0x20, ...+1] # gas: 3 (total: 1899+)
000000d0: NOT                                │ Stack: [[~0x1f], 0x1f, 0x0, [?+?], ...+2] # gas: 3 (total: 1902+)
000000d1: PUSH1 0x1f                         │ Stack: [0x1f, [~0x1f], 0x1f, 0x0, ...+3] # gas: 3 (total: 1905+)
000000d3: DUP4                               │ Stack: [0x0, 0x1f, [~0x1f], 0x1f, ...+4] # gas: 3 (total: 1908+)
000000d4: ADD                                │ Stack: [[0x0+0x0], 0x0, 0x1f, [~0x1f], ...+5] # gas: 3 (total: 1911+)
000000d5: AND                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], [0x0+0x0], 0x0, 0x1f, ...+6] # gas: 3 (total: 1914+)
000000d6: SWAP1                              │ Stack: [[0x0+0x0], [[0x0+0x0]&[0x0+0x0]], 0x0, 0x1f, ...+6] # gas: 3 (total: 1917+)
000000d7: POP                                │ Stack: [[[0x0+0x0]&[0x0+0x0]], 0x0, 0x1f, [~0x1f], ...+5] # gas: 2 (total: 1919+)
000000d8: SWAP2                              │ Stack: [0x1f, 0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 1922+)
000000d9: SWAP1                              │ Stack: [0x0, 0x1f, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 1925+)
000000da: POP                                │ Stack: [0x1f, [[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, ...+4] # gas: 2 (total: 1927+)
000000db: JUMP                               │ Stack: [[[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, 0x0, ...+3] # gas: 8 (total: 1935+)
000000dc: JUMPDEST                           │ Stack: [[[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, 0x0, ...+3] # gas: 1 (total: 1936+)
000000dd: PUSH0                              │ Stack: [0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x1f, ...+4] # gas: 2 (total: 1938+)
000000de: PUSH2 0x00e7                       │ Stack: [0x00e7, 0x0, [[0x0+0x0]&[0x0+0x0]], [~0x1f], ...+5] # gas: 3 (total: 1941+)
000000e1: DUP4                               │ Stack: [[~0x1f], 0x00e7, 0x0, [[0x0+0x0]&[0x0+0x0]], ...+6] # gas: 3 (total: 1944+)
000000e2: DUP6                               │ Stack: [0x1f, [~0x1f], 0x00e7, 0x0, ...+7] # gas: 3 (total: 1947+)
000000e3: PUSH2 0x00ae                       │ Stack: [0x00ae, 0x1f, [~0x1f], 0x00e7, ...+8] # gas: 3 (total: 1950+)
000000e6: JUMP                               │ Stack: [0x1f, [~0x1f], 0x00e7, 0x0, ...+7] # gas: 8 (total: 1958+)
000000e7: JUMPDEST                           │ Stack: [0x1f, [~0x1f], 0x00e7, 0x0, ...+7] # gas: 1 (total: 1959+)
000000e8: SWAP4                              │ Stack: [[[0x0+0x0]&[0x0+0x0]], [~0x1f], 0x00e7, 0x0, ...+7] # gas: 3 (total: 1962+)
000000e9: POP                                │ Stack: [[~0x1f], 0x00e7, 0x0, 0x1f, ...+6] # gas: 2 (total: 1964+)
000000ea: PUSH2 0x00f4                       │ Stack: [0x00f4, [~0x1f], 0x00e7, 0x0, ...+7] # gas: 3 (total: 1967+)
000000ed: DUP4                               │ Stack: [0x0, 0x00f4, [~0x1f], 0x00e7, ...+8] # gas: 3 (total: 1970+)
000000ee: DUP6                               │ Stack: [0x1f, 0x0, 0x00f4, [~0x1f], ...+9] # gas: 3 (total: 1973+)
000000ef: DUP5                               │ Stack: [0x00e7, 0x1f, 0x0, 0x00f4, ...+10] # gas: 3 (total: 1976+)
000000f0: PUSH2 0x00be                       │ Stack: [0x00be, 0x00e7, 0x1f, 0x0, ...+11] # gas: 3 (total: 1979+)
000000f3: JUMP                               │ Stack: [0x00e7, 0x1f, 0x0, 0x00f4, ...+10] # gas: 8 (total: 1987+)
000000f4: JUMPDEST                           │ Stack: [0x00e7, 0x1f, 0x0, 0x00f4, ...+10] # gas: 1 (total: 1988+)
000000f5: PUSH2 0x00fd                       │ Stack: [0x00fd, 0x00e7, 0x1f, 0x0, ...+11] # gas: 3 (total: 1991+)
000000f8: DUP4                               │ Stack: [0x0, 0x00fd, 0x00e7, 0x1f, ...+12] # gas: 3 (total: 1994+)
000000f9: PUSH2 0x00cc                       │ Stack: [0x00cc, 0x0, 0x00fd, 0x00e7, ...+13] # gas: 3 (total: 1997+)
000000fc: JUMP                               │ Stack: [0x0, 0x00fd, 0x00e7, 0x1f, ...+12] # gas: 8 (total: 2005+)
000000fd: JUMPDEST                           │ Stack: [0x0, 0x00fd, 0x00e7, 0x1f, ...+12] # gas: 1 (total: 2006+)
000000fe: DUP5                               │ Stack: [0x0, 0x0, 0x00fd, 0x00e7, ...+13] # gas: 3 (total: 2009+)
000000ff: ADD                                │ Stack: [[0x0+0x0], 0x0, 0x0, 0x00fd, ...+14] # gas: 3 (total: 2012+)
00000100: SWAP1                              │ Stack: [0x0, [0x0+0x0], 0x0, 0x00fd, ...+14] # gas: 3 (total: 2015+)
00000101: POP                                │ Stack: [[0x0+0x0], 0x0, 0x00fd, 0x00e7, ...+13] # gas: 2 (total: 2017+)
00000102: SWAP4                              │ Stack: [0x1f, 0x0, 0x00fd, 0x00e7, ...+13] # gas: 3 (total: 2020+)
00000103: SWAP3                              │ Stack: [0x00e7, 0x0, 0x00fd, 0x1f, ...+13] # gas: 3 (total: 2023+)
00000104: POP                                │ Stack: [0x0, 0x00fd, 0x1f, [0x0+0x0], ...+12] # gas: 2 (total: 2025+)
00000105: POP                                │ Stack: [0x00fd, 0x1f, [0x0+0x0], 0x0, ...+11] # gas: 2 (total: 2027+)
00000106: POP                                │ Stack: [0x1f, [0x0+0x0], 0x0, 0x00f4, ...+10] # gas: 2 (total: 2029+)
00000107: JUMP                               │ Stack: [[0x0+0x0], 0x0, 0x00f4, [~0x1f], ...+9] # gas: 8 (total: 2037+)
00000108: JUMPDEST                           │ Stack: [[0x0+0x0], 0x0, 0x00f4, [~0x1f], ...+9] # gas: 1 (total: 2038+)
00000109: PUSH0                              │ Stack: [0x0, [0x0+0x0], 0x0, 0x00f4, ...+10] # gas: 2 (total: 2040+)
0000010a: PUSH1 0x20                         │ Stack: [0x20, 0x0, [0x0+0x0], 0x0, ...+11] # gas: 3 (total: 2043+)
0000010c: DUP3                               │ Stack: [[0x0+0x0], 0x20, 0x0, [0x0+0x0], ...+12] # gas: 3 (total: 2046+)
0000010d: ADD                                │ Stack: [[[0x0+0x0]+[0x0+0x0]], [0x0+0x0], 0x20, 0x0, ...+13] # gas: 3 (total: 2049+)
0000010e: SWAP1                              │ Stack: [[0x0+0x0], [[0x0+0x0]+[0x0+0x0]], 0x20, 0x0, ...+13] # gas: 3 (total: 2052+)
0000010f: POP                                │ Stack: [[[0x0+0x0]+[0x0+0x0]], 0x20, 0x0, [0x0+0x0], ...+12] # gas: 2 (total: 2054+)
00000110: DUP2                               │ Stack: [0x20, [[0x0+0x0]+[0x0+0x0]], 0x20, 0x0, ...+13] # gas: 3 (total: 2057+)
00000111: DUP2                               │ Stack: [[[0x0+0x0]+[0x0+0x0]], 0x20, [[0x0+0x0]+[0x0+0x0]], 0x20, ...+14] # gas: 3 (total: 2060+)
00000112: SUB                                │ Stack: [[[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], [[0x0+0x0]+[0x0+0x0]], 0x20, [[0x0+0x0]+[0x0+0x0]], ...+15] # gas: 3 (total: 2063+)
00000113: PUSH0                              │ Stack: [0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], [[0x0+0x0]+[0x0+0x0]], 0x20, ...+16] # gas: 2 (total: 2065+)
00000114: DUP4                               │ Stack: [0x20, 0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], [[0x0+0x0]+[0x0+0x0]], ...+17] # gas: 3 (total: 2068+)
00000115: ADD                                │ Stack: [[0x20+0x20], 0x20, 0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], ...+18] # gas: 3 (total: 2071+)
00000116: MSTORE                             │ Stack: [0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], [[0x0+0x0]+[0x0+0x0]], 0x20, ...+16] # gas: 3 (total: 2074+)
00000117: PUSH2 0x0121                       │ Stack: [0x0121, 0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], [[0x0+0x0]+[0x0+0x0]], ...+17] # gas: 3 (total: 2077+)
0000011a: DUP2                               │ Stack: [0x0, 0x0121, 0x0, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], ...+18] # gas: 3 (total: 2080+)
0000011b: DUP5                               │ Stack: [[[0x0+0x0]+[0x0+0x0]], 0x0, 0x0121, 0x0, ...+19] # gas: 3 (total: 2083+)
0000011c: DUP7                               │ Stack: [0x20, [[0x0+0x0]+[0x0+0x0]], 0x0, 0x0121, ...+20] # gas: 3 (total: 2086+)
0000011d: PUSH2 0x00dc                       │ Stack: [0x00dc, 0x20, [[0x0+0x0]+[0x0+0x0]], 0x0, ...+21] # gas: 3 (total: 2089+)
00000120: JUMP                               │ Stack: [0x20, [[0x0+0x0]+[0x0+0x0]], 0x0, 0x0121, ...+20] # gas: 8 (total: 2097+)
00000121: JUMPDEST                           │ Stack: [0x20, [[0x0+0x0]+[0x0+0x0]], 0x0, 0x0121, ...+20] # gas: 1 (total: 2098+)
00000122: SWAP1                              │ Stack: [[[0x0+0x0]+[0x0+0x0]], 0x20, 0x0, 0x0121, ...+20] # gas: 3 (total: 2101+)
00000123: POP                                │ Stack: [0x20, 0x0, 0x0121, 0x0, ...+19] # gas: 2 (total: 2103+)
00000124: SWAP4                              │ Stack: [[[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], 0x0, 0x0121, 0x0, ...+19] # gas: 3 (total: 2106+)
00000125: SWAP3                              │ Stack: [0x0, 0x0, 0x0121, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], ...+19] # gas: 3 (total: 2109+)
00000126: POP                                │ Stack: [0x0, 0x0121, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], 0x20, ...+18] # gas: 2 (total: 2111+)
00000127: POP                                │ Stack: [0x0121, [[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], 0x20, [[0x0+0x0]+[0x0+0x0]], ...+17] # gas: 2 (total: 2113+)
00000128: POP                                │ Stack: [[[[0x0+0x0]+[0x0+0x0]]-[[0x0+0x0]+[0x0+0x0]]], 0x20, [[0x0+0x0]+[0x0+0x0]], 0x20, ...+16] # gas: 2 (total: 2115+)
00000129: JUMP                               │ Stack: [0x20, [[0x0+0x0]+[0x0+0x0]], 0x20, [[0x0+0x0]+[0x0+0x0]], ...+15] # gas: 8 (total: 2123+)

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

0000012a: INVALID                            │ Stack: [] # gas: 0 (total: 2123+)
0000012b: LOG2                               │ Stack: [] # gas: 1125 (base + dynamic) (total: 3248+)
0000012c: PUSH5 0x6970667358                 │ Stack: [0x6970667358] # gas: 3 (total: 3251+)
00000132: INVALID                            │ Stack: [] # gas: 0 (total: 3251+)
00000133: SLT                                │ Stack: [[cmp]] # gas: 3 (total: 3254+)
00000134: KECCAK256                          │ Stack: [[KECCAK]] # gas: 30 (base + dynamic) (total: 3284+) # mapping/array slot computation
00000135: RETURNDATALOAD                     │ Stack: [[KECCAK]] # gas: ? (total: 3284+)
00000136: INVALID                            │ Stack: [] # gas: 0 (total: 3284+)
00000137: PUSH32 0xe36537714f72fdcab0723085d27bd85d8c4a47e5976cc19b58896d495f64736f │ Stack: [0xe36537714f72fdcab0723085d27bd85d8c4a47e5976cc19b58896d495f64736f] # gas: 3 (total: 3287+)
00000158: PUSH13 0x634300081c0033000000000000 │ Stack: [0x634300081c0033000000000000, 0xe36537714f72fdcab0723085d27bd85d8c4a47e5976cc19b58896d495f64736f] # gas: 3 (total: 3290+)

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
  • 0x00000038
  • 0x00000042
  • 0x00000073
  • 0x0000007d
  • 0x00000086
  • 0x0000008f
  • 0x00000095
  • 0x000000a8
  • 0x000000ae
  • 0x000000be
  • 0x000000cc
  • 0x000000dc
  • 0x000000e7
  • 0x000000f4
  • 0x000000fd
  • 0x00000108
  • 0x00000121

