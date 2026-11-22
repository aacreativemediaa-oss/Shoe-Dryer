<!doctype html>
<html lang="ms" data-resolution="portrait">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=1080, height=1920" />
    <script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
    <style>
      @font-face { font-family: "Anton"; src: url("assets/fonts/anton.woff2") format("woff2"); font-weight: 400; }
      @font-face { font-family: "Poppins"; src: url("assets/fonts/pop600.woff2") format("woff2"); font-weight: 600; }
      @font-face { font-family: "Poppins"; src: url("assets/fonts/pop800.woff2") format("woff2"); font-weight: 800; }
      @font-face { font-family: "Poppins"; src: url("assets/fonts/pop900.woff2") format("woff2"); font-weight: 900; }
      :root {
        --yellow: #ffd60a; --orange: #ff6a1a; --red: #ff2d3d; --green: #2bd96b; --blue: #3aa0ff; --dark: rgba(8,10,20,0.86);
        /* approved type scale */
        --t-head: 100px; --t-sub: 47px; --t-cap: 40px; --t-num: 64px; --t-chip: 19px;
      }
      * { margin: 0; padding: 0; box-sizing: border-box; }
      html, body { width: 1080px; height: 1920px; overflow: hidden; background: #05070d; }
      #root { position: relative; width: 1080px; height: 1920px; overflow: hidden; font-family: "Poppins", sans-serif; color: #fff; }
      .clip { position: absolute; inset: 0; }
      video.clip { width: 1080px; height: 1920px; object-fit: cover; }
      .layer { position: absolute; inset: 0; pointer-events: none; }
      .top { position: absolute; left: 70px; right: 150px; top: 330px; text-align: center; }
      .head { font-family: "Anton", sans-serif; text-transform: uppercase; line-height: 0.98; font-size: var(--t-head); text-shadow: 0 5px 0 rgba(0,0,0,0.35), 0 10px 32px rgba(0,0,0,0.6); }
      .head .y { color: var(--yellow); }
      .sub { display: inline-block; font-family: "Anton", sans-serif; text-transform: uppercase; font-size: var(--t-sub); line-height: 1.05; padding: 6px 22px 10px; border-radius: 14px; }
      .s-y { background: var(--yellow); color: #111; }
      .s-r { background: var(--red); color: #fff; }
      .s-d { background: var(--dark); color: #fff; }
      .s-g { background: var(--green); color: #111; }
      .tilt { transform: rotate(-3deg); }
      .num { font-family: "Anton", sans-serif; font-size: var(--t-num); line-height: 1; }
      .chip { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 999px; background: var(--dark); border: 3px solid rgba(255,255,255,0.3); font-weight: 900; font-size: var(--t-chip); color: rgba(255,255,255,0.75); white-space: nowrap; }
      .chip .n { width: 22px; height: 22px; border-radius: 50%; background: rgba(255,255,255,0.2); display: inline-flex; align-items: center; justify-content: center; font-size: 13px; }
      .chip.on { background: var(--yellow); border-color: var(--yellow); color: #111; }
      .chip.on .n { background: #111; color: var(--yellow); }
      .chip.done { border-color: var(--green); color: #fff; }
      .chip.done .n { background: var(--green); color: #111; }
      .mt { margin-top: 18px; }
      #vig { background: radial-gradient(ellipse at 50% 50%, rgba(0,0,0,0) 55%, rgba(0,0,0,0.45) 100%); }
      #shade { background: linear-gradient(180deg, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0) 34%, rgba(0,0,0,0) 50%, rgba(0,0,0,0.45) 70%, rgba(0,0,0,0) 100%); }
      #flash { background: #fff; opacity: 0; }
      #rainTint { background: linear-gradient(180deg, rgba(10,25,60,0.72), rgba(10,25,60,0.4) 50%, rgba(5,10,30,0.78)); }
      .drop { position: absolute; top: 0; width: 3px; border-radius: 3px; background: linear-gradient(180deg, rgba(200,225,255,0), rgba(200,225,255,0.75)); }

      /* captions (40px) */
      .cap { top: 1110px; bottom: auto; left: 110px; right: 190px; height: auto; text-align: center; font-weight: 900; font-size: var(--t-cap); line-height: 1.2; text-transform: uppercase; }
      .cw { display: inline-block; margin: 0 0.08em; color: #fff; -webkit-text-stroke: 7px #000; paint-order: stroke fill; text-shadow: 0 6px 14px rgba(0,0,0,0.6); }
      .cw.emph.on { color: var(--yellow); }

      /* icons */
      .ico { display: block; margin: 0 auto 14px; }
      #steps { display: grid; grid-template-columns: auto auto; justify-content: center; gap: 8px; margin-top: 16px; }
      .stepLbl { position: absolute; left: 70px; right: 150px; top: 960px; text-align: center; }
      #tempBadge { display: inline-flex; align-items: center; gap: 12px; padding: 12px 26px 12px 18px; border-radius: 22px; background: var(--dark); border: 4px solid var(--orange); }
      #tempU { color: var(--orange); }
      #costCard { display: inline-flex; align-items: center; gap: 14px; padding: 12px 26px; border-radius: 22px; background: var(--dark); border: 4px solid var(--yellow); }
      #costCard .num span { color: var(--yellow); }
      #ctaCard { display: inline-block; background: var(--yellow); color: #111; border-radius: 24px; padding: 16px 30px 22px; box-shadow: 0 18px 50px rgba(0,0,0,0.5); }
      #ctaCard .head { text-shadow: none; }
      #bag { position: absolute; left: 415px; top: 1250px; width: 100px; }
      #arrows { position: absolute; left: 425px; top: 1370px; width: 80px; }
    </style>
  </head>
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="__TOTAL__" data-width="1080" data-height="1920" data-fps="60">
      <!--VIDEOS-->

      <div id="vig" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>
      <div id="shade" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>
      <div id="rainTint" class="layer clip" data-start="0" data-duration="4.52"></div>
      <div id="rain" data-layout-allow-overflow class="layer clip" data-start="0" data-duration="4.52"></div>

      <!-- HOOK 0–4.52 -->
      <div id="g1" class="layer clip" data-start="0" data-duration="4.52">
        <div class="top">
          <svg class="ico" id="cloud" width="130" height="104" viewBox="0 0 300 240"><path d="M80 140 a55 55 0 0 1 8-108 a72 72 0 0 1 132 22 a48 48 0 0 1 4 96 z" fill="#dfe8f7"/><g fill="#7fb4ff"><path class="cd" d="M95 165 q10 22 0 36 q-10-14 0-36z"/><path class="cd" d="M150 170 q10 22 0 36 q-10-14 0-36z"/><path class="cd" d="M205 165 q10 22 0 36 q-10-14 0-36z"/></g></svg>
          <div id="hookH" class="head"><span class="w">Musim</span> <span class="w y">hujan</span><br /><span class="w y">lebat</span> <span class="w">ni!</span></div>
          <div id="hookS" class="mt"><span class="sub s-r tilt">Kasut &amp; baju lambat kering?</span></div>
        </div>
      </div>
      <!-- PRODUCT 4.52–6.92 -->
      <div id="g2" class="layer clip" data-start="4.52" data-duration="2.4">
        <div class="top"><div id="prodH" class="head">Pengering<br /><span class="y">portable</span></div><div id="prodS" class="mt"><span class="sub s-y">Sesuai sangat!</span></div></div>
      </div>
      <!-- CARA GUNA 6.92–15.22 -->
      <div id="g3" class="layer clip" data-start="6.92" data-duration="8.3">
        <div class="top"><div id="stepsH" class="head">Cara guna</div>
          <div id="steps">
            <div class="chip" id="st1"><span class="n">1</span>MASUKKAN KASUT</div>
            <div class="chip" id="st2"><span class="n">2</span>ATAU CELAH BAJU</div>
            <div class="chip" id="st3"><span class="n">3</span>ON TIMER</div>
            <div class="chip" id="st4"><span class="n">4</span>TUNGGU KERING</div>
          </div>
        </div>
      </div>
      <div id="L1" class="stepLbl clip" data-start="8.3" data-duration="2.08"><span class="sub s-y">1 · Masukkan kasut</span></div>
      <div id="L2" class="stepLbl clip" data-start="10.38" data-duration="1.86"><span class="sub s-y">2 · Atau celah baju</span></div>
      <div id="L3" class="stepLbl clip" data-start="12.24" data-duration="1.8"><span class="sub s-y">3 · On timer</span></div>
      <div id="L4" class="stepLbl clip" data-start="14.04" data-duration="1.18"><span class="sub s-g">4 · Tunggu kering &#10003;</span></div>
      <!-- 48C 15.22–18.62 -->
      <div id="g4" class="layer clip" data-start="15.22" data-duration="3.4">
        <div class="top"><div id="goodH" class="head">Yang <span class="y">bagusnya</span></div>
          <div class="mt"><div id="tempBadge"><svg width="34" height="84" viewBox="0 0 70 170"><rect x="22" y="6" width="26" height="120" rx="13" fill="none" stroke="#fff" stroke-width="7"/><rect id="merc" x="29" y="40" width="12" height="90" rx="6" fill="#ff6a1a"/><circle cx="35" cy="140" r="26" fill="#ff6a1a" stroke="#fff" stroke-width="7"/></svg><div class="num" id="tempNum">0</div><div class="num" id="tempU">&deg;C</div></div></div>
          <div id="lockS" class="mt"><span class="sub s-y"><svg width="30" height="36" viewBox="0 0 92 110" style="vertical-align:-4px;margin-right:8px"><path id="shackle" d="M22 52 V32 a24 24 0 0 1 48 0 V52" fill="none" stroke="#111" stroke-width="12" stroke-linecap="round"/><rect x="8" y="50" width="76" height="58" rx="12" fill="#111"/></svg>Suhu dah lock</span></div>
        </div>
      </div>
      <!-- SAFE 18.62–20.96 -->
      <div id="g5" class="layer clip" data-start="18.62" data-duration="2.34">
        <div class="top">
          <svg class="ico" id="shield" width="110" height="126" viewBox="0 0 210 240"><path d="M105 10 L190 42 V112 C190 170 152 210 105 230 C58 210 20 170 20 112 V42 Z" fill="#2bd96b" stroke="#fff" stroke-width="10" stroke-linejoin="round"/><path id="shCheck" d="M62 120 l30 30 l58-62" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" stroke-linejoin="round" stroke-dasharray="160" stroke-dashoffset="160"/></svg>
          <div id="safeH" class="head">Tak perlu <span class="y">risau</span></div>
          <div id="safeS" class="mt"><span class="sub s-g">Kain tak rosak</span></div>
        </div>
      </div>
      <!-- COST 20.96–25.54 -->
      <div id="g6" class="layer clip" data-start="20.96" data-duration="4.58">
        <div class="top">
          <svg class="ico" id="bolt" width="80" height="110" viewBox="0 0 80 110"><path d="M48 4 L10 62 H36 L28 106 L70 40 H44 Z" fill="#ffd60a" stroke="#111" stroke-width="5" stroke-linejoin="round"/></svg>
          <div id="costH" class="head">Kos elektrik<br /><span class="y">murah</span></div>
          <div id="costS" class="mt"><div id="costCard"><span class="chip on">1 JAM</span><div class="num">&asymp; <span id="senNum">0</span> <span>SEN</span></div></div></div>
        </div>
      </div>
      <!-- WHERE 25.54–28.32 -->
      <div id="g7" class="layer clip" data-start="25.54" data-duration="2.78">
        <div class="top"><div id="whereH" class="head">Guna mana-mana</div>
          <div id="homeS" class="mt"><span class="sub s-d">Dalam rumah &#10003;</span></div>
          <div id="travS" class="mt"><span class="sub s-y">Bawa travel &#10003;</span></div>
        </div>
      </div>
      <!-- STOCK 28.32–29.84 -->
      <div id="g8" class="layer clip" data-start="28.32" data-duration="1.52">
        <div class="top"><div id="stockH" class="head"><span class="sub s-r tilt" style="font-size:var(--t-head);padding:10px 30px 16px">Stok dah<br />tak banyak!</span></div></div>
      </div>
      <!-- CTA 29.84–32.4 -->
      <div id="g9" class="layer clip" data-start="29.84" data-duration="2.56">
        <div class="top"><div id="soldS"><span class="sub s-r tilt">Sebelum sold out!</span></div>
          <div id="ctaWrap" class="mt"><div id="ctaCard"><div class="head">Check out<br />sekarang</div></div></div>
          <div id="begS" class="mt"><span class="sub s-d">Dengan <span style="color:var(--yellow)">beg kuning</span></span></div>
        </div>
        <svg id="bag" viewBox="0 0 170 170"><path d="M52 62 V48 a33 33 0 0 1 66 0 V62" fill="none" stroke="#111" stroke-width="11" stroke-linecap="round"/><path d="M22 58 H148 L138 158 H32 Z" fill="#ffd60a" stroke="#111" stroke-width="9" stroke-linejoin="round"/><path d="M60 98 a25 25 0 0 0 50 0" fill="none" stroke="#111" stroke-width="9" stroke-linecap="round"/></svg>
        <svg id="arrows" viewBox="0 0 120 200"><path class="ar" d="M15 20 L60 60 L105 20" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/><path class="ar" d="M15 80 L60 120 L105 80" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/><path class="ar" d="M15 140 L60 180 L105 140" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </div>

      <!--CAPTIONS-->

      <div id="flash" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>

      <audio id="vo" src="assets/audio/vo_original.m4a" data-start="0" data-duration="32.19" data-volume="1"></audio>
      <!--SFX-->
    </div>

    <script>
      window.__timelines = window.__timelines || {};
      const tl = gsap.timeline({ paused: true });
      const punch = (s, t, f = 1.12, d = 0.3) => tl.fromTo(s, { scale: f }, { scale: 1, duration: d, ease: "power3.out" }, t);
      const drift = (s, t, d) => tl.fromTo(s, { scale: 1 }, { scale: 1.07, duration: d, ease: "none", immediateRender: false }, t);
      const flash = (t, a) => tl.fromTo("#flash", { opacity: a }, { opacity: 0, duration: 0.18, ease: "power2.out", immediateRender: false }, t);
      const pop = (s, t, extra = {}) => tl.from(s, Object.assign({ scale: 0.3, opacity: 0, duration: 0.3, ease: "back.out(2.2)" }, extra), t);
      const slam = (s, t) => tl.from(s, { scale: 2.2, opacity: 0, duration: 0.3, ease: "power4.out" }, t);
      const hl = (s, t, c) => { tl.set(s, { className: c + " on" }, t); tl.fromTo(s, { scale: 1.15 }, { scale: 1, duration: 0.18, ease: "back.out(3)", immediateRender: false }, t); };
      const count = (id, to, t, d) => { const o = { v: 0 }; tl.to(o, { v: to, duration: d, ease: "power2.out", onUpdate: () => { document.getElementById(id).textContent = Math.round(o.v); } }, t); };

      /*VIDJS*/
      flash(4.52, 0.8); flash(28.32, 0.8);

      /* rain */
      (function () {
        const rain = document.getElementById("rain"); let seed = 11;
        const rnd = () => ((seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648);
        for (let i = 0; i < 60; i++) {
          const d = document.createElement("div"); d.className = "drop";
          d.style.left = Math.round(rnd() * 1120 - 20) + "px"; d.style.height = Math.round(60 + rnd() * 110) + "px"; d.style.opacity = (0.35 + rnd() * 0.6).toFixed(2);
          rain.appendChild(d);
          const sp = 0.35 + rnd() * 0.3, off = rnd() * sp;
          for (let r = 0; r < Math.ceil(4.7 / sp) + 1; r++)
            tl.fromTo(d, { y: -220, x: 0, rotation: 12 }, { y: 2000, x: -120, rotation: 12, duration: sp, ease: "none", immediateRender: false }, Math.max(0, r * sp - off));
        }
      })();

      /* hook */
      gsap.utils.toArray("#hookH .w").forEach((w, i) => i < 2
        ? tl.fromTo(w, { y: -24 }, { y: 0, duration: 0.3, ease: "back.out(2)" }, 0)
        : tl.from(w, { y: 70, scale: 0.4, opacity: 0, duration: 0.3, ease: "back.out(2.2)" }, 0.68 + (i - 2) * 0.28));
      tl.from("#cloud", { y: -50, opacity: 0, duration: 0.4, ease: "back.out(1.8)" }, 0.1);
      tl.fromTo("#cloud .cd", { y: -8, opacity: 0 }, { y: 24, opacity: 1, duration: 0.45, stagger: 0.15, repeat: 6, ease: "power1.in" }, 0.4);
      slam("#hookS", 2.64);
      tl.to("#hookS .sub", { x: 8, duration: 0.05, yoyo: true, repeat: 5, ease: "none" }, 2.9);
      tl.to("#g1", { scale: 1.25, opacity: 0, duration: 0.14, ease: "power2.in" }, 4.38);
      /* product */
      slam("#prodH", 4.54); pop("#prodS", 5.56, { y: 30 });
      /* steps */
      tl.from("#stepsH", { y: -40, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 6.94);
      tl.from("#steps .chip", { y: -30, opacity: 0, duration: 0.25, stagger: 0.06, ease: "back.out(2)" }, 7.0);
      [["#st1", 8.3, 10.38], ["#st2", 10.38, 12.24], ["#st3", 12.24, 14.04], ["#st4", 14.04, 99]].forEach(([c, t, e]) => {
        tl.set(c, { className: "chip on" }, t); tl.fromTo(c, { scale: 1.3 }, { scale: 1, duration: 0.3, ease: "back.out(3)", immediateRender: false }, t);
        if (e < 99) tl.set(c, { className: "chip done" }, e);
      });
      ["#L1", "#L2", "#L3", "#L4"].forEach((l, i) => pop(l + " .sub", [8.32, 10.4, 12.26, 14.06][i], { y: 30 }));
      /* 48C */
      slam("#goodH", 15.24);
      tl.from("#tempBadge", { y: -60, opacity: 0, duration: 0.35, ease: "back.out(1.7)" }, 15.5);
      count("tempNum", 48, 16.08, 1.0);
      tl.fromTo("#merc", { attr: { y: 120, height: 10 } }, { attr: { y: 30, height: 100 }, duration: 1.0, ease: "power2.out" }, 16.08);
      pop("#lockS", 16.56, { y: 30 });
      tl.fromTo("#shackle", { y: -20 }, { y: 0, duration: 0.16, ease: "power4.in", immediateRender: false }, 16.7);
      tl.fromTo("#tempBadge", { boxShadow: "0 0 0 rgba(255,106,26,0)" }, { boxShadow: "0 0 50px rgba(255,106,26,0.9)", duration: 0.3, yoyo: true, repeat: 3, immediateRender: false }, 17.14);
      /* safe */
      pop("#shield", 18.64); tl.to("#shCheck", { attr: { "stroke-dashoffset": 0 }, duration: 0.3, ease: "power2.out" }, 18.95);
      slam("#safeH", 18.74); pop("#safeS", 19.9, { y: 30 });
      /* cost */
      pop("#bolt", 20.98); tl.to("#bolt", { scale: 1.15, duration: 0.15, yoyo: true, repeat: 5, ease: "sine.inOut" }, 21.3);
      slam("#costH", 21.16);
      tl.from("#costCard", { y: 60, opacity: 0, duration: 0.35, ease: "back.out(2)" }, 22.9);
      count("senNum", 10, 24.2, 0.5);
      tl.fromTo("#costCard", { scale: 1 }, { scale: 1.12, duration: 0.14, yoyo: true, repeat: 1, immediateRender: false }, 24.66);
      /* where */
      slam("#whereH", 25.56);
      pop("#homeS", 25.94, { x: -300, scale: 0.8 });
      pop("#travS", 27.26, { x: 300, scale: 0.8 });
      /* stock */
      tl.from("#stockH .sub", { scale: 3, opacity: 0, rotation: -15, duration: 0.3, ease: "power4.out" }, 28.34);
      tl.to("#stockH .sub", { rotation: 2, duration: 0.07, yoyo: true, repeat: 9, ease: "none" }, 28.7);
      /* CTA */
      slam("#soldS", 29.86);
      tl.from("#ctaWrap", { y: 600, opacity: 0, duration: 0.45, ease: "back.out(1.4)" }, 31.1);
      pop("#begS", 31.64, { y: 30 });
      tl.from("#bag", { scale: 0, rotation: -30, duration: 0.3, ease: "back.out(2.5)" }, 31.78);
      tl.to("#bag", { y: -16, duration: 0.2, yoyo: true, repeat: 2, ease: "sine.inOut" }, 32.08);
      tl.from("#arrows", { opacity: 0, duration: 0.12 }, 31.86);
      tl.fromTo("#arrows .ar", { opacity: 0.15 }, { opacity: 1, duration: 0.12, stagger: 0.08, repeat: 3, yoyo: true, ease: "none", immediateRender: false }, 31.86);

      /* captions */
      /*CAPJS*/

      /* explicit clip visibility (render-path independent) */
      document.querySelectorAll("#root [data-start]:not(video):not(audio)").forEach((el) => {
        const st = parseFloat(el.dataset.start), du = parseFloat(el.dataset.duration);
        tl.set(el, { visibility: st > 0 ? "hidden" : "visible" }, 0);
        if (st > 0) tl.set(el, { visibility: "visible" }, st);
        if (st + du < __TOTAL__ - 0.001) tl.set(el, { visibility: "hidden" }, st + du);
      });

      window.__timelines["main"] = tl;
      tl.seek(0);
    </script>
  </body>
</html>
