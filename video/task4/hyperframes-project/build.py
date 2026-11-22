"""Task 4 (New Task): builds index.html on the ORIGINAL, untouched VO timeline.
Type scale (approved format): headline 100px, sub-headline/sticker 47px, caption 40px, big number 64px, chips 19px."""
import json, html, math, os

HERE = os.path.dirname(os.path.abspath(__file__))
TOTAL = 32.4
FIX = {"penggering": "pengering", "jemuk": "jemur", "betul": "better", "bay": "beg"}
W = [[x[0], x[1], FIX.get(x[2].strip(), x[2].strip())] for s in json.load(open(os.path.join(HERE, "tx.json"))) for x in s["w"]]
SENT = [s["w"][0][0] for s in json.load(open(os.path.join(HERE, "tx.json")))]

# (start, end, clip, media_start)
SCENES = [
    (0.00, 4.52, "hook45", 0.0),      # musim hujan, lambat kering (slow-mo hoodie + rain)
    (4.52, 6.92, "lv0", 0.0),         # pengering portable
    (6.92, 8.30, "IMG_2344", 8.0),    # nak pakai pun senang
    (8.30, 10.38, "IMG_2344", 12.0),  # masukkan kasut dekat batang
    (10.38, 12.24, "copy0B", 0.3),    # celah baju
    (12.24, 14.04, "IMG_2344", 31.0), # on timer
    (14.04, 15.22, "IMG_2345", 4.6),  # tunggu sampai kering
    (15.22, 18.62, "lv0", 31.2),      # 48C lock
    (18.62, 20.96, "IMG_2493", 97.0), # kain tak rosak
    (20.96, 22.90, "IMG_2344", 4.4),  # kos elektrik (plug)
    (22.90, 25.54, "IMG_2345", 7.8),  # 1 jam ~ 10 sen
    (25.54, 26.98, "IMG_2493", 68.0), # dalam rumah
    (26.98, 28.32, "IMG_2344", 0.5),  # bawa travel
    (28.32, 29.84, "lv0", 57.4),      # stok tak banyak
    (29.84, TOTAL, "IMG_2345", 19.6), # CTA
]

EMPH = {"hujan", "lebat", "kasut", "pakaian", "lambat", "kering,", "kering.", "portable", "sesuai", "senang", "masukkan",
        "baju", "timer", "48°C", "lock", "risau,", "rosak.", "murah", "10", "sen", "rumah", "travel", "stok", "banyak",
        "sold", "out,", "sekarang", "beg", "kuning."}

# ---------- captions: split on VO sentences, then commas, <=4 words ----------
sents = [[[x[0], x[1], FIX.get(x[2].strip(), x[2].strip())] for x in s["w"]] for s in json.load(open(os.path.join(HERE, "tx.json")))]
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
CAP_END = 31.10  # CTA card takes over from "check out sekarang"
chunks = [c for c in chunks if c[0][0] < CAP_END]

cap_html, cap_js = [], []
for ci, c in enumerate(chunks):
    st = c[0][0]
    en = chunks[ci + 1][0][0] if ci + 1 < len(chunks) else CAP_END
    spans = []
    for wi, w in enumerate(c):
        cls = "cw emph" if w[2].lower() in EMPH else "cw"
        spans.append(f'<span class="{cls}" id="w{ci}_{wi}">{html.escape(w[2].rstrip(",."))}</span>')
        cap_js.append(f'hl("#w{ci}_{wi}", {w[0]:.3f}, "{cls}");')
    cap_html.append(f'<div class="cap clip" id="cap{ci}" data-start="{st:.3f}" data-duration="{en - st:.3f}">' + " ".join(spans) + "</div>")
    cap_js.append(f'tl.from("#cap{ci}", {{ y: 16, scale: 0.86, opacity: 0, duration: 0.14, ease: "back.out(2)" }}, {st:.3f});')

vid_html, vid_js = [], []
for i, (s, e, src, ms) in enumerate(SCENES):
    vid_html.append(f'<video id="v{i}" class="clip" src="assets/video/{src}.mp4" data-start="{s:.2f}" data-duration="{e - s:.2f}" data-media-start="{ms}" muted playsinline></video>')
    vid_js.append(f'punch("#v{i}", {s:.2f}); drift("#v{i}", {s + 0.3:.2f}, {max(0.1, e - s - 0.3):.2f});' + (f' flash({s:.2f}, 0.35);' if i else ""))

SFX_GAIN = 0.1  # VO stays untouched and is fairly quiet, so SFX sit low
SFX = [("rain", 0.0, 4.0, 1.2), ("impact", 0.0, 1.2, 1.4), ("whoosh", 0.05, 0.55, 1.4), ("pop", 2.64, 0.12, 1.5),
       ("riser", 3.2, 1.3, 1.0), ("impact", 4.52, 1.2, 1.6), ("pop", 5.56, 0.12, 1.5),
       ("swipe", 6.88, 0.3, 1.2), ("pop", 8.64, 0.12, 1.5), ("swipe", 10.34, 0.3, 1.2), ("pop", 10.86, 0.12, 1.5),
       ("swipe", 12.2, 0.3, 1.2), ("tick", 12.7, 0.05, 1.5), ("tick", 12.9, 0.05, 1.5), ("tick", 13.1, 0.05, 1.5),
       ("pop", 14.12, 0.12, 1.5), ("ding", 14.56, 1.3, 1.2),
       ("whoosh", 15.18, 0.55, 1.2), ("tick", 16.2, 0.05, 1.4), ("tick", 16.4, 0.05, 1.4), ("impact", 16.56, 0.6, 1.0),
       ("ding", 17.14, 1.3, 1.3),
       ("swipe", 18.58, 0.3, 1.2), ("pop", 19.9, 0.12, 1.5),
       ("whoosh", 20.92, 0.55, 1.2), ("pop", 22.04, 0.12, 1.5), ("swipe", 22.86, 0.3, 1.2), ("kaching", 24.44, 1.3, 1.6),
       ("swipe", 25.5, 0.3, 1.2), ("pop", 26.0, 0.12, 1.5), ("whoosh", 27.0, 0.55, 1.3), ("pop", 27.44, 0.12, 1.5),
       ("impact", 28.32, 1.0, 1.5), ("whoosh", 29.8, 0.55, 1.3), ("pop", 30.1, 0.12, 1.5), ("riser", 30.0, 1.1, 0.8),
       ("impact", 31.1, 0.8, 1.2), ("pop", 31.8, 0.12, 1.6), ("ding", 31.9, 0.5, 1.0)]
sfx_html = [f'<audio id="s{i}" src="assets/sfx/{f}.wav" data-start="{s}" data-duration="{d}" data-volume="{round(v * SFX_GAIN, 3)}"></audio>'
            for i, (f, s, d, v) in enumerate(SFX)]

tpl = open(os.path.join(HERE, "template.tpl")).read()
out = (tpl.replace("<!--VIDEOS-->", "\n      ".join(vid_html))
          .replace("<!--CAPTIONS-->", "\n      ".join(cap_html))
          .replace("<!--SFX-->", "\n      ".join(sfx_html))
          .replace("/*VIDJS*/", "\n      ".join(vid_js))
          .replace("/*CAPJS*/", "\n      ".join(cap_js))
          .replace("__TOTAL__", str(TOTAL)))
open(os.path.join(HERE, "index.html"), "w").write(out)
print(len(chunks), "caption chunks;", len(SCENES), "scenes;", len(SFX), "sfx")
