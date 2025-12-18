00000001: PUSH1 0x80
; PUSH1 1-byte immediate ke stack.
; 0x80 adalah nilai awal Free Memory Pointer (first free memory offset) sesuai konvensi Solidity,
; yang akan disimpan ke slot memori 0x40 sebagai penanda offset memori bebas berikutnya.
; Byte di offset 00000002 (0x80) adalah immediate/argumen untuk PUSH1 ini, sehingga tidak muncul
; sebagai instruksi terpisah di disassembly.
; Referensi: https://docs.soliditylang.org/en/latest/internals/layout_in_memory.html


00000003: PUSH1 0x40
; PUSH1 1-byte immediate ke stack.
; 0x40 adalah offset memori untuk slot Free Memory Pointer (FMP) sesuai konvensi Solidity,
; yaitu word memory[0x40..0x5f] yang menyimpan alamat awal memori bebas berikutnya.
; Instruksi setelah ini (MSTORE) akan menulis nilai 0x80 ke slot tersebut: memory[0x40] = 0x80.


00000005: MSTORE
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

00000006: CALLVALUE
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

00000007: DUP1
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

00000008: ISZERO
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

00000009: PUSH1 0x0e
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

0000000b: JUMPI
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

0000000c: PUSH0
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

0000000d: PUSH0
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

0000000e: REVERT
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

0000000f: JUMPDEST
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

00000010: POP
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

00000011: PUSH2 0x0868
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

00000014: DUP1
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

00000015: PUSH2 0x001c
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

00000018: PUSH0
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

00000019: CODECOPY
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

0000001a: PUSH0
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

0000001b: RETURN
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

0000001c: INVALID
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

0000001d: PUSH1 0x80
; ============================================================================
; RUNTIME CODE - Memory Initialization
; ============================================================================
; Sama seperti di deployment code, runtime code juga dimulai dengan
; inisialisasi Free Memory Pointer. Ini adalah "ritual pembuka" standar.
;
; Gas cost: 3 gas

0000001f: PUSH1 0x40
; Push alamat slot Free Memory Pointer (0x40).
; memory[0x40] akan menyimpan pointer ke memori bebas berikutnya.
;
; Gas cost: 3 gas

00000021: MSTORE
; Simpan 0x80 ke memory[0x40].
; Sekarang Free Memory Pointer sudah terinisialisasi.
;
; Gas cost: 3 gas + memory expansion

00000022: CALLVALUE
; ============================================================================
; RUNTIME CODE - Non-payable Guard Check
; ============================================================================
; Sama seperti di deployment code, runtime juga mengecek apakah ada ETH
; yang dikirim. Ini adalah pengecekan standar untuk fungsi non-payable.
;
; Push msg.value ke stack.
; Gas cost: 2 gas

00000023: DUP1
; Duplikat msg.value untuk pengecekan ISZERO.
; Gas cost: 3 gas

00000024: ISZERO
; Cek apakah msg.value == 0.
; Gas cost: 3 gas

00000025: PUSH2 0x000f
; Push alamat tujuan jump (0x0f dalam konteks runtime = 0x2c dalam bytecode penuh).
; Catatan: Alamat di runtime code relatif terhadap awal runtime code.
;
; Gas cost: 3 gas

00000028: JUMPI
; Jika msg.value == 0 (ISZERO = 1), lompat ke JUMPDEST dan lanjutkan.
; Jika msg.value != 0 (ISZERO = 0), jatuh ke REVERT.
;
; Gas cost: 10 gas

00000029: PUSH0
; Siapkan offset = 0 untuk REVERT.
; Gas cost: 2 gas

0000002a: PUSH0
; Siapkan size = 0 untuk REVERT.
; Gas cost: 2 gas

0000002b: REVERT
; Batalkan transaksi jika ada ETH yang dikirim.
; Ini memastikan contract tidak menerima ETH karena tidak ada fungsi payable.
;
; Gas cost: 0 gas (tapi transaksi tetap gagal)

0000002c: JUMPDEST
; Landing point setelah non-payable check berhasil.
; Dari sini, eksekusi berlanjut ke function dispatcher.
;
; Gas cost: 1 gas

0000002d: POP
; Buang sisa msg.value dari stack (cleanup).
; Gas cost: 2 gas

0000002e: PUSH1 0x04
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

00000030: CALLDATASIZE
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

00000031: LT
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

00000032: PUSH2 0x0091
; Push alamat fallback/default handler (0x91 dalam runtime = 0xae dalam bytecode).
; Ini adalah alamat yang akan dituju jika calldata terlalu pendek.
;
; Gas cost: 3 gas

00000035: JUMPI
; Jika calldatasize < 4, lompat ke fallback (REVERT di 0x91).
; Jika calldatasize >= 4, lanjut ke function selector extraction.
;
; Gas cost: 10 gas

00000036: PUSH0
; ============================================================================
; FUNCTION DISPATCHER - Bagian 2: Extract Function Selector
; ============================================================================
; Push 0 sebagai offset untuk CALLDATALOAD.
; Kita akan membaca 32 bytes mulai dari offset 0 calldata.
;
; Gas cost: 2 gas

00000037: CALLDATALOAD
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

00000038: PUSH1 0xe0
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

0000003a: SHR
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

0000003b: DUP1
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
0000003c: PUSH4 0xa4ad2ee9
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

00000041: GT
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

00000042: PUSH2 0x0064
; Push alamat untuk handling function selector di grup "atas".
; Jika selector > 0xa4ad2ee9, lompat ke 0x64 untuk cek selector
; yang lebih besar (b12fe826, b67d77c5, c8a4ac9c, f43f523a).
;
; Gas cost: 3 gas

00000045: JUMPI
; Conditional jump berdasarkan hasil GT.
; Ini adalah bagian dari binary search di function dispatcher.
;
; Gas cost: 10 gas

00000046: DUP1
; Duplikat selector untuk perbandingan berikutnya.
; Gas cost: 3 gas

00000047: PUSH4 0xa4ad2ee9
; Push selector mulmod untuk perbandingan EQ.
; Gas cost: 3 gas

0000004c: EQ
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

0000004d: PUSH2 0x0155
; Push alamat implementasi fungsi mulmod (0x155 dalam runtime).
; Jika selector cocok, akan lompat ke sini untuk eksekusi fungsi.
;
; Gas cost: 3 gas

00000050: JUMPI
; Jika selector == 0xa4ad2ee9, lompat ke implementasi mulmod di 0x155.
; Jika tidak cocok, lanjut ke pengecekan selector berikutnya.
;
; Gas cost: 10 gas
00000051: DUP1
; Duplikat selector untuk pengecekan mul.
00000052: PUSH4 0xb12fe826
; Selector untuk mul(uint256,uint256) - perkalian
00000057: EQ
; Cek apakah selector == mul
00000058: PUSH2 0x0185
; Alamat implementasi mul
0000005b: JUMPI
; Jump ke mul jika cocok

0000005c: DUP1
; Duplikat selector untuk pengecekan sub.
0000005d: PUSH4 0xb67d77c5
; Selector untuk sub(uint256,uint256) - pengurangan
00000062: EQ
; Cek apakah selector == sub
00000063: PUSH2 0x01b5
; Alamat implementasi sub
00000066: JUMPI
; Jump ke sub jika cocok

00000067: DUP1
; Duplikat selector untuk pengecekan mod.
00000068: PUSH4 0xc8a4ac9c
; Selector untuk mod(uint256,uint256) - modulo
0000006d: EQ
; Cek apakah selector == mod
0000006e: PUSH2 0x01e5
; Alamat implementasi mod
00000071: JUMPI
; Jump ke mod jika cocok

00000072: DUP1
; Duplikat selector untuk pengecekan signedDiv.
00000073: PUSH4 0xf43f523a
; Selector untuk signedDiv(uint256,uint256) - pembagian signed (SDIV)
00000078: EQ
; Cek apakah selector == signedDiv
00000079: PUSH2 0x0215
; Alamat implementasi signedDiv
0000007c: JUMPI
; Jump ke signedDiv jika cocok

0000007d: PUSH2 0x0091
; Tidak ada function yang cocok di grup "atas", jump ke fallback.
00000080: JUMP
; JUMP (Unconditional Jump) - Opcode 0x56
; Lompat tanpa syarat ke alamat fallback (0x91).
; Berbeda dengan JUMPI, JUMP selalu lompat tanpa mengecek kondisi.
;
; Gas cost: 8 gas
;
; Referensi:
; - https://www.evm.codes/#56

00000081: JUMPDEST
; ============================================================================
; FUNCTION DISPATCHER - Grup Selector "Bawah" (< 0xa4ad2ee9)
; ============================================================================
; Ini adalah entry point untuk function selector yang lebih kecil dari pivot.
; Function di grup ini: addmod, exp, add, div

00000082: DUP1
; Duplikat selector untuk pengecekan addmod.
00000083: PUSH4 0x25a35559
; Selector untuk addmod(uint256,uint256,uint256) - penjumlahan modular
00000088: EQ
; Cek apakah selector == addmod
00000089: PUSH2 0x0095
; Alamat implementasi addmod
0000008c: JUMPI
; Jump ke addmod jika cocok

0000008d: DUP1
; Duplikat selector untuk pengecekan exp.
0000008e: PUSH4 0x2e4c697f
; Selector untuk exp(uint256,uint256) - eksponensial (pangkat)
00000093: EQ
; Cek apakah selector == exp
00000094: PUSH2 0x00c5
; Alamat implementasi exp
00000097: JUMPI
; Jump ke exp jika cocok

00000098: DUP1
; Duplikat selector untuk pengecekan add.
00000099: PUSH4 0x771602f7
; Selector untuk add(uint256,uint256) - penjumlahan
; Ini adalah 4 bytes pertama dari keccak256("add(uint256,uint256)")
;
; Cara menghitung selector:
; keccak256("add(uint256,uint256)") = 0x771602f7...
; Ambil 4 bytes pertama: 0x771602f7
0000009e: EQ
; Cek apakah selector == add
0000009f: PUSH2 0x00f5
; Alamat implementasi add
000000a2: JUMPI
; Jump ke add jika cocok

