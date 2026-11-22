# Konsep Edit Video (ikut gaya Task 1 – diluluskan)

Gunakan konsep ini untuk setiap video VO/produk seterusnya, melainkan diminta lain.

## Audio
- **Voiceover asal JANGAN diubah**: tiada potongan, tiada tempo, tiada EQ/compressor/normalisasi, tiada naik/turun gain.
  Salin audio terus dari fail asal; semua visual ikut masa VO asal.
- Selepas render, sahkan VO: anjakan 0 sampel, gain ≈ 1.0 berbanding asal.
- Background music: ikut arahan (Task 1 = tiada).
- SFX (whoosh, swipe, pop, tick, ding, ka-ching, impact, hujan) diletak rendah supaya suara VO kekal jelas di atasnya
  (Task 1: SFX_GAIN 0.3).
- Langkah akhir: encode semula video ke H.264 sahaja, audio `-c:a copy` (tiada loudnorm).

## Transkrip & potongan
- Transkrip dengan Whisper (medium, bahasa `ms`, word timestamps). Betulkan ejaan (cth. "penggering" → "pengering").
- "Buang bahagian tak perlu" = buang visual yang tak berguna (skrin hitam, logo CapCut, bahagian unboxing/setup panjang),
  BUKAN memotong VO.

## Visual
- 1080x1920, 60fps. Footage B-roll tukar setiap ayat/frasa VO, dengan punch-in zoom + flash putih ringan di setiap cut.
- Klip iPhone HLG HDR mesti tone-map ke SDR bt709 dahulu (zscale + tonemap=hable), kalau tak renderer masuk laluan HDR.
- Hook (0–3s): soalan besar (Anton) + animasi ikon (cth. "KAKI TRAVEL?" + kapal terbang), kemudian "WAJIB BAWA BENDA NI!".
- Motion graphics ikut sebutan VO, di zon atas (y ≈ 330–1000):
  chip ✓ yang menyala bila disebut, kad ikon masalah, langkah 1-2-3, badge/dial nombor (0→120 minit, 0→48°C + mangga),
  perisai "tak rosak", starburst harga + cop "RUGI TAK GRAB!".
- CTA: kotak merah "SEBELUM HARGA NAIK!" → kad kuning "CHECK OUT SEKARANG kat beg kuning bawah ni" + ikon beg kuning + anak panah ke bawah.
- Palet: kuning #ffd60a, oren #ff6a1a, merah #ff2d3d, hijau #2bd96b, panel gelap rgba(8,10,20,.86). Font: Anton + Poppins 900.

## Caption
- Gaya karaoke, huruf besar, Poppins 900 ~62px, outline hitam, di y ≈ 1060 (tengah-bawah, dalam zon selamat TikTok).
- Pecah ikut ayat VO dan koma, maksimum 4 perkataan sebaris. Perkataan aktif melantun; kata kunci bertukar kuning.
- Caption berhenti bila kad CTA keluar (kad dah papar ayat sama).

## Teknikal HyperFrames
- Set keterlihatan klip secara eksplisit dalam timeline GSAP (render-path independent).
- Semak dengan `npx hyperframes check` + snapshot sebelum render; render `-f 60 -q delivery`.
- Rujukan projek: `video/task1/hyperframes-project/` (build.py + template.tpl).

## Varian tanpa VO (Task 3)
- Bila tiada fail VO: footage + teks skrin ikut skrip pengguna (hook / langkah / USP / CTA) + SFX.
- Langkah "Cara guna": senarai ringkas 2x2 di atas (aktif = kuning, selesai = hijau) + label besar "LANGKAH N" di tengah.
- Hanya guna ayat yang pengguna beri — jangan tambah dakwaan baru.
- Master audio (SFX sahaja) boleh dinormalkan ke -14 LUFS.

## Saiz grafik (diluluskan – Task 3 v3)
- Semua caption, overlay, kad dan animasi = **70% daripada saiz asal** template ini.
  - Caption langkah: label "LANGKAH N" 42px, teks utama Anton 67px (stroke 3px + bayang gelap), chip 25px.
  - Grafik lain dibungkus dalam `.sc { transform: scale(0.7) }` dengan transform-origin di bahagian atas grafik
    (kedudukan atas kekal, saiz mengecil ke bawah).
- Rujukan: `video/task3/hyperframes-project/index.html`.

## Format tulisan (TERKINI – guna untuk task seterusnya; mengatasi saiz di atas)
Saiz ditetapkan terus dalam CSS (tanpa `.sc { transform: scale(...) }`).

| Tulisan | Sebelum | Sekarang | Contoh elemen dalam template ini |
|---|---|---|---|
| Headline | 150px | **100px** | hook ("WAJIB BAWAK PERGI TRAVEL!"), "CARA GUNA", "GRAB CEPAT!", "SAIZ KOMPAK" |
| Sub-headline / pelekat | 70px | **47px** | "( PENGERING PORTABLE )", "HARGA TENGAH MURAH!", label "LANGKAH N", "SUHU DAH LOCK" |
| Caption | 60px | **40px** | teks caption / label langkah di tengah skrin |
| Nombor besar (cth. heart rate) | 96px | **64px** | kaunter 48°C, dial 120 / 30 minit |
| Chip, nama warna, label zon | 28px | **19px** | chip KASUT/STOKIN/BAJU, item senarai langkah, pill kecil |

## Caption vs grafik (diluluskan – Task 4)
- Kalau tulisan dah ada pada grafik/overlay di atas, **jangan ulang dalam caption**: buang chunk caption itu
  (dalam build.py: senarai `DUP`). Caption hanya untuk bahagian VO yang tiada teks grafik.
