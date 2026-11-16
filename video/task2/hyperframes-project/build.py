"""Generates index.html for the Task 1 VO edit from words.json + scene plan."""
import json, html, os
from timemap import f as _f
from map12 import M
T = lambda x: M(_f(x))

HERE = os.path.dirname(os.path.abspath(__file__))
W0 = [[x[0], x[1], {"penggering": "pengering", "betul": "better"}.get(x[2].strip(), x[2].strip())] for s in json.load(open(os.path.join(HERE, "tx.json"))) for x in s["w"]]
W = []
for w in W0:
    if W and w[2].startswith("-"):
        W[-1] = [W[-1][0], w[1], W[-1][2] + w[2]]
    else:
        W.append(list(w))
TOTAL = 36.4

# (start, end, src, media_start)
SCENES = [
    (0.00, 1.40, "lv0", 0.0),        # hook: neon shoes
    (1.40, 3.24, "lv0", 38.5),       # portable: arms unfold
    (3.24, 3.98, "lv0", 57.4),       # senang nak keringkan
    (3.98, 4.72, "IMG_2345", 7.8),   # kasut
    (4.72, 5.40, "IMG_2493", 52.0),  # stokin
    (5.40, 6.76, "copy0B", 1.0),     # baju
    (6.76, 9.64, "IMG_2344", 0.0),   # hotel
    (9.64, 10.93, "IMG_2344", 8.0),  # cara guna
    (10.93, 11.98, "IMG_2344", 12.0),# letak kasut
    (11.98, 12.79, "IMG_2344", 31.0),# set timer
    (12.79, 13.57, "IMG_2345", 4.6), # tinggal je
    (13.57, 15.18, "IMG_2344", 37.5),# kasut lembab
    (15.18, 16.81, "copy0B", 18.6),  # baju terkena minuman
    (16.81, 19.02, "hook", 0.0),     # air hujan
    (19.02, 20.62, "IMG_2493", 0.0), # 30 minit
    (20.62, 22.89, "lv0", 54.6),     # 120 minit
    (22.89, 25.67, "lv0", 31.2),     # 48C lock
    (25.67, 27.39, "IMG_2493", 97.0),# kain tak rosak
    (27.39, 29.70, "lv0", 10.0),     # harga murah
    (29.70, TOTAL, "IMG_2345", 19.6),# CTA
]

EMPH = {"travel,", "wajib", "portable", "hotel", "susah", "30", "minit", "120", "48°C", "lock",
        "murah", "gila", "grab", "beg", "kuning", "kasut,", "stokin", "baju", "lembab,", "hujan,",
        "rosak", "naik,", "sekarang", "senang", "kering", "tinggal", "timer,", "letak"}

# ---------- caption chunks (split on VO sentence boundaries, <=4 words, balanced) ----------
import math
SENT = [s["w"][0][0] for s in json.load(open(os.path.join(HERE, "tx.json")))]
sents, cur = [], []
for w in W:
    if cur and any(abs(w[0] - s) < 0.06 for s in SENT):
        sents.append(cur); cur = []
    cur.append(w)
