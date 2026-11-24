Footage proxies (1080x1920, 60fps H.264) are not committed because they're too large.
Rebuild them from the Drive folder clips:
  ffmpeg -i <clip> -vf "scale=1080:1920,fps=60" -c:v libx264 -crf 18 -an assets/video/<name>.mp4
Names: lv0.mp4 (lv_0_20260412012428.mp4), copy0B.mp4, IMG_2345.mp4, IMG_2493.mp4
hook.mp4 = copy0B.mp4 5.9s–6.95s slowed 2.35x:
  ffmpeg -ss 5.9 -t 1.05 -i copy0B.mp4 -an -vf "setpts=2.35*PTS,minterpolate=fps=60:mi_mode=blend" hook.mp4
IMG_2344.mp4 / IMG_2345.mp4 / IMG_2493.mp4 are HLG HDR: tone-map to SDR bt709 (see zscale/tonemap=hable chain) or the renderer switches to its HDR path.
Task 6 slow-mo clips (from lv0.mp4, minterpolate blend to 60fps):
  arms_slow.mp4 = lv0 37.8s +3.6s, setpts=1.55*PTS
  knob_slow.mp4 = lv0 54.5s +2.1s, setpts=1.72*PTS
  t48_slow.mp4  = lv0 31.2s +3.2s, setpts=1.6*PTS
