╔════════════════════════════════════════════════════════════════╗
║                      CREATION CODE                             ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80
; PUSH1 1-byte immediate ke stack.
; 0x80 adalah nilai awal Free Memory Pointer (first free memory offset) sesuai konvensi Solidity,
; yang akan disimpan ke slot memori 0x40 sebagai penanda offset memori bebas berikutnya.
; Byte di offset 00000002 (0x80) adalah immediate/argumen untuk PUSH1 ini, sehingga tidak muncul
; sebagai instruksi terpisah di disassembly.
; Referensi: https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html


00000002: PUSH1 0x40
; PUSH1 1-byte immediate ke stack.
; 0x40 adalah offset memori untuk slot Free Memory Pointer (FMP) sesuai konvensi Solidity,
; yaitu word memory[0x40..0x5f] yang menyimpan alamat awal memori bebas berikutnya.
; Instruksi setelah ini (MSTORE) akan menulis nilai 0x80 ke slot tersebut: memory[0x40] = 0x80.


00000004: MSTORE
; MSTORE (Memory Store) - Opcode 0x52
; Menyimpan 32-byte (256-bit word) ke dalam memori EVM.
;
; Cara kerja MSTORE:
; 1. Pop 2 nilai dari stack:
;    - Nilai pertama (top of stack): offset/alamat memori tujuan
;    - Nilai kedua: data 32-byte yang akan disimpan
; 2. Simpan data tersebut ke memori pada offset yang ditentukan
;
; Kondisi stack SEBELUM MSTORE dieksekusi:
;   Stack: [0x40, 0x80, ...] (0x40 di paling atas)
;   - 0x40 = alamat memori tujuan (slot Free Memory Pointer)
;   - 0x80 = nilai yang akan disimpan (offset memori bebas awal)
;
; Kondisi SETELAH MSTORE dieksekusi:
;   - Stack: kosong (kedua nilai sudah di-pop)
;   - Memory[0x40] = 0x0000...0080 (32 bytes, padded dengan zeros di depan)
;
; Analogi sederhana:
; Bayangkan memory seperti "papan tulis" raksasa dengan kotak-kotak bernomor.
; MSTORE seperti menulis angka 0x80 (128) di kotak nomor 0x40 (64).
; Setelah ini, setiap kali EVM perlu tahu "di mana memori kosong berikutnya?",
; ia akan melihat kotak 0x40 dan menemukan jawaban: "mulai dari offset 0x80".
;
; Kenapa ini penting?
; Instruksi PUSH1 0x80 + PUSH1 0x40 + MSTORE adalah "ritual pembuka" standar
; yang dilakukan oleh SEMUA smart contract Solidity. Ini menginisialisasi
; Free Memory Pointer (FMP) sehingga Solidity tahu di mana harus menyimpan
; data dinamis seperti array, string, struct, dll saat runtime.
;
; Gas cost: 3 gas (minimum) + biaya ekspansi memori jika mengakses area baru
;
; Referensi:
; - https://www.evm.codes/#52
; - https://ethereum.org/developers/docs/evm/opcodes/
; - https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html

00000005: CALLVALUE
; CALLVALUE (Get Call Value) - Opcode 0x34
; Mengambil jumlah ETH (dalam satuan Wei) yang dikirim bersama transaksi/pemanggilan ini
; dan mendorongnya (push) ke stack.
;
; Cara kerja CALLVALUE:
; 1. Tidak mengambil (pop) apapun dari stack
; 2. Mendorong (push) 1 nilai ke stack:
;    - Jumlah Wei yang dikirim dalam transaksi   saat ini (msg.value di Solidity)
;
; Kondisi stack SEBELUM CALLVALUE dieksekusi:
;   Stack: [...] (bisa kosong atau berisi nilai lain, dalam kasus ini kosong setelah MSTORE)
;
; Kondisi stack SETELAH CALLVALUE dieksekusi:
;   Stack: [msg.value]
;   - Jika tidak ada ETH yang dikirim: nilai = 0
;   - Jika ada ETH yang dikirim: nilai = jumlah Wei (1 ETH = 10^18 Wei)
;
; Analogi sederhana:
; Bayangkan kamu adalah kasir di toko. Sebelum melayani pelanggan,
; kamu SELALU cek dulu: "Ada uang yang dikasih nggak sama pelanggan ini?"
; CALLVALUE seperti mengintip amplop dari pelanggan untuk melihat berapa uang
; yang mereka kirim bersama "pesanan" (transaksi) mereka.
;
; Konteks penggunaan di bytecode ini (pola "non-payable guard"):
;   00000006: CALLVALUE    ; Ambil jumlah ETH yang dikirim → stack: [msg.value]
;   00000007: DUP1         ; Duplikat nilai tersebut → stack: [msg.value, msg.value]
;   00000008: ISZERO       ; Cek apakah msg.value == 0 → stack: [isZero, msg.value]
;   00000009: PUSH1 0x0e   ; Push alamat jump → stack: [0x0e, isZero, msg.value]
;   0000000b: JUMPI        ; Jika isZero=true (value=0), lompat ke 0x0f (JUMPDEST)
;   0000000c: PUSH0        ; Kalau value bukan 0, push 0 → untuk REVERT
;   0000000d: PUSH0        ; Push 0 lagi → untuk REVERT
;   0000000e: REVERT       ; Batalkan transaksi! (reject ETH yang dikirim)
;
; Pola ini adalah "non-payable guard" - penjaga agar constructor/fungsi
; TIDAK MENERIMA ETH. Ini setara dengan fungsi Solidity yang TIDAK ditandai "payable".
;
; Mengapa ini penting?
; 1. KEAMANAN: Mencegah pengguna tidak sengaja mengirim ETH ke contract yang tidak
;    dirancang untuk menerima/mengelola ETH → mencegah ETH "terkunci" selamanya.
; 2. DESAIN CONTRACT: Hanya fungsi dengan keyword "payable" di Solidity yang
;    boleh menerima ETH. Sisanya WAJIB menolak.
;
; Contoh Solidity yang menghasilkan pola ini:
;   contract Example {
;       // Constructor ini TIDAK payable, jadi compiler Solidity akan
;       // menambahkan pengecekan CALLVALUE → ISZERO → REVERT
;       constructor() {
;           // inisialisasi...
;       }
;   }
;
; vs constructor payable:
;   constructor() payable {
;       // Tidak ada pengecekan CALLVALUE, ETH boleh diterima saat deploy
;   }
;
; Gas cost: 2 gas (sangat murah, hanya membaca environment variable)
;
; Referensi:
; - https://www.evm.codes/#34
; - https://ethereum.org/developers/docs/evm/opcodes/
; - https://ethervm.io/

00000006: DUP1
; DUP1 (Duplicate 1st Stack Item) - Opcode 0x80
; Menduplikasi (meng-copy) nilai yang ada di paling atas stack, lalu mendorong
; salinan tersebut ke atas stack. Nilai asli TETAP ADA, tidak dihapus.
;
; Cara kerja DUP1:
; 1. Mengintip (peek) nilai di posisi pertama stack (top of stack)
; 2. Membuat salinan dari nilai tersebut
; 3. Mendorong (push) salinan ke atas stack
; 4. Nilai asli tetap di tempatnya (sekarang menjadi posisi ke-2)
;
; Kondisi stack SEBELUM DUP1 dieksekusi:
;   Stack: [msg.value] (hasil dari CALLVALUE sebelumnya)
;
; Kondisi stack SETELAH DUP1 dieksekusi:
;   Stack: [msg.value, msg.value]
;   - Kedua nilai identik (salinan sempurna)
;   - Top of stack: msg.value (salinan)
;   - Posisi ke-2: msg.value (asli)
;
; Analogi sederhana:
; Bayangkan kamu punya tumpukan kertas, dan kertas paling atas bertuliskan "100".
; DUP1 seperti memfotokopi kertas tersebut dan meletakkan hasil fotokopinya
; di atas tumpukan. Sekarang kamu punya DUA kertas bertuliskan "100" di paling atas.
; Kertas asli tidak hilang, hanya "turun" satu posisi.
;
; Mengapa perlu DUP1 di sini?
; Karena opcode ISZERO (berikutnya) akan MENGKONSUMSI (pop) nilai dari stack
; untuk mengecek apakah nilainya nol. Tapi kita masih butuh nilai msg.value
; untuk keperluan lain nanti (misalnya di-POP setelah JUMPDEST).
;
; Jadi flow-nya:
;   1. CALLVALUE → stack: [msg.value]
;   2. DUP1      → stack: [msg.value, msg.value]  ← duplikat untuk "dikorbankan"
;   3. ISZERO    → stack: [isZero, msg.value]     ← salinan dikonsumsi, asli tetap
;
; Ini adalah pola umum di EVM: duplikasi nilai sebelum operasi yang mengkonsumsi
; nilai tersebut, agar nilai asli masih tersedia untuk operasi selanjutnya.
;
; Keluarga DUP (DUP1 - DUP16):
; - DUP1 (0x80): Duplikat item ke-1 (top)
; - DUP2 (0x81): Duplikat item ke-2
; - DUP3 (0x82): Duplikat item ke-3
; - ... dan seterusnya sampai ...
; - DUP16 (0x8f): Duplikat item ke-16
;
; Gas cost: 3 gas (sangat murah, operasi stack sederhana)
;
; Referensi:
; - https://www.evm.codes/#80
; - https://ethereum.org/developers/docs/evm/opcodes/
; - https://ethervm.io/

00000007: ISZERO
; ISZERO (Is Zero Check) - Opcode 0x15
; Mengecek apakah nilai di paling atas stack sama dengan NOL (0).
; Jika ya, push angka 1 (true). Jika tidak, push angka 0 (false).
;
; Cara kerja ISZERO:
; 1. Pop 1 nilai dari stack (nilai yang akan dicek)
; 2. Bandingkan nilai tersebut dengan 0
; 3. Push hasil perbandingan ke stack:
;    - Jika nilai == 0 → push 1 (true, "ya ini nol")
;    - Jika nilai != 0 → push 0 (false, "bukan nol")
;
; Kondisi stack SEBELUM ISZERO dieksekusi:
;   Stack: [msg.value, msg.value] (hasil dari DUP1 sebelumnya)
;   - Top of stack: msg.value (salinan yang akan "dikorbankan")
;   - Posisi ke-2: msg.value (asli yang tetap tersimpan)
;
; Kondisi stack SETELAH ISZERO dieksekusi:
;   Stack: [isZero, msg.value]
;   - Top of stack: hasil pengecekan (1 jika msg.value=0, atau 0 jika msg.value≠0)
;   - Posisi ke-2: msg.value asli (masih tersimpan untuk keperluan lain)
;
; Analogi sederhana:
; Bayangkan kamu adalah penjaga pintu di sebuah acara GRATIS (free entry).
; Tugasmu sederhana: cek apakah tamu membawa uang untuk bayar masuk.
;
; ISZERO seperti bertanya: "Apakah uang yang dibawa = 0?"
;   - Jika tamu tidak bawa uang (value = 0): "Ya, uangnya nol!" → hasilnya 1 (true) → BOLEH MASUK
;   - Jika tamu bawa uang (value ≠ 0): "Tidak, dia bawa uang!" → hasilnya 0 (false) → DITOLAK
;
; Ini kebalikan dari logika biasa! Di dunia nyata, bawa uang = boleh masuk.
; Tapi di sini, justru TIDAK bawa uang = boleh masuk (karena fungsinya non-payable).
;
; Mengapa logikanya "terbalik"?
; ISZERO mengembalikan 1 (true) ketika nilai adalah 0.
; Ini karena pertanyaannya adalah "IS ZERO?" (apakah ini nol?), bukan "IS NOT ZERO?".
; Jadi jawaban 1 = "ya, benar, ini nol" dan 0 = "tidak, ini bukan nol".
;
; Konteks penggunaan dalam pola "non-payable guard":
;   00000006: CALLVALUE    ; Ambil msg.value → stack: [msg.value]
;   00000007: DUP1         ; Duplikat → stack: [msg.value, msg.value]
;   00000008: ISZERO       ; Cek apakah = 0 → stack: [isZero, msg.value]
;   00000009: PUSH1 0x0e   ; Push alamat jump → stack: [0x0e, isZero, msg.value]
;   0000000b: JUMPI        ; Jika isZero=1, lompat ke 0x0f (lanjut eksekusi)
;   0000000c: PUSH0        ; Kalau isZero=0, siapkan untuk REVERT
;   0000000d: PUSH0        ;
;   0000000e: REVERT       ; Batalkan transaksi! ETH dikembalikan
;   0000000f: JUMPDEST     ; Destinasi jump jika msg.value = 0 (OK, lanjut)
;
; Skenario 1 - Pengguna TIDAK mengirim ETH (msg.value = 0):
;   CALLVALUE → stack: [0]
;   DUP1      → stack: [0, 0]
;   ISZERO    → stack: [1, 0]     ← 1 karena 0 IS ZERO (benar, ini nol)
;   PUSH1 0x0e→ stack: [0x0e, 1, 0]
;   JUMPI     → 1 ≠ 0, jadi LOMPAT ke 0x0f ✓ (transaksi berlanjut)
;
; Skenario 2 - Pengguna mengirim 1 ETH (msg.value = 1000000000000000000 Wei):
;   CALLVALUE → stack: [1000000000000000000]
;   DUP1      → stack: [1000000000000000000, 1000000000000000000]
;   ISZERO    → stack: [0, 1000000000000000000]  ← 0 karena bukan nol
;   PUSH1 0x0e→ stack: [0x0e, 0, 1000000000000000000]
;   JUMPI     → 0 = 0, jadi TIDAK lompat, lanjut ke REVERT ✗ (transaksi dibatalkan)
;
; Equivalent di Solidity:
;   // Ini yang terjadi di balik layar untuk fungsi non-payable:
;   if (msg.value != 0) {
;       revert();  // Tolak transaksi yang mengirim ETH
;   }
;   // atau bisa ditulis:
;   require(msg.value == 0, "This function does not accept ETH");
;
; Penggunaan umum ISZERO lainnya:
; 1. Cek apakah hasil operasi = 0 (misalnya setelah SUB untuk cek equality)
; 2. Negasi boolean: ISZERO(0) = 1, ISZERO(1) = 0, ISZERO(apapun≠0) = 0
; 3. Cek apakah address = 0 (address kosong/tidak valid)
; 4. Cek return value dari CALL (0 = gagal, bukan 0 = sukses)
;
; Tips untuk reverse engineering:
; Ketika melihat pola CALLVALUE → DUP1 → ISZERO → PUSH → JUMPI → REVERT,
; ini hampir PASTI adalah pengecekan "non-payable function".
; Artinya fungsi tersebut menolak menerima ETH.
;
; Gas cost: 3 gas (sangat murah, operasi komparasi sederhana)
;
; Referensi:
; - https://www.evm.codes/#15
; - https://ethereum.org/developers/docs/evm/opcodes/
; - https://ethervm.io/

00000008: PUSH1 0x0e
; PUSH1 (Push 1-byte Immediate) - Opcode 0x60
; Mendorong nilai 1-byte ke stack. Di sini nilai yang di-push adalah 0x0e (14 dalam desimal).
;
; Cara kerja PUSH1:
; 1. Baca 1 byte setelah opcode PUSH1 (yaitu 0x0e)
; 2. Dorong nilai tersebut ke stack (diperluas menjadi 32-byte dengan padding nol di depan)
;
; Kondisi stack SEBELUM PUSH1 0x0e:
;   Stack: [isZero, msg.value] (hasil dari ISZERO sebelumnya)
;
; Kondisi stack SETELAH PUSH1 0x0e:
;   Stack: [0x0e, isZero, msg.value]
;   - 0x0e = alamat tujuan untuk JUMPI (offset 14 dalam bytecode)
;
; Konteks penggunaan:
; Nilai 0x0e adalah alamat JUMPDEST yang akan dituju jika kondisi JUMPI terpenuhi.
; Perhatikan bahwa 0x0e (14) adalah offset di mana REVERT berada, tapi sebenarnya
; JUMPI akan lompat ke 0x0f (15) karena ada offset adjustment.
;
; Catatan: Byte di offset 0x0a (0x0e) adalah immediate/argumen untuk PUSH1,
; sehingga PC (Program Counter) melompat dari 0x09 ke 0x0b.
;
; Gas cost: 3 gas

0000000a: JUMPI
; JUMPI (Conditional Jump) - Opcode 0x57
; Melakukan lompatan BERSYARAT ke alamat tertentu dalam bytecode.
; Jump hanya terjadi JIKA kondisi (nilai kedua di stack) BUKAN NOL.
;
; Cara kerja JUMPI:
; 1. Pop 2 nilai dari stack:
;    - Nilai pertama (top): destination (alamat tujuan lompatan)
;    - Nilai kedua: condition (kondisi, 0 = false, selainnya = true)
; 2. Jika condition ≠ 0 → lompat ke destination
;    Jika condition = 0 → lanjut ke instruksi berikutnya (tidak lompat)
;
; Kondisi stack SEBELUM JUMPI:
;   Stack: [0x0e, isZero, msg.value]
;   - 0x0e = destination (alamat tujuan: offset 14 → akan ke JUMPDEST di 0x0f)
;   - isZero = condition (1 jika msg.value=0, atau 0 jika msg.value≠0)
;
; Kondisi stack SETELAH JUMPI:
;   Stack: [msg.value]
;   - Kedua nilai (destination dan condition) sudah di-pop
;
; Analogi sederhana:
; JUMPI seperti "pintu otomatis dengan sensor".
;   - Jika sensor mendeteksi sesuatu (condition ≠ 0) → pintu TERBUKA (lompat)
;   - Jika sensor tidak mendeteksi apa-apa (condition = 0) → pintu TERTUTUP (lanjut lurus)
;
; Skenario dalam konteks non-payable guard:
;
; Skenario 1 - msg.value = 0 (tidak kirim ETH):
;   isZero = 1 (true, karena value memang nol)
;   JUMPI dengan condition=1 → LOMPAT ke 0x0f (JUMPDEST)
;   Hasil: Transaksi berlanjut normal ✓
;
; Skenario 2 - msg.value = 1 ETH:
;   isZero = 0 (false, karena value bukan nol)
;   JUMPI dengan condition=0 → TIDAK LOMPAT, lanjut ke PUSH0
;   Hasil: Akan menuju REVERT, transaksi dibatalkan ✗
;
; Perbedaan JUMP vs JUMPI:
; - JUMP (0x56): Lompat TANPA syarat (unconditional) - selalu lompat
; - JUMPI (0x57): Lompat DENGAN syarat (conditional) - lompat hanya jika condition ≠ 0
;
; PENTING: Destination HARUS berupa JUMPDEST yang valid!
; Jika mencoba lompat ke alamat yang bukan JUMPDEST, EVM akan REVERT.
;
; Gas cost: 10 gas (lebih mahal karena ada branching logic)
;
; Referensi:
; - https://www.evm.codes/#57

0000000b: PUSH0
; PUSH0 (Push Zero) - Opcode 0x5f
; Mendorong nilai 0 ke stack. Ini adalah opcode baru yang diperkenalkan di EIP-3855
; (Shanghai upgrade) untuk menghemat gas dibanding PUSH1 0x00.
;
; Cara kerja PUSH0:
; 1. Tidak membaca byte tambahan apapun
; 2. Langsung push nilai 0 (32-byte, semua nol) ke stack
;
; Kondisi stack SEBELUM PUSH0 (pertama):
;   Stack: [msg.value] (setelah JUMPI tidak lompat karena condition=0)
;
; Kondisi stack SETELAH PUSH0 (pertama):
;   Stack: [0, msg.value]
;
; Mengapa ada di sini?
; Dua PUSH0 berturut-turut menyiapkan argumen untuk REVERT:
;   - PUSH0 pertama: offset memori untuk revert data (0 = tidak ada data)
;   - PUSH0 kedua: size/ukuran revert data (0 = tidak ada data)
;
; Keuntungan PUSH0 vs PUSH1 0x00:
; - PUSH0: 1 byte (hanya opcode), gas cost 2
; - PUSH1 0x00: 2 bytes (opcode + immediate), gas cost 3
; Menghemat 1 byte bytecode DAN 1 gas per penggunaan!
;
; Sejarah:
; Sebelum EIP-3855, untuk push angka 0 harus pakai PUSH1 0x00.
; Ini "pemborosan" karena 0 adalah nilai yang SANGAT sering digunakan.
; EIP-3855 menambahkan PUSH0 untuk optimasi ini.
;
; Gas cost: 2 gas (lebih murah dari PUSH1!)
;
; Referensi:
; - https://www.evm.codes/#5f
; - https://eips.ethereum.org/EIPS/eip-3855