sents.append(cur)
chunks = []
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
for s in phr:
    k = math.ceil(len(s) / 4); n = len(s)
    sizes = [n // k + (1 if i < n % k else 0) for i in range(k)]
    i = 0
    for z in sizes:
        chunks.append(s[i:i + z]); i += z
cap_html, cap_js = [], []
chunks = [c for c in chunks if c[0][0] < T(31.0)]
CAP_END = T(31.0)
for ci, c in enumerate(chunks):
    st = c[0][0]
    en = chunks[ci + 1][0][0] if ci + 1 < len(chunks) else CAP_END
    spans = []
    for wi, w in enumerate(c):
        txt = w[2].rstrip(",.")
        cls = "cw emph" if w[2].lower() in EMPH or w[2] in EMPH else "cw"
        spans.append(f'<span class="{cls}" id="w{ci}_{wi}">{html.escape(txt)}</span>')
        cap_js.append(f'hl("#w{ci}_{wi}", {w[0]:.3f}, "{cls}");')
    cap_html.append(f'<div class="cap clip" id="cap{ci}" data-start="{st:.3f}" data-duration="{en - st:.3f}">'
                    + " ".join(spans) + "</div>")
    cap_js.append(f'tl.from("#cap{ci}", {{ y: 24, scale: 0.86, opacity: 0, duration: 0.14, ease: "back.out(2)" }}, {st:.3f});')

SCENES = [(T(s), (TOTAL if e >= 33.0 else T(e)), src, ms) for s, e, src, ms in SCENES]
# original-VO timing tweaks: box front only lasts 2.2s; knob shot starts a little earlier
_s = []
for s, e, src, ms in SCENES:
    if src == "lv0" and ms == 10.0:            # harga: box front, then neon shoes on "Rugi"
        _s += [(30.30, 31.84, src, 10.0), (31.84, e, "lv0", 57.4)]
    elif src == "IMG_2493" and ms == 97.0:     # kain tak rosak, then NEW "saiz kecil / bawa mana-mana"
        _s += [(s, 27.12, src, ms), (27.12, 28.76, "lv0", 35.0), (28.76, 30.30, "IMG_2344", 0.5)]
    elif src == "IMG_2344" and ms == 12.0:     # VO 2 has no "letak kasut": fold into previous shot
        _s[-1] = (_s[-1][0], e, _s[-1][2], _s[-1][3])
    elif src == "lv0" and ms == 54.6:          # knob close-up only lasts ~2s: hotel knob shot first
        _s += [(s, 20.6, "IMG_2344", 33.0), (20.6, e, src, 54.6)]
    else:
        _s.append((s, e, src, ms))
SCENES = _s
vid_html, vid_js = [], []
for i, (s, e, src, ms) in enumerate(SCENES):
    vid_html.append(f'<video id="v{i}" class="clip" src="assets/video/{src}.mp4" data-start="{s:.2f}" '
                    f'data-duration="{e - s:.2f}" data-media-start="{ms}" muted playsinline></video>')
    vid_js.append(f'punch("#v{i}", {s:.2f}); drift("#v{i}", {s + 0.3:.2f}, {max(0.1, e - s - 0.3):.2f});')
    if i:
        vid_js.append(f'flash({s:.2f}, 0.35);')

# ---------- SFX ----------
SFX_GAIN = 0.3
# Task 2 only: new 'saiz kecil' beat (times already on Task 2 VO)
EXTRA_SFX = [("swipe", 27.08, 0.3, 0.35), ("pop", 28.0, 0.12, 0.45), ("whoosh", 28.72, 0.55, 0.35), ("ding", 29.4, 1.3, 0.3)]  # original VO is quiet and must stay untouched, so SFX sit lower
SFX = [  # (file, start, dur, vol)
    ("impact", 0.0, 1.2, 0.45), ("whoosh", 0.05, 0.55, 0.45),
    ("swipe", 1.35, 0.3, 0.35), ("pop", 2.48, 0.12, 0.45),
    ("swipe", 3.2, 0.3, 0.3), ("pop", 3.98, 0.12, 0.45), ("pop", 4.72, 0.12, 0.45), ("pop", 5.40, 0.12, 0.45),
    ("whoosh", 6.7, 0.55, 0.35), ("impact", 8.21, 0.6, 0.3),
    ("swipe", 9.6, 0.3, 0.3), ("pop", 10.93, 0.12, 0.45), ("pop", 11.98, 0.12, 0.45), ("tick", 12.1, 0.05, 0.4),
    ("ding", 12.79, 1.4, 0.3),
    ("swipe", 13.53, 0.3, 0.3), ("pop", 14.02, 0.12, 0.4), ("swipe", 15.14, 0.3, 0.3), ("pop", 16.13, 0.12, 0.4),
    ("rain", 16.81, 2.3, 0.35),
    ("whoosh", 18.98, 0.55, 0.35), ("tick", 19.44, 0.05, 0.4), ("ding", 20.24, 1.3, 0.35),
    ("whoosh", 20.58, 0.55, 0.3), ("tick", 21.5, 0.05, 0.35), ("tick", 21.7, 0.05, 0.35), ("tick", 21.9, 0.05, 0.35),
    ("ding", 22.2, 1.3, 0.35),
    ("whoosh", 22.85, 0.55, 0.3), ("tick", 24.0, 0.05, 0.35), ("tick", 24.2, 0.05, 0.35), ("impact", 24.47, 0.6, 0.3),
    ("ding", 24.73, 1.3, 0.35),
    ("swipe", 25.63, 0.3, 0.3), ("pop", 26.87, 0.12, 0.45),
    ("swipe", 27.35, 0.3, 0.3), ("kaching", 28.01, 1.3, 0.45), ("impact", 28.86, 1.0, 0.4),
    ("whoosh", 29.66, 0.55, 0.35), ("pop", 30.36, 0.12, 0.45), ("riser", 30.0, 1.1, 0.25),
    ("impact", 31.08, 0.8, 0.35), ("pop", 32.06, 0.12, 0.5), ("ding", 32.16, 0.8, 0.3),
]
sfx_html = [f'<audio id="s{i}" src="assets/sfx/{f}.wav" data-start="{s}" data-duration="{d}" data-volume="{round(v * SFX_GAIN, 3)}"></audio>'
            for i, (f, s, d, v) in enumerate([(a, round(T(s0), 3), dd, vv) for a, s0, dd, vv in SFX] + EXTRA_SFX)]

tpl = open(os.path.join(HERE, "template.tpl")).read()
out = (tpl.replace("<!--VIDEOS-->", "\n      ".join(vid_html))
          .replace("<!--CAPTIONS-->", "\n      ".join(cap_html))
          .replace("<!--SFX-->", "\n      ".join(sfx_html))
          .replace("/*VIDJS*/", "\n      ".join(vid_js))
          .replace("/*CAPJS*/", "\n      ".join(cap_js))
          .replace("__TOTAL__", str(TOTAL)))
open(os.path.join(HERE, "index.html"), "w").write(out)
print(len(chunks), "caption chunks;", len(SCENES), "scenes;", len(SFX), "sfx")
