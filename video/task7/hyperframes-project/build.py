"""Task 7: builds index.html on the ORIGINAL, untouched VO timeline.
Approved rules: reference-video proportions (CSS --t-* vars), one wide shot per point, no close-up/zoom,
captions dropped where the on-screen graphic already says the same words."""
import json, html, math, os

HERE = os.path.dirname(os.path.abspath(__file__))
TOTAL = 38.0           # VO ends 37.08; CTA holds ~1s after
FIX = {"penggering": "pengering"}
TX = json.load(open(os.path.join(HERE, "tx.json")))
sents = [[[x[0], x[1], FIX.get(x[2].strip(), x[2].strip())] for x in s["w"]] for s in TX]

# (start, end, clip, media_start) — one shot per point
SCENES = [
    (0.00, 3.94, "hook45", 0.0),      # musim hujan / lambat kering (hoodie + rain)
    (3.94, 6.50, "IMG_2345", 13.6),   # pengering portable (wide, hotel)
    (6.50, 9.74, "IMG_2345", 0.0),    # cara guna + masukkan kasut
    (9.74, 11.98, "copy0B", 0.0),     # selit celah baju
    (11.98, 14.94, "IMG_2493", 0.0),  # on timer, tunggu kering
    (14.94, 17.64, "IMG_2344", 29.0), # maksimum 120 minit
    (17.64, 21.74, "IMG_2493", 20.6), # suhu lock 48C
    (21.74, 23.34, "IMG_2493", 97.0), # kain tak rosak
    (23.34, 28.98, "IMG_2344", 3.0),  # kos elektrik (plug)
    (28.98, 30.42, "IMG_2493", 64.7), # kat rumah
    (30.42, 32.86, "IMG_2344", 0.3),  # bawa travel (hotel)
    (32.86, TOTAL, "IMG_2493", 69.0), # stok + CTA
]

EMPH = {"hujan", "lebat", "kasut", "pakaian", "lambat", "kering", "kering.", "pengering", "portable", "wajib", "senang",
        "masukkan", "batang", "selit", "baju", "timer,", "120", "minit.", "48", "lock", "rosak", "murah", "10", "sen",
        "rumah", "travel", "bag.", "stok", "sold", "sekarang", "link"}

# ---------- captions: split on VO sentences, then commas, <=4 words ----------
phr = []
for s in sents:
    cur = []
    for w in s:
        cur.append(w)
        if w[2].endswith(",") and len(cur) >= 2:
            phr.append(cur); cur = []
    if cur:
        if len(cur) == 1 and phr and phr[-1][0] in s: phr[-1] = phr[-1] + cur
        else: phr.append(cur)