0000000c: PUSH0
; PUSH0 (Push Zero) - Opcode 0x5f
; Push nilai 0 kedua untuk argumen REVERT.
;
; Kondisi stack SEBELUM PUSH0 (kedua):
;   Stack: [0, msg.value]
;
; Kondisi stack SETELAH PUSH0 (kedua):
;   Stack: [0, 0, msg.value]
;   - Top: size = 0 (ukuran revert data)
;   - Kedua: offset = 0 (offset memori revert data)
;
; REVERT membutuhkan 2 argumen: (offset, size)
; Dengan keduanya 0, artinya REVERT tanpa pesan error (empty revert).

0000000d: REVERT
; REVERT (Revert Execution) - Opcode 0xfd
; Membatalkan eksekusi transaksi, mengembalikan semua perubahan state,
; dan mengembalikan sisa gas ke pengirim (minus gas yang sudah terpakai).
;
; Cara kerja REVERT:
; 1. Pop 2 nilai dari stack:
;    - offset: posisi awal di memori untuk data yang akan dikembalikan
;    - size: ukuran data yang akan dikembalikan (dalam bytes)
; 2. Batalkan SEMUA perubahan state yang terjadi dalam transaksi ini
; 3. Kembalikan data dari memory[offset:offset+size] sebagai revert reason
; 4. Kembalikan sisa gas ke pengirim (gas refund)
;
; Kondisi stack SEBELUM REVERT:
;   Stack: [0, 0, msg.value]
;   - size = 0 (tidak ada revert message)
;   - offset = 0 (tidak relevan karena size = 0)
;
; Kondisi stack SETELAH REVERT:
;   Eksekusi BERHENTI - stack tidak relevan lagi
;
; Analogi sederhana:
; REVERT seperti tombol "UNDO" atau "BATALKAN" di aplikasi.
; Semua yang sudah kamu ketik/ubah akan dikembalikan ke kondisi semula.
; Bedanya, di blockchain ini memastikan:
; - ETH yang dikirim dikembalikan ke pengirim
; - Perubahan storage dibatalkan
; - Sisa gas dikembalikan (tidak hangus semua seperti INVALID)
;
; Perbedaan REVERT vs INVALID vs STOP:
; - REVERT (0xfd): Batalkan + kembalikan sisa gas + bisa kirim error message
; - INVALID (0xfe): Batalkan + HABISKAN semua gas (punishment)
; - STOP (0x00): Sukses berhenti normal, perubahan state DISIMPAN
;
; Dalam konteks non-payable guard:
; Jika pengguna mengirim ETH ke fungsi non-payable:
; 1. ETH akan dikembalikan ke pengirim
; 2. Transaksi ditandai sebagai "failed/reverted"
; 3. Sisa gas dikembalikan (hanya bayar gas yang sudah terpakai)
;
; Contoh REVERT dengan error message di Solidity:
;   revert("Payment not allowed");  // Ada message
;   revert();                       // Tanpa message (seperti di sini)
;
; Gas cost: 0 gas untuk opcode + biaya memory expansion jika ada data
;
; Referensi:
; - https://www.evm.codes/#fd
; - https://eips.ethereum.org/EIPS/eip-140

0000000e: JUMPDEST
; JUMPDEST (Jump Destination) - Opcode 0x5b
; Menandai lokasi yang VALID sebagai tujuan lompatan (JUMP/JUMPI).
; Opcode ini sendiri tidak melakukan apa-apa, hanya sebagai "marker".
;
; Cara kerja JUMPDEST:
; 1. Tidak pop atau push apapun dari/ke stack
; 2. Tidak mengubah state apapun
; 3. Hanya menandai bahwa "alamat ini boleh dijadikan tujuan jump"
;
; Kondisi stack SEBELUM dan SETELAH JUMPDEST:
;   Stack: [msg.value] (tidak berubah)
;
; Analogi sederhana:
; JUMPDEST seperti "rambu penunjuk jalan" atau "halte bus".
; Kamu tidak bisa turun dari bus di sembarang tempat - harus di halte.
; Sama seperti EVM tidak bisa jump ke sembarang alamat - harus ke JUMPDEST.
;
; Mengapa JUMPDEST diperlukan?
; KEAMANAN! Tanpa JUMPDEST, attacker bisa mencoba jump ke tengah-tengah
; instruksi lain dan menyebabkan eksekusi yang tidak diinginkan.
;
; Contoh serangan yang dicegah:
;   PUSH2 0x6060   ; Bytecode: 61 60 60
;   ; Tanpa validasi JUMPDEST, attacker bisa jump ke offset+1
;   ; yang akan dibaca sebagai PUSH1 0x60 (instruksi berbeda!)
;
; Dengan JUMPDEST, EVM memvalidasi:
; 1. Saat deployment: scan semua JUMPDEST dan buat "valid jump table"
; 2. Saat runtime: setiap JUMP/JUMPI dicek apakah tujuannya ada di table
; 3. Jika tidak valid → REVERT
;
; Dalam konteks ini:
; JUMPDEST di 0x0f adalah "safe landing spot" setelah JUMPI berhasil.
; Artinya pengecekan non-payable sudah selesai dan eksekusi berlanjut normal.
;
; Gas cost: 1 gas (sangat murah, hanya marker)
;
; Referensi:
; - https://www.evm.codes/#5b

0000000f: POP
; POP (Remove Top Stack Item) - Opcode 0x50
; Menghapus/membuang nilai di paling atas stack. Nilai tersebut dibuang begitu saja,
; tidak disimpan di mana-mana.
;
; Cara kerja POP:
; 1. Ambil nilai di top of stack
; 2. Buang nilai tersebut (tidak digunakan)
; 3. Stack berkurang 1 item
;
; Kondisi stack SEBELUM POP:
;   Stack: [msg.value]
;   - msg.value adalah "sisa" dari operasi DUP1 sebelumnya yang tidak terpakai
;
; Kondisi stack SETELAH POP:
;   Stack: [] (kosong)
;   - msg.value sudah dibuang karena tidak diperlukan lagi
;
; Analogi sederhana:
; POP seperti membuang kertas paling atas dari tumpukan ke tempat sampah.
; Kamu tidak membacanya, tidak menyimpannya - langsung buang.
;
; Mengapa perlu POP di sini?
; Ingat alur sebelumnya:
;   CALLVALUE → stack: [msg.value]
;   DUP1      → stack: [msg.value, msg.value]
;   ISZERO    → stack: [isZero, msg.value]  ← satu msg.value masih ada!
;   PUSH1     → stack: [0x0e, isZero, msg.value]
;   JUMPI     → stack: [msg.value]  ← setelah jump, msg.value masih nongkrong
;
; Nilai msg.value ini sudah tidak diperlukan setelah pengecekan selesai.
; POP membersihkannya agar stack bersih untuk operasi selanjutnya.
;
; "Stack hygiene" penting karena:
; 1. Stack EVM terbatas (max 1024 items)
; 2. Nilai yang tidak dibersihkan bisa mengganggu operasi selanjutnya
; 3. Compiler Solidity otomatis menambahkan POP untuk cleanup
;
; Gas cost: 2 gas
;
; Referensi:
; - https://www.evm.codes/#50

00000010: PUSH2 0x0868
; PUSH2 (Push 2-byte Immediate) - Opcode 0x61
; Mendorong nilai 2-byte (16-bit) ke stack. Di sini nilai 0x0868 (2152 dalam desimal).
;
; Cara kerja PUSH2:
; 1. Baca 2 byte setelah opcode PUSH2 (yaitu 0x08 dan 0x68 → 0x0868)
; 2. Dorong nilai tersebut ke stack (diperluas menjadi 32-byte dengan padding nol)
;
; Kondisi stack SEBELUM PUSH2 0x0868:
;   Stack: [] (kosong setelah POP)
;
; Kondisi stack SETELAH PUSH2 0x0868:
;   Stack: [0x0868]
;   - 0x0868 = 2152 bytes = ukuran RUNTIME CODE yang akan di-deploy
;
; Konteks - DEPLOYMENT vs RUNTIME CODE:
; Smart contract bytecode terdiri dari 2 bagian:
; 1. DEPLOYMENT CODE (Creation Code): Kode yang dieksekusi SAAT DEPLOY
;    - Tugas: setup awal + copy runtime code ke blockchain
;    - TIDAK disimpan di blockchain setelah deploy selesai
;
; 2. RUNTIME CODE: Kode yang disimpan di blockchain
;    - Tugas: handle semua function calls setelah contract di-deploy
;    - INI yang disimpan permanen dan dieksekusi saat interact dengan contract
;
; Nilai 0x0868 adalah SIZE dari runtime code yang akan di-copy.
;
; Keluarga PUSH (PUSH1 - PUSH32):
; - PUSH1 (0x60): Push 1 byte
; - PUSH2 (0x61): Push 2 bytes
; - PUSH3 (0x62): Push 3 bytes
; - ... sampai ...
; - PUSH32 (0x7f): Push 32 bytes (maksimum, satu word penuh)
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#61

00000013: DUP1
; DUP1 (Duplicate 1st Stack Item) - Opcode 0x80
; Menduplikasi nilai di paling atas stack.
;
; Kondisi stack SEBELUM DUP1:
;   Stack: [0x0868]
;
; Kondisi stack SETELAH DUP1:
;   Stack: [0x0868, 0x0868]
;   - Satu untuk CODECOPY (size)
;   - Satu untuk RETURN (size)
;
; Mengapa perlu duplikat?
; Karena ukuran runtime code (0x0868) dibutuhkan di DUA tempat:
; 1. CODECOPY: untuk tahu berapa banyak byte yang harus di-copy
; 2. RETURN: untuk tahu berapa banyak byte yang harus dikembalikan
;
; Gas cost: 3 gas

00000014: PUSH2 0x001c
; PUSH2 (Push 2-byte Immediate) - Opcode 0x61
; Mendorong nilai 0x001c (28 dalam desimal) ke stack.
;
; Kondisi stack SEBELUM PUSH2 0x001c:
;   Stack: [0x0868, 0x0868]
;
; Kondisi stack SETELAH PUSH2 0x001c:
;   Stack: [0x001c, 0x0868, 0x0868]
;   - 0x001c = offset di mana RUNTIME CODE dimulai dalam bytecode
;
; Nilai 0x001c (28) menunjukkan:
; - Deployment code: byte 0x00 sampai 0x1b (28 bytes)
; - Runtime code: mulai dari byte 0x1c (28) sampai akhir
;
; Ini adalah SOURCE OFFSET untuk CODECOPY - dari mana mulai copy.
;
; Gas cost: 3 gas

00000017: PUSH0
; PUSH0 (Push Zero) - Opcode 0x5f
; Mendorong nilai 0 ke stack.
;
; Kondisi stack SEBELUM PUSH0:
;   Stack: [0x001c, 0x0868, 0x0868]
;
; Kondisi stack SETELAH PUSH0:
;   Stack: [0, 0x001c, 0x0868, 0x0868]
;   - 0 = DESTINATION offset di memory (mulai copy ke memory[0])
;
; CODECOPY akan copy bytecode ke memory mulai dari offset 0.
;
; Gas cost: 2 gas

00000018: CODECOPY
; CODECOPY (Copy Code to Memory) - Opcode 0x39
; Menyalin bagian dari bytecode contract ke memory.
; Ini adalah instruksi KUNCI untuk deployment!
;
; Cara kerja CODECOPY:
; 1. Pop 3 nilai dari stack:
;    - destOffset: alamat tujuan di memory (di mana mulai menulis)
;    - offset: posisi awal di bytecode (dari mana mulai membaca)
;    - size: berapa banyak byte yang akan di-copy
; 2. Copy bytecode[offset:offset+size] ke memory[destOffset:destOffset+size]
;
; Kondisi stack SEBELUM CODECOPY:
;   Stack: [0, 0x001c, 0x0868, 0x0868]
;   - destOffset = 0 (tulis ke memory mulai dari offset 0)
;   - offset = 0x001c (28) (baca dari bytecode mulai offset 28)
;   - size = 0x0868 (2152) (copy sebanyak 2152 bytes)
;
; Kondisi stack SETELAH CODECOPY:
;   Stack: [0x0868]
;   - 3 nilai sudah di-pop
;   - Sisa 0x0868 untuk RETURN nanti
;
; Kondisi memory SETELAH CODECOPY:
;   memory[0:0x0868] = bytecode[0x001c:0x0884]
;   - Runtime code sekarang ada di memory!
;
; Analogi sederhana:
; CODECOPY seperti "mesin fotokopi" yang meng-copy bagian dari buku (bytecode)
; ke kertas baru (memory).
; - Kamu bilang: "Copy halaman 28 sampai halaman 2180, taruh di kertas kosong"
; - Hasilnya: Kertas (memory) sekarang berisi salinan halaman tersebut
;
; Visualisasi:
;   BYTECODE:        [DEPLOYMENT CODE (28 bytes)][RUNTIME CODE (2152 bytes)]
;                    ^0                         ^0x1c                      ^0x884
;                                               └──── COPY INI ────────────┘
;                                                         │
;                                                         ▼
;   MEMORY:          [RUNTIME CODE (2152 bytes)][...................]
;                    ^0                        ^0x868
;
; Gas cost: 3 gas + 3 gas per word (32 bytes) yang di-copy + memory expansion
;
; Referensi:
; - https://www.evm.codes/#39

00000019: PUSH0
; PUSH0 (Push Zero) - Opcode 0x5f
; Mendorong nilai 0 ke stack untuk argumen RETURN.
;
; Kondisi stack SEBELUM PUSH0:
;   Stack: [0x0868]
;
; Kondisi stack SETELAH PUSH0:
;   Stack: [0, 0x0868]
;   - 0 = offset di memory (dari mana mulai return)
;   - 0x0868 = size (berapa banyak byte yang di-return)
;
; Gas cost: 2 gas

0000001a: RETURN
; RETURN (Return from Execution) - Opcode 0xf3
; Menghentikan eksekusi dengan SUKSES dan mengembalikan data dari memory.
; Dalam konteks DEPLOYMENT, data yang di-return adalah RUNTIME CODE yang
; akan disimpan di blockchain sebagai code contract!
;
; Cara kerja RETURN:
; 1. Pop 2 nilai dari stack:
;    - offset: posisi awal di memory
;    - size: ukuran data yang akan dikembalikan
; 2. Ambil data dari memory[offset:offset+size]
; 3. Hentikan eksekusi (sukses)
; 4. Kembalikan data tersebut
;
; Kondisi stack SEBELUM RETURN:
;   Stack: [0, 0x0868]
;   - offset = 0 (ambil dari memory mulai offset 0)
;   - size = 0x0868 (ambil 2152 bytes)
;
; Kondisi stack SETELAH RETURN:
;   Eksekusi SELESAI - deployment sukses!
;
; APA YANG TERJADI SAAT DEPLOYMENT?
; 1. EVM menjalankan deployment code (yang kita analisis dari awal)
; 2. RETURN mengembalikan runtime code dari memory
; 3. EVM menyimpan runtime code tersebut di blockchain
; 4. Contract address dibuat berdasarkan sender address + nonce
; 5. Sekarang contract sudah "hidup" dan bisa dipanggil!
;
; Analogi sederhana:
; Deployment seperti "melahirkan" contract:
; - Deployment code = proses kehamilan/persiapan
; - RETURN = proses kelahiran
; - Runtime code = bayi yang lahir dan hidup mandiri
;
; Setelah RETURN di deployment:
; - Deployment code sudah selesai tugasnya dan "dibuang"
; - Hanya runtime code yang disimpan di blockchain
; - Semua interaksi selanjutnya akan menjalankan runtime code
;
; RETURN di runtime vs deployment:
; - Di DEPLOYMENT: Return value = code yang disimpan di blockchain
; - Di RUNTIME: Return value = data yang dikembalikan ke pemanggil
;
; Gas cost: 0 gas untuk opcode + memory expansion cost
;
; Referensi:
; - https://www.evm.codes/#f3

0000001b: INVALID
; INVALID (Invalid Instruction) - Opcode 0xfe
; Instruksi yang SENGAJA tidak valid. Jika dieksekusi, akan menyebabkan
; transaksi gagal dan SEMUA gas habis (out of gas).
;
; Cara kerja INVALID:
; 1. Jika PC (Program Counter) mencapai opcode ini → GAGAL
; 2. Semua gas yang tersisa akan HANGUS (tidak dikembalikan)
; 3. Semua perubahan state dibatalkan
;
; MENGAPA ADA INVALID DI SINI?
; Ini adalah "separator" atau "barrier" antara deployment code dan runtime code!
;
; Struktur bytecode:
;   [DEPLOYMENT CODE][INVALID][RUNTIME CODE]
;   ^0              ^0x1c    ^0x1d
;
; INVALID berfungsi sebagai:
; 1. MARKER: Menandai akhir deployment code
; 2. SAFETY: Jika ada bug dan eksekusi "melewati" RETURN, akan langsung gagal
; 3. SEPARATOR: Memisahkan dua "program" yang berbeda dalam satu bytecode
;
; Dalam eksekusi NORMAL, INVALID tidak pernah dieksekusi karena:
; - RETURN sudah menghentikan eksekusi sebelum sampai sini
;
; INVALID hanya tereksekusi jika:
; - Ada bug di deployment code yang menyebabkan "fall through"
; - Attacker mencoba exploit dengan jump ke sini
;
; Perbedaan INVALID vs REVERT:
; - INVALID (0xfe): Gas HABIS semua (punishment), no return data
; - REVERT (0xfd): Sisa gas dikembalikan, bisa ada return data
;
; Fun fact:
; Sebelum EIP-141, opcode 0xfe belum resmi ada. Compiler menggunakan
; PUSH1 0x00 PUSH1 0x00 REVERT atau infinite loop. EIP-141 menambahkan
; INVALID sebagai opcode designated untuk "sengaja gagal".
;
; Gas cost: ALL REMAINING GAS (habis semua!)
;
; Referensi:
; - https://www.evm.codes/#fe
; - https://eips.ethereum.org/EIPS/eip-141

; ============================================================================
; RUNTIME CODE DIMULAI DI SINI
; ============================================================================
; Mulai dari sini adalah RUNTIME CODE yang akan disimpan di blockchain.
; Ini adalah kode yang dieksekusi setiap kali ada yang memanggil contract.
;
; Runtime code memiliki struktur:
; 1. Memory initialization (Free Memory Pointer setup)
; 2. Non-payable check (sama seperti di deployment)
; 3. Function dispatcher (memilih fungsi berdasarkan selector)
; 4. Function implementations (kode untuk setiap fungsi)
; 5. Helper/utility functions
; ============================================================================


╔════════════════════════════════════════════════════════════════╗
║                      RUNTIME CODE                              ║
║                  (Deployed Contract Code)                      ║
╚════════════════════════════════════════════════════════════════╝

00000000: PUSH1 0x80
; ============================================================================
; RUNTIME CODE - Memory Initialization
; ============================================================================
; Sama seperti di deployment code, runtime code juga dimulai dengan
; inisialisasi Free Memory Pointer. Ini adalah "ritual pembuka" standar.
;
; Gas cost: 3 gas

00000002: PUSH1 0x40
; Push alamat slot Free Memory Pointer (0x40).
; memory[0x40] akan menyimpan pointer ke memori bebas berikutnya.
;
; Gas cost: 3 gas

00000004: MSTORE
; Simpan 0x80 ke memory[0x40].
; Sekarang Free Memory Pointer sudah terinisialisasi.
;
; Gas cost: 3 gas + memory expansion

00000005: CALLVALUE
; ============================================================================
; RUNTIME CODE - Non-payable Guard Check
; ============================================================================
; Sama seperti di deployment code, runtime juga mengecek apakah ada ETH
; yang dikirim. Ini adalah pengecekan standar untuk fungsi non-payable.
;
; Push msg.value ke stack.
; Gas cost: 2 gas

00000006: DUP1
; Duplikat msg.value untuk pengecekan ISZERO.
; Gas cost: 3 gas

00000007: ISZERO
; Cek apakah msg.value == 0.
; Gas cost: 3 gas