000000a3: DUP1
; Duplikat selector untuk pengecekan div.
000000a4: PUSH4 0xa391c15b
; Selector untuk div(uint256,uint256) - pembagian
000000a9: EQ
; Cek apakah selector == div
000000aa: PUSH2 0x0125
; Alamat implementasi div
000000ad: JUMPI
; Jump ke div jika cocok

000000ae: JUMPDEST
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

000000af: PUSH0
; Siapkan offset = 0 untuk REVERT.
000000b0: PUSH0
; Siapkan size = 0 untuk REVERT.
000000b1: REVERT
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

000000b2: JUMPDEST
; ============================================================================
; FUNCTION: addmod(uint256 a, uint256 b, uint256 n)
; Selector: 0x25a35559
; ============================================================================
; Menghitung (a + b) % n dengan presisi penuh (tidak overflow).
; Ini adalah wrapper yang memanggil fungsi internal addmod.

000000b3: PUSH2 0x00af
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

000000b6: PUSH1 0x04
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

000000b8: DUP1
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

000000b9: CALLDATASIZE
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

000000ba: SUB
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

000000bb: DUP2
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

000000bc: ADD
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

000000bd: SWAP1
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

000000be: PUSH2 0x00aa
; Push return address untuk nested function call.
;
; Kondisi stack SETELAH:
;   Stack: [0x00aa, 0x04, end_offset, 0x00af]
;
; Gas cost: 3 gas

000000c1: SWAP2
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

000000c2: SWAP1
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

000000c3: PUSH2 0x03c2
; Push alamat fungsi ABI decode.
;
; Alamat 0x03c2 adalah internal helper function yang melakukan:
; 1. Decode arguments dari calldata
; 2. Validasi format arguments
; 3. Push decoded values ke stack
;
; Gas cost: 3 gas

000000c6: JUMP
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

000000c7: JUMPDEST
; JUMPDEST - Return point setelah ABI decode selesai.
; Pada titik ini, arguments sudah di-decode dan ada di stack.
;
; Kondisi stack di sini:
;   Stack: [arg_n, arg_b, arg_a, 0x00af]
;   - Untuk addmod: [n, b, a, return_addr]

000000c8: PUSH2 0x0245
; Push alamat implementasi internal addmod.
;
; Alamat 0x0245 berisi kode yang melakukan operasi:
; (a + b) % n dengan presisi penuh.
;
; Gas cost: 3 gas

000000cb: JUMP
; Lompat ke implementasi addmod.
; Setelah addmod selesai, akan JUMP kembali ke return address.
;
; Gas cost: 8 gas

000000cc: JUMPDEST
; ============================================================================
; RETURN VALUE ENCODING & RETURN
; ============================================================================
; Setelah fungsi internal selesai, hasil ada di stack.
; Bagian ini meng-encode hasil dan mengembalikannya ke caller.

000000cd: PUSH1 0x40
; Push alamat Free Memory Pointer (0x40).
; Kita akan menggunakan FMP untuk mendapatkan alamat memori
; di mana kita bisa menyimpan return value.
;
; Gas cost: 3 gas

000000cf: MLOAD
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

000000d0: PUSH2 0x00bc
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000000d3: SWAP2
; Rearrange stack untuk parameter.
;
; Gas cost: 3 gas

000000d4: SWAP1
; Rearrange stack lagi.
;
; Gas cost: 3 gas

000000d5: PUSH2 0x040f
; Push alamat helper untuk encode uint256 ke memory.
; Helper ini akan menyimpan result ke memory untuk di-return.
;
; Gas cost: 3 gas

000000d8: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000000d9: JUMPDEST
; Return point setelah encoding selesai.
; Sekarang result sudah tersimpan di memory.

000000da: PUSH1 0x40
; Push alamat FMP lagi untuk mendapatkan end of data.
;
; Gas cost: 3 gas

000000dc: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data yang di-encode).
;
; Gas cost: 3 gas

000000dd: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

000000de: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000000df: SUB
; Hitung size = end_ptr - start_ptr.
; Ini adalah ukuran data yang akan di-return.
;
; Gas cost: 3 gas

000000e0: SWAP1
; Rearrange: [start_ptr, size]
;
; Gas cost: 3 gas

000000e1: RETURN
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

000000e2: JUMPDEST
; ============================================================================
; FUNCTION: exp(uint256 base, uint256 exponent)
; Selector: 0x2e4c697f
; ============================================================================
; Entry point untuk fungsi eksponensial (pangkat).
; Menghitung base^exponent.
000000e3: PUSH2 0x00df
; Push return address untuk wrapper exp.
; Setelah internal function selesai, akan kembali ke 0x00df untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

000000e6: PUSH1 0x04
; Push offset 4 - awal arguments setelah function selector.
;
; Gas cost: 3 gas

000000e8: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000000e9: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk exp(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000000ea: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000000eb: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000000ec: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000000ed: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000000ee: PUSH2 0x00da
; Push nested return address.
;
; Gas cost: 3 gas

000000f1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000000f2: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000000f3: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (uint256, uint256).
;
; Gas cost: 3 gas

000000f6: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000000f7: JUMPDEST
; Return point dari ABI decode.
; Stack: [exponent, base, return_addr]

000000f8: PUSH2 0x0251
; Push alamat implementasi internal exp.
; Fungsi ini menghitung base^exponent menggunakan algoritma
; square-and-multiply untuk efisiensi.
;
; Gas cost: 3 gas

000000fb: JUMP
; Lompat ke implementasi exp.
;
; Gas cost: 8 gas

000000fc: JUMPDEST
; Return point dari exp calculation.
; Stack: [result, return_addr]

000000fd: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000000ff: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000100: PUSH2 0x00ec
; Push return address untuk encoding.
;
; Gas cost: 3 gas

00000103: SWAP2
; Rearrange stack untuk encoding helper.
;
; Gas cost: 3 gas

00000104: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000105: PUSH2 0x040f
; Push alamat encoding helper (menyimpan uint256 ke memory).
;
; Gas cost: 3 gas

00000108: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

00000109: JUMPDEST
; Return point dari encoding.

0000010a: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

0000010c: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data).
;
; Gas cost: 3 gas

0000010d: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

0000010e: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

0000010f: SUB
; Hitung size = end - start (32 bytes untuk uint256).
;
; Gas cost: 3 gas

00000110: SWAP1
; Susun stack: [offset, size] untuk RETURN.
;
; Gas cost: 3 gas

00000111: RETURN
; Kembalikan hasil ke caller.
; memory[offset:offset+32] berisi result dari exp.
;
; Gas cost: 0 gas

00000112: JUMPDEST
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

00000113: PUSH2 0x010f
; Push return address untuk wrapper add.
;
; Gas cost: 3 gas

00000116: PUSH1 0x04
; Push offset 4 (skip selector).
;
; Gas cost: 3 gas

00000118: DUP1
; Duplikat offset.
;
; Gas cost: 3 gas

00000119: CALLDATASIZE
; Ukuran calldata: 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

0000011a: SUB
; Args size: 68 - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000011b: DUP2
; Duplikat offset.
;
; Gas cost: 3 gas

0000011c: ADD
; End offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

0000011d: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

0000011e: PUSH2 0x010a
; Push nested return address.
;
; Gas cost: 3 gas

00000121: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000122: SWAP1
; Rearrange.
;
; Gas cost: 3 gas

00000123: PUSH2 0x03c2
; Push ABI decode helper address.
;
; Gas cost: 3 gas

00000126: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

00000127: JUMPDEST
; Return dari ABI decode.
; Stack: [b, a, return_addr]

00000128: PUSH2 0x0266
; Push alamat implementasi internal add.
; Di alamat ini ada opcode ADD yang melakukan penjumlahan.
;
; Gas cost: 3 gas

0000012b: JUMP
; Lompat ke implementasi add.
;
; Gas cost: 8 gas

0000012c: JUMPDEST
; Return dari add calculation.
; Stack: [result, return_addr]

0000012d: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000012f: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

00000130: PUSH2 0x011c
; Push encoding return address.
;
; Gas cost: 3 gas

00000133: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000134: SWAP1
; Rearrange.
;
; Gas cost: 3 gas

00000135: PUSH2 0x040f
; Push encoding helper address.
;
; Gas cost: 3 gas

00000138: JUMP
; Lompat ke encoding.
;
; Gas cost: 8 gas

00000139: JUMPDEST
; Return dari encoding.

0000013a: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000013c: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

0000013d: DUP1
; Duplikat.
;
; Gas cost: 3 gas

0000013e: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

0000013f: SUB
; Hitung size.
;
; Gas cost: 3 gas

00000140: SWAP1
; Rearrange untuk RETURN.
;
; Gas cost: 3 gas

00000141: RETURN
; Kembalikan hasil add ke caller.
;
; Gas cost: 0 gas

00000142: JUMPDEST
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
00000143: PUSH2 0x013f
; Push return address untuk wrapper div.
;
; Gas cost: 3 gas

00000146: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

00000148: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

00000149: CALLDATASIZE
; Ambil ukuran calldata (68 bytes untuk 2 uint256 args).
;
; Gas cost: 2 gas

0000014a: SUB
; Hitung args size: 68 - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000014b: DUP2
; Duplikat offset.
;
; Gas cost: 3 gas

0000014c: ADD
; Hitung end offset.
;
; Gas cost: 3 gas

0000014d: SWAP1
; Rearrange stack untuk ABI decode.
;
; Gas cost: 3 gas

0000014e: PUSH2 0x013a
; Push nested return address.
;
; Gas cost: 3 gas

00000151: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000152: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000153: PUSH2 0x03c2
; Push ABI decode helper address.
;
; Gas cost: 3 gas

00000156: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

00000157: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]

