╔════════════════════════════════════════════════════════════════╗
║                      CREATION CODE                             ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80
00000002: PUSH1 0x40
00000004: MSTORE
00000005: CALLVALUE
00000006: PUSH0
00000007: DUP2
00000008: SWAP1
00000009: SSTORE
0000000a: POP
0000000b: PUSH1 0xac
0000000d: DUP1
0000000e: PUSH1 0x15
00000010: PUSH0
00000011: CODECOPY
00000012: PUSH0
00000013: RETURN
00000014: INVALID

╔════════════════════════════════════════════════════════════════╗
║                      RUNTIME CODE                              ║
║                  (Deployed Contract Code)                      ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║                        PREAMBLE                                ║
║              Memory Init & Callvalue Check                     ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80
00000002: PUSH1 0x40
00000004: MSTORE
00000005: CALLVALUE
00000006: DUP1
00000007: ISZERO
00000008: PUSH1 0x0e
0000000a: JUMPI
0000000b: PUSH0
0000000c: PUSH0
0000000d: REVERT
0000000e: JUMPDEST
0000000f: POP
00000010: PUSH1 0x04
00000012: CALLDATASIZE
00000013: LT
00000014: PUSH1 0x26
00000016: JUMPI
00000017: PUSH0

╔════════════════════════════════════════════════════════════════╗
║                   FUNCTION DISPATCHER                          ║
║             Routes Calls to Function Bodies                    ║
╚════════════════════════════════════════════════════════════════╝

00000018: CALLDATALOAD
00000019: PUSH1 0xe0
0000001b: SHR
0000001c: DUP1
0000001d: PUSH4 0x9632e720 # receivedAmount()
00000022: EQ
00000023: PUSH1 0x2a
00000025: JUMPI
00000026: JUMPDEST
00000027: PUSH0
00000028: PUSH0
00000029: REVERT

╔════════════════════════════════════════════════════════════════╗
║                    FUNCTION BODIES                             ║
║              External Function Implementations                 ║
╚════════════════════════════════════════════════════════════════╝

0000002a: JUMPDEST
0000002b: PUSH1 0x30
0000002d: PUSH1 0x44
0000002f: JUMP
00000030: JUMPDEST
00000031: PUSH1 0x40
00000033: MLOAD
00000034: PUSH1 0x3b
00000036: SWAP2
00000037: SWAP1
00000038: PUSH1 0x5f
0000003a: JUMP
0000003b: JUMPDEST
0000003c: PUSH1 0x40
0000003e: MLOAD
0000003f: DUP1
00000040: SWAP2
00000041: SUB
00000042: SWAP1
00000043: RETURN
00000044: JUMPDEST
00000045: PUSH0
00000046: SLOAD
00000047: DUP2
00000048: JUMP
00000049: JUMPDEST
0000004a: PUSH0
0000004b: DUP2
0000004c: SWAP1
0000004d: POP
0000004e: SWAP2
0000004f: SWAP1
00000050: POP
00000051: JUMP
00000052: JUMPDEST
00000053: PUSH1 0x59
00000055: DUP2
00000056: PUSH1 0x49
00000058: JUMP
00000059: JUMPDEST
0000005a: DUP3
0000005b: MSTORE
0000005c: POP
0000005d: POP
0000005e: JUMP
0000005f: JUMPDEST
00000060: PUSH0
00000061: PUSH1 0x20
00000063: DUP3
00000064: ADD
00000065: SWAP1
00000066: POP
00000067: PUSH1 0x70
00000069: PUSH0
0000006a: DUP4
0000006b: ADD
0000006c: DUP5
0000006d: PUSH1 0x52
0000006f: JUMP
00000070: JUMPDEST
00000071: SWAP3
00000072: SWAP2
00000073: POP
00000074: POP
00000075: JUMP

╔════════════════════════════════════════════════════════════════╗
║                         METADATA                               ║
║                    (CBOR Encoded Data)                         ║
╚════════════════════════════════════════════════════════════════╝

00000076: INVALID
00000077: LOG2
00000078: PUSH5 0x6970667358
0000007e: INVALID
0000007f: SLT
00000080: KECCAK256
00000081: NUMBER
00000082: INVALID
00000083: CODESIZE
00000084: DUP1
00000085: PUSH24 0x74b9ea0c58974a6b81bf2f27cb38f8c57e4b9199cc95d400
0000009e: PUSH2 0x8650
000000a1: PUSH5 0x736f6c6343
000000a7: STOP
000000a8: ADDMOD
000000a9: SHR
000000aa: STOP
000000ab: CALLER