00000008: PUSH2 0x000f
; Push alamat tujuan jump (0x0f dalam konteks runtime = 0x2c dalam bytecode penuh).
; Catatan: Alamat di runtime code relatif terhadap awal runtime code.
;
; Gas cost: 3 gas

0000000b: JUMPI
; Jika msg.value == 0 (ISZERO = 1), lompat ke JUMPDEST dan lanjutkan.
; Jika msg.value != 0 (ISZERO = 0), jatuh ke REVERT.
;
; Gas cost: 10 gas

0000000c: PUSH0
; Siapkan offset = 0 untuk REVERT.
; Gas cost: 2 gas

0000000d: PUSH0
; Siapkan size = 0 untuk REVERT.
; Gas cost: 2 gas

0000000e: REVERT
; Batalkan transaksi jika ada ETH yang dikirim.
; Ini memastikan contract tidak menerima ETH karena tidak ada fungsi payable.
;
; Gas cost: 0 gas (tapi transaksi tetap gagal)

0000000f: JUMPDEST
; Landing point setelah non-payable check berhasil.
; Dari sini, eksekusi berlanjut ke function dispatcher.
;
; Gas cost: 1 gas

00000010: POP
; Buang sisa msg.value dari stack (cleanup).
; Gas cost: 2 gas

00000011: PUSH1 0x04
; ============================================================================
; FUNCTION DISPATCHER - Bagian 1: Calldata Size Check
; ============================================================================
; Push nilai 4 ke stack. Ini adalah ukuran minimum calldata yang valid.
;
; Mengapa 4 bytes?
; Function selector di Solidity adalah 4 bytes pertama dari keccak256(signature).
; Contoh: add(uint256,uint256) → selector = 0x771602f7 (4 bytes)
;
; Jika calldata < 4 bytes, tidak mungkin ada function call yang valid.
;
; Gas cost: 3 gas

00000013: CALLDATASIZE
; CALLDATASIZE - Opcode 0x36
; Mendorong ukuran calldata (dalam bytes) ke stack.
;
; Calldata adalah data yang dikirim bersama transaksi/call.
; Untuk function call, strukturnya:
;   [4 bytes selector][argument 1][argument 2][...]
;
; Kondisi stack SETELAH CALLDATASIZE:
;   Stack: [calldatasize, 4]
;
; Gas cost: 2 gas
;
; Referensi:
; - https://www.evm.codes/#36

00000014: LT
; LT (Less Than) - Opcode 0x10
; Membandingkan dua nilai: apakah nilai kedua < nilai pertama?
;
; Cara kerja LT:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Push 1 jika b < a, push 0 jika b >= a
;
; Kondisi stack SEBELUM LT:
;   Stack: [calldatasize, 4]
;   - a = calldatasize
;   - b = 4
;
; Kondisi stack SETELAH LT:
;   Stack: [result]
;   - result = 1 jika 4 < calldatasize (calldata cukup besar)
;   - result = 0 jika 4 >= calldatasize (calldata terlalu kecil)
;
; TUNGGU! Ini terlihat terbalik...
; Sebenarnya kita ingin cek: calldatasize < 4?
; Tapi urutan stack: [calldatasize, 4], LT mengecek: 4 < calldatasize
;
; Jadi:
; - Jika calldatasize > 4: LT returns 1 (ada selector + mungkin args)
; - Jika calldatasize <= 4: LT returns 0 (calldata tidak cukup)
;
; Hmm, ini mengecek calldatasize > 4, bukan calldatasize < 4.
; Sebenarnya: LT(a,b) = 1 jika b < a, di sini: LT(calldatasize, 4) = 1 jika 4 < calldatasize
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#10

00000015: PUSH2 0x0091
; Push alamat fallback/default handler (0x91 dalam runtime = 0xae dalam bytecode).
; Ini adalah alamat yang akan dituju jika calldata terlalu pendek.
;
; Gas cost: 3 gas

00000018: JUMPI
; Jika calldatasize < 4, lompat ke fallback (REVERT di 0x91).
; Jika calldatasize >= 4, lanjut ke function selector extraction.
;
; Gas cost: 10 gas

00000019: PUSH0
; ============================================================================
; FUNCTION DISPATCHER - Bagian 2: Extract Function Selector
; ============================================================================
; Push 0 sebagai offset untuk CALLDATALOAD.
; Kita akan membaca 32 bytes mulai dari offset 0 calldata.
;
; Gas cost: 2 gas

0000001a: CALLDATALOAD
; CALLDATALOAD - Opcode 0x35
; Membaca 32 bytes dari calldata pada offset tertentu.
;
; Cara kerja CALLDATALOAD:
; 1. Pop 1 nilai dari stack: offset
; 2. Baca 32 bytes dari calldata[offset:offset+32]
; 3. Push hasil sebagai uint256 (big-endian)
;
; Kondisi stack SEBELUM CALLDATALOAD:
;   Stack: [0]
;
; Kondisi stack SETELAH CALLDATALOAD:
;   Stack: [calldata[0:32]]
;   - Berisi function selector (4 bytes pertama) + 28 bytes argumen/padding
;
; Contoh:
; Calldata: 0x771602f7000000000000000000000000000000000000000000000000000000000000000a...
; Hasil: 0x771602f7000000000000000000000000000000000000000000000000000000000000000a
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#35

0000001b: PUSH1 0xe0
; Push nilai 0xe0 (224 dalam desimal) ke stack.
; 224 = 256 - 32 = jumlah bit yang harus di-shift untuk mendapat 4 bytes pertama.
;
; Mengapa 224?
; - 1 word = 256 bits = 32 bytes
; - Function selector = 4 bytes = 32 bits
; - Untuk mengekstrak 4 bytes PERTAMA dari 32 bytes, shift right 224 bits
;   (membuang 28 bytes terakhir)
;
; Gas cost: 3 gas

0000001d: SHR
; SHR (Shift Right) - Opcode 0x1c
; Melakukan logical shift right pada nilai.
;
; Cara kerja SHR:
; 1. Pop 2 nilai dari stack: shift (top), value (second)
; 2. Shift value ke kanan sebanyak shift bits
; 3. Push hasil ke stack
;
; Kondisi stack SEBELUM SHR:
;   Stack: [0xe0, calldata[0:32]]
;   - shift = 0xe0 = 224 bits
;   - value = calldata 32 bytes pertama
;
; Kondisi stack SETELAH SHR:
;   Stack: [selector]
;   - selector = 4 bytes pertama calldata (function selector)
;
; Contoh:
; Sebelum: 0x771602f7000000000000000000000000000000000000000000000000000000000000000a
; Setelah: 0x00000000000000000000000000000000000000000000000000000000771602f7
;          (yaitu 0x771602f7 sebagai uint256)
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#1c

0000001e: DUP1
; ============================================================================
; FUNCTION DISPATCHER - Bagian 3: Function Selector Matching
; ============================================================================
; Duplikat selector untuk perbandingan pertama.
; Selector akan dibandingkan dengan berbagai function signature.
;
; Solidity compiler menggunakan binary search atau linear search
; untuk menemukan function yang cocok dengan selector.
;
; Gas cost: 3 gas
0000001f: PUSH4 0xa4ad2ee9
; PUSH4 (Push 4-byte Immediate) - Opcode 0x63
; Mendorong nilai 4-byte ke stack. Di sini adalah function selector 0xa4ad2ee9.
;
; Selector 0xa4ad2ee9 adalah keccak256("mulmod(uint256,uint256,uint256)")[:4]
;
; Binary Search di Function Dispatcher:
; Solidity compiler sering menggunakan binary search untuk efisiensi.
; Selector ini digunakan sebagai "pivot" untuk membagi function selector
; menjadi dua grup: yang lebih besar dan yang lebih kecil dari pivot.
;
; Function selectors dalam contract ini (diurutkan):
; - 0x25a35559: addmod(uint256,uint256,uint256)
; - 0x2e4c697f: exp(uint256,uint256)
; - 0x771602f7: add(uint256,uint256)
; - 0xa391c15b: div(uint256,uint256)
; - 0xa4ad2ee9: mulmod(uint256,uint256,uint256) ← PIVOT
; - 0xb12fe826: mul(uint256,uint256)
; - 0xb67d77c5: sub(uint256,uint256)
; - 0xc8a4ac9c: mod(uint256,uint256)
; - 0xf43f523a: signedDiv(uint256,uint256)
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#63

00000024: GT
; GT (Greater Than) - Opcode 0x11
; Membandingkan dua nilai: apakah nilai kedua > nilai pertama?
;
; Cara kerja GT:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Push 1 jika b > a, push 0 jika b <= a
;
; Kondisi stack SEBELUM GT:
;   Stack: [0xa4ad2ee9, selector]
;
; Kondisi stack SETELAH GT:
;   Stack: [result]
;   - result = 1 jika selector > 0xa4ad2ee9 (function di grup "atas")
;   - result = 0 jika selector <= 0xa4ad2ee9 (function di grup "bawah")
;
; Binary search: jika selector > pivot, cari di grup atas (0x64),
; jika tidak, lanjut cari di grup bawah.
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#11

00000025: PUSH2 0x0064
; Push alamat untuk handling function selector di grup "atas".
; Jika selector > 0xa4ad2ee9, lompat ke 0x64 untuk cek selector
; yang lebih besar (b12fe826, b67d77c5, c8a4ac9c, f43f523a).
;
; Gas cost: 3 gas

00000028: JUMPI
; Conditional jump berdasarkan hasil GT.
; Ini adalah bagian dari binary search di function dispatcher.
;
; Gas cost: 10 gas

00000029: DUP1
; Duplikat selector untuk perbandingan berikutnya.
; Gas cost: 3 gas

0000002a: PUSH4 0xa4ad2ee9
; Push selector mulmod untuk perbandingan EQ.
; Gas cost: 3 gas

0000002f: EQ
; EQ (Equal) - Opcode 0x14
; Membandingkan dua nilai: apakah keduanya sama?
;
; Cara kerja EQ:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Push 1 jika a == b, push 0 jika a != b
;
; Kondisi stack SEBELUM EQ:
;   Stack: [0xa4ad2ee9, selector]
;
; Kondisi stack SETELAH EQ:
;   Stack: [result]
;   - result = 1 jika selector == 0xa4ad2ee9 (ini adalah mulmod!)
;   - result = 0 jika selector != 0xa4ad2ee9
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#14

00000030: PUSH2 0x0155
; Push alamat implementasi fungsi mulmod (0x155 dalam runtime).
; Jika selector cocok, akan lompat ke sini untuk eksekusi fungsi.
;
; Gas cost: 3 gas

00000033: JUMPI
; Jika selector == 0xa4ad2ee9, lompat ke implementasi mulmod di 0x155.
; Jika tidak cocok, lanjut ke pengecekan selector berikutnya.
;
; Gas cost: 10 gas
00000034: DUP1
; Duplikat selector untuk pengecekan mul.
00000035: PUSH4 0xb12fe826
; Selector untuk mul(uint256,uint256) - perkalian
0000003a: EQ
; Cek apakah selector == mul
0000003b: PUSH2 0x0185
; Alamat implementasi mul
0000003e: JUMPI
; Jump ke mul jika cocok

0000003f: DUP1
; Duplikat selector untuk pengecekan sub.
00000040: PUSH4 0xb67d77c5
; Selector untuk sub(uint256,uint256) - pengurangan
00000045: EQ
; Cek apakah selector == sub
00000046: PUSH2 0x01b5
; Alamat implementasi sub
00000049: JUMPI
; Jump ke sub jika cocok

0000004a: DUP1
; Duplikat selector untuk pengecekan mod.
0000004b: PUSH4 0xc8a4ac9c
; Selector untuk mod(uint256,uint256) - modulo
00000050: EQ
; Cek apakah selector == mod
00000051: PUSH2 0x01e5
; Alamat implementasi mod
00000054: JUMPI
; Jump ke mod jika cocok

00000055: DUP1
; Duplikat selector untuk pengecekan signedDiv.
00000056: PUSH4 0xf43f523a
; Selector untuk signedDiv(uint256,uint256) - pembagian signed (SDIV)
0000005b: EQ
; Cek apakah selector == signedDiv
0000005c: PUSH2 0x0215
; Alamat implementasi signedDiv
0000005f: JUMPI
; Jump ke signedDiv jika cocok

00000060: PUSH2 0x0091
; Tidak ada function yang cocok di grup "atas", jump ke fallback.
00000063: JUMP
; JUMP (Unconditional Jump) - Opcode 0x56
; Lompat tanpa syarat ke alamat fallback (0x91).
; Berbeda dengan JUMPI, JUMP selalu lompat tanpa mengecek kondisi.
;
; Gas cost: 8 gas
;
; Referensi:
; - https://www.evm.codes/#56

00000064: JUMPDEST
; ============================================================================
; FUNCTION DISPATCHER - Grup Selector "Bawah" (< 0xa4ad2ee9)
; ============================================================================
; Ini adalah entry point untuk function selector yang lebih kecil dari pivot.
; Function di grup ini: addmod, exp, add, div

00000065: DUP1
; Duplikat selector untuk pengecekan addmod.
00000066: PUSH4 0x25a35559
; Selector untuk addmod(uint256,uint256,uint256) - penjumlahan modular
0000006b: EQ
; Cek apakah selector == addmod
0000006c: PUSH2 0x0095
; Alamat implementasi addmod
0000006f: JUMPI
; Jump ke addmod jika cocok

00000070: DUP1
; Duplikat selector untuk pengecekan exp.
00000071: PUSH4 0x2e4c697f
; Selector untuk exp(uint256,uint256) - eksponensial (pangkat)
00000076: EQ
; Cek apakah selector == exp
00000077: PUSH2 0x00c5
; Alamat implementasi exp
0000007a: JUMPI
; Jump ke exp jika cocok

0000007b: DUP1
; Duplikat selector untuk pengecekan add.
0000007c: PUSH4 0x771602f7
; Selector untuk add(uint256,uint256) - penjumlahan
; Ini adalah 4 bytes pertama dari keccak256("add(uint256,uint256)")
;
; Cara menghitung selector:
; keccak256("add(uint256,uint256)") = 0x771602f7...
; Ambil 4 bytes pertama: 0x771602f7
00000081: EQ
; Cek apakah selector == add
00000082: PUSH2 0x00f5
; Alamat implementasi add
00000085: JUMPI
; Jump ke add jika cocok

00000086: DUP1
; Duplikat selector untuk pengecekan div.
00000087: PUSH4 0xa391c15b
; Selector untuk div(uint256,uint256) - pembagian
0000008c: EQ
; Cek apakah selector == div
0000008d: PUSH2 0x0125
; Alamat implementasi div
00000090: JUMPI
; Jump ke div jika cocok

00000091: JUMPDEST
; ============================================================================
; FALLBACK - Default Handler (No Matching Function)
; ============================================================================
; Jika tidak ada function selector yang cocok, eksekusi sampai di sini.
; Contract akan REVERT tanpa pesan error.
;
; Ini terjadi ketika:
; 1. Calldata terlalu pendek (< 4 bytes)
; 2. Function selector tidak cocok dengan fungsi manapun
; 3. Seseorang mencoba memanggil fungsi yang tidak ada

00000092: PUSH0
; Siapkan offset = 0 untuk REVERT.
00000093: PUSH0
; Siapkan size = 0 untuk REVERT.
00000094: REVERT
; Batalkan transaksi karena tidak ada fungsi yang cocok.
; Pengguna akan melihat transaksi gagal tanpa pesan error spesifik.
;
; Di Solidity, ini setara dengan:
;   fallback() external {
;       revert();
;   }
; Atau contract tanpa fallback function sama sekali.

; ============================================================================
; FUNCTION WRAPPER IMPLEMENTATIONS
; ============================================================================
; Setiap fungsi memiliki "wrapper" yang bertugas:
; 1. Decode arguments dari calldata
; 2. Memanggil fungsi internal yang melakukan operasi sebenarnya
; 3. Encode hasil dan return ke caller
;
; Pola umum function wrapper:
;   JUMPDEST              ; Entry point
;   PUSH return_addr      ; Return address setelah internal call
;   PUSH 0x04             ; Offset calldata (skip selector)
;   DUP1                  ; Duplicate offset
;   CALLDATASIZE          ; Get total calldata size
;   SUB                   ; Calculate args size = calldatasize - 4
;   DUP2                  ; Duplicate for calculation
;   ADD                   ; Calculate end offset
;   SWAP1                 ; Rearrange stack
;   PUSH abi_decode_addr  ; Address of ABI decode function
;   SWAP2                 ; Rearrange
;   SWAP1                 ; Rearrange
;   PUSH decode_helper    ; Address of decode helper
;   JUMP                  ; Jump to decode calldata
; ============================================================================

00000095: JUMPDEST
; ============================================================================
; FUNCTION: addmod(uint256 a, uint256 b, uint256 n)
; Selector: 0x25a35559
; ============================================================================
; Menghitung (a + b) % n dengan presisi penuh (tidak overflow).
; Ini adalah wrapper yang memanggil fungsi internal addmod.

00000096: PUSH2 0x00af
; PUSH2 (Push 2-byte Immediate) - Opcode 0x61
; Mendorong nilai 0x00af (175 dalam desimal) ke stack.
;
; Nilai ini adalah RETURN ADDRESS - alamat di mana eksekusi akan kembali
; setelah fungsi internal selesai dieksekusi. Ini adalah bagian dari
; mekanisme "internal function call" di EVM.
;
; Cara kerja internal function call di EVM:
; 1. Push return address ke stack
; 2. Push arguments
; 3. JUMP ke fungsi
; 4. Fungsi selesai → JUMP kembali ke return address
;
; Kondisi stack SETELAH PUSH2 0x00af:
;   Stack: [0x00af]
;
; Gas cost: 3 gas

00000099: PUSH1 0x04
; PUSH1 (Push 1-byte Immediate) - Opcode 0x60
; Mendorong nilai 0x04 (4 dalam desimal) ke stack.
;
; Nilai 4 adalah OFFSET di mana arguments dimulai dalam calldata.
; Ingat struktur calldata: [4-byte selector][arg1][arg2][...]
; Jadi arguments dimulai dari byte ke-4 (offset 4).
;
; Kondisi stack SETELAH PUSH1 0x04:
;   Stack: [0x04, 0x00af]
;
; Gas cost: 3 gas

0000009b: DUP1
; DUP1 (Duplicate 1st Stack Item) - Opcode 0x80
; Menduplikasi nilai di top of stack (0x04).
;
; Kondisi stack SEBELUM DUP1:
;   Stack: [0x04, 0x00af]
;
; Kondisi stack SETELAH DUP1:
;   Stack: [0x04, 0x04, 0x00af]
;
; Mengapa perlu duplikat?
; Nilai 0x04 akan digunakan dua kali:
; 1. Untuk menghitung ukuran arguments (calldatasize - 4)
; 2. Untuk menghitung end offset (start + size)
;
; Gas cost: 3 gas

0000009c: CALLDATASIZE
; CALLDATASIZE (Get Calldata Size) - Opcode 0x36
; Mendorong ukuran total calldata (dalam bytes) ke stack.
;
; Calldata adalah data yang dikirim bersama transaksi, berisi:
; - 4 bytes: function selector
; - N bytes: encoded arguments
;
; Contoh untuk addmod(5, 10, 3):
; - Selector: 0x25a35559 (4 bytes)
; - Arg 1 (a=5): 32 bytes (padded)
; - Arg 2 (b=10): 32 bytes (padded)
; - Arg 3 (n=3): 32 bytes (padded)
; - Total: 4 + 32 + 32 + 32 = 100 bytes
;
; Kondisi stack SEBELUM CALLDATASIZE:
;   Stack: [0x04, 0x04, 0x00af]
;
; Kondisi stack SETELAH CALLDATASIZE (misal calldata = 100 bytes):
;   Stack: [0x64, 0x04, 0x04, 0x00af]  (0x64 = 100)
;
; Gas cost: 2 gas
;
; Referensi:
; - https://www.evm.codes/#36