00000158: PUSH2 0x027b
; Push alamat implementasi internal div.
; Fungsi ini melakukan pembagian dengan pengecekan division by zero.
;
; Di dalam implementasi div:
; 1. Cek apakah divisor (b) == 0
; 2. Jika 0, revert dengan error "Division by zero"
; 3. Jika tidak 0, hitung a / b menggunakan opcode DIV
;
; Gas cost: 3 gas

0000015b: JUMP
; Lompat ke implementasi div.
;
; Gas cost: 8 gas

0000015c: JUMPDEST
; Return point dari div calculation.
; Stack: [result, return_addr]

0000015d: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000015f: MLOAD
; Baca Free Memory Pointer.
;
; Gas cost: 3 gas

00000160: PUSH2 0x014c
; Push encoding return address.
;
; Gas cost: 3 gas

00000163: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000164: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000165: PUSH2 0x040f
; Push encoding helper address.
;
; Gas cost: 3 gas

00000168: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

00000169: JUMPDEST
; Return dari encoding.

0000016a: PUSH1 0x40
; Push FMP address.
;
; Gas cost: 3 gas

0000016c: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

0000016d: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

0000016e: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

0000016f: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000170: SWAP1
; Rearrange untuk RETURN.
;
; Gas cost: 3 gas

00000171: RETURN
; Kembalikan hasil div ke caller.
;
; Gas cost: 0 gas

00000172: JUMPDEST
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
00000173: PUSH2 0x016f
; Push return address untuk wrapper mulmod.
; Setelah internal function selesai, akan kembali ke 0x016f untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

00000176: PUSH1 0x04
; Push offset 4 - awal arguments setelah function selector.
; Untuk mulmod(uint256, uint256, uint256): 4 bytes selector + 96 bytes args.
;
; Gas cost: 3 gas

00000178: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

00000179: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mulmod dengan 3 uint256 args: 4 + 32 + 32 + 32 = 100 bytes.
;
; Gas cost: 2 gas

0000017a: SUB
; Hitung ukuran arguments: calldatasize - 4 = 96 bytes.
;
; Gas cost: 3 gas

0000017b: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000017c: ADD
; Hitung end offset: 4 + 96 = 100.
;
; Gas cost: 3 gas

0000017d: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

0000017e: PUSH2 0x016a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000181: SWAP2
; Rearrange stack untuk ABI decode helper.
;
; Gas cost: 3 gas

00000182: SWAP1
; Rearrange stack lagi.
;
; Gas cost: 3 gas

00000183: PUSH2 0x0428
; Push alamat ABI decode helper untuk 3 arguments (uint256, uint256, uint256).
; Helper ini akan decode calldata dan push 3 nilai ke stack.
;
; Gas cost: 3 gas

00000186: JUMP
; Lompat ke ABI decode helper.
;
; Gas cost: 8 gas

00000187: JUMPDEST
; Return point dari ABI decode.
; Stack: [n, b, a, return_addr]
; - a = operand pertama untuk mulmod
; - b = operand kedua untuk mulmod
; - n = modulus (pembagi)

00000188: PUSH2 0x02d2
; Push alamat implementasi internal mulmod.
; Fungsi ini akan menghitung (a * b) mod n dengan presisi 512-bit.
;
; Gas cost: 3 gas

0000018b: JUMP
; Lompat ke implementasi mulmod internal.
;
; Gas cost: 8 gas

0000018c: JUMPDEST
; Return point dari mulmod calculation.
; Stack: [result, return_addr]
; - result = (a * b) mod n

0000018d: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

0000018f: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000190: PUSH2 0x017c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000193: SWAP2
; Rearrange stack untuk encoding helper.
;
; Gas cost: 3 gas

00000194: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000195: PUSH2 0x040f
; Push alamat encoding helper yang menyimpan uint256 ke memory.
;
; Gas cost: 3 gas

00000198: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

00000199: JUMPDEST
; Return dari encoding helper.
; Result sudah tersimpan di memory.

0000019a: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size return data.
;
; Gas cost: 3 gas

0000019c: MLOAD
; Baca FMP (sekarang menunjuk ke akhir data yang di-encode).
;
; Gas cost: 3 gas

0000019d: DUP1
; Duplikat untuk kalkulasi size.
;
; Gas cost: 3 gas

0000019e: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

0000019f: SUB
; Hitung size = end - start (32 bytes untuk uint256).
;
; Gas cost: 3 gas

000001a0: SWAP1
; Susun stack: [offset, size] untuk RETURN.
;
; Gas cost: 3 gas

000001a1: RETURN
; Kembalikan hasil mulmod ke caller.
; memory[offset:offset+32] berisi result dari mulmod.
;
; Gas cost: 0 gas
000001a2: JUMPDEST
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

000001a3: PUSH2 0x019f
; Push return address untuk wrapper mul.
; Setelah internal function selesai, akan kembali ke sini untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

000001a6: PUSH1 0x04
; Push offset 4 (skip function selector).
; Calldata: [4-byte selector][32-byte a][32-byte b]
;
; Gas cost: 3 gas

000001a8: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000001a9: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mul(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000001aa: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000001ab: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000001ac: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000001ad: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000001ae: PUSH2 0x019a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

000001b1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001b2: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001b3: PUSH2 0x0428
; Push alamat ABI decode helper untuk 2 arguments (dengan helper 3-arg).
; CATATAN: Menggunakan helper yang sama dengan mulmod (0x0428)
; karena decode 2 args dan 3 args bisa menggunakan helper yang sama
; dengan validasi size yang berbeda.
;
; Gas cost: 3 gas

000001b6: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000001b7: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]

000001b8: PUSH2 0x02ee
; Push alamat implementasi internal mul.
; Fungsi ini akan menghitung a * b dengan pengecekan overflow.
;
; Gas cost: 3 gas

000001bb: JUMP
; Lompat ke implementasi mul.
;
; Gas cost: 8 gas

000001bc: JUMPDEST
; Return point dari mul calculation.
; Stack: [result, return_addr]

000001bd: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000001bf: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

000001c0: PUSH2 0x01ac
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000001c3: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001c4: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001c5: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

000001c8: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000001c9: JUMPDEST
; Return dari encoding helper.

000001ca: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

000001cc: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

000001cd: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

000001ce: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001cf: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

000001d0: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

000001d1: RETURN
; Kembalikan hasil mul ke caller.
;
; Gas cost: 0 gas
000001d2: JUMPDEST
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

000001d3: PUSH2 0x01cf
; Push return address untuk wrapper sub.
;
; Gas cost: 3 gas

000001d6: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

000001d8: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