chunks = []
for s in phr:
    k = math.ceil(len(s) / 4); n = len(s); i = 0
    for z in [n // k + (1 if j < n % k else 0) for j in range(k)]:
        chunks.append(s[i:i + z]); i += z
CAP_END = TOTAL
# hook sentence: split so the part not on the sticker ("bila jemur kat luar") stays a caption
s0 = sents[0]
chunks = [c for c in chunks if c[0][0] >= s0[-1][1]]
chunks = [s0[0:4], s0[4:8], s0[8:10], s0[10:]] + chunks

# Chunks whose words are already shown by a graphic are not captioned (keyed by chunk start).
DUP = {}
DUP_WORDS = {  # chunk text (lowercase, no punctuation) -> graphic that says it
    "musim hujan lebat ni": "MUSIM HUJAN LEBAT NI!",
    "korang lambat kering": "LAMBAT KERING?",
    "pengering portable ni": "PENGERING PORTABLE", "memang wajib korang": "WAJIB STAND BY!", "kena stand by": "WAJIB STAND BY!",
    "pun senang je": "SENANG JE!", "korang masukkan kasut": "MASUKKAN KASUT", "kat batang ni": "KAT BATANG",
    "ataupun selit celah": "ATAU SELIT CELAH BAJU", "baju macam ni": "CELAH BAJU",
    "korang on timer": "ON TIMER", "lepas tu korang on timer": "ON TIMER", "tunggu sampai kering": "TUNGGU SAMPAI KERING",
    "maksimum korang boleh set": "MAKSIMUM", "maksimum korang boleh": "MAKSIMUM", "set selama 120 minit": "120 MINIT", "selama 120 minit": "120 MINIT",
    "dah lock kepada": "SUHU DAH LOCK", "suhu dia dah lock": "SUHU DAH LOCK", "lock kepada 48 darjah": "48°C", "48 darjah celsius": "48°C",
    "kain rosak pun": "KAIN TAK ROSAK", "risau kain rosak pun": "KAIN TAK ROSAK",
    "kos elektrik pun": "KOS ELEKTRIK MURAH", "murah sangat": "KOS ELEKTRIK MURAH", "kos elektrik pun murah sangat": "KOS ELEKTRIK MURAH",
    "sejam korang pakai": "SEJAM", "lebih kurang 10 sen je": "± 10 SEN", "kurang 10 sen je": "± 10 SEN",
    "nak pakai kat rumah boleh": "KAT RUMAH BOLEH ✓", "kat rumah boleh": "KAT RUMAH BOLEH ✓",
    "nak bawa pergi travel": "BAWA TRAVEL ✓", "simpan dalam bag": "SENANG SIMPAN DALAM BAG", "pun senang nak simpan dalam bag": "SENANG SIMPAN DALAM BAG",
    "stok dah tak banyak tau": "STOK DAH TAK BANYAK!", "stok dah tak": "STOK DAH TAK BANYAK!", "banyak tau": "STOK DAH TAK BANYAK!",
    "so sebelum sold out": "SEBELUM SOLD OUT!", "sebelum sold out": "SEBELUM SOLD OUT!",
    "check out sekarang": "CHECK OUT SEKARANG", "dekat link bawah ni": "KAT LINK BAWAH",
    "kasut ataupun pakaian korang": "KASUT & BAJU", "lambat kering": "LAMBAT KERING?", "cara nak guna": "CARA GUNA",
    "on timer": "ON TIMER", "lebih kurang 10": "± 10 SEN", "sen je": "± 10 SEN", "nak pakai kat": "KAT RUMAH BOLEH ✓",
    "rumah boleh": "KAT RUMAH BOLEH ✓", "pun senang nak": "SENANG SIMPAN DALAM BAG", "better korang check": "CHECK OUT SEKARANG",
    "out sekarang dekat": "CHECK OUT SEKARANG", "link bawah ni": "KAT LINK BAWAH", "sebab suhu dia": "SUHU DAH LOCK",
}
norm = lambda c: " ".join(w[2].lower().strip(",.?") for w in c)

cap_html, cap_js, kept, dropped = [], [], [], []
for ci, c in enumerate(chunks):
    st = c[0][0]
    en = chunks[ci + 1][0][0] if ci + 1 < len(chunks) else CAP_END
    if norm(c) in DUP_WORDS:
        dropped.append(norm(c)); continue
    kept.append(norm(c))
    spans = []
    for wi, w in enumerate(c):
        cls = "cw emph" if w[2].lower() in EMPH else "cw"
        spans.append(f'<span class="{cls}" id="w{ci}_{wi}">{html.escape(w[2].rstrip(",.?"))}</span>')
        cap_js.append(f'hl("#w{ci}_{wi}", {w[0]:.3f}, "{cls}");')
    cap_html.append(f'<div class="cap clip" id="cap{ci}" data-start="{st:.3f}" data-duration="{en - st:.3f}">' + " ".join(spans) + "</div>")
    cap_js.append(f'tl.from("#cap{ci}", {{ y: 16, scale: 0.86, opacity: 0, duration: 0.14, ease: "back.out(2)" }}, {st:.3f});')

vid_html, vid_js = [], []
for i, (s, e, src, ms) in enumerate(SCENES):
    vid_html.append(f'<video id="v{i}" class="clip" src="assets/video/{src}.mp4" data-start="{s:.2f}" data-duration="{e - s:.2f}" data-media-start="{ms}" muted playsinline></video>')
    if i: vid_js.append(f'flash({s:.2f}, 0.3);')

SFX_GAIN = 0.1  # VO stays untouched and is fairly quiet, so SFX sit low
SFX = [("rain", 0.0, 4.0, 1.2), ("impact", 0.0, 1.2, 1.4), ("whoosh", 0.05, 0.55, 1.4), ("pop", 1.02, 0.12, 1.5),
       ("riser", 2.6, 1.3, 1.0), ("impact", 3.94, 1.2, 1.6), ("pop", 5.46, 0.12, 1.5),
       ("swipe", 6.46, 0.3, 1.2), ("pop", 7.38, 0.12, 1.5), ("pop", 8.04, 0.12, 1.5), ("swipe", 9.7, 0.3, 1.2), ("pop", 9.74, 0.12, 1.5),
       ("swipe", 11.94, 0.3, 1.2), ("pop", 11.98, 0.12, 1.5), ("tick", 12.8, 0.05, 1.5), ("tick", 13.0, 0.05, 1.5), ("ding", 14.26, 1.2, 1.2),
       ("whoosh", 14.9, 0.55, 1.2), ("tick", 15.7, 0.05, 1.4), ("tick", 16.0, 0.05, 1.4), ("tick", 16.3, 0.05, 1.4), ("ding", 16.8, 1.3, 1.3),
       ("whoosh", 17.6, 0.55, 1.2), ("tick", 19.5, 0.05, 1.4), ("tick", 19.8, 0.05, 1.4), ("impact", 20.1, 0.6, 1.0), ("ding", 20.44, 1.3, 1.3),
       ("swipe", 21.7, 0.3, 1.2), ("pop", 22.0, 0.12, 1.5),
       ("whoosh", 23.3, 0.55, 1.2), ("pop", 24.54, 0.12, 1.5), ("pop", 26.2, 0.12, 1.5), ("kaching", 28.46, 1.3, 1.6),
       ("swipe", 28.94, 0.3, 1.2), ("pop", 29.82, 0.12, 1.5), ("whoosh", 30.9, 0.55, 1.3), ("pop", 31.24, 0.12, 1.5), ("pop", 32.06, 0.12, 1.4),
       ("impact", 32.86, 1.0, 1.5), ("whoosh", 34.5, 0.55, 1.3), ("pop", 34.6, 0.12, 1.5), ("riser", 34.6, 1.1, 0.8),
       ("impact", 35.72, 0.8, 1.2), ("pop", 36.42, 0.12, 1.6), ("ding", 36.56, 1.3, 1.0)]
sfx_html = [f'<audio id="s{i}" src="assets/sfx/{f}.wav" data-start="{s}" data-duration="{d}" data-volume="{round(v * SFX_GAIN, 3)}"></audio>'
            for i, (f, s, d, v) in enumerate(SFX)]

tpl = open(os.path.join(HERE, "template.tpl")).read()
out = (tpl.replace("<!--VIDEOS-->", "\n      ".join(vid_html))
          .replace("<!--CAPTIONS-->", "\n      ".join(cap_html))
          .replace("<!--SFX-->", "\n      ".join(sfx_html))
          .replace("/*VIDJS*/", "\n      ".join(vid_js))
          .replace("/*CAPJS*/", "\n      ".join(cap_js))
          .replace("__CTADUR__", f"{TOTAL - 33.98:.2f}")
          .replace("__TOTAL__", str(TOTAL)))
open(os.path.join(HERE, "index.html"), "w").write(out)
print("all chunks:", [(round(c[0][0], 2), norm(c)) for c in chunks])
print("kept:", kept)
print("dropped:", dropped)