0000009d: SUB
; SUB (Subtraction) - Opcode 0x03
; Operasi pengurangan: menghitung b - a dari stack.
;
; Cara kerja SUB:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Hitung b - a
; 3. Push hasil ke stack
;
; PENTING - Urutan operand:
; Stack: [a, b] → hasil: b - a (BUKAN a - b!)
; Ini sering membingungkan karena kebalikan dari intuisi.
;
; PENTING tentang UNDERFLOW:
; SUB di EVM adalah operasi MODULAR 2^256. Artinya:
; - Jika b < a, hasilnya akan "wrap around" (underflow)
; - 0 - 1 = 2^256 - 1 = MAX_UINT256 (bukan error!)
;
; Kondisi stack SEBELUM SUB:
;   Stack: [calldatasize, 0x04, 0x04, 0x00af]
;   - a = calldatasize (misal 100)
;   - b = 0x04 (4)
;
; TUNGGU! Ini terlihat terbalik. Sebenarnya:
;   Stack: [0x64, 0x04, ...] dimana 0x64 di top
;   SUB: 0x04 - 0x64? Tidak, SUB mengambil a=0x64, b=0x04
;   Hasil: 0x04 - 0x64 = UNDERFLOW!
;
; Hmm, sepertinya saya salah analisis. Mari kita trace ulang:
; Setelah CALLDATASIZE, stack adalah: [calldatasize, 0x04, 0x04, 0x00af]
; SUB: a = calldatasize (top), b = 0x04 (second)
; Hasil: 0x04 - calldatasize → ini underflow jika calldatasize > 4
;
; Sebenarnya yang terjadi:
; calldatasize di top, lalu SUB → calldatasize - 4 = ukuran arguments
; Karena SUB(a,b) = b - a, dan stack adalah [calldatasize, 4]
; Maka: 4 - calldatasize? Tidak benar...
;
; Mari trace lebih hati-hati:
; - PUSH1 0x04 → stack: [4]
; - DUP1 → stack: [4, 4]
; - CALLDATASIZE → stack: [size, 4, 4]
; - SUB → pop size dan 4, push 4 - size?
;
; Berdasarkan evm.codes: SUB(a, b) = a - b dimana a adalah top of stack
; Jadi: size - 4 = ukuran arguments ✓
;
; Kondisi stack SETELAH SUB:
;   Stack: [args_size, 0x04, 0x00af]
;   - args_size = calldatasize - 4 (ukuran arguments saja)
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#03

0000009e: DUP2
; DUP2 (Duplicate 2nd Stack Item) - Opcode 0x81
; Menduplikasi nilai di posisi ke-2 dari top of stack.
;
; Keluarga DUP (DUP1 - DUP16):
; - DUP1: Duplikat item ke-1 (top)
; - DUP2: Duplikat item ke-2
; - DUP3: Duplikat item ke-3
; - ... dan seterusnya
;
; Kondisi stack SEBELUM DUP2:
;   Stack: [args_size, 0x04, 0x00af]
;   - Posisi 1 (top): args_size
;   - Posisi 2: 0x04
;   - Posisi 3: 0x00af
;
; Kondisi stack SETELAH DUP2:
;   Stack: [0x04, args_size, 0x04, 0x00af]
;   - Item ke-2 (0x04) diduplikat ke top
;
; Mengapa DUP2?
; Kita butuh nilai 0x04 lagi untuk kalkulasi berikutnya.
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#81

0000009f: ADD
; ADD (Addition) - Opcode 0x01
; Menghitung penjumlahan dua nilai di top stack.
;
; Kondisi stack SEBELUM ADD:
;   Stack: [0x04, args_size, 0x04, 0x00af]
;
; Kondisi stack SETELAH ADD:
;   Stack: [0x04 + args_size, 0x04, 0x00af]
;   - Ini adalah END OFFSET dari arguments di calldata
;   - end_offset = start_offset + size = 4 + args_size
;
; Gas cost: 3 gas

000000a0: SWAP1
; SWAP1 (Swap 1st and 2nd Stack Items) - Opcode 0x90
; Menukar posisi item ke-1 dan ke-2 di stack.
;
; Keluarga SWAP (SWAP1 - SWAP16):
; - SWAP1: Tukar item 1 dengan item 2
; - SWAP2: Tukar item 1 dengan item 3
; - ... dan seterusnya
;
; Kondisi stack SEBELUM SWAP1:
;   Stack: [end_offset, 0x04, 0x00af]
;
; Kondisi stack SETELAH SWAP1:
;   Stack: [0x04, end_offset, 0x00af]
;
; Mengapa SWAP?
; Menyusun ulang stack agar sesuai dengan parameter yang dibutuhkan
; oleh fungsi ABI decode.
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#90

000000a1: PUSH2 0x00aa
; Push return address untuk nested function call.
;
; Kondisi stack SETELAH:
;   Stack: [0x00aa, 0x04, end_offset, 0x00af]
;
; Gas cost: 3 gas

000000a4: SWAP2
; SWAP2 (Swap 1st and 3rd Stack Items) - Opcode 0x91
; Menukar item ke-1 dengan item ke-3.
;
; Kondisi stack SEBELUM SWAP2:
;   Stack: [0x00aa, 0x04, end_offset, 0x00af]
;
; Kondisi stack SETELAH SWAP2:
;   Stack: [end_offset, 0x04, 0x00aa, 0x00af]
;
; Gas cost: 3 gas

000000a5: SWAP1
; Menukar lagi untuk menyusun parameter dengan benar.
;
; Kondisi stack SETELAH SWAP1:
;   Stack: [0x04, end_offset, 0x00aa, 0x00af]
;
; Sekarang stack siap untuk ABI decode:
; - 0x04: start offset
; - end_offset: end offset
; - 0x00aa: return address setelah decode
; - 0x00af: return address setelah seluruh operasi
;
; Gas cost: 3 gas

000000a6: PUSH2 0x03c2
; Push alamat fungsi ABI decode.
;
; Alamat 0x03c2 adalah internal helper function yang melakukan:
; 1. Decode arguments dari calldata
; 2. Validasi format arguments
; 3. Push decoded values ke stack
;
; Gas cost: 3 gas

000000a9: JUMP
; JUMP (Unconditional Jump) - Opcode 0x56
; Melompat ke alamat yang ada di top of stack.
;
; Cara kerja JUMP:
; 1. Pop 1 nilai dari stack (destination address)
; 2. Lompat ke alamat tersebut
; 3. Alamat HARUS berupa JUMPDEST yang valid
;
; Kondisi stack SEBELUM JUMP:
;   Stack: [0x03c2, 0x04, end_offset, 0x00aa, 0x00af]
;
; Kondisi stack SETELAH JUMP:
;   Stack: [0x04, end_offset, 0x00aa, 0x00af]
;   PC (Program Counter) = 0x03c2
;
; PERBEDAAN JUMP vs JUMPI:
; - JUMP: Selalu lompat (unconditional)
; - JUMPI: Lompat hanya jika kondisi != 0 (conditional)
;
; Gas cost: 8 gas
;
; Referensi:
; - https://www.evm.codes/#56

000000aa: JUMPDEST
; JUMPDEST - Return point setelah ABI decode selesai.
; Pada titik ini, arguments sudah di-decode dan ada di stack.
;
; Kondisi stack di sini:
;   Stack: [arg_n, arg_b, arg_a, 0x00af]
;   - Untuk addmod: [n, b, a, return_addr]

000000ab: PUSH2 0x0245
; Push alamat implementasi internal addmod.
;
; Alamat 0x0245 berisi kode yang melakukan operasi:
; (a + b) % n dengan presisi penuh.
;
; Gas cost: 3 gas

000000ae: JUMP
; Lompat ke implementasi addmod.
; Setelah addmod selesai, akan JUMP kembali ke return address.
;
; Gas cost: 8 gas

000000af: JUMPDEST
; ============================================================================
; RETURN VALUE ENCODING & RETURN
; ============================================================================
; Setelah fungsi internal selesai, hasil ada di stack.
; Bagian ini meng-encode hasil dan mengembalikannya ke caller.

000000b0: PUSH1 0x40
; Push alamat Free Memory Pointer (0x40).
; Kita akan menggunakan FMP untuk mendapatkan alamat memori
; di mana kita bisa menyimpan return value.
;
; Gas cost: 3 gas

000000b2: MLOAD
; MLOAD (Memory Load) - Opcode 0x51
; Membaca 32 bytes dari memory pada alamat tertentu.
;
; Cara kerja MLOAD:
; 1. Pop 1 nilai dari stack: offset
; 2. Baca 32 bytes dari memory[offset:offset+32]
; 3. Push nilai yang dibaca ke stack
;
; Kondisi stack SEBELUM MLOAD:
;   Stack: [0x40, result, 0x00af]
;
; Kondisi stack SETELAH MLOAD:
;   Stack: [free_mem_ptr, result, 0x00af]
;   - free_mem_ptr = nilai di memory[0x40] (biasanya 0x80 atau lebih)
;
; Analogi sederhana:
; MLOAD seperti membuka laci (alamat 0x40) dan melihat isinya.
; Isi laci tersebut adalah "penunjuk" ke area memori kosong berikutnya.
;
; Gas cost: 3 gas + memory expansion jika perlu
;
; Referensi:
; - https://www.evm.codes/#51

000000b3: PUSH2 0x00bc
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000000b6: SWAP2
; Rearrange stack untuk parameter.
;
; Gas cost: 3 gas

000000b7: SWAP1
; Rearrange stack lagi.
;
; Gas cost: 3 gas

000000b8: PUSH2 0x040f
; Push alamat helper untuk encode uint256 ke memory.
; Helper ini akan menyimpan result ke memory untuk di-return.
;
; Gas cost: 3 gas

000000bb: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000000bc: JUMPDEST
; Return point setelah encoding selesai.
; Sekarang result sudah tersimpan di memory.

000000bd: PUSH1 0x40
; Push alamat FMP lagi untuk mendapatkan end of data.
;
; Gas cost: 3 gas

000000bf: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data yang di-encode).
;
; Gas cost: 3 gas

000000c0: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

000000c1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000000c2: SUB
; Hitung size = end_ptr - start_ptr.
; Ini adalah ukuran data yang akan di-return.
;
; Gas cost: 3 gas

000000c3: SWAP1
; Rearrange: [start_ptr, size]
;
; Gas cost: 3 gas

000000c4: RETURN
; RETURN (Return from Call) - Opcode 0xf3
; Menghentikan eksekusi dan mengembalikan data ke caller.
;
; Cara kerja RETURN:
; 1. Pop 2 nilai dari stack:
;    - offset: alamat awal data di memory
;    - size: ukuran data (dalam bytes)
; 2. Ambil data dari memory[offset:offset+size]
; 3. Kembalikan data tersebut ke caller
; 4. Eksekusi selesai (sukses)
;
; Kondisi stack SEBELUM RETURN:
;   Stack: [offset, size]
;
; Dalam konteks RUNTIME (bukan deployment):
; - Data yang di-return adalah hasil fungsi
; - Caller akan menerima data ini
; - Untuk fungsi yang return uint256, size = 32 bytes
;
; Perbedaan RETURN di deployment vs runtime:
; - DEPLOYMENT: Return value = bytecode yang disimpan on-chain
; - RUNTIME: Return value = hasil fungsi yang dikembalikan ke caller
;
; Analogi sederhana:
; RETURN seperti mengirim balasan email.
; Kamu sudah menulis jawabannya (di memory), sekarang tinggal kirim.
; Setelah dikirim, percakapan selesai.
;
; Gas cost: 0 gas (untuk opcode) + memory expansion cost
;
; Referensi:
; - https://www.evm.codes/#f3

000000c5: JUMPDEST
; ============================================================================
; FUNCTION: exp(uint256 base, uint256 exponent)
; Selector: 0x2e4c697f
; ============================================================================
; Entry point untuk fungsi eksponensial (pangkat).
; Menghitung base^exponent.
000000c6: PUSH2 0x00df
; Push return address untuk wrapper exp.
; Setelah internal function selesai, akan kembali ke 0x00df untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

000000c9: PUSH1 0x04
; Push offset 4 - awal arguments setelah function selector.
;
; Gas cost: 3 gas

000000cb: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000000cc: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk exp(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000000cd: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000000ce: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000000cf: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000000d0: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000000d1: PUSH2 0x00da
; Push nested return address.
;
; Gas cost: 3 gas

000000d4: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000000d5: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000000d6: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (uint256, uint256).
;
; Gas cost: 3 gas

000000d9: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000000da: JUMPDEST
; Return point dari ABI decode.
; Stack: [exponent, base, return_addr]

000000db: PUSH2 0x0251
; Push alamat implementasi internal exp.
; Fungsi ini menghitung base^exponent menggunakan algoritma
; square-and-multiply untuk efisiensi.
;
; Gas cost: 3 gas

000000de: JUMP
; Lompat ke implementasi exp.
;
; Gas cost: 8 gas

000000df: JUMPDEST
; Return point dari exp calculation.
; Stack: [result, return_addr]

000000e0: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000000e2: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

000000e3: PUSH2 0x00ec
; Push return address untuk encoding.
;
; Gas cost: 3 gas

000000e6: SWAP2
; Rearrange stack untuk encoding helper.
;
; Gas cost: 3 gas

000000e7: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000000e8: PUSH2 0x040f
; Push alamat encoding helper (menyimpan uint256 ke memory).
;
; Gas cost: 3 gas

000000eb: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000000ec: JUMPDEST
; Return point dari encoding.

000000ed: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

000000ef: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data).
;
; Gas cost: 3 gas

000000f0: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

000000f1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000000f2: SUB
; Hitung size = end - start (32 bytes untuk uint256).
;
; Gas cost: 3 gas

000000f3: SWAP1
; Susun stack: [offset, size] untuk RETURN.
;
; Gas cost: 3 gas

000000f4: RETURN
; Kembalikan hasil ke caller.
; memory[offset:offset+32] berisi result dari exp.
;
; Gas cost: 0 gas

000000f5: JUMPDEST
; ============================================================================
; FUNCTION: add(uint256 a, uint256 b)
; Selector: 0x771602f7
; ============================================================================
; Entry point untuk fungsi penjumlahan sederhana.
;
; Solidity equivalent:
;   function add(uint256 a, uint256 b) public pure returns (uint256) {
;       return a + b;
;   }
;
; Contoh penggunaan:
;   add(5, 3) → 8
;   add(MAX_UINT256, 1) → REVERT (overflow di Solidity 0.8+)

000000f6: PUSH2 0x010f
; Push return address untuk wrapper add.
;
; Gas cost: 3 gas

000000f9: PUSH1 0x04
; Push offset 4 (skip selector).
;
; Gas cost: 3 gas

000000fb: DUP1
; Duplikat offset.
;
; Gas cost: 3 gas

000000fc: CALLDATASIZE
; Ukuran calldata: 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000000fd: SUB
; Args size: 68 - 4 = 64 bytes.
;
; Gas cost: 3 gas

000000fe: DUP2
; Duplikat offset.
;
; Gas cost: 3 gas

000000ff: ADD
; End offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

00000100: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000101: PUSH2 0x010a
; Push nested return address.
;
; Gas cost: 3 gas

00000104: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000105: SWAP1
; Rearrange.
;
; Gas cost: 3 gas

00000106: PUSH2 0x03c2
; Push ABI decode helper address.
;
; Gas cost: 3 gas

00000109: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

0000010a: JUMPDEST
; Return dari ABI decode.
; Stack: [b, a, return_addr]

0000010b: PUSH2 0x0266
; Push alamat implementasi internal add.
; Di alamat ini ada opcode ADD yang melakukan penjumlahan.
;
; Gas cost: 3 gas

0000010e: JUMP
; Lompat ke implementasi add.
;
; Gas cost: 8 gas

0000010f: JUMPDEST
; Return dari add calculation.
; Stack: [result, return_addr]

00000110: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

00000112: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000113: PUSH2 0x011c
; Push encoding return address.
;
; Gas cost: 3 gas

00000116: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000117: SWAP1
; Rearrange.
;
; Gas cost: 3 gas

00000118: PUSH2 0x040f
; Push encoding helper address.
;
; Gas cost: 3 gas

0000011b: JUMP
; Lompat ke encoding.
;
; Gas cost: 8 gas

0000011c: JUMPDEST
; Return dari encoding.

0000011d: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000011f: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000120: DUP1
; Duplikat.
;
; Gas cost: 3 gas

00000121: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000122: SUB
; Hitung size.
;
; Gas cost: 3 gas

00000123: SWAP1
; Rearrange untuk RETURN.
;
; Gas cost: 3 gas

00000124: RETURN
; Kembalikan hasil add ke caller.
;
; Gas cost: 0 gas

00000125: JUMPDEST
; ============================================================================
; FUNCTION: div(uint256 a, uint256 b)
; Selector: 0xa391c15b
; ============================================================================
; Entry point untuk fungsi pembagian.
;
; Solidity equivalent:
;   function div(uint256 a, uint256 b) public pure returns (uint256) {
;       require(b != 0, "Division by zero");
;       return a / b;
;   }
;
; Contoh penggunaan:
;   div(10, 3) → 3 (integer division, floor)
;   div(10, 0) → REVERT (division by zero)
00000126: PUSH2 0x013f
; Push return address untuk wrapper div.
;
; Gas cost: 3 gas

00000129: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

0000012b: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

0000012c: CALLDATASIZE
; Ambil ukuran calldata (68 bytes untuk 2 uint256 args).
;
; Gas cost: 2 gas

0000012d: SUB
; Hitung args size: 68 - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000012e: DUP2
; Duplikat offset.
;
; Gas cost: 3 gas

0000012f: ADD
; Hitung end offset.
;
; Gas cost: 3 gas

00000130: SWAP1
; Rearrange stack untuk ABI decode.
;
; Gas cost: 3 gas

00000131: PUSH2 0x013a
; Push nested return address.
;
; Gas cost: 3 gas

00000134: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000135: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000136: PUSH2 0x03c2
; Push ABI decode helper address.
;
; Gas cost: 3 gas

00000139: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

0000013a: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]

0000013b: PUSH2 0x027b
; Push alamat implementasi internal div.
; Fungsi ini melakukan pembagian dengan pengecekan division by zero.
;
; Di dalam implementasi div:
; 1. Cek apakah divisor (b) == 0
; 2. Jika 0, revert dengan error "Division by zero"
; 3. Jika tidak 0, hitung a / b menggunakan opcode DIV
;
; Gas cost: 3 gas

0000013e: JUMP
; Lompat ke implementasi div.
;
; Gas cost: 8 gas

0000013f: JUMPDEST
; Return point dari div calculation.
; Stack: [result, return_addr]

00000140: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

00000142: MLOAD
; Baca Free Memory Pointer.
;
; Gas cost: 3 gas

00000143: PUSH2 0x014c
; Push encoding return address.
;
; Gas cost: 3 gas

00000146: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000147: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000148: PUSH2 0x040f
; Push encoding helper address.
;
; Gas cost: 3 gas

0000014b: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

0000014c: JUMPDEST
; Return dari encoding.

0000014d: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000014f: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000150: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

00000151: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000152: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000153: SWAP1
; Rearrange untuk RETURN.
;
; Gas cost: 3 gas

00000154: RETURN
; Kembalikan hasil div ke caller.
;
; Gas cost: 0 gas

00000155: JUMPDEST
; ============================================================================
; FUNCTION: mulmod(uint256 a, uint256 b, uint256 n)
; Selector: 0xa4ad2ee9
; ============================================================================
; Entry point untuk fungsi perkalian modular.
;
; Solidity equivalent:
;   function mulmod(uint256 a, uint256 b, uint256 n)
;       public pure returns (uint256) {
;       require(n != 0, "Modulo by zero");
;       return mulmod(a, b, n);  // Built-in Solidity function
;   }
;
; KEUNGGULAN UTAMA:
; mulmod menggunakan presisi 512-bit untuk intermediate result (a * b)
; sebelum melakukan modulo. Ini mencegah overflow yang terjadi jika
; menggunakan MUL biasa diikuti MOD.
;
; Contoh penggunaan:
;   mulmod(2, 3, 5) → (2 * 3) % 5 = 6 % 5 = 1
;   mulmod(2^200, 2^200, 2^256-1) → hasil BENAR (tidak overflow!)
00000156: PUSH2 0x016f
; Push return address untuk wrapper mulmod.
; Setelah internal function selesai, akan kembali ke 0x016f untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

00000159: PUSH1 0x04
; Push offset 4 - awal arguments setelah function selector.
; Untuk mulmod(uint256, uint256, uint256): 4 bytes selector + 96 bytes args.
;
; Gas cost: 3 gas

0000015b: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