000001d9: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk sub(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

000001da: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

000001db: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

000001dc: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

000001dd: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

000001de: PUSH2 0x01ca
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

000001e1: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001e2: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001e3: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (uint256, uint256).
; Ini adalah helper berbeda dari mulmod (0x03c2 vs 0x0428).
;
; Gas cost: 3 gas

000001e6: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

000001e7: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = operand pertama (minuend)
; - b = operand kedua (subtrahend)

000001e8: PUSH2 0x030a
; Push alamat implementasi internal sub.
; Fungsi ini akan menghitung a - b dengan pengecekan underflow.
;
; Gas cost: 3 gas

000001eb: JUMP
; Lompat ke implementasi sub.
;
; Gas cost: 8 gas

000001ec: JUMPDEST
; Return point dari sub calculation.
; Stack: [result, return_addr]
; - result = a - b

000001ed: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

000001ef: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

000001f0: PUSH2 0x01dc
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

000001f3: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001f4: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

000001f5: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

000001f8: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

000001f9: JUMPDEST
; Return dari encoding helper.

000001fa: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

000001fc: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

000001fd: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

000001fe: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

000001ff: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000200: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

00000201: RETURN
; Kembalikan hasil sub ke caller.
;
; Gas cost: 0 gas
00000202: JUMPDEST
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

00000203: PUSH2 0x01ff
; Push return address untuk wrapper mod.
;
; Gas cost: 3 gas

00000206: PUSH1 0x04
; Push offset 4 (skip function selector).
;
; Gas cost: 3 gas

00000208: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

00000209: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk mod(uint256, uint256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

0000020a: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000020b: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000020c: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

0000020d: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

0000020e: PUSH2 0x01fa
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000211: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000212: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000213: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments.
;
; Gas cost: 3 gas

00000216: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

00000217: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = dividend (yang dibagi)
; - b = divisor (pembagi)

00000218: PUSH2 0x031f
; Push alamat implementasi internal mod.
; Fungsi ini akan menghitung a % b dengan pengecekan division by zero.
;
; Gas cost: 3 gas

0000021b: JUMP
; Lompat ke implementasi mod.
;
; Gas cost: 8 gas

0000021c: JUMPDEST
; Return point dari mod calculation.
; Stack: [result, return_addr]
; - result = a % b

0000021d: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

0000021f: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000220: PUSH2 0x020c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000223: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000224: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000225: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

00000228: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

00000229: JUMPDEST
; Return dari encoding helper.

0000022a: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

0000022c: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

0000022d: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

0000022e: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

0000022f: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000230: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

00000231: RETURN
; Kembalikan hasil mod ke caller.
;
; Gas cost: 0 gas

00000232: JUMPDEST
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

00000233: PUSH2 0x022f
; Push return address untuk wrapper signedDiv.
; Setelah internal function selesai, akan kembali ke 0x022f untuk
; melakukan encoding result dan return ke caller.
;
; Gas cost: 3 gas

00000236: PUSH1 0x04
; Push offset 4 (skip function selector).
; Calldata: [4-byte selector][32-byte a][32-byte b]
;
; Gas cost: 3 gas

00000238: DUP1
; Duplikat offset untuk kalkulasi.
;
; Gas cost: 3 gas

00000239: CALLDATASIZE
; Ambil ukuran total calldata.
; Untuk signedDiv(int256, int256): 4 + 32 + 32 = 68 bytes.
;
; Gas cost: 2 gas

0000023a: SUB
; Hitung ukuran arguments: calldatasize - 4 = 64 bytes.
;
; Gas cost: 3 gas

0000023b: DUP2
; Duplikat offset (4).
;
; Gas cost: 3 gas

0000023c: ADD
; Hitung end offset: 4 + 64 = 68.
;
; Gas cost: 3 gas

0000023d: SWAP1
; Susun stack untuk ABI decode.
;
; Gas cost: 3 gas

0000023e: PUSH2 0x022a
; Push nested return address setelah ABI decode.
;
; Gas cost: 3 gas

00000241: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000242: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000243: PUSH2 0x03c2
; Push alamat ABI decode helper untuk 2 arguments (int256, int256).
;
; Gas cost: 3 gas

00000246: JUMP
; Lompat ke ABI decode.
;
; Gas cost: 8 gas

00000247: JUMPDEST
; Return point dari ABI decode.
; Stack: [b, a, return_addr]
; - a = dividend (yang dibagi) - SIGNED integer
; - b = divisor (pembagi) - SIGNED integer

00000248: PUSH2 0x0334
; Push alamat implementasi internal signedDiv.
; Fungsi ini akan menghitung a / b menggunakan SDIV dengan pengecekan
; division by zero.
;
; Gas cost: 3 gas

0000024b: JUMP
; Lompat ke implementasi signedDiv.
;
; Gas cost: 8 gas

0000024c: JUMPDEST
; Return point dari signedDiv calculation.
; Stack: [result, return_addr]
; - result = a / b (signed division)

0000024d: PUSH1 0x40
; Push alamat Free Memory Pointer.
;
; Gas cost: 3 gas

0000024f: MLOAD
; Baca FMP untuk mendapatkan lokasi memori kosong.
;
; Gas cost: 3 gas

00000250: PUSH2 0x023c
; Push return address untuk encoding helper.
;
; Gas cost: 3 gas

00000253: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

00000254: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000255: PUSH2 0x040f
; Push alamat encoding helper.
;
; Gas cost: 3 gas

00000258: JUMP
; Lompat ke encoding helper.
;
; Gas cost: 8 gas

00000259: JUMPDEST
; Return dari encoding helper.

0000025a: PUSH1 0x40
; Push alamat FMP untuk kalkulasi size.
;
; Gas cost: 3 gas

0000025c: MLOAD
; Baca FMP.
;
; Gas cost: 3 gas

0000025d: DUP1
; Duplikat untuk kalkulasi.
;
; Gas cost: 3 gas

0000025e: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

0000025f: SUB
; Hitung size = end - start.
;
; Gas cost: 3 gas

00000260: SWAP1
; Susun stack untuk RETURN.
;
; Gas cost: 3 gas

00000261: RETURN
; Kembalikan hasil signedDiv ke caller.
;
; Gas cost: 0 gas

00000262: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: add(uint256 a, uint256 b) returns (uint256)
; ============================================================================
; Ini adalah implementasi internal dari fungsi penjumlahan.
; Equivalent Solidity: function add(uint256 a, uint256 b) internal pure returns (uint256)
;
; Stack saat masuk: [b, a, return_addr, ...]
; Stack saat keluar: [result, return_addr, ...]

00000263: PUSH0
; Push 0 sebagai placeholder untuk result.
; Stack: [0, b, a, return_addr]

00000264: DUP2
; Duplikat b ke top stack.
; Stack: [b, 0, b, a, return_addr]

00000265: DUP4
; Duplikat a ke top stack.
; Stack: [a, b, 0, b, a, return_addr]

00000266: ADD
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

00000267: SWAP1
; Stack: [0, a+b, b, a, return_addr] → [a+b, 0, b, a, return_addr]

00000268: POP
; Buang placeholder 0.
; Stack: [a+b, b, a, return_addr]

00000269: SWAP3
; Stack: [return_addr, b, a, a+b]

0000026a: SWAP2
; Stack: [return_addr, a+b, a, b]

0000026b: POP
; Buang a.

0000026c: POP
; Buang b.
; Stack: [return_addr, result]

0000026d: JUMP
; Return ke caller dengan result di stack.

0000026e: JUMPDEST
0000026f: PUSH0
00000270: DUP2
00000271: DUP4
00000272: PUSH2 0x025e
00000275: SWAP2
00000276: SWAP1
00000277: PUSH2 0x05d4
0000027a: JUMP
0000027b: JUMPDEST
0000027c: SWAP1
0000027d: POP
0000027e: SWAP3
0000027f: SWAP2
00000280: POP
00000281: POP
00000282: JUMP
00000283: JUMPDEST
00000284: PUSH0
00000285: DUP2
00000286: DUP4
00000287: PUSH2 0x0273
0000028a: SWAP2
0000028b: SWAP1
0000028c: PUSH2 0x061e
0000028f: JUMP
00000290: JUMPDEST
00000291: SWAP1
00000292: POP
00000293: SWAP3
00000294: SWAP2
00000295: POP
00000296: POP
00000297: JUMP
00000298: JUMPDEST
00000299: PUSH0
0000029a: PUSH0
0000029b: DUP3
0000029c: SUB
0000029d: PUSH2 0x02be
000002a0: JUMPI
000002a1: PUSH1 0x40
000002a3: MLOAD
000002a4: PUSH32 0x08c379a000000000000000000000000000000000000000000000000000000000
000002c5: DUP2
000002c6: MSTORE
000002c7: PUSH1 0x04
000002c9: ADD
000002ca: PUSH2 0x02b5
000002cd: SWAP1
000002ce: PUSH2 0x06ab
000002d1: JUMP
000002d2: JUMPDEST
000002d3: PUSH1 0x40
000002d5: MLOAD
000002d6: DUP1
000002d7: SWAP2
000002d8: SUB
000002d9: SWAP1
000002da: REVERT
000002db: JUMPDEST
000002dc: DUP2
000002dd: DUP4
000002de: PUSH2 0x02ca
000002e1: SWAP2
000002e2: SWAP1
000002e3: PUSH2 0x06f6
000002e6: JUMP
000002e7: JUMPDEST
000002e8: SWAP1
000002e9: POP
000002ea: SWAP3
000002eb: SWAP2
000002ec: POP
000002ed: POP
000002ee: JUMP
000002ef: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: mulmod(uint256 a, uint256 b, uint256 n) returns (uint256)
; ============================================================================
; Menghitung (a * b) % n dengan PRESISI PENUH.
; Ini sangat penting untuk kriptografi karena intermediate result tidak overflow!
;
; Equivalent Solidity: mulmod(a, b, n)
; Stack saat masuk: [n, b, a, return_addr, ...]

000002f0: PUSH0
; Push 0 sebagai placeholder untuk result.

000002f1: DUP2
; Duplikat n untuk pengecekan division by zero.

000002f2: DUP1
; Duplikat n lagi.

000002f3: PUSH2 0x02e2
; Push alamat untuk skip error handling jika n != 0.

000002f6: JUMPI
; Jika n != 0, skip error handling.
; Jika n == 0, jatuh ke panic handler (division by zero).

000002f7: PUSH2 0x02e1
; Error handling: push panic selector.

000002fa: PUSH2 0x06c9
; Push address panic handler.

000002fd: JUMP
; Jump ke panic handler untuk division by zero error.

000002fe: JUMPDEST
; Landing point jika n != 0 (safe to proceed).

000002ff: JUMPDEST
; Extra JUMPDEST (mungkin dari compiler optimization).

00000300: DUP4
; Duplikat a ke top stack.

00000301: DUP6
; Duplikat b ke top stack.
; Stack sekarang: [b, a, n, ...]

00000302: MULMOD
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

00000303: SWAP1
; Swap untuk cleanup stack.

00000304: POP
; Buang placeholder.

00000305: SWAP4
; Rearrange stack untuk return.

00000306: SWAP3
; Rearrange stack.

00000307: POP
; Cleanup.

00000308: POP
; Cleanup.

00000309: POP
; Cleanup.

0000030a: JUMP
; Return ke caller dengan result.

0000030b: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: addmod(uint256 a, uint256 b, uint256 n) returns (uint256)
; ============================================================================
; Menghitung (a + b) % n dengan PRESISI PENUH.
; Intermediate result (a + b) tidak overflow meskipun melebihi 2^256.
;
; Equivalent Solidity: addmod(a, b, n)

0000030c: PUSH0
; Push placeholder.

0000030d: DUP2
; Duplikat n untuk pengecekan.

0000030e: DUP1
; Duplikat n lagi.

0000030f: PUSH2 0x02fe
; Push alamat untuk skip error jika n != 0.

00000312: JUMPI
; Jika n != 0, lanjut ke operasi.
; Jika n == 0, jatuh ke panic handler.

00000313: PUSH2 0x02fd
; Push panic info.

00000316: PUSH2 0x06c9
; Push panic handler address.

00000319: JUMP
; Jump ke panic handler.

0000031a: JUMPDEST
; Landing point jika n != 0.

0000031b: JUMPDEST
; Extra JUMPDEST.

0000031c: DUP4
; Duplikat a.

0000031d: DUP6
; Duplikat b.
; Stack: [b, a, n, ...]

0000031e: ADDMOD
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

0000031f: SWAP1
; Swap untuk cleanup.

00000320: POP
; Buang placeholder.

00000321: SWAP4
; Rearrange untuk return.

00000322: SWAP3
; Rearrange.

00000323: POP
; Cleanup.

00000324: POP
; Cleanup.

00000325: POP
; Cleanup.

00000326: JUMP
; Return ke caller.

00000327: JUMPDEST
; ============================================================================
; INTERNAL FUNCTION: mul helper wrapper
; ============================================================================
; Wrapper internal untuk operasi perkalian yang memanggil helper
; dengan overflow checking.

00000328: PUSH0
; Push placeholder.
;
; Gas cost: 2 gas

00000329: DUP2
; Duplikat operand kedua.
;
; Gas cost: 3 gas

0000032a: DUP4
; Duplikat operand pertama.
;
; Gas cost: 3 gas

0000032b: PUSH2 0x0317
; Push return address.
;
; Gas cost: 3 gas

0000032e: SWAP2
; Rearrange stack.
;
; Gas cost: 3 gas

0000032f: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000330: PUSH2 0x0726
; Push alamat helper untuk safe multiplication dengan overflow check.
;
; Gas cost: 3 gas

00000333: JUMP
; Lompat ke helper function.
;
; Gas cost: 8 gas

00000334: JUMPDEST
; Return point dari helper.

00000335: SWAP1
; Rearrange hasil.
;
; Gas cost: 3 gas

00000336: POP
; Cleanup placeholder.
;
; Gas cost: 2 gas

00000337: SWAP3
; Rearrange untuk return.
;
; Gas cost: 3 gas

00000338: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

00000339: POP
; Cleanup operand.
;
; Gas cost: 2 gas

0000033a: POP
; Cleanup operand.
;
; Gas cost: 2 gas

0000033b: JUMP
; Return ke caller.
;
; Gas cost: 8 gas

0000033c: JUMPDEST
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

0000033d: PUSH0
; Push placeholder untuk result.
;
; Gas cost: 2 gas

0000033e: DUP2
; Duplikat b (divisor).
;
; Gas cost: 3 gas

0000033f: DUP4
; Duplikat a (dividend).
;
; Gas cost: 3 gas

00000340: PUSH2 0x032c
; Push return address setelah helper.
;
; Gas cost: 3 gas

00000343: SWAP2
; Rearrange stack untuk parameter.
;
; Gas cost: 3 gas

00000344: SWAP1
; Rearrange stack.
;
; Gas cost: 3 gas

00000345: PUSH2 0x0759
; Push alamat helper untuk subtraction/division dengan underflow check.
; Helper ini akan melakukan operasi yang aman dengan pengecekan error.
;
; Gas cost: 3 gas

00000348: JUMP
; Lompat ke helper.
;
; Gas cost: 8 gas

00000349: JUMPDEST
; Return point dari helper.

0000034a: SWAP1
; Rearrange hasil.
;
; Gas cost: 3 gas

0000034b: POP
; Cleanup placeholder.
;
; Gas cost: 2 gas

0000034c: SWAP3
; Rearrange untuk return.
;
; Gas cost: 3 gas

0000034d: SWAP2
; Rearrange.
;
; Gas cost: 3 gas

0000034e: POP
; Cleanup.
;
; Gas cost: 2 gas

0000034f: POP
; Cleanup.
;
; Gas cost: 2 gas

00000350: JUMP
; Return ke caller dengan result.
;
; Gas cost: 8 gas

00000351: JUMPDEST
00000352: PUSH0
00000353: PUSH0
00000354: DUP3
00000355: SUB
00000356: PUSH2 0x0377
00000359: JUMPI
0000035a: PUSH1 0x40
0000035c: MLOAD
0000035d: PUSH32 0x08c379a000000000000000000000000000000000000000000000000000000000
0000037e: DUP2
0000037f: MSTORE
00000380: PUSH1 0x04
00000382: ADD
00000383: PUSH2 0x036e
00000386: SWAP1
00000387: PUSH2 0x07e4
0000038a: JUMP
0000038b: JUMPDEST
0000038c: PUSH1 0x40
0000038e: MLOAD
0000038f: DUP1
00000390: SWAP2
00000391: SUB
00000392: SWAP1
00000393: REVERT
00000394: JUMPDEST
00000395: DUP2
00000396: DUP4
00000397: PUSH2 0x0383
0000039a: SWAP2
0000039b: SWAP1
0000039c: PUSH2 0x0802
0000039f: JUMP
000003a0: JUMPDEST
000003a1: SWAP1
000003a2: POP
000003a3: SWAP3
000003a4: SWAP2
000003a5: POP
000003a6: POP
000003a7: JUMP
000003a8: JUMPDEST
000003a9: PUSH0
000003aa: PUSH0
000003ab: REVERT
000003ac: JUMPDEST
000003ad: PUSH0
000003ae: DUP2
000003af: SWAP1
000003b0: POP
000003b1: SWAP2
000003b2: SWAP1
000003b3: POP
000003b4: JUMP
000003b5: JUMPDEST
000003b6: PUSH2 0x03a1
000003b9: DUP2
000003ba: PUSH2 0x038f
000003bd: JUMP
000003be: JUMPDEST
000003bf: DUP2
000003c0: EQ
000003c1: PUSH2 0x03ab
000003c4: JUMPI
000003c5: PUSH0
000003c6: PUSH0
000003c7: REVERT
000003c8: JUMPDEST
000003c9: POP
000003ca: JUMP
000003cb: JUMPDEST
000003cc: PUSH0
000003cd: DUP2
000003ce: CALLDATALOAD
000003cf: SWAP1
000003d0: POP
000003d1: PUSH2 0x03bc
000003d4: DUP2
000003d5: PUSH2 0x0398
000003d8: JUMP
000003d9: JUMPDEST
000003da: SWAP3
000003db: SWAP2
000003dc: POP
000003dd: POP
000003de: JUMP

000003df: JUMPDEST
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

000003e0: PUSH0
; Push 0 sebagai placeholder untuk nilai pertama yang akan di-decode.
;
; Gas cost: 2 gas

000003e1: PUSH0
; Push 0 sebagai placeholder untuk nilai kedua yang akan di-decode.
;
; Gas cost: 2 gas

000003e2: PUSH1 0x40
; Push 0x40 (64 dalam desimal) - ukuran minimal yang dibutuhkan.
; 2 arguments × 32 bytes = 64 bytes.
;
; Gas cost: 3 gas

000003e4: DUP4
; Duplikat start offset dari parameter.
;
; Gas cost: 3 gas

000003e5: DUP6
; Duplikat end offset dari parameter.
;
; Gas cost: 3 gas

000003e6: SUB
; Hitung ukuran arguments: end - start.
;
; Gas cost: 3 gas

000003e7: SLT
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

000003e8: ISZERO
; Invert hasil: jika args_size < 0x40 → SLT = 1 → ISZERO = 0 (gagal)
;              jika args_size >= 0x40 → SLT = 0 → ISZERO = 1 (lanjut)
;
; Gas cost: 3 gas

000003e9: PUSH2 0x03d8
; Push alamat untuk skip error jika validasi berhasil.
;
; Gas cost: 3 gas

000003ec: JUMPI
; Jika ISZERO = 1 (args cukup), skip error handling.
; Jika ISZERO = 0 (args kurang), jatuh ke error handler.
;
; Gas cost: 10 gas

000003ed: PUSH2 0x03d7
; Calldata terlalu pendek - push error info.
;
; Gas cost: 3 gas

000003f0: PUSH2 0x038b
; Push address error handler.
;
; Gas cost: 3 gas

000003f3: JUMP
; Jump ke error handler untuk REVERT.
;
; Gas cost: 8 gas

000003f4: JUMPDEST
; Landing point setelah validasi berhasil.

000003f5: JUMPDEST
; Extra JUMPDEST (dari compiler).

000003f6: PUSH0
000003f7: PUSH2 0x03e5
000003fa: DUP6
000003fb: DUP3
000003fc: DUP7
000003fd: ADD
000003fe: PUSH2 0x03ae
00000401: JUMP
00000402: JUMPDEST
00000403: SWAP3
00000404: POP
00000405: POP
00000406: PUSH1 0x20
00000408: PUSH2 0x03f6
0000040b: DUP6
0000040c: DUP3
0000040d: DUP7
0000040e: ADD
0000040f: PUSH2 0x03ae
00000412: JUMP
00000413: JUMPDEST
00000414: SWAP2
00000415: POP
00000416: POP
00000417: SWAP3
00000418: POP
00000419: SWAP3
0000041a: SWAP1
0000041b: POP
0000041c: JUMP
0000041d: JUMPDEST
0000041e: PUSH2 0x0409
00000421: DUP2
00000422: PUSH2 0x038f
00000425: JUMP
00000426: JUMPDEST
00000427: DUP3
00000428: MSTORE
00000429: POP
0000042a: POP
0000042b: JUMP
0000042c: JUMPDEST
0000042d: PUSH0
0000042e: PUSH1 0x20
00000430: DUP3
00000431: ADD
00000432: SWAP1
00000433: POP
00000434: PUSH2 0x0422
00000437: PUSH0
00000438: DUP4
00000439: ADD
0000043a: DUP5
0000043b: PUSH2 0x0400
0000043e: JUMP
0000043f: JUMPDEST
00000440: SWAP3
00000441: SWAP2
00000442: POP
00000443: POP
00000444: JUMP

00000445: JUMPDEST
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

00000446: PUSH0
; Push placeholder untuk nilai pertama.
;
; Gas cost: 2 gas

00000447: PUSH0
; Push placeholder untuk nilai kedua.
;
; Gas cost: 2 gas

00000448: PUSH0
; Push placeholder untuk nilai ketiga.
;
; Gas cost: 2 gas

00000449: PUSH1 0x60
; Push 0x60 (96 desimal) - ukuran minimal yang dibutuhkan.
; 3 arguments × 32 bytes = 96 bytes.
;
; Gas cost: 3 gas

0000044b: DUP5
; Duplikat start offset.
;
; Gas cost: 3 gas

0000044c: DUP7
; Duplikat end offset.
;
; Gas cost: 3 gas

0000044d: SUB
; Hitung ukuran: end - start.
;
; Gas cost: 3 gas

0000044e: SLT
; SLT - Cek apakah ukuran < 96 (tidak cukup untuk 3 args).
;
; Gas cost: 3 gas

0000044f: ISZERO
; Invert: true jika ukuran >= 96 (cukup).
;
; Gas cost: 3 gas

00000450: PUSH2 0x043f
; Push alamat skip error.
;
; Gas cost: 3 gas

00000453: JUMPI
; Skip error jika calldata cukup.
;
; Gas cost: 10 gas

00000454: PUSH2 0x043e
; Calldata tidak cukup - push error info.
;
; Gas cost: 3 gas

00000457: PUSH2 0x038b
; Push error handler address.
;
; Gas cost: 3 gas

0000045a: JUMP
; Jump ke error handler untuk REVERT.
;
; Gas cost: 8 gas

0000045b: JUMPDEST
; Landing point setelah validasi.

0000045c: JUMPDEST
; Extra JUMPDEST.

0000045d: PUSH0
; Offset untuk argument pertama: 0.
;
; Gas cost: 2 gas

0000045e: PUSH2 0x044c
; Push return address setelah decode arg 1.
;
; Gas cost: 3 gas

00000461: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000462: DUP3
; Duplikat argument offset (0).
;
; Gas cost: 3 gas

00000463: DUP8
; Duplikat end offset.
;
; Gas cost: 3 gas

00000464: ADD
; Hitung absolute offset: calldata_offset + arg_offset.
;
; Gas cost: 3 gas

00000465: PUSH2 0x03ae
; Push alamat helper untuk decode single uint256.
;
; Gas cost: 3 gas

00000468: JUMP
; Decode argument pertama.
;
; Gas cost: 8 gas

00000469: JUMPDEST
; Return dari decode arg 1.

0000046a: SWAP4
; Simpan arg1 ke posisi yang tepat.
;
; Gas cost: 3 gas

0000046b: POP
; Cleanup.
;
; Gas cost: 2 gas

0000046c: POP
; Cleanup.
;
; Gas cost: 2 gas

0000046d: PUSH1 0x20
; Offset untuk argument kedua: 32.
;
; Gas cost: 3 gas

0000046f: PUSH2 0x045d
; Push return address setelah decode arg 2.
;
; Gas cost: 3 gas

00000472: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000473: DUP3
; Duplikat argument offset (32).
;
; Gas cost: 3 gas

00000474: DUP8
; Duplikat untuk calculation.
;
; Gas cost: 3 gas

00000475: ADD
; Hitung absolute offset: calldata_offset + 32.
;
; Gas cost: 3 gas

00000476: PUSH2 0x03ae
; Push alamat decode helper.
;
; Gas cost: 3 gas

00000479: JUMP
; Decode argument kedua.
;
; Gas cost: 8 gas

0000047a: JUMPDEST
; Return dari decode arg 2.

0000047b: SWAP3
; Simpan arg2.
;
; Gas cost: 3 gas

0000047c: POP
; Cleanup.
;
; Gas cost: 2 gas

0000047d: POP
; Cleanup.
;
; Gas cost: 2 gas

0000047e: PUSH1 0x40
; Offset untuk argument ketiga: 64.
;
; Gas cost: 3 gas

00000480: PUSH2 0x046e
; Push return address setelah decode arg 3.
;
; Gas cost: 3 gas

00000483: DUP7
; Duplikat calldata offset.
;
; Gas cost: 3 gas

00000484: DUP3
00000485: DUP8
00000486: ADD
00000487: PUSH2 0x03ae
0000048a: JUMP
0000048b: JUMPDEST
0000048c: SWAP2
0000048d: POP
0000048e: POP
0000048f: SWAP3
00000490: POP
00000491: SWAP3
00000492: POP
00000493: SWAP3
00000494: JUMP

00000495: JUMPDEST
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

00000496: PUSH32 0x4e487b7100000000000000000000000000000000000000000000000000000000
; Push selector untuk Panic(uint256).
; Ini adalah 4 bytes pertama dari keccak256("Panic(uint256)").
;
; Gas cost: 3 gas

000004b7: PUSH0
; Push offset 0 untuk MSTORE.
;
; Gas cost: 2 gas

000004b8: MSTORE
; Simpan selector ke memory[0:32].
; memory[0:4] = 0x4e487b71 (selector)
; memory[4:32] = 0x00...00 (padding)
;
; Gas cost: 3 gas + memory expansion

000004b9: PUSH1 0x11
; Push error code 0x11 (17) = Arithmetic overflow/underflow.
; Ini memberitahu caller MENGAPA transaksi gagal.
;
; Gas cost: 3 gas

000004bb: PUSH1 0x04
; Push offset 4 untuk MSTORE.
; Error code akan disimpan setelah selector.
;
; Gas cost: 3 gas

000004bd: MSTORE
; Simpan error code ke memory[4:36].
; memory[0:4] = selector
; memory[4:36] = error code (0x11 dengan padding)
;
; Gas cost: 3 gas

000004be: PUSH1 0x24
; Push 0x24 (36) = size of error data.
; 4 bytes selector + 32 bytes error code = 36 bytes.
;
; Gas cost: 3 gas

000004c0: PUSH0
; Push 0 = offset di memory.
;
; Gas cost: 2 gas

000004c1: REVERT
; REVERT dengan error data Panic(0x11).
; Caller akan melihat "Panic: Arithmetic overflow/underflow".
;
; Di etherscan/block explorer, error ini ditampilkan sebagai:
; "execution reverted: Panic: Arithmetic operation underflowed or overflowed"
;
; Gas cost: 0 gas (transaksi tetap gagal, sisa gas dikembalikan)

000004c2: JUMPDEST
000004c3: PUSH0
000004c4: DUP2
000004c5: PUSH1 0x01
000004c7: SHR
000004c8: SWAP1
000004c9: POP
000004ca: SWAP2
000004cb: SWAP1
000004cc: POP
000004cd: JUMP
000004ce: JUMPDEST
; ============================================================================
; HELPER: Exponentiation dengan algoritma "Square and Multiply"
; ============================================================================
; Ini adalah implementasi efisien untuk menghitung base^exp dengan
; algoritma binary exponentiation (square and multiply).
;
; Algoritma ini menghitung a^n dalam O(log n) perkalian, bukan O(n).
; Contoh: 2^10 = ((2^2)^2 * 2)^2 = hanya 4 perkalian, bukan 10!

000004cf: PUSH0
; Initialize result placeholder.

000004d0: PUSH0
; Initialize accumulator placeholder.

000004d1: DUP3
; Duplikat base.

000004d2: SWAP2
; Rearrange stack.

000004d3: POP
; Cleanup.

000004d4: DUP4
; Duplikat exp.

000004d5: SWAP1
; Rearrange.

000004d6: POP
; Cleanup.

000004d7: JUMPDEST
; Loop entry point untuk square and multiply.

000004d8: PUSH1 0x01
; Push 1 untuk perbandingan.

000004da: DUP6
; Duplikat current exponent.

000004db: GT
; Cek apakah exp > 1 (masih perlu iterasi).

000004dc: ISZERO
; Invert: true jika exp <= 1 (loop selesai).

000004dd: PUSH2 0x04fa
; Alamat keluar loop.

000004e0: JUMPI
; Jump keluar jika exp <= 1.

000004e1: DUP1
; Duplikat current result.

000004e2: DUP7
; Duplikat MAX_UINT atau base.

000004e3: DIV
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

000004e4: DUP2
; Duplikat untuk overflow check.

000004e5: GT
; Cek overflow.

000004e6: ISZERO
; Invert result.

000004e7: PUSH2 0x04d6
; Alamat untuk continue loop.

000004ea: JUMPI
; Skip panic jika tidak overflow.

000004eb: PUSH2 0x04d5
; Overflow detected - push panic info.

000004ee: PUSH2 0x0478
; Push panic handler address.

000004f1: JUMP
; Jump ke panic handler.

000004f2: JUMPDEST
; Landing point setelah overflow check.

000004f3: JUMPDEST
; Extra JUMPDEST.

000004f4: PUSH1 0x01
; Push 1 untuk AND operation.

000004f6: DUP6
; Duplikat current exponent.

000004f7: AND
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

000004f8: ISZERO
; true jika bit terakhir = 0 (exp genap).

000004f9: PUSH2 0x04e5
; Skip multiplication jika exp genap.

000004fc: JUMPI
; Conditional jump.

000004fd: DUP1
; Duplikat base untuk perkalian.

000004fe: DUP3
; Duplikat current result.

000004ff: MUL
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

00000500: SWAP2
; result = result * base (update accumulator).

00000501: POP
; Cleanup old result.

00000502: JUMPDEST
; Landing point untuk "multiply" step.

00000503: DUP1
; Duplikat base.

00000504: DUP2
; Duplikat base lagi.

00000505: MUL
; base = base * base (square step)
; Ini adalah bagian "square" dari "square and multiply".

00000506: SWAP1
; Update base.

00000507: POP
; Cleanup old base.

00000508: PUSH2 0x04f3
; Push return address untuk recursive call.

0000050b: DUP6
; Duplikat exponent.

0000050c: PUSH2 0x04a5
; Push address untuk SHR (shift right by 1).

0000050f: JUMP
; Jump ke shift exp right (exp = exp / 2).
00000510: JUMPDEST
00000511: SWAP5
00000512: POP
00000513: PUSH2 0x04ba
00000516: JUMP
00000517: JUMPDEST
00000518: SWAP5
00000519: POP
0000051a: SWAP5
0000051b: SWAP3
0000051c: POP
0000051d: POP
0000051e: POP
0000051f: JUMP
00000520: JUMPDEST
00000521: PUSH0
00000522: DUP3
00000523: PUSH2 0x0512
00000526: JUMPI
00000527: PUSH1 0x01
00000529: SWAP1
0000052a: POP
0000052b: PUSH2 0x05cd
0000052e: JUMP
0000052f: JUMPDEST
00000530: DUP2
00000531: PUSH2 0x051f
00000534: JUMPI
00000535: PUSH0
00000536: SWAP1
00000537: POP
00000538: PUSH2 0x05cd
0000053b: JUMP
0000053c: JUMPDEST
0000053d: DUP2
0000053e: PUSH1 0x01
00000540: DUP2
00000541: EQ
00000542: PUSH2 0x0535
00000545: JUMPI
00000546: PUSH1 0x02
00000548: DUP2
00000549: EQ
0000054a: PUSH2 0x053f
0000054d: JUMPI
0000054e: PUSH2 0x056e
00000551: JUMP
00000552: JUMPDEST
00000553: PUSH1 0x01
00000555: SWAP2
00000556: POP
00000557: POP
00000558: PUSH2 0x05cd
0000055b: JUMP
0000055c: JUMPDEST
0000055d: PUSH1 0xff
0000055f: DUP5
00000560: GT
00000561: ISZERO
00000562: PUSH2 0x0551
00000565: JUMPI
00000566: PUSH2 0x0550
00000569: PUSH2 0x0478
0000056c: JUMP
0000056d: JUMPDEST
0000056e: JUMPDEST
; Fallback untuk kasus exp yang tidak teroptimasi.

0000056f: DUP4
; Duplikat exponent.

00000570: PUSH1 0x02
; Push base 2 untuk operasi 2^exp.

00000572: EXP
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

00000573: SWAP2
00000574: POP
00000575: DUP5
00000576: DUP3
00000577: GT
00000578: ISZERO
00000579: PUSH2 0x0568
0000057c: JUMPI
0000057d: PUSH2 0x0567
00000580: PUSH2 0x0478
00000583: JUMP
00000584: JUMPDEST
00000585: JUMPDEST
00000586: POP
00000587: PUSH2 0x05cd
0000058a: JUMP
0000058b: JUMPDEST
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

0000058c: POP
; Cleanup stack.
;
; Gas cost: 2 gas

0000058d: PUSH1 0x20
; Push 0x20 (32 desimal) - threshold exponent pertama.
;
; Gas cost: 3 gas

0000058f: DUP4
; Duplikat exponent.
;
; Gas cost: 3 gas

00000590: LT
; LT - Cek apakah exp < 32.
;
; Gas cost: 3 gas

00000591: PUSH2 0x0133
; Push 0x0133 (307 desimal) - threshold base pertama.
;
; Gas cost: 3 gas

00000594: DUP4
; Duplikat base.
;
; Gas cost: 3 gas

00000595: LT
; LT - Cek apakah base < 307.
;
; Gas cost: 3 gas

00000596: AND
; Kombinasi: (exp < 32) AND (base < 307)
; Jika kedua kondisi true, ini adalah "small exponentiation" yang aman.
;
; Gas cost: 3 gas

00000597: PUSH1 0x4e
; Push 0x4e (78 desimal) - threshold exponent kedua.
;
; Gas cost: 3 gas

00000599: DUP5
; Duplikat exponent.
;
; Gas cost: 3 gas

0000059a: LT
; LT - Cek apakah exp < 78.
;
; Gas cost: 3 gas

0000059b: PUSH1 0x0b
; Push 0x0b (11 desimal) - threshold base kedua.
;
; Gas cost: 3 gas

0000059d: DUP5
; Duplikat base.
;
; Gas cost: 3 gas

0000059e: LT
; LT - Cek apakah base < 11.
;
; Gas cost: 3 gas

0000059f: AND
; Kombinasi: (exp < 78) AND (base < 11)
; Kondisi kedua untuk optimisasi.
;
; Gas cost: 3 gas

000005a0: OR
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

000005a1: ISZERO
; Invert hasil OR:
; - Jika OR = 1 (bisa optimisasi): ISZERO = 0 → tidak jump, pakai EXP langsung
; - Jika OR = 0 (perlu full algo): ISZERO = 1 → jump ke square-and-multiply
;
; Gas cost: 3 gas

000005a2: PUSH2 0x05a3
; Push alamat untuk case yang perlu square-and-multiply.
;
; Gas cost: 3 gas

000005a5: JUMPI
; Conditional jump berdasarkan hasil ISZERO.
;
; Gas cost: 10 gas

000005a6: DUP3
; Jika sampai sini, kita bisa pakai optimisasi langsung.
; Duplikat base untuk EXP.
;
; Gas cost: 3 gas

000005a7: DUP3
; Duplikat exponent untuk EXP.
;
; Gas cost: 3 gas

000005a8: EXP
000005a9: SWAP1
000005aa: POP
000005ab: DUP4
000005ac: DUP2
000005ad: GT
000005ae: ISZERO
000005af: PUSH2 0x059e
000005b2: JUMPI
000005b3: PUSH2 0x059d
000005b6: PUSH2 0x0478
000005b9: JUMP
000005ba: JUMPDEST
000005bb: JUMPDEST
000005bc: PUSH2 0x05cd
000005bf: JUMP
000005c0: JUMPDEST
000005c1: PUSH2 0x05b0
000005c4: DUP5
000005c5: DUP5
000005c6: DUP5
000005c7: PUSH1 0x01
000005c9: PUSH2 0x04b1
000005cc: JUMP
000005cd: JUMPDEST
000005ce: SWAP3
000005cf: POP
000005d0: SWAP1
000005d1: POP
000005d2: DUP2
000005d3: DUP5
000005d4: DIV
000005d5: DUP2
000005d6: GT
000005d7: ISZERO
000005d8: PUSH2 0x05c7
000005db: JUMPI
000005dc: PUSH2 0x05c6
000005df: PUSH2 0x0478
000005e2: JUMP
000005e3: JUMPDEST
000005e4: JUMPDEST
000005e5: DUP2
000005e6: DUP2
000005e7: MUL
000005e8: SWAP1
000005e9: POP
000005ea: JUMPDEST
000005eb: SWAP4
000005ec: SWAP3
000005ed: POP
000005ee: POP
000005ef: POP
000005f0: JUMP
000005f1: JUMPDEST
000005f2: PUSH0
000005f3: PUSH2 0x05de
000005f6: DUP3
000005f7: PUSH2 0x038f
000005fa: JUMP
000005fb: JUMPDEST
000005fc: SWAP2
000005fd: POP
000005fe: PUSH2 0x05e9
00000601: DUP4
00000602: PUSH2 0x038f
00000605: JUMP
00000606: JUMPDEST
00000607: SWAP3
00000608: POP
00000609: PUSH2 0x0616
0000060c: PUSH32 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
0000062d: DUP5
0000062e: DUP5
0000062f: PUSH2 0x0503
00000632: JUMP
00000633: JUMPDEST
00000634: SWAP1
00000635: POP
00000636: SWAP3
00000637: SWAP2
00000638: POP
00000639: POP
0000063a: JUMP
0000063b: JUMPDEST
0000063c: PUSH0
0000063d: PUSH2 0x0628
00000640: DUP3
00000641: PUSH2 0x038f
00000644: JUMP
00000645: JUMPDEST
00000646: SWAP2
00000647: POP
00000648: PUSH2 0x0633
0000064b: DUP4
0000064c: PUSH2 0x038f
0000064f: JUMP
00000650: JUMPDEST
00000651: SWAP3
00000652: POP
00000653: DUP3
00000654: DUP3
00000655: ADD
00000656: SWAP1
00000657: POP
00000658: DUP1
00000659: DUP3
0000065a: GT
0000065b: ISZERO
0000065c: PUSH2 0x064b
0000065f: JUMPI
00000660: PUSH2 0x064a
00000663: PUSH2 0x0478
00000666: JUMP
00000667: JUMPDEST
00000668: JUMPDEST
00000669: SWAP3
0000066a: SWAP2
0000066b: POP
0000066c: POP
0000066d: JUMP
0000066e: JUMPDEST
0000066f: PUSH0
00000670: DUP3
00000671: DUP3
00000672: MSTORE
00000673: PUSH1 0x20
00000675: DUP3
00000676: ADD
00000677: SWAP1
00000678: POP
00000679: SWAP3
0000067a: SWAP2
0000067b: POP
0000067c: POP
0000067d: JUMP

0000067e: JUMPDEST
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

0000067f: PUSH32 0x4469766973696f6e206279207a65726f00000000000000000000000000000000
; Push string "Division by zero" dengan padding zeros.
; 32 bytes total, 16 bytes string + 16 bytes padding.
;
; Gas cost: 3 gas

000006a0: PUSH0
; Push offset 0 (relative ke posisi penulisan).
;
; Gas cost: 2 gas

000006a1: DUP3
; Duplikat memory destination.
;
; Gas cost: 3 gas

000006a2: ADD
; Hitung absolute memory address.
;
; Gas cost: 3 gas

000006a3: MSTORE
; Simpan string ke memory.
;
; Gas cost: 3 gas

000006a4: POP
; Cleanup stack.
;
; Gas cost: 2 gas

000006a5: JUMP
; Return ke caller.
;
; Gas cost: 8 gas
000006a6: JUMPDEST
000006a7: PUSH0
000006a8: PUSH2 0x0695
000006ab: PUSH1 0x10
000006ad: DUP4
000006ae: PUSH2 0x0651
000006b1: JUMP
000006b2: JUMPDEST
000006b3: SWAP2
000006b4: POP
000006b5: PUSH2 0x06a0
000006b8: DUP3
000006b9: PUSH2 0x0661
000006bc: JUMP
000006bd: JUMPDEST
000006be: PUSH1 0x20
000006c0: DUP3
000006c1: ADD
000006c2: SWAP1
000006c3: POP
000006c4: SWAP2
000006c5: SWAP1
000006c6: POP
000006c7: JUMP
000006c8: JUMPDEST
000006c9: PUSH0
000006ca: PUSH1 0x20
000006cc: DUP3
000006cd: ADD
000006ce: SWAP1
000006cf: POP
000006d0: DUP2
000006d1: DUP2
000006d2: SUB
000006d3: PUSH0
000006d4: DUP4
000006d5: ADD
000006d6: MSTORE
000006d7: PUSH2 0x06c2
000006da: DUP2
000006db: PUSH2 0x0689
000006de: JUMP
000006df: JUMPDEST
000006e0: SWAP1
000006e1: POP
000006e2: SWAP2
000006e3: SWAP1
000006e4: POP
000006e5: JUMP

000006e6: JUMPDEST
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

000006e7: PUSH32 0x4e487b7100000000000000000000000000000000000000000000000000000000
; Push selector untuk Panic(uint256).
;
; Gas cost: 3 gas

00000708: PUSH0
; Push offset 0 untuk MSTORE.
;
; Gas cost: 2 gas

00000709: MSTORE
; Simpan selector ke memory[0:32].
;
; Gas cost: 3 gas + memory expansion

0000070a: PUSH1 0x12
; Push error code 0x12 (18) = Division or modulo by zero.
;
; Gas cost: 3 gas

0000070c: PUSH1 0x04
; Push offset 4 untuk MSTORE.
;
; Gas cost: 3 gas

0000070e: MSTORE
; Simpan error code ke memory[4:36].
;
; Gas cost: 3 gas

0000070f: PUSH1 0x24
; Push 0x24 (36) = size of error data.
;
; Gas cost: 3 gas

00000711: PUSH0
; Push 0 = offset di memory.
;
; Gas cost: 2 gas

00000712: REVERT
; REVERT dengan error data Panic(0x12).
; Caller akan melihat "Panic: Division or modulo by zero".
;
; Di etherscan/block explorer, error ini ditampilkan sebagai:
; "execution reverted: Panic: Division or modulo division by zero"
;
; Gas cost: 0 gas

00000713: JUMPDEST
00000714: PUSH0
00000715: PUSH2 0x0700
00000718: DUP3
00000719: PUSH2 0x038f
0000071c: JUMP
0000071d: JUMPDEST
0000071e: SWAP2
0000071f: POP
00000720: PUSH2 0x070b
00000723: DUP4
00000724: PUSH2 0x038f
00000727: JUMP
00000728: JUMPDEST
00000729: SWAP3
0000072a: POP
0000072b: DUP3
0000072c: PUSH2 0x071b
0000072f: JUMPI
00000730: PUSH2 0x071a
00000733: PUSH2 0x06c9
00000736: JUMP
00000737: JUMPDEST
00000738: JUMPDEST
00000739: DUP3
0000073a: DUP3
0000073b: DIV
0000073c: SWAP1
0000073d: POP
0000073e: SWAP3
0000073f: SWAP2
00000740: POP
00000741: POP
00000742: JUMP
00000743: JUMPDEST
00000744: PUSH0
00000745: PUSH2 0x0730
00000748: DUP3
00000749: PUSH2 0x038f
0000074c: JUMP
0000074d: JUMPDEST
0000074e: SWAP2
0000074f: POP
00000750: PUSH2 0x073b
00000753: DUP4
00000754: PUSH2 0x038f
00000757: JUMP
00000758: JUMPDEST
00000759: SWAP3
0000075a: POP
0000075b: DUP3
0000075c: DUP3
0000075d: SUB
0000075e: SWAP1
0000075f: POP
00000760: DUP2
00000761: DUP2
00000762: GT
00000763: ISZERO
00000764: PUSH2 0x0753
00000767: JUMPI
00000768: PUSH2 0x0752
0000076b: PUSH2 0x0478
0000076e: JUMP
0000076f: JUMPDEST
00000770: JUMPDEST
00000771: SWAP3
00000772: SWAP2
00000773: POP
00000774: POP
00000775: JUMP
00000776: JUMPDEST
00000777: PUSH0
00000778: PUSH2 0x0763
0000077b: DUP3
0000077c: PUSH2 0x038f
0000077f: JUMP
00000780: JUMPDEST
00000781: SWAP2
00000782: POP
00000783: PUSH2 0x076e
00000786: DUP4
00000787: PUSH2 0x038f
0000078a: JUMP
0000078b: JUMPDEST
0000078c: SWAP3
0000078d: POP
0000078e: DUP3
0000078f: DUP3
00000790: MUL
00000791: PUSH2 0x077c
00000794: DUP2
00000795: PUSH2 0x038f
00000798: JUMP
00000799: JUMPDEST
0000079a: SWAP2
0000079b: POP
0000079c: DUP3
0000079d: DUP3
0000079e: DIV
0000079f: DUP5
000007a0: EQ
000007a1: DUP4
000007a2: ISZERO
000007a3: OR
000007a4: PUSH2 0x0793
000007a7: JUMPI
000007a8: PUSH2 0x0792
000007ab: PUSH2 0x0478
000007ae: JUMP
000007af: JUMPDEST
000007b0: JUMPDEST
000007b1: POP
000007b2: SWAP3
000007b3: SWAP2
000007b4: POP
000007b5: POP
000007b6: JUMP

000007b7: JUMPDEST
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

000007b8: PUSH32 0x4d6f64756c6f206279207a65726f000000000000000000000000000000000000
; Push string "Modulo by zero" dengan padding zeros.
; 32 bytes total, 14 bytes string + 18 bytes padding.
;
; Gas cost: 3 gas

000007d9: PUSH0
; Push offset 0 (relative ke posisi penulisan).
;
; Gas cost: 2 gas

000007da: DUP3
; Duplikat memory destination.
;
; Gas cost: 3 gas

000007db: ADD
; Hitung absolute memory address.
;
; Gas cost: 3 gas

000007dc: MSTORE
; Simpan string ke memory.
;
; Gas cost: 3 gas

000007dd: POP
; Cleanup stack.
;
; Gas cost: 2 gas

000007de: JUMP
; Return ke caller.
;
; Gas cost: 8 gas
000007df: JUMPDEST
000007e0: PUSH0
000007e1: PUSH2 0x07ce
000007e4: PUSH1 0x0e
000007e6: DUP4
000007e7: PUSH2 0x0651
000007ea: JUMP
000007eb: JUMPDEST
000007ec: SWAP2
000007ed: POP
000007ee: PUSH2 0x07d9
000007f1: DUP3
000007f2: PUSH2 0x079a
000007f5: JUMP
000007f6: JUMPDEST
000007f7: PUSH1 0x20
000007f9: DUP3
000007fa: ADD
000007fb: SWAP1
000007fc: POP
000007fd: SWAP2
000007fe: SWAP1
000007ff: POP
00000800: JUMP
00000801: JUMPDEST
00000802: PUSH0
00000803: PUSH1 0x20
00000805: DUP3
00000806: ADD
00000807: SWAP1
00000808: POP
00000809: DUP2
0000080a: DUP2
0000080b: SUB
0000080c: PUSH0
0000080d: DUP4
0000080e: ADD
0000080f: MSTORE
00000810: PUSH2 0x07fb
00000813: DUP2
00000814: PUSH2 0x07c2
00000817: JUMP
00000818: JUMPDEST
00000819: SWAP1
0000081a: POP
0000081b: SWAP2
0000081c: SWAP1
0000081d: POP
0000081e: JUMP
0000081f: JUMPDEST
; ============================================================================
; HELPER: Modulo Operation with Division by Zero Check
; ============================================================================
; Fungsi helper untuk operasi modulo dengan pengecekan pembagian dengan nol.

00000820: PUSH0
; Push placeholder.

00000821: PUSH2 0x080c
; Push return address.

00000824: DUP3
; Duplikat operand.

00000825: PUSH2 0x038f
; Push address type check.

00000828: JUMP
; Jump ke type check.

00000829: JUMPDEST
; Landing point.

0000082a: SWAP2
; Rearrange stack.

0000082b: POP
; Cleanup.

0000082c: PUSH2 0x0817
; Push return address.

0000082f: DUP4
; Duplikat operand.

00000830: PUSH2 0x038f
; Push address type check.

00000833: JUMP
; Jump ke type check.

00000834: JUMPDEST
; Landing point.

00000835: SWAP3
; Rearrange stack.

00000836: POP
; Cleanup.

00000837: DUP3
; Duplikat divisor untuk pengecekan zero.

00000838: PUSH2 0x0827
; Push alamat skip panic.

0000083b: JUMPI
; Jump jika divisor != 0.

0000083c: PUSH2 0x0826
; Divisor adalah 0 - push panic info.

0000083f: PUSH2 0x06c9
; Push panic handler address (division by zero).

00000842: JUMP
; Jump ke panic handler.

00000843: JUMPDEST
; Landing point jika divisor != 0.

00000844: JUMPDEST
; Extra JUMPDEST.

00000845: DUP3
; Duplikat dividend.

00000846: DUP3
; Duplikat divisor.
; Stack: [divisor, dividend, ...]

00000847: MOD
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

00000848: SWAP1
; Swap untuk cleanup stack.

00000849: POP
; Buang operand lama.

0000084a: SWAP3
; Rearrange untuk return.

0000084b: SWAP2
; Rearrange.

0000084c: POP
; Cleanup.

0000084d: POP
; Cleanup.

0000084e: JUMP
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

0000084f: INVALID
; Barrier - metadata dimulai setelah ini.
; Jika eksekusi mencapai sini, transaksi akan gagal.

00000850: LOG2
; Bagian dari CBOR-encoded metadata.
; BUKAN instruksi LOG2 yang sebenarnya - ini adalah data mentah.

00000851: PUSH5 0x6970667358
; Bagian dari metadata - "ipfs" dalam hex: 0x69706673 = "ipfs"

00000857: INVALID
; Data metadata.

00000858: SLT
; Data metadata (bukan opcode SLT sebenarnya).

00000859: KECCAK256
; Data metadata (bukan opcode KECCAK256 sebenarnya).

0000085a: PUSH8 0xc4b4727da07d0f03
; Bagian dari IPFS content hash.

00000863: SWAP15
; Data metadata.

00000864: SELFDESTRUCT
; Data metadata (BUKAN opcode SELFDESTRUCT sebenarnya!)
; Ini adalah bagian dari hash, bukan instruksi.

00000865: DUP4
; Data metadata.

00000866: SHR
; Data metadata.

00000867: STOP
; Data metadata.

00000868: PUSH18 0xb512a15fbcfafa4706464a55e5ba02e80a64
; Lanjutan IPFS hash.

0000087b: PUSH20 0x6f6c634300081c00330000000000000000000000
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