0000015c: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mulmod dengan 3 uint256 args: 4 + 32 + 32 + 32 = 100 bytes.
;
; Gas cost: 2 gas

0000015d: SUB
; Hitung ukuran arguments: calldatasize - 4 = 96 bytes.
;
; Gas cost: 3 gas

0000015e: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000015f: ADD
; Hitung end offset: 4 + 96 = 100.
;
; Gas cost: 3 gas

00000160: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

00000161: PUSH2 0x016a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000164: SWAP2
; Rearrange stack untuk ABI decode helper.
;
; Gas cost: 3 gas

00000165: SWAP1
; Rearrange stack lagi.
;
; Gas cost: 3 gas

00000166: PUSH2 0x0428
; Push alamat ABI decode helper untuk 3 arguments (uint256, uint256, uint256).
; Helper ini akan decode calldata dan push 3 nilai ke stack.
;
; Gas cost: 3 gas

00000169: JUMP
; Lompat ke ABI decode helper.
;
; Gas cost: 8 gas

0000016a: JUMPDEST
; Return point dari ABI decode.
; Stack: [n, b, a, return_addr]
; - a = operand pertama untuk mulmod
; - b = operand kedua untuk mulmod
; - n = modulus (pembagi)

0000016b: PUSH2 0x02d2
; Push alamat implementasi internal mulmod.
; Fungsi ini akan menghitung (a * b) mod n dengan presisi 512-bit.
;
; Gas cost: 3 gas

0000016e: JUMP
; Lompat ke implementasi mulmod internal.
;
; Gas cost: 8 gas

0000016f: JUMPDEST
; Return point dari mulmod calculation.
; Stack: [result, return_addr]
; - result = (a * b) mod n

00000170: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

00000172: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000173: PUSH2 0x017c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000176: SWAP2
; Rearrange stack untuk encoding helper.
;
; Gas cost: 3 gas

00000177: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000178: PUSH2 0x040f
; Push alamat encoding helper yang menyimpan uint256 ke memory.
;
; Gas cost: 3 gas

0000017b: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

0000017c: JUMPDEST
; Return dari encoding helper.
; Result sudah tersimpan di memory.

0000017d: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size return data.
;
; Gas cost: 3 gas

0000017f: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data yang di-encode).
;
; Gas cost: 3 gas

00000180: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

00000181: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000182: SUB
; Hitung size = end - start (32 bytes untuk uint256).
;
; Gas cost: 3 gas

00000183: SWAP1
; Susun stack: [offset, size] untuk RETURN.
;
; Gas cost: 3 gas

00000184: RETURN
; Kembalikan hasil mulmod ke caller.
; memory[offset:offset+32] berisi result dari mulmod.
;
; Gas cost: 0 gas
00000185: JUMPDEST
; ============================================================================
; FUNCTION: mul(uint256 a, uint256 b)
; Selector: 0xb12fe826
; ============================================================================
; Entry point untuk fungsi perkalian sederhana.
;
; Solidity equivalent:
;   function mul(uint256 a, uint256 b) public pure returns (uint256) {
;       return a * b;
;   }
;
; PENTING - Overflow:
; Di Solidity 0.8+, MUL akan di-wrap dengan pengecekan overflow.
; Jika a * b > MAX_UINT256, transaksi akan REVERT.
;
; Contoh penggunaan:
;   mul(3, 4) → 12
;   mul(2^128, 2^128) → REVERT (overflow!)

00000186: PUSH2 0x019f
; Push return address untuk wrapper mul.
; Setelah internal function selesai, akan kembali ke sini untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

00000189: PUSH1 0x04
; Push offset 4 (skip function selector).
; Calldata: [4-byte selector][32-byte a][32-byte b]
;
; Gas cost: 3 gas

0000018b: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

0000018c: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mul(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

0000018d: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000018e: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000018f: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

00000190: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

00000191: PUSH2 0x019a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000194: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000195: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000196: PUSH2 0x0428
; Push alamat ABI decode helper untuk 2 arguments (dengan helper 3-arg).
; CATATAN: Menggunakan helper yang sama dengan mulmod (0x0428)
; karena decode 2 args dan 3 args bisa menggunakan helper yang sama
; dengan validasi size yang berbeda.
;
; Gas cost: 3 gas

00000199: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

0000019a: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]

0000019b: PUSH2 0x02ee
; Push alamat implementasi internal mul.
; Fungsi ini akan menghitung a * b dengan pengecekan overflow.
;
; Gas cost: 3 gas

0000019e: JUMP
; Lompat ke implementasi mul.
;
; Gas cost: 8 gas

0000019f: JUMPDEST
; Return point dari mul calculation.
; Stack: [result, return_addr]

000001a0: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000001a2: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

000001a3: PUSH2 0x01ac
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000001a6: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001a7: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001a8: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

000001ab: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000001ac: JUMPDEST
; Return dari encoding helper.

000001ad: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

000001af: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

000001b0: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

000001b1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001b2: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

000001b3: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

000001b4: RETURN
; Kembalikan hasil mul ke caller.
;
; Gas cost: 0 gas
000001b5: JUMPDEST
; ============================================================================
; FUNCTION: sub(uint256 a, uint256 b)
; Selector: 0xb67d77c5
; ============================================================================
; Entry point untuk fungsi pengurangan sederhana.
;
; Solidity equivalent:
;   function sub(uint256 a, uint256 b) public pure returns (uint256) {
;       return a - b;
;   }
;
; PENTING - Underflow:
; Di Solidity 0.8+, jika b > a (hasil negatif), transaksi akan REVERT.
; Di Solidity < 0.8, hasil akan wrap around ke angka besar (underflow bug!).
;
; Contoh penggunaan:
;   sub(10, 3) → 7
;   sub(3, 10) → REVERT (underflow di Solidity 0.8+)

000001b6: PUSH2 0x01cf
; Push return address untuk wrapper sub.
;
; Gas cost: 3 gas

000001b9: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

000001bb: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000001bc: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk sub(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000001bd: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000001be: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000001bf: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000001c0: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000001c1: PUSH2 0x01ca
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

000001c4: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001c5: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001c6: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (uint256, uint256).
; Ini adalah helper berbeda dari mulmod (0x03c2 vs 0x0428).
;
; Gas cost: 3 gas

000001c9: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000001ca: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = operand pertama (minuend)
; - b = operand kedua (subtrahend)

000001cb: PUSH2 0x030a
; Push alamat implementasi internal sub.
; Fungsi ini akan menghitung a - b dengan pengecekan underflow.
;
; Gas cost: 3 gas

000001ce: JUMP
; Lompat ke implementasi sub.
;
; Gas cost: 8 gas

000001cf: JUMPDEST
; Return point dari sub calculation.
; Stack: [result, return_addr]
; - result = a - b

000001d0: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000001d2: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

000001d3: PUSH2 0x01dc
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000001d6: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001d7: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001d8: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

000001db: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000001dc: JUMPDEST
; Return dari encoding helper.

000001dd: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

000001df: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

000001e0: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

000001e1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001e2: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

000001e3: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

000001e4: RETURN
; Kembalikan hasil sub ke caller.
;
; Gas cost: 0 gas
000001e5: JUMPDEST
; ============================================================================
; FUNCTION: mod(uint256 a, uint256 b)
; Selector: 0xc8a4ac9c
; ============================================================================
; Entry point untuk fungsi modulo (sisa pembagian).
;
; Solidity equivalent:
;   function mod(uint256 a, uint256 b) public pure returns (uint256) {
;       require(b != 0, "Modulo by zero");
;       return a % b;
;   }
;
; PENTING - Division by Zero:
; Jika b = 0, transaksi akan REVERT dengan error "Modulo by zero".
; Berbeda dengan opcode MOD murni yang return 0 saat divide by zero.
;
; Contoh penggunaan:
;   mod(17, 5) → 2 (sisa dari 17/5)
;   mod(10, 3) → 1 (sisa dari 10/3)
;   mod(10, 0) → REVERT!

000001e6: PUSH2 0x01ff
; Push return address untuk wrapper mod.
;
; Gas cost: 3 gas

000001e9: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

000001eb: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000001ec: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mod(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000001ed: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000001ee: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000001ef: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000001f0: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000001f1: PUSH2 0x01fa
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

000001f4: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001f5: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001f6: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments.
;
; Gas cost: 3 gas

000001f9: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000001fa: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = dividend (yang dibagi)
; - b = divisor (pembagi)

000001fb: PUSH2 0x031f
; Push alamat implementasi internal mod.
; Fungsi ini akan menghitung a % b dengan pengecekan division by zero.
;
; Gas cost: 3 gas

000001fe: JUMP
; Lompat ke implementasi mod.
;
; Gas cost: 8 gas

000001ff: JUMPDEST
; Return point dari mod calculation.
; Stack: [result, return_addr]
; - result = a % b

00000200: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

00000202: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000203: PUSH2 0x020c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000206: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000207: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000208: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

0000020b: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

0000020c: JUMPDEST
; Return dari encoding helper.

0000020d: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

0000020f: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000210: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

00000211: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000212: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000213: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

00000214: RETURN
; Kembalikan hasil mod ke caller.
;
; Gas cost: 0 gas

00000215: JUMPDEST
; ============================================================================
; FUNCTION: signedDiv(int256 a, int256 b)
; Selector: 0xf43f523a
; ============================================================================
; Entry point untuk fungsi pembagian SIGNED (bertanda).
; Berbeda dengan div() biasa yang unsigned, signedDiv menggunakan SDIV
; yang bisa menangani angka negatif.
;
; Solidity equivalent:
;   function signedDiv(int256 a, int256 b) public pure returns (int256) {
;       require(b != 0, "Division by zero");
;       return a / b;  // Menggunakan SDIV di balik layar
;   }
;
; PENTING - Perbedaan DIV vs SDIV:
; - DIV: Menganggap semua angka sebagai UNSIGNED (0 sampai 2^256-1)
; - SDIV: Menganggap angka sebagai SIGNED (-2^255 sampai 2^255-1)
;
; Contoh perbedaan:
;   Nilai 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
;   - DIV melihat ini sebagai: 2^256 - 1 (angka positif sangat besar)
;   - SDIV melihat ini sebagai: -1 (two's complement)
;
; Contoh penggunaan signedDiv:
;   signedDiv(-10, 3) → -3 (bukan 0 seperti unsigned!)
;   signedDiv(10, -3) → -3
;   signedDiv(-10, -3) → 3 (negatif dibagi negatif = positif)
;   signedDiv(10, 0) → REVERT!

00000216: PUSH2 0x022f
; Push return address untuk wrapper signedDiv.
; Setelah internal function selesai, akan kembali ke 0x022f untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

00000219: PUSH1 0x04
; Push offset 4 (skip function selector).
; Calldata: [4-byte selector][32-byte a][32-byte b]
;
; Gas cost: 3 gas

0000021b: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

0000021c: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk signedDiv(int256, int256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

0000021d: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000021e: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000021f: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

00000220: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

00000221: PUSH2 0x022a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000224: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000225: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000226: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (int256, int256).
;
; Gas cost: 3 gas

00000229: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

0000022a: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = dividend (yang dibagi) - SIGNED integer
; - b = divisor (pembagi) - SIGNED integer

0000022b: PUSH2 0x0334
; Push alamat implementasi internal signedDiv.
; Fungsi ini akan menghitung a / b menggunakan SDIV dengan pengecekan
; division by zero.
;
; Gas cost: 3 gas

0000022e: JUMP
; Lompat ke implementasi signedDiv.
;
; Gas cost: 8 gas

0000022f: JUMPDEST
; Return point dari signedDiv calculation.
; Stack: [result, return_addr]
; - result = a / b (signed division)

00000230: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

00000232: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000233: PUSH2 0x023c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000236: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000237: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000238: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

0000023b: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

0000023c: JUMPDEST
; Return dari encoding helper.

0000023d: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

0000023f: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000240: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

00000241: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000242: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000243: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

00000244: RETURN
; Kembalikan hasil signedDiv ke caller.
;
; Gas cost: 0 gas

00000245: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: add(uint256 a, uint256 b) returns (uint256)
; ============================================================================
; Ini adalah implementasi internal dari fungsi penjumlahan.
; Equivalent Solidity: function add(uint256 a, uint256 b) internal pure returns (uint256)
;
; Stack saat masuk: [b, a, return_addr, ...]
; Stack saat keluar: [result, return_addr, ...]

00000246: PUSH0
; Push 0 sebagai placeholder untuk result.
; Stack: [0, b, a, return_addr]

00000247: DUP2
; Duplikat b ke top stack.
; Stack: [b, 0, b, a, return_addr]

00000248: DUP4
; Duplikat a ke top stack.
; Stack: [a, b, 0, b, a, return_addr]

00000249: ADD
; ADD (Addition) - Opcode 0x01
; ============================================================================
; Opcode aritmetika paling dasar: PENJUMLAHAN
;
; Cara kerja ADD:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Hitung a + b
; 3. Push hasil ke stack
;
; PENTING tentang OVERFLOW:
; ADD di EVM adalah operasi MODULAR 2^256. Artinya:
; - Jika hasil melebihi 2^256 - 1 (MAX_UINT256), akan "wrap around"
; - Tidak ada exception/error saat overflow!
; - Contoh: (2^256 - 1) + 1 = 0 (bukan error!)
;
; Kondisi stack SEBELUM ADD:
;   Stack: [a, b, ...]
;
; Kondisi stack SETELAH ADD:
;   Stack: [a + b, ...]  (modulo 2^256)
;
; Analogi sederhana:
; ADD seperti kalkulator biasa untuk penjumlahan, tapi dengan "odometer mobil".
; Jika sudah sampai angka maksimum, akan reset ke 0 dan mulai lagi.
;
; Contoh penggunaan di Solidity:
;   uint256 result = a + b;  // Menggunakan ADD opcode
;
; KEAMANAN:
; Di Solidity < 0.8.0, overflow tidak dicek (bisa menyebabkan bug keamanan).
; Di Solidity >= 0.8.0, ada pengecekan overflow otomatis (revert jika overflow).
; Contract ini menggunakan unchecked add (langsung ADD tanpa pengecekan).
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#01

0000024a: SWAP1
; Stack: [0, a+b, b, a, return_addr] → [a+b, 0, b, a, return_addr]

0000024b: POP
; Buang placeholder 0.
; Stack: [a+b, b, a, return_addr]

0000024c: SWAP3
; Stack: [return_addr, b, a, a+b]

0000024d: SWAP2
; Stack: [return_addr, a+b, a, b]

0000024e: POP
; Buang a.

0000024f: POP
; Buang b.
; Stack: [return_addr, result]

00000250: JUMP
; Return ke caller dengan result di stack.

00000251: JUMPDEST
00000252: PUSH0
00000253: DUP2
00000254: DUP4
00000255: PUSH2 0x025e
00000258: SWAP2
00000259: SWAP1
0000025a: PUSH2 0x05d4
0000025d: JUMP
0000025e: JUMPDEST
0000025f: SWAP1
00000260: POP
00000261: SWAP3
00000262: SWAP2
00000263: POP
00000264: POP
00000265: JUMP
00000266: JUMPDEST
00000267: PUSH0
00000268: DUP2
00000269: DUP4
0000026a: PUSH2 0x0273
0000026d: SWAP2
0000026e: SWAP1
0000026f: PUSH2 0x061e
00000272: JUMP
00000273: JUMPDEST
00000274: SWAP1
00000275: POP
00000276: SWAP3
00000277: SWAP2
00000278: POP
00000279: POP
0000027a: JUMP
0000027b: JUMPDEST
0000027c: PUSH0
0000027d: PUSH0
0000027e: DUP3
0000027f: SUB
00000280: PUSH2 0x02be
00000283: JUMPI
00000284: PUSH1 0x40
00000286: MLOAD
00000287: PUSH32 0x08c379a000000000000000000000000000000000000000000000000000000000
000002a8: DUP2
000002a9: MSTORE
000002aa: PUSH1 0x04
000002ac: ADD
000002ad: PUSH2 0x02b5
000002b0: SWAP1
000002b1: PUSH2 0x06ab
000002b4: JUMP
000002b5: JUMPDEST
000002b6: PUSH1 0x40
000002b8: MLOAD
000002b9: DUP1
000002ba: SWAP2
000002bb: SUB
000002bc: SWAP1
000002bd: REVERT
000002be: JUMPDEST
000002bf: DUP2
000002c0: DUP4
000002c1: PUSH2 0x02ca
000002c4: SWAP2
000002c5: SWAP1
000002c6: PUSH2 0x06f6
000002c9: JUMP
000002ca: JUMPDEST
000002cb: SWAP1
000002cc: POP
000002cd: SWAP3
000002ce: SWAP2
000002cf: POP
000002d0: POP
000002d1: JUMP
000002d2: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: mulmod(uint256 a, uint256 b, uint256 n) returns (uint256)
; ============================================================================
; Menghitung (a * b) % n dengan PRESISI PENUH.
; Ini sangat penting untuk kriptografi karena intermediate result tidak overflow!
;
; Equivalent Solidity: mulmod(a, b, n)
; Stack saat masuk: [n, b, a, return_addr, ...]

000002d3: PUSH0
; Push 0 sebagai placeholder untuk result.

000002d4: DUP2
; Duplikat n untuk pengecekan division by zero.

000002d5: DUP1
; Duplikat n lagi.

000002d6: PUSH2 0x02e2
; Push alamat untuk skip error handling jika n != 0.

000002d9: JUMPI
; Jika n != 0, skip error handling.
; Jika n == 0, jatuh ke panic handler (division by zero).

000002da: PUSH2 0x02e1
; Error handling: push panic selector.

000002dd: PUSH2 0x06c9
; Push address panic handler.

000002e0: JUMP
; Jump ke panic handler untuk division by zero error.

000002e1: JUMPDEST
; Landing point jika n != 0 (safe to proceed).

000002e2: JUMPDEST
; Extra JUMPDEST (mungkin dari compiler optimization).

000002e3: DUP4
; Duplikat a ke top stack.

000002e4: DUP6
; Duplikat b ke top stack.
; Stack sekarang: [b, a, n, ...]

000002e5: MULMOD
; MULMOD (Modular Multiplication) - Opcode 0x09
; ============================================================================
; Opcode aritmetika KHUSUS untuk perkalian modular dengan PRESISI PENUH.
;
; Cara kerja MULMOD:
; 1. Pop 3 nilai dari stack: a (top), b (second), N (third)
; 2. Hitung (a * b) mod N
; 3. Push hasil ke stack
;
; KEUNGGULAN UTAMA - PRESISI PENUH:
; Berbeda dengan MUL biasa yang bisa overflow, MULMOD menghitung
; intermediate result (a * b) dengan presisi 512-bit sebelum melakukan modulo.
; Ini KRUSIAL untuk:
; - Kriptografi (RSA, ECDSA, dll)
; - Finite field arithmetic
; - Menghindari overflow pada perkalian besar
;
; Contoh mengapa ini penting:
;   a = 2^200
;   b = 2^200
;   N = 2^256 - 1
;
;   MUL biasa: a * b = 2^400, tapi di-truncate ke 256 bit → SALAH!
;   MULMOD: (a * b) mod N = (2^400) mod (2^256-1) = hasil yang BENAR
;
; Kondisi stack SEBELUM MULMOD:
;   Stack: [a, b, N, ...]
;
; Kondisi stack SETELAH MULMOD:
;   Stack: [(a * b) mod N, ...]
;
; CATATAN KHUSUS:
; - Jika N = 0, hasil adalah 0 (bukan error!)
; - Berbeda dengan DIV/MOD yang panic saat pembagi 0
;
; Analogi sederhana:
; MULMOD seperti kalkulator yang bisa menangani angka SANGAT BESAR.
; Bayangkan kamu perlu menghitung (999999999 × 999999999) mod 1000.
; Kalkulator biasa mungkin overflow, tapi MULMOD bisa menanganinya
; karena dia "ingat" semua digit sebelum melakukan modulo.
;
; Penggunaan umum:
; 1. Elliptic Curve Cryptography (ECC)
; 2. Zero-Knowledge Proofs
; 3. Signature verification (ECDSA)
; 4. Modular exponentiation
;
; Gas cost: 8 gas
;
; Referensi:
; - https://www.evm.codes/#09

000002e6: SWAP1
; Swap untuk cleanup stack.

000002e7: POP
; Buang placeholder.

000002e8: SWAP4
; Rearrange stack untuk return.

000002e9: SWAP3
; Rearrange stack.

000002ea: POP
; Cleanup.

000002eb: POP
; Cleanup.

000002ec: POP
; Cleanup.

000002ed: JUMP
; Return ke caller dengan result.

000002ee: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: addmod(uint256 a, uint256 b, uint256 n) returns (uint256)
; ============================================================================
; Menghitung (a + b) % n dengan PRESISI PENUH.
; Intermediate result (a + b) tidak overflow meskipun melebihi 2^256.
;
; Equivalent Solidity: addmod(a, b, n)

000002ef: PUSH0
; Push placeholder.

000002f0: DUP2
; Duplikat n untuk pengecekan.

000002f1: DUP1
; Duplikat n lagi.

000002f2: PUSH2 0x02fe
; Push alamat untuk skip error jika n != 0.

000002f5: JUMPI
; Jika n != 0, lanjut ke operasi.
; Jika n == 0, jatuh ke panic handler.

000002f6: PUSH2 0x02fd
; Push panic info.

000002f9: PUSH2 0x06c9
; Push panic handler address.

000002fc: JUMP
; Jump ke panic handler.

000002fd: JUMPDEST
; Landing point jika n != 0.

000002fe: JUMPDEST
; Extra JUMPDEST.

000002ff: DUP4
; Duplikat a.

00000300: DUP6
; Duplikat b.
; Stack: [b, a, n, ...]

00000301: ADDMOD
; ADDMOD (Modular Addition) - Opcode 0x08
; ============================================================================
; Opcode aritmetika KHUSUS untuk penjumlahan modular dengan PRESISI PENUH.
;
; Cara kerja ADDMOD:
; 1. Pop 3 nilai dari stack: a (top), b (second), N (third)
; 2. Hitung (a + b) mod N
; 3. Push hasil ke stack
;
; KEUNGGULAN UTAMA - PRESISI PENUH:
; Intermediate result (a + b) dihitung dengan presisi 257-bit sebelum modulo.
; Ini mencegah overflow yang bisa terjadi dengan ADD biasa.
;
; Contoh mengapa ini penting:
;   a = 2^255
;   b = 2^255
;   N = 2^256 - 1
;
;   ADD biasa: a + b = 2^256, overflow ke 0 → SALAH!
;   ADDMOD: (a + b) mod N = (2^256) mod (2^256-1) = 1 → BENAR!
;
; Kondisi stack SEBELUM ADDMOD:
;   Stack: [a, b, N, ...]
;
; Kondisi stack SETELAH ADDMOD:
;   Stack: [(a + b) mod N, ...]
;
; CATATAN KHUSUS:
; - Jika N = 0, hasil adalah 0 (bukan error!)
;
; Analogi sederhana:
; ADDMOD seperti jam 24 jam yang tidak pernah overflow.
; Jika kamu tambah 20 + 10 dengan modulo 24, hasilnya 6 (bukan 30).
; Perbedaannya, ADDMOD bisa handle angka yang SANGAT besar sebelum wrap.
;
; Penggunaan umum:
; 1. Finite field arithmetic untuk kriptografi
; 2. Ring arithmetic
; 3. Mencegah overflow dalam kalkulasi sensitif
;
; Gas cost: 8 gas
;
; Referensi:
; - https://www.evm.codes/#08

00000302: SWAP1
; Swap untuk cleanup.

00000303: POP
; Buang placeholder.

00000304: SWAP4
; Rearrange untuk return.

00000305: SWAP3
; Rearrange.

00000306: POP
; Cleanup.

00000307: POP
; Cleanup.

00000308: POP
; Cleanup.

00000309: JUMP
; Return ke caller.

0000030a: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: mul helper wrapper
; ============================================================================
; Wrapper internal untuk operasi perkalian yang memanggil helper
; dengan overflow checking.

0000030b: PUSH0
; Push placeholder.
;
; Gas cost: 2 gas

0000030c: DUP2
; Duplikat operand kedua.
;
; Gas cost: 3 gas

0000030d: DUP4
; Duplikat operand pertama.
;
; Gas cost: 3 gas

0000030e: PUSH2 0x0317
; Push return address.
;
; Gas cost: 3 gas

00000311: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000312: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000313: PUSH2 0x0726
; Push alamat helper untuk safe multiplication dengan overflow check.
;
; Gas cost: 3 gas

00000316: JUMP
; Lompat ke helper function.
;
; Gas cost: 8 gas

00000317: JUMPDEST
; Return point dari helper.

00000318: SWAP1
; Rearrange hasil.
;
; Gas cost: 3 gas

00000319: POP
; Cleanup placeholder.
;
; Gas cost: 2 gas

0000031a: SWAP3
; Rearrange untuk return.
;
; Gas cost: 3 gas

0000031b: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

0000031c: POP
; Cleanup operand.
;
; Gas cost: 2 gas

0000031d: POP
; Cleanup operand.
;
; Gas cost: 2 gas

0000031e: JUMP
; Return ke caller.
;
; Gas cost: 8 gas

0000031f: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: signedDiv(int256 a, int256 b) returns (int256)
; ============================================================================
; Implementasi internal untuk signed division.
; Menggunakan helper di 0x0759 untuk operasi pembagian dengan pengecekan.
;
; Stack saat masuk: [b, a, return_addr, ...]
; Stack saat keluar: [result, return_addr, ...]
;
; CATATAN tentang SIGNED DIVISION:
; Solidity/EVM menggunakan two's complement untuk angka signed.
; - Angka positif: sama dengan unsigned
; - Angka negatif: diwakili dengan most significant bit = 1
; - Contoh: -1 = 0xFFFF...FFFF (256-bit)
;
; Aturan pembagian signed:
; - (+) / (+) = (+)  → 10 / 3 = 3
; - (+) / (-) = (-)  → 10 / -3 = -3
; - (-) / (+) = (-)  → -10 / 3 = -3
; - (-) / (-) = (+)  → -10 / -3 = 3

00000320: PUSH0
; Push placeholder untuk result.
;
; Gas cost: 2 gas

00000321: DUP2
; Duplikat b (divisor).
;
; Gas cost: 3 gas

00000322: DUP4
; Duplikat a (dividend).
;
; Gas cost: 3 gas

00000323: PUSH2 0x032c
; Push return address setelah helper.
;
; Gas cost: 3 gas

00000326: SWAP2
; Rearrange stack untuk parameter.
;
; Gas cost: 3 gas

00000327: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000328: PUSH2 0x0759
; Push alamat helper untuk subtraction/division dengan underflow check.
; Helper ini akan melakukan operasi yang aman dengan pengecekan error.
;
; Gas cost: 3 gas

0000032b: JUMP
; Lompat ke helper.
;
; Gas cost: 8 gas

0000032c: JUMPDEST
; Return point dari helper.

0000032d: SWAP1
; Rearrange hasil.
;
; Gas cost: 3 gas

0000032e: POP
; Cleanup placeholder.
;
; Gas cost: 2 gas

0000032f: SWAP3
; Rearrange untuk return.
;
; Gas cost: 3 gas

00000330: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000331: POP
; Cleanup.
;
; Gas cost: 2 gas

00000332: POP
; Cleanup.
;
; Gas cost: 2 gas

00000333: JUMP
; Return ke caller dengan result.
;
; Gas cost: 8 gas

00000334: JUMPDEST
00000335: PUSH0
00000336: PUSH0
00000337: DUP3
00000338: SUB
00000339: PUSH2 0x0377
0000033c: JUMPI
0000033d: PUSH1 0x40
0000033f: MLOAD
00000340: PUSH32 0x08c379a000000000000000000000000000000000000000000000000000000000
00000361: DUP2
00000362: MSTORE
00000363: PUSH1 0x04
00000365: ADD
00000366: PUSH2 0x036e
00000369: SWAP1
0000036a: PUSH2 0x07e4
0000036d: JUMP
0000036e: JUMPDEST
0000036f: PUSH1 0x40
00000371: MLOAD
00000372: DUP1
00000373: SWAP2
00000374: SUB
00000375: SWAP1
00000376: REVERT
00000377: JUMPDEST
00000378: DUP2
00000379: DUP4
0000037a: PUSH2 0x0383
0000037d: SWAP2
0000037e: SWAP1
0000037f: PUSH2 0x0802
00000382: JUMP
00000383: JUMPDEST
00000384: SWAP1
00000385: POP
00000386: SWAP3
00000387: SWAP2
00000388: POP
00000389: POP
0000038a: JUMP
0000038b: JUMPDEST
0000038c: PUSH0
0000038d: PUSH0
0000038e: REVERT
0000038f: JUMPDEST
00000390: PUSH0
00000391: DUP2
00000392: SWAP1
00000393: POP
00000394: SWAP2
00000395: SWAP1
00000396: POP
00000397: JUMP
00000398: JUMPDEST
00000399: PUSH2 0x03a1
0000039c: DUP2
0000039d: PUSH2 0x038f
000003a0: JUMP
000003a1: JUMPDEST
000003a2: DUP2
000003a3: EQ
000003a4: PUSH2 0x03ab
000003a7: JUMPI
000003a8: PUSH0
000003a9: PUSH0
000003aa: REVERT
000003ab: JUMPDEST
000003ac: POP
000003ad: JUMP
000003ae: JUMPDEST
000003af: PUSH0
000003b0: DUP2
000003b1: CALLDATALOAD
000003b2: SWAP1
000003b3: POP
000003b4: PUSH2 0x03bc
000003b7: DUP2
000003b8: PUSH2 0x0398
000003bb: JUMP
000003bc: JUMPDEST
000003bd: SWAP3
000003be: SWAP2
000003bf: POP
000003c0: POP
000003c1: JUMP
000003c2: JUMPDEST
; ============================================================================
; HELPER: ABI Decode untuk 2 Arguments (uint256, uint256)
; Alamat: 0x03c2 (relative ke runtime code)
; ============================================================================
; Fungsi helper ini melakukan decoding calldata ABI untuk 2 parameter uint256.
; Digunakan oleh fungsi add, sub, mul, div, mod, exp, signedDiv.
;
; Tugas utama:
; 1. Validasi ukuran calldata cukup (minimal 64 bytes untuk 2 uint256)
; 2. Baca nilai pertama dari calldata[offset]
; 3. Baca nilai kedua dari calldata[offset+32]
; 4. Return kedua nilai di stack

000003c3: PUSH0
; Push 0 sebagai placeholder untuk nilai pertama yang akan di-decode.
;
; Gas cost: 2 gas

000003c4: PUSH0
; Push 0 sebagai placeholder untuk nilai kedua yang akan di-decode.
;
; Gas cost: 2 gas

000003c5: PUSH1 0x40
; Push 0x40 (64 dalam desimal) - ukuran minimal yang dibutuhkan.
; 2 arguments × 32 bytes = 64 bytes.
;
; Gas cost: 3 gas

000003c7: DUP4
; Duplikat start offset dari parameter.
;
; Gas cost: 3 gas

000003c8: DUP6
; Duplikat end offset dari parameter.
;
; Gas cost: 3 gas

000003c9: SUB
; Hitung ukuran arguments: end - start.
;
; Gas cost: 3 gas

000003ca: SLT
; SLT (Signed Less Than) - Opcode 0x12
; ============================================================================
; Perbandingan SIGNED: apakah nilai kedua < nilai pertama?
;
; Cara kerja SLT:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Interpretasikan keduanya sebagai SIGNED integers (two's complement)
; 3. Push 1 jika b < a (signed), push 0 jika b >= a
;
; PERBEDAAN SLT vs LT:
; - LT (0x10): Perbandingan UNSIGNED
;   Contoh: 0xFF...FF < 0x01? → false (karena FF...FF adalah angka besar)
; - SLT (0x12): Perbandingan SIGNED
;   Contoh: 0xFF...FF < 0x01? → true (karena FF...FF = -1 dalam signed)
;
; Kondisi stack di sini:
;   Stack: [0x40, args_size]
;   Cek: args_size < 0x40? (apakah ukuran args kurang dari 64 bytes?)
;
; Mengapa SLT, bukan LT?
; Dalam konteks ini, perbedaannya tidak signifikan karena ukuran calldata
; selalu positif. Namun SLT digunakan untuk konsistensi dengan Solidity
; yang menggunakan signed comparison untuk bounds checking.
;
; Penggunaan umum SLT:
; 1. Membandingkan angka yang bisa negatif (int256)
; 2. Bounds checking pada array dengan index signed
; 3. Validasi range untuk nilai yang bisa negatif
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#12

000003cb: ISZERO
; Invert hasil: jika args_size < 0x40 → SLT = 1 → ISZERO = 0 (gagal)
;              jika args_size >= 0x40 → SLT = 0 → ISZERO = 1 (lanjut)
;
; Gas cost: 3 gas

000003cc: PUSH2 0x03d8
; Push alamat untuk skip error jika validasi berhasil.
;
; Gas cost: 3 gas

000003cf: JUMPI
; Jika ISZERO = 1 (args cukup), skip error handling.
; Jika ISZERO = 0 (args kurang), jatuh ke error handler.
;
; Gas cost: 10 gas

000003d0: PUSH2 0x03d7
; Calldata terlalu pendek - push error info.
;
; Gas cost: 3 gas

000003d3: PUSH2 0x038b
; Push address error handler.
;
; Gas cost: 3 gas

000003d6: JUMP
; Jump ke error handler untuk REVERT.
;
; Gas cost: 8 gas

000003d7: JUMPDEST
; Landing point setelah validasi berhasil.

000003d8: JUMPDEST
; Extra JUMPDEST (dari compiler).

000003d9: PUSH0
000003da: PUSH2 0x03e5
000003dd: DUP6
000003de: DUP3
000003df: DUP7
000003e0: ADD
000003e1: PUSH2 0x03ae
000003e4: JUMP
000003e5: JUMPDEST
000003e6: SWAP3
000003e7: POP
000003e8: POP
000003e9: PUSH1 0x20
000003eb: PUSH2 0x03f6
000003ee: DUP6
000003ef: DUP3
000003f0: DUP7
000003f1: ADD
000003f2: PUSH2 0x03ae
000003f5: JUMP
000003f6: JUMPDEST
000003f7: SWAP2
000003f8: POP
000003f9: POP
000003fa: SWAP3
000003fb: POP
000003fc: SWAP3
000003fd: SWAP1
000003fe: POP
000003ff: JUMP
00000400: JUMPDEST
00000401: PUSH2 0x0409
00000404: DUP2
00000405: PUSH2 0x038f
00000408: JUMP
00000409: JUMPDEST
0000040a: DUP3
0000040b: MSTORE
0000040c: POP
0000040d: POP
0000040e: JUMP
0000040f: JUMPDEST
00000410: PUSH0
00000411: PUSH1 0x20
00000413: DUP3
00000414: ADD
00000415: SWAP1
00000416: POP
00000417: PUSH2 0x0422
0000041a: PUSH0
0000041b: DUP4
0000041c: ADD
0000041d: DUP5
0000041e: PUSH2 0x0400
00000421: JUMP
00000422: JUMPDEST
00000423: SWAP3
00000424: SWAP2
00000425: POP
00000426: POP
00000427: JUMP
00000428: JUMPDEST
; ============================================================================
; HELPER: ABI Decode untuk 3 Arguments (uint256, uint256, uint256)
; Alamat: 0x0428 (relative ke runtime code)
; ============================================================================
; Fungsi helper ini melakukan decoding calldata ABI untuk 3 parameter uint256.
; Digunakan oleh fungsi addmod dan mulmod.
;
; Tugas utama:
; 1. Validasi ukuran calldata cukup (minimal 96 bytes untuk 3 uint256)
; 2. Baca nilai pertama dari calldata[offset]
; 3. Baca nilai kedua dari calldata[offset+32]
; 4. Baca nilai ketiga dari calldata[offset+64]
; 5. Return ketiga nilai di stack
;
; Contoh calldata untuk addmod(5, 10, 3):
;   [4 bytes selector][32 bytes: 5][32 bytes: 10][32 bytes: 3]
;   Total: 4 + 32 + 32 + 32 = 100 bytes

00000429: PUSH0
; Push placeholder untuk nilai pertama.
;
; Gas cost: 2 gas

0000042a: PUSH0
; Push placeholder untuk nilai kedua.
;
; Gas cost: 2 gas

0000042b: PUSH0
; Push placeholder untuk nilai ketiga.
;
; Gas cost: 2 gas

0000042c: PUSH1 0x60
; Push 0x60 (96 desimal) - ukuran minimal yang dibutuhkan.
; 3 arguments × 32 bytes = 96 bytes.
;
; Gas cost: 3 gas

0000042e: DUP5
; Duplikat start offset.
;
; Gas cost: 3 gas

0000042f: DUP7
; Duplikat end offset.
;
; Gas cost: 3 gas

00000430: SUB
; Hitung ukuran: end - start.
;
; Gas cost: 3 gas

00000431: SLT
; SLT - Cek apakah ukuran < 96 (tidak cukup untuk 3 args).
;
; Gas cost: 3 gas

00000432: ISZERO
; Invert: true jika ukuran >= 96 (cukup).
;
; Gas cost: 3 gas

00000433: PUSH2 0x043f
; Push alamat skip error.
;
; Gas cost: 3 gas

00000436: JUMPI
; Skip error jika calldata cukup.
;
; Gas cost: 10 gas

00000437: PUSH2 0x043e
; Calldata tidak cukup - push error info.
;
; Gas cost: 3 gas

0000043a: PUSH2 0x038b
; Push error handler address.
;
; Gas cost: 3 gas

0000043d: JUMP
; Jump ke error handler untuk REVERT.
;
; Gas cost: 8 gas

0000043e: JUMPDEST
; Landing point setelah validasi.

0000043f: JUMPDEST
; Extra JUMPDEST.

00000440: PUSH0
; Offset untuk argument pertama: 0.
;
; Gas cost: 2 gas

00000441: PUSH2 0x044c
; Push return address setelah decode arg 1.
;
; Gas cost: 3 gas

00000444: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000445: DUP3
; Duplikat argument offset (0).
;
; Gas cost: 3 gas

00000446: DUP8
; Duplikat end offset.
;
; Gas cost: 3 gas

00000447: ADD
; Hitung absolute offset: calldata_offset + arg_offset.
;
; Gas cost: 3 gas

00000448: PUSH2 0x03ae
; Push alamat helper untuk decode single uint256.
;
; Gas cost: 3 gas

0000044b: JUMP
; Decode argument pertama.
;
; Gas cost: 8 gas

0000044c: JUMPDEST
; Return dari decode arg 1.

0000044d: SWAP4
; Simpan arg1 ke posisi yang tepat.
;
; Gas cost: 3 gas

0000044e: POP
; Cleanup.
;
; Gas cost: 2 gas

0000044f: POP
; Cleanup.
;
; Gas cost: 2 gas

00000450: PUSH1 0x20
; Offset untuk argument kedua: 32.
;
; Gas cost: 3 gas

00000452: PUSH2 0x045d
; Push return address setelah decode arg 2.
;
; Gas cost: 3 gas

00000455: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000456: DUP3
; Duplikat argument offset (32).
;
; Gas cost: 3 gas

00000457: DUP8
; Duplikat untuk calculation.
;
; Gas cost: 3 gas

00000458: ADD
; Hitung absolute offset: calldata_offset + 32.
;
; Gas cost: 3 gas

00000459: PUSH2 0x03ae
; Push alamat decode helper.
;
; Gas cost: 3 gas

0000045c: JUMP
; Decode argument kedua.
;
; Gas cost: 8 gas

0000045d: JUMPDEST
; Return dari decode arg 2.

0000045e: SWAP3
; Simpan arg2.
;
; Gas cost: 3 gas

0000045f: POP
; Cleanup.
;
; Gas cost: 2 gas

00000460: POP
; Cleanup.
;
; Gas cost: 2 gas

00000461: PUSH1 0x40
; Offset untuk argument ketiga: 64.
;
; Gas cost: 3 gas

00000463: PUSH2 0x046e
; Push return address setelah decode arg 3.
;
; Gas cost: 3 gas

00000466: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000467: DUP3
00000468: DUP8
00000469: ADD
0000046a: PUSH2 0x03ae
0000046d: JUMP
0000046e: JUMPDEST
0000046f: SWAP2
00000470: POP
00000471: POP
00000472: SWAP3
00000473: POP
00000474: SWAP3
00000475: POP
00000476: SWAP3
00000477: JUMP
00000478: JUMPDEST
; ============================================================================
; PANIC HANDLER: Arithmetic Overflow/Underflow (Error Code 0x11)
; ============================================================================
; Handler ini dipanggil ketika terjadi arithmetic overflow atau underflow.
; Ini adalah bagian dari Solidity 0.8+ yang secara otomatis mengecek
; overflow/underflow dan me-revert jika terdeteksi.
;
; Error format: Panic(uint256)
; - Selector: 0x4e487b71 = keccak256("Panic(uint256)")[:4]
; - Error code 0x11 = 17 dalam desimal
;
; Panic error codes (EIP-4399):
; 0x00: Generic/compiler panic
; 0x01: Assert failed
; 0x11: Arithmetic overflow/underflow
; 0x12: Division or modulo by zero
; 0x21: Conversion to enum with invalid value
; 0x22: Storage byte array incorrectly encoded
; 0x31: Pop on empty array
; 0x32: Array index out of bounds
; 0x41: Memory allocation too large
; 0x51: Internal function type error

00000479: PUSH32 0x4e487b7100000000000000000000000000000000000000000000000000000000
; Push selector untuk Panic(uint256).
; Ini adalah 4 bytes pertama dari keccak256("Panic(uint256)").
;
; Gas cost: 3 gas

0000049a: PUSH0
; Push offset 0 untuk MSTORE.
;
; Gas cost: 2 gas

0000049b: MSTORE
; Simpan selector ke memory[0:32].
; memory[0:4] = 0x4e487b71 (selector)
; memory[4:32] = 0x00...00 (padding)
;
; Gas cost: 3 gas + memory expansion

0000049c: PUSH1 0x11
; Push error code 0x11 (17) = Arithmetic overflow/underflow.
; Ini memberitahu caller MENGAPA transaksi gagal.
;
; Gas cost: 3 gas

0000049e: PUSH1 0x04
; Push offset 4 untuk MSTORE.
; Error code akan disimpan setelah selector.
;
; Gas cost: 3 gas

000004a0: MSTORE
; Simpan error code ke memory[4:36].
; memory[0:4] = selector
; memory[4:36] = error code (0x11 dengan padding)
;
; Gas cost: 3 gas

000004a1: PUSH1 0x24
; Push 0x24 (36) = size of error data.
; 4 bytes selector + 32 bytes error code = 36 bytes.
;
; Gas cost: 3 gas

000004a3: PUSH0
; Push 0 = offset di memory.
;
; Gas cost: 2 gas

000004a4: REVERT
; REVERT dengan error data Panic(0x11).
; Caller akan melihat "Panic: Arithmetic overflow/underflow".
;
; Di etherscan/block explorer, error ini ditampilkan sebagai:
; "execution reverted: Panic: Arithmetic operation underflowed or overflowed"
;
; Gas cost: 0 gas (transaksi tetap gagal, sisa gas dikembalikan)

000004a5: JUMPDEST
000004a6: PUSH0
000004a7: DUP2
000004a8: PUSH1 0x01
000004aa: SHR
000004ab: SWAP1
000004ac: POP
000004ad: SWAP2
000004ae: SWAP1
000004af: POP
000004b0: JUMP
000004b1: JUMPDEST
; ============================================================================
; HELPER: Exponentiation dengan algoritma "Square and Multiply"
; ============================================================================
; Ini adalah implementasi efisien untuk menghitung base^exp dengan
; algoritma binary exponentiation (square and multiply).
;
; Algoritma ini menghitung a^n dalam O(log n) perkalian, bukan O(n).
; Contoh: 2^10 = ((2^2)^2 * 2)^2 = hanya 4 perkalian, bukan 10!

000004b2: PUSH0
; Initialize result placeholder.

000004b3: PUSH0
; Initialize accumulator placeholder.

000004b4: DUP3
; Duplikat base.

000004b5: SWAP2
; Rearrange stack.

000004b6: POP
; Cleanup.

000004b7: DUP4
; Duplikat exp.

000004b8: SWAP1
; Rearrange.

000004b9: POP
; Cleanup.

000004ba: JUMPDEST
; Loop entry point untuk square and multiply.

000004bb: PUSH1 0x01
; Push 1 untuk perbandingan.

000004bd: DUP6
; Duplikat current exponent.

000004be: GT
; Cek apakah exp > 1 (masih perlu iterasi).

000004bf: ISZERO
; Invert: true jika exp <= 1 (loop selesai).

000004c0: PUSH2 0x04fa
; Alamat keluar loop.

000004c3: JUMPI
; Jump keluar jika exp <= 1.

000004c4: DUP1
; Duplikat current result.

000004c5: DUP7
; Duplikat MAX_UINT atau base.

000004c6: DIV
; DIV (Division) - Opcode 0x04
; ============================================================================
; Integer division (pembagian bulat) unsigned.
;
; Cara kerja DIV:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Hitung b / a (integer division, hasil dibulatkan ke bawah)
; 3. Push hasil ke stack
;
; PENTING - Urutan operand:
; Stack: [a, b] → hasil: b / a (BUKAN a / b!)
; Ini sering membingungkan pemula.
;
; Pembagian dengan 0:
; Jika a = 0, hasil adalah 0 (BUKAN error!)
; Ini berbeda dengan bahasa pemrograman lain.
;
; Contoh:
;   DIV(10, 3) → 10 / 3 = 3 (bukan 3.33)
;   DIV(0, 5) → 5 / 0 = 0 (bukan error!)
;
; Gas cost: 5 gas
;
; Referensi:
; - https://www.evm.codes/#04

000004c7: DUP2
; Duplikat untuk overflow check.

000004c8: GT
; Cek overflow.

000004c9: ISZERO
; Invert result.

000004ca: PUSH2 0x04d6
; Alamat untuk continue loop.

000004cd: JUMPI
; Skip panic jika tidak overflow.

000004ce: PUSH2 0x04d5
; Overflow detected - push panic info.

000004d1: PUSH2 0x0478
; Push panic handler address.

000004d4: JUMP
; Jump ke panic handler.

000004d5: JUMPDEST
; Landing point setelah overflow check.

000004d6: JUMPDEST
; Extra JUMPDEST.

000004d7: PUSH1 0x01
; Push 1 untuk AND operation.

000004d9: DUP6
; Duplikat current exponent.

000004da: AND
; AND (Bitwise AND) - Opcode 0x16
; ============================================================================
; Operasi logika AND bit per bit antara dua nilai.
;
; Cara kerja AND:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Lakukan operasi AND untuk setiap pasangan bit: a[i] AND b[i]
; 3. Push hasil ke stack
;
; Tabel kebenaran AND (per bit):
;   0 AND 0 = 0
;   0 AND 1 = 0
;   1 AND 0 = 0
;   1 AND 1 = 1
;
; Kondisi stack di sini:
;   Stack: [exp, 0x01]
;   Operasi: exp AND 1
;
; Mengapa exp AND 1?
; Ini adalah cara klasik untuk mengecek apakah angka GENAP atau GANJIL!
; - Jika exp genap: bit terakhir = 0, maka exp AND 1 = 0
; - Jika exp ganjil: bit terakhir = 1, maka exp AND 1 = 1
;
; Contoh:
;   5 = 0b101 → 5 AND 1 = 1 (ganjil)
;   8 = 0b1000 → 8 AND 1 = 0 (genap)
;
; Dalam konteks "Square and Multiply":
; Algoritma ini menghitung base^exp dengan efisien:
; - Setiap iterasi, kita "square" base (base = base * base)
; - Jika bit exponent = 1 (ganjil), kita "multiply" result dengan base
; - Shift exponent ke kanan (exp = exp / 2)
;
; Penggunaan umum AND:
; 1. Cek genap/ganjil: n AND 1
; 2. Masking bits: value AND 0xFF (ambil 8 bit terakhir)
; 3. Clear bits: value AND NOT(mask)
; 4. Cek flag: flags AND FLAG_BIT
;
; Analogi sederhana:
; AND seperti "filter" yang hanya meloloskan bit yang "nyala" di kedua operand.
; Bayangkan dua pelat berlubang yang ditumpuk - cahaya hanya lewat
; dimana KEDUA pelat memiliki lubang.
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#16

000004db: ISZERO
; true jika bit terakhir = 0 (exp genap).

000004dc: PUSH2 0x04e5
; Skip multiplication jika exp genap.

000004df: JUMPI
; Conditional jump.

000004e0: DUP1
; Duplikat base untuk perkalian.

000004e1: DUP3
; Duplikat current result.

000004e2: MUL
; MUL (Multiplication) - Opcode 0x02
; ============================================================================
; Integer multiplication (perkalian) unsigned.
;
; Cara kerja MUL:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Hitung a * b
; 3. Push hasil ke stack (modulo 2^256)
;
; PENTING tentang OVERFLOW:
; Sama seperti ADD, MUL adalah operasi modular 2^256.
; Jika hasil melebihi MAX_UINT256, akan "wrap around".
; TIDAK ada error saat overflow!
;
; Contoh:
;   MUL(3, 4) → 3 * 4 = 12
;   MUL(2^128, 2^128) → 2^256 mod 2^256 = 0 (overflow!)
;
; Gas cost: 5 gas
;
; Referensi:
; - https://www.evm.codes/#02

000004e3: SWAP2
; result = result * base (update accumulator).

000004e4: POP
; Cleanup old result.

000004e5: JUMPDEST
; Landing point untuk "multiply" step.

000004e6: DUP1
; Duplikat base.

000004e7: DUP2
; Duplikat base lagi.

000004e8: MUL
; base = base * base (square step)
; Ini adalah bagian "square" dari "square and multiply".

000004e9: SWAP1
; Update base.

000004ea: POP
; Cleanup old base.

000004eb: PUSH2 0x04f3
; Push return address untuk recursive call.

000004ee: DUP6
; Duplikat exponent.

000004ef: PUSH2 0x04a5
; Push address untuk SHR (shift right by 1).

000004f2: JUMP
; Jump ke shift exp right (exp = exp / 2).
000004f3: JUMPDEST
000004f4: SWAP5
000004f5: POP
000004f6: PUSH2 0x04ba
000004f9: JUMP
000004fa: JUMPDEST
000004fb: SWAP5
000004fc: POP
000004fd: SWAP5
000004fe: SWAP3
000004ff: POP
00000500: POP
00000501: POP
00000502: JUMP
00000503: JUMPDEST
00000504: PUSH0
00000505: DUP3
00000506: PUSH2 0x0512
00000509: JUMPI
0000050a: PUSH1 0x01
0000050c: SWAP1
0000050d: POP
0000050e: PUSH2 0x05cd
00000511: JUMP
00000512: JUMPDEST
00000513: DUP2
00000514: PUSH2 0x051f
00000517: JUMPI
00000518: PUSH0
00000519: SWAP1
0000051a: POP
0000051b: PUSH2 0x05cd
0000051e: JUMP
0000051f: JUMPDEST
00000520: DUP2
00000521: PUSH1 0x01
00000523: DUP2
00000524: EQ
00000525: PUSH2 0x0535
00000528: JUMPI
00000529: PUSH1 0x02
0000052b: DUP2
0000052c: EQ
0000052d: PUSH2 0x053f
00000530: JUMPI
00000531: PUSH2 0x056e
00000534: JUMP
00000535: JUMPDEST
00000536: PUSH1 0x01
00000538: SWAP2
00000539: POP
0000053a: POP
0000053b: PUSH2 0x05cd
0000053e: JUMP
0000053f: JUMPDEST
00000540: PUSH1 0xff
00000542: DUP5
00000543: GT
00000544: ISZERO
00000545: PUSH2 0x0551
00000548: JUMPI
00000549: PUSH2 0x0550
0000054c: PUSH2 0x0478
0000054f: JUMP
00000550: JUMPDEST
00000551: JUMPDEST
; Fallback untuk kasus exp yang tidak teroptimasi.

00000552: DUP4
; Duplikat exponent.

00000553: PUSH1 0x02
; Push base 2 untuk operasi 2^exp.

00000555: EXP
; EXP (Exponentiation) - Opcode 0x0a
; ============================================================================
; Operasi eksponensial (pangkat) unsigned.
;
; Cara kerja EXP:
; 1. Pop 2 nilai dari stack: a (top, base), b (second, exponent)
; 2. Hitung a^b (a pangkat b)
; 3. Push hasil ke stack (modulo 2^256)
;
; PENTING - Urutan operand:
; Stack: [exponent, base] → hasil: base^exponent
;
; Contoh:
;   EXP(3, 2) → 2^3 = 8
;   EXP(10, 2) → 2^10 = 1024
;   EXP(256, 2) → 2^256 = 0 (overflow, wrap around!)
;
; BIAYA GAS KHUSUS:
; EXP adalah salah satu opcode dengan gas cost DINAMIS:
; - Base cost: 10 gas
; - Per-byte cost: 50 gas per byte dari exponent
; Contoh: EXP(255, x) → 10 + 50*1 = 60 gas (255 = 1 byte)
;         EXP(256, x) → 10 + 50*2 = 110 gas (256 = 2 bytes)
;
; Karena biaya gas yang tinggi, Solidity compiler sering mengoptimasi
; kasus-kasus umum seperti 2^n dengan shift operations.
;
; Analogi sederhana:
; EXP seperti menghitung "2 dikali dirinya sendiri sebanyak n kali".
; 2^3 = 2 × 2 × 2 = 8
;
; Penggunaan umum:
; 1. Menghitung powers of 2 untuk bitmasks
; 2. Token decimal conversion (10^18 untuk Wei)
; 3. Mathematical calculations
;
; Gas cost: 10 + 50 * byte_size(exponent)
;
; Referensi:
; - https://www.evm.codes/#0a

00000556: SWAP2
00000557: POP
00000558: DUP5
00000559: DUP3
0000055a: GT
0000055b: ISZERO
0000055c: PUSH2 0x0568
0000055f: JUMPI
00000560: PUSH2 0x0567
00000563: PUSH2 0x0478
00000566: JUMP
00000567: JUMPDEST
00000568: JUMPDEST
00000569: POP
0000056a: PUSH2 0x05cd
0000056d: JUMP
0000056e: JUMPDEST
; ============================================================================
; HELPER: Exponentiation Optimization Check
; ============================================================================
; Bagian ini melakukan pengecekan apakah kita bisa menggunakan optimisasi
; untuk kasus-kasus eksponensial yang umum dan bisa dihitung dengan cepat.
;
; Logika optimisasi:
; - Cek apakah (exp < 0x20 AND base < 0x133) OR (exp < 0x4e AND base < 0x0b)
; - Jika true, gunakan opcode EXP langsung (lebih efisien untuk kasus kecil)
; - Jika false, gunakan algoritma square-and-multiply

0000056f: POP
; Cleanup stack.
;
; Gas cost: 2 gas

00000570: PUSH1 0x20
; Push 0x20 (32 desimal) - threshold exponent pertama.
;
; Gas cost: 3 gas

00000572: DUP4
; Duplikat exponent.
;
; Gas cost: 3 gas

00000573: LT
; LT - Cek apakah exp < 32.
;
; Gas cost: 3 gas

00000574: PUSH2 0x0133
; Push 0x0133 (307 desimal) - threshold base pertama.
;
; Gas cost: 3 gas

00000577: DUP4
; Duplikat base.
;
; Gas cost: 3 gas

00000578: LT
; LT - Cek apakah base < 307.
;
; Gas cost: 3 gas

00000579: AND
; Kombinasi: (exp < 32) AND (base < 307)
; Jika kedua kondisi true, ini adalah "small exponentiation" yang aman.
;
; Gas cost: 3 gas

0000057a: PUSH1 0x4e
; Push 0x4e (78 desimal) - threshold exponent kedua.
;
; Gas cost: 3 gas

0000057c: DUP5
; Duplikat exponent.
;
; Gas cost: 3 gas

0000057d: LT
; LT - Cek apakah exp < 78.
;
; Gas cost: 3 gas

0000057e: PUSH1 0x0b
; Push 0x0b (11 desimal) - threshold base kedua.
;
; Gas cost: 3 gas

00000580: DUP5
; Duplikat base.
;
; Gas cost: 3 gas

00000581: LT
; LT - Cek apakah base < 11.
;
; Gas cost: 3 gas

00000582: AND
; Kombinasi: (exp < 78) AND (base < 11)
; Kondisi kedua untuk optimisasi.
;
; Gas cost: 3 gas

00000583: OR
; OR (Bitwise OR) - Opcode 0x17
; ============================================================================
; Operasi logika OR bit per bit antara dua nilai.
;
; Cara kerja OR:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Lakukan operasi OR untuk setiap pasangan bit: a[i] OR b[i]
; 3. Push hasil ke stack
;
; Tabel kebenaran OR (per bit):
;   0 OR 0 = 0
;   0 OR 1 = 1
;   1 OR 0 = 1
;   1 OR 1 = 1
;
; Kondisi stack di sini:
;   Stack: [kondisi2, kondisi1]
;   - kondisi1 = (exp < 32) AND (base < 307)
;   - kondisi2 = (exp < 78) AND (base < 11)
;
; Hasil OR:
;   True jika SALAH SATU (atau kedua) kondisi terpenuhi.
;   Ini menentukan apakah kita bisa gunakan EXP langsung atau perlu
;   algoritma square-and-multiply.
;
; Penggunaan umum OR:
; 1. Menggabungkan kondisi: condition1 OR condition2
; 2. Set bits: value OR mask
; 3. Combine flags: flags1 OR flags2
;
; Analogi sederhana:
; OR seperti dua saklar yang paralel - lampu menyala jika SALAH SATU
; atau KEDUA saklar ON.
;
; Gas cost: 3 gas
;
; Referensi:
; - https://www.evm.codes/#17

00000584: ISZERO
; Invert hasil OR:
; - Jika OR = 1 (bisa optimisasi): ISZERO = 0 → tidak jump, pakai EXP langsung
; - Jika OR = 0 (perlu full algo): ISZERO = 1 → jump ke square-and-multiply
;
; Gas cost: 3 gas

00000585: PUSH2 0x05a3
; Push alamat untuk case yang perlu square-and-multiply.
;
; Gas cost: 3 gas

00000588: JUMPI
; Conditional jump berdasarkan hasil ISZERO.
;
; Gas cost: 10 gas

00000589: DUP3
; Jika sampai sini, kita bisa pakai optimisasi langsung.
; Duplikat base untuk EXP.
;
; Gas cost: 3 gas

0000058a: DUP3
; Duplikat exponent untuk EXP.
;
; Gas cost: 3 gas

0000058b: EXP
0000058c: SWAP1
0000058d: POP
0000058e: DUP4
0000058f: DUP2
00000590: GT
00000591: ISZERO
00000592: PUSH2 0x059e
00000595: JUMPI
00000596: PUSH2 0x059d
00000599: PUSH2 0x0478
0000059c: JUMP
0000059d: JUMPDEST
0000059e: JUMPDEST
0000059f: PUSH2 0x05cd
000005a2: JUMP
000005a3: JUMPDEST
000005a4: PUSH2 0x05b0
000005a7: DUP5
000005a8: DUP5
000005a9: DUP5
000005aa: PUSH1 0x01
000005ac: PUSH2 0x04b1
000005af: JUMP
000005b0: JUMPDEST
000005b1: SWAP3
000005b2: POP
000005b3: SWAP1
000005b4: POP
000005b5: DUP2
000005b6: DUP5
000005b7: DIV
000005b8: DUP2
000005b9: GT
000005ba: ISZERO
000005bb: PUSH2 0x05c7
000005be: JUMPI
000005bf: PUSH2 0x05c6
000005c2: PUSH2 0x0478
000005c5: JUMP
000005c6: JUMPDEST
000005c7: JUMPDEST
000005c8: DUP2
000005c9: DUP2
000005ca: MUL
000005cb: SWAP1
000005cc: POP
000005cd: JUMPDEST
000005ce: SWAP4
000005cf: SWAP3
000005d0: POP
000005d1: POP
000005d2: POP
000005d3: JUMP
000005d4: JUMPDEST
000005d5: PUSH0
000005d6: PUSH2 0x05de
000005d9: DUP3
000005da: PUSH2 0x038f
000005dd: JUMP
000005de: JUMPDEST
000005df: SWAP2
000005e0: POP
000005e1: PUSH2 0x05e9
000005e4: DUP4
000005e5: PUSH2 0x038f
000005e8: JUMP
000005e9: JUMPDEST
000005ea: SWAP3
000005eb: POP
000005ec: PUSH2 0x0616
000005ef: PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
00000610: DUP5
00000611: DUP5
00000612: PUSH2 0x0503
00000615: JUMP
00000616: JUMPDEST
00000617: SWAP1
00000618: POP
00000619: SWAP3
0000061a: SWAP2
0000061b: POP
0000061c: POP
0000061d: JUMP
0000061e: JUMPDEST
0000061f: PUSH0
00000620: PUSH2 0x0628
00000623: DUP3
00000624: PUSH2 0x038f
00000627: JUMP
00000628: JUMPDEST
00000629: SWAP2
0000062a: POP
0000062b: PUSH2 0x0633
0000062e: DUP4
0000062f: PUSH2 0x038f
00000632: JUMP
00000633: JUMPDEST
00000634: SWAP3
00000635: POP
00000636: DUP3
00000637: DUP3
00000638: ADD
00000639: SWAP1
0000063a: POP
0000063b: DUP1
0000063c: DUP3
0000063d: GT
0000063e: ISZERO
0000063f: PUSH2 0x064b
00000642: JUMPI
00000643: PUSH2 0x064a
00000646: PUSH2 0x0478
00000649: JUMP
0000064a: JUMPDEST
0000064b: JUMPDEST
0000064c: SWAP3
0000064d: SWAP2
0000064e: POP
0000064f: POP
00000650: JUMP
00000651: JUMPDEST
00000652: PUSH0
00000653: DUP3
00000654: DUP3
00000655: MSTORE
00000656: PUSH1 0x20
00000658: DUP3
00000659: ADD
0000065a: SWAP1
0000065b: POP
0000065c: SWAP3
0000065d: SWAP2
0000065e: POP
0000065f: POP
00000660: JUMP
00000661: JUMPDEST
; ============================================================================
; STRING CONSTANT: "Division by zero"
; ============================================================================
; Helper untuk menyimpan string error "Division by zero" ke memory.
; Digunakan oleh fungsi div() untuk menampilkan pesan error yang jelas
; ketika divisor adalah 0.
;
; String dalam hex:
; 0x4469766973696f6e206279207a65726f = "Division by zero"
;   44 = 'D'
;   69 = 'i'
;   76 = 'v'
;   69 = 'i'
;   73 = 's'
;   69 = 'i'
;   6f = 'o'
;   6e = 'n'
;   20 = ' ' (space)
;   62 = 'b'
;   79 = 'y'
;   20 = ' ' (space)
;   7a = 'z'
;   65 = 'e'
;   72 = 'r'
;   6f = 'o'
;
; Panjang string: 16 karakter (0x10)

00000662: PUSH32 0x4469766973696f6e206279207a65726f00000000000000000000000000000000
; Push string "Division by zero" dengan padding zeros.
; 32 bytes total, 16 bytes string + 16 bytes padding.
;
; Gas cost: 3 gas

00000683: PUSH0
; Push offset 0 (relative ke posisi penulisan).
;
; Gas cost: 2 gas

00000684: DUP3
; Duplikat memory destination.
;
; Gas cost: 3 gas

00000685: ADD
; Hitung absolute memory address.
;
; Gas cost: 3 gas

00000686: MSTORE
; Simpan string ke memory.
;
; Gas cost: 3 gas

00000687: POP
; Cleanup stack.
;
; Gas cost: 2 gas

00000688: JUMP
; Return ke caller.
;
; Gas cost: 8 gas
00000689: JUMPDEST
0000068a: PUSH0
0000068b: PUSH2 0x0695
0000068e: PUSH1 0x10
00000690: DUP4
00000691: PUSH2 0x0651
00000694: JUMP
00000695: JUMPDEST
00000696: SWAP2
00000697: POP
00000698: PUSH2 0x06a0
0000069b: DUP3
0000069c: PUSH2 0x0661
0000069f: JUMP
000006a0: JUMPDEST
000006a1: PUSH1 0x20
000006a3: DUP3
000006a4: ADD
000006a5: SWAP1
000006a6: POP
000006a7: SWAP2
000006a8: SWAP1
000006a9: POP
000006aa: JUMP
000006ab: JUMPDEST
000006ac: PUSH0
000006ad: PUSH1 0x20
000006af: DUP3
000006b0: ADD
000006b1: SWAP1
000006b2: POP
000006b3: DUP2
000006b4: DUP2
000006b5: SUB
000006b6: PUSH0
000006b7: DUP4
000006b8: ADD
000006b9: MSTORE
000006ba: PUSH2 0x06c2
000006bd: DUP2
000006be: PUSH2 0x0689
000006c1: JUMP
000006c2: JUMPDEST
000006c3: SWAP1
000006c4: POP
000006c5: SWAP2
000006c6: SWAP1
000006c7: POP
000006c8: JUMP
000006c9: JUMPDEST
; ============================================================================
; PANIC HANDLER: Division/Modulo by Zero (Error Code 0x12)
; ============================================================================
; Handler ini dipanggil ketika terjadi pembagian atau modulo dengan nol.
; Ini adalah error yang fatal dan tidak bisa di-recover.
;
; Error format: Panic(uint256)
; - Selector: 0x4e487b71 = keccak256("Panic(uint256)")[:4]
; - Error code 0x12 = 18 dalam desimal
;
; Kapan error ini terjadi:
; 1. DIV(x, 0) - pembagian dengan nol (Solidity 0.8+ revert)
; 2. MOD(x, 0) - modulo dengan nol (Solidity 0.8+ revert)
; 3. SDIV(x, 0) - signed division dengan nol
; 4. SMOD(x, 0) - signed modulo dengan nol
;
; CATATAN PENTING:
; Di level opcode EVM, DIV/MOD/SDIV/SMOD dengan divisor 0 TIDAK error!
; Mereka return 0. Tapi Solidity 0.8+ menambahkan pengecekan eksplisit
; dan me-revert dengan Panic(0x12) jika divisor adalah 0.
;
; Contoh yang menyebabkan error ini:
;   uint256 x = 10;
;   uint256 y = 0;
;   uint256 z = x / y;  // Panic: Division by zero!

000006ca: PUSH32 0x4e487b7100000000000000000000000000000000000000000000000000000000
; Push selector untuk Panic(uint256).
;
; Gas cost: 3 gas

000006eb: PUSH0
; Push offset 0 untuk MSTORE.
;
; Gas cost: 2 gas

000006ec: MSTORE
; Simpan selector ke memory[0:32].
;
; Gas cost: 3 gas + memory expansion

000006ed: PUSH1 0x12
; Push error code 0x12 (18) = Division or modulo by zero.
;
; Gas cost: 3 gas

000006ef: PUSH1 0x04
; Push offset 4 untuk MSTORE.
;
; Gas cost: 3 gas

000006f1: MSTORE
; Simpan error code ke memory[4:36].
;
; Gas cost: 3 gas

000006f2: PUSH1 0x24
; Push 0x24 (36) = size of error data.
;
; Gas cost: 3 gas

000006f4: PUSH0
; Push 0 = offset di memory.
;
; Gas cost: 2 gas

000006f5: REVERT
; REVERT dengan error data Panic(0x12).
; Caller akan melihat "Panic: Division or modulo by zero".
;
; Di etherscan/block explorer, error ini ditampilkan sebagai:
; "execution reverted: Panic: Division or modulo division by zero"
;
; Gas cost: 0 gas

000006f6: JUMPDEST
000006f7: PUSH0
000006f8: PUSH2 0x0700
000006fb: DUP3
000006fc: PUSH2 0x038f
000006ff: JUMP
00000700: JUMPDEST
00000701: SWAP2
00000702: POP
00000703: PUSH2 0x070b
00000706: DUP4
00000707: PUSH2 0x038f
0000070a: JUMP
0000070b: JUMPDEST
0000070c: SWAP3
0000070d: POP
0000070e: DUP3
0000070f: PUSH2 0x071b
00000712: JUMPI
00000713: PUSH2 0x071a
00000716: PUSH2 0x06c9
00000719: JUMP
0000071a: JUMPDEST
0000071b: JUMPDEST
0000071c: DUP3
0000071d: DUP3
0000071e: DIV
0000071f: SWAP1
00000720: POP
00000721: SWAP3
00000722: SWAP2
00000723: POP
00000724: POP
00000725: JUMP
00000726: JUMPDEST
00000727: PUSH0
00000728: PUSH2 0x0730
0000072b: DUP3
0000072c: PUSH2 0x038f
0000072f: JUMP
00000730: JUMPDEST
00000731: SWAP2
00000732: POP
00000733: PUSH2 0x073b
00000736: DUP4
00000737: PUSH2 0x038f
0000073a: JUMP
0000073b: JUMPDEST
0000073c: SWAP3
0000073d: POP
0000073e: DUP3
0000073f: DUP3
00000740: SUB
00000741: SWAP1
00000742: POP
00000743: DUP2
00000744: DUP2
00000745: GT
00000746: ISZERO
00000747: PUSH2 0x0753
0000074a: JUMPI
0000074b: PUSH2 0x0752
0000074e: PUSH2 0x0478
00000751: JUMP
00000752: JUMPDEST
00000753: JUMPDEST
00000754: SWAP3
00000755: SWAP2
00000756: POP
00000757: POP
00000758: JUMP
00000759: JUMPDEST
0000075a: PUSH0
0000075b: PUSH2 0x0763
0000075e: DUP3
0000075f: PUSH2 0x038f
00000762: JUMP
00000763: JUMPDEST
00000764: SWAP2
00000765: POP
00000766: PUSH2 0x076e
00000769: DUP4
0000076a: PUSH2 0x038f
0000076d: JUMP
0000076e: JUMPDEST
0000076f: SWAP3
00000770: POP
00000771: DUP3
00000772: DUP3
00000773: MUL
00000774: PUSH2 0x077c
00000777: DUP2
00000778: PUSH2 0x038f
0000077b: JUMP
0000077c: JUMPDEST
0000077d: SWAP2
0000077e: POP
0000077f: DUP3
00000780: DUP3
00000781: DIV
00000782: DUP5
00000783: EQ
00000784: DUP4
00000785: ISZERO
00000786: OR
00000787: PUSH2 0x0793
0000078a: JUMPI
0000078b: PUSH2 0x0792
0000078e: PUSH2 0x0478
00000791: JUMP
00000792: JUMPDEST
00000793: JUMPDEST
00000794: POP
00000795: SWAP3
00000796: SWAP2
00000797: POP
00000798: POP
00000799: JUMP
0000079a: JUMPDEST
; ============================================================================
; STRING CONSTANT: "Modulo by zero"
; ============================================================================
; Helper untuk menyimpan string error "Modulo by zero" ke memory.
; Digunakan oleh fungsi mod() untuk menampilkan pesan error yang jelas
; ketika divisor adalah 0.
;
; String dalam hex:
; 0x4d6f64756c6f206279207a65726f = "Modulo by zero"
;   4d = 'M'
;   6f = 'o'
;   64 = 'd'
;   75 = 'u'
;   6c = 'l'
;   6f = 'o'
;   20 = ' ' (space)
;   62 = 'b'
;   79 = 'y'
;   20 = ' ' (space)
;   7a = 'z'
;   65 = 'e'
;   72 = 'r'
;   6f = 'o'
;
; Panjang string: 14 karakter (0x0e)

0000079b: PUSH32 0x4d6f64756c6f206279207a65726f000000000000000000000000000000000000
; Push string "Modulo by zero" dengan padding zeros.
; 32 bytes total, 14 bytes string + 18 bytes padding.
;
; Gas cost: 3 gas

000007bc: PUSH0
; Push offset 0 (relative ke posisi penulisan).
;
; Gas cost: 2 gas

000007bd: DUP3
; Duplikat memory destination.
;
; Gas cost: 3 gas

000007be: ADD
; Hitung absolute memory address.
;
; Gas cost: 3 gas

000007bf: MSTORE
; Simpan string ke memory.
;
; Gas cost: 3 gas

000007c0: POP
; Cleanup stack.
;
; Gas cost: 2 gas

000007c1: JUMP
; Return ke caller.
;
; Gas cost: 8 gas
000007c2: JUMPDEST
000007c3: PUSH0
000007c4: PUSH2 0x07ce
000007c7: PUSH1 0x0e
000007c9: DUP4
000007ca: PUSH2 0x0651
000007cd: JUMP
000007ce: JUMPDEST
000007cf: SWAP2
000007d0: POP
000007d1: PUSH2 0x07d9
000007d4: DUP3
000007d5: PUSH2 0x079a
000007d8: JUMP
000007d9: JUMPDEST
000007da: PUSH1 0x20
000007dc: DUP3
000007dd: ADD
000007de: SWAP1
000007df: POP
000007e0: SWAP2
000007e1: SWAP1
000007e2: POP
000007e3: JUMP
000007e4: JUMPDEST
000007e5: PUSH0
000007e6: PUSH1 0x20
000007e8: DUP3
000007e9: ADD
000007ea: SWAP1
000007eb: POP
000007ec: DUP2
000007ed: DUP2
000007ee: SUB
000007ef: PUSH0
000007f0: DUP4
000007f1: ADD
000007f2: MSTORE
000007f3: PUSH2 0x07fb
000007f6: DUP2
000007f7: PUSH2 0x07c2
000007fa: JUMP
000007fb: JUMPDEST
000007fc: SWAP1
000007fd: POP
000007fe: SWAP2
000007ff: SWAP1
00000800: POP
00000801: JUMP
00000802: JUMPDEST
; ============================================================================
; HELPER: Modulo Operation with Division by Zero Check
; ============================================================================
; Fungsi helper untuk operasi modulo dengan pengecekan pembagian dengan nol.

00000803: PUSH0
; Push placeholder.

00000804: PUSH2 0x080c
; Push return address.

00000807: DUP3
; Duplikat operand.

00000808: PUSH2 0x038f
; Push address type check.

0000080b: JUMP
; Jump ke type check.

0000080c: JUMPDEST
; Landing point.

0000080d: SWAP2
; Rearrange stack.

0000080e: POP
; Cleanup.

0000080f: PUSH2 0x0817
; Push return address.

00000812: DUP4
; Duplikat operand.

00000813: PUSH2 0x038f
; Push address type check.

00000816: JUMP
; Jump ke type check.

00000817: JUMPDEST
; Landing point.

00000818: SWAP3
; Rearrange stack.

00000819: POP
; Cleanup.

0000081a: DUP3
; Duplikat divisor untuk pengecekan zero.

0000081b: PUSH2 0x0827
; Push alamat skip panic.

0000081e: JUMPI
; Jump jika divisor != 0.

0000081f: PUSH2 0x0826
; Divisor adalah 0 - push panic info.

00000822: PUSH2 0x06c9
; Push panic handler address (division by zero).

00000825: JUMP
; Jump ke panic handler.

00000826: JUMPDEST
; Landing point jika divisor != 0.

00000827: JUMPDEST
; Extra JUMPDEST.

00000828: DUP3
; Duplikat dividend.

00000829: DUP3
; Duplikat divisor.
; Stack: [divisor, dividend, ...]

0000082a: MOD
; MOD (Modulo) - Opcode 0x06
; ============================================================================
; Operasi modulo (sisa pembagian) unsigned.
;
; Cara kerja MOD:
; 1. Pop 2 nilai dari stack: a (top), b (second)
; 2. Hitung b mod a (sisa pembagian b dibagi a)
; 3. Push hasil ke stack
;
; PENTING - Urutan operand:
; Stack: [a, b] → hasil: b mod a (BUKAN a mod b!)
; Ini konsisten dengan DIV: b / a dan b mod a.
;
; Pembagian dengan 0:
; Jika a = 0, hasil adalah 0 (BUKAN error!)
; Sama seperti DIV, EVM tidak throw exception untuk div by zero.
;
; Contoh:
;   MOD(3, 10) → 10 mod 3 = 1 (sisa dari 10/3)
;   MOD(5, 17) → 17 mod 5 = 2 (sisa dari 17/5)
;   MOD(0, 5) → 5 mod 0 = 0 (bukan error!)
;
; Perbedaan MOD vs SMOD:
; - MOD (0x06): Modulo unsigned (selalu positif)
; - SMOD (0x07): Modulo signed (bisa negatif)
;
; Analogi sederhana:
; MOD seperti menghitung "sisa" setelah pembagian.
; Jika kamu punya 17 apel dan mau bagi ke 5 orang rata-rata,
; setiap orang dapat 3 apel, dan SISA-nya adalah 2 apel.
; 17 mod 5 = 2
;
; Penggunaan umum:
; 1. Cek apakah bilangan genap/ganjil (n mod 2)
; 2. Circular array indexing
; 3. Time calculations (detik mod 60 = sisa detik)
; 4. Cryptographic operations
;
; Gas cost: 5 gas
;
; Referensi:
; - https://www.evm.codes/#06

0000082b: SWAP1
; Swap untuk cleanup stack.

0000082c: POP
; Buang operand lama.

0000082d: SWAP3
; Rearrange untuk return.

0000082e: SWAP2
; Rearrange.

0000082f: POP
; Cleanup.

00000830: POP
; Cleanup.

00000831: JUMP
; Return ke caller dengan result.

; ============================================================================
; CONTRACT METADATA (CBOR-encoded)
; ============================================================================
; Bagian berikut adalah metadata yang ditambahkan oleh Solidity compiler.
; Ini BUKAN bagian dari executable code - hanya informasi tambahan.
;
; Metadata berisi:
; 1. IPFS hash dari source code
; 2. Versi compiler Solidity yang digunakan
; 3. Experimental features yang diaktifkan
;
; Format: CBOR (Concise Binary Object Representation)
;
; INVALID opcode (0xfe) sebelum metadata memastikan eksekusi tidak akan
; pernah mencapai bagian ini secara tidak sengaja.

00000832: INVALID
; Barrier - metadata dimulai setelah ini.
; Jika eksekusi mencapai sini, transaksi akan gagal.

00000833: LOG2
; Bagian dari CBOR-encoded metadata.
; BUKAN instruksi LOG2 yang sebenarnya - ini adalah data mentah.

00000834: PUSH5 0x6970667358
; Bagian dari metadata - "ipfs" dalam hex: 0x69706673 = "ipfs"

0000083a: INVALID
; Data metadata.

0000083b: SLT
; Data metadata (bukan opcode SLT sebenarnya).

0000083c: KECCAK256
; Data metadata (bukan opcode KECCAK256 sebenarnya).

0000083d: PUSH8 0xc4b4727da07d0f03
; Bagian dari IPFS content hash.

00000846: SWAP15
; Data metadata.

00000847: SELFDESTRUCT
; Data metadata (BUKAN opcode SELFDESTRUCT sebenarnya!)
; Ini adalah bagian dari hash, bukan instruksi.

00000848: DUP4
; Data metadata.

00000849: SHR
; Data metadata.

0000084a: STOP
; Data metadata.

0000084b: PUSH18 0xb512a15fbcfafa4706464a55e5ba02e80a64
; Lanjutan IPFS hash.

0000085e: PUSH20 0x6f6c634300081c00330000000000000000000000
; Solidity version info dalam metadata:
; "solc" = 0x736f6c63
; 0x00081c00 = versi 0.8.28 (0x08 = 8, 0x1c = 28)
;
; Ini menunjukkan contract dikompilasi dengan Solidity 0.8.28

; ============================================================================
; END OF BYTECODE
; ============================================================================
; Total bytecode size: 0x0884 bytes (2180 bytes)
;
; Struktur keseluruhan:
; 1. Deployment Code: 0x00 - 0x1b (28 bytes)
; 2. INVALID separator: 0x1c (1 byte)
; 3. Runtime Code: 0x1d - 0x84e (2097 bytes)
; 4. Metadata: 0x84f - 0x883 (53 bytes)
;
; Fungsi yang tersedia:
; - add(uint256,uint256): Penjumlahan
; - sub(uint256,uint256): Pengurangan
; - mul(uint256,uint256): Perkalian
; - div(uint256,uint256): Pembagian
; - mod(uint256,uint256): Modulo
; - exp(uint256,uint256): Eksponensial
; - addmod(uint256,uint256,uint256): Penjumlahan modular
; - mulmod(uint256,uint256,uint256): Perkalian modular
; - signedDiv(uint256,uint256): Pembagian signed (SDIV)
; ============================================================================
