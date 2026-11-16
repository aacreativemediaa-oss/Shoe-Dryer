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
      :root { --yellow: #ffd60a; --orange: #ff6a1a; --red: #ff2d3d; --green: #2bd96b; --blue: #3aa0ff; --dark: rgba(8,10,20,0.86); }
      * { margin: 0; padding: 0; box-sizing: border-box; }
      html, body { width: 1080px; height: 1920px; overflow: hidden; background: #05070d; }
      #root { position: relative; width: 1080px; height: 1920px; overflow: hidden; font-family: "Poppins", sans-serif; color: #fff; }
      .clip { position: absolute; inset: 0; }
      video.clip { width: 1080px; height: 1920px; object-fit: cover; }
      .layer { position: absolute; inset: 0; pointer-events: none; }
      .A { font-family: "Anton", sans-serif; text-transform: uppercase; line-height: 0.95; }
      .sh { text-shadow: 0 6px 0 rgba(0,0,0,0.35), 0 12px 40px rgba(0,0,0,0.6); }
      .top { position: absolute; left: 60px; right: 140px; top: 330px; text-align: center; }
      .pill { display: inline-block; padding: 12px 30px; border-radius: 999px; font-weight: 900; font-size: 42px; }
      .py { background: var(--yellow); color: #111; }
      .pd { background: var(--dark); color: #fff; }
      .pr { background: var(--red); color: #fff; }
      #vig { background: radial-gradient(ellipse at 50% 50%, rgba(0,0,0,0) 55%, rgba(0,0,0,0.45) 100%); }
      #shade { background: linear-gradient(180deg, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0) 34%, rgba(0,0,0,0) 52%, rgba(0,0,0,0.45) 75%, rgba(0,0,0,0) 100%); }
      #flash { background: #fff; opacity: 0; }

      /* captions */
      .cap { top: 1060px; bottom: auto; left: 100px; right: 190px; height: auto; text-align: center; font-weight: 900; font-size: 62px; line-height: 1.12; text-transform: uppercase; }
      .cw { display: inline-block; margin: 0 0.1em; color: #fff; -webkit-text-stroke: 10px #000; paint-order: stroke fill; text-shadow: 0 8px 18px rgba(0,0,0,0.55); transform-origin: 50% 60%; }
      .cw.emph.on { color: var(--yellow); }

      /* hook */
      #hookA { font-size: 190px; color: #fff; }
      #hookB { font-size: 120px; color: var(--yellow); margin-top: 10px; }
      #plane { position: absolute; left: 0; top: 760px; width: 1080px; height: 260px; }
      #portable { margin-top: 26px; }

      /* chips */
      #chipsHead { font-size: 72px; }
      .chips { display: flex; justify-content: center; flex-wrap: wrap; gap: 16px; margin-top: 22px; }
      .chip { display: inline-flex; align-items: center; gap: 12px; padding: 14px 28px; border-radius: 999px; background: var(--dark); border: 4px solid rgba(255,255,255,0.3); font-weight: 900; font-size: 42px; color: rgba(255,255,255,0.7); }
      .chip .tk { width: 40px; height: 40px; border-radius: 50%; background: rgba(255,255,255,0.18); display: flex; align-items: center; justify-content: center; }
      .chip .tk svg { width: 26px; height: 26px; opacity: 0; }
      .chip.on { background: var(--yellow); border-color: var(--yellow); color: #111; }
      .chip.on .tk { background: #111; } .chip.on .tk svg { opacity: 1; }

      /* hotel */
      #hotelCard { display: inline-flex; align-items: center; gap: 24px; background: var(--dark); border-radius: 30px; padding: 22px 40px 22px 26px; }
      #hotelCard .A { font-size: 110px; }
      #susah { margin-top: 26px; display: inline-block; position: relative; }
      #susah .A { font-size: 96px; color: #fff; background: var(--red); padding: 10px 30px 14px; border-radius: 20px; transform: rotate(-2deg); display: inline-block; }

      /* steps */
      #stepsHead { font-size: 92px; }
      .steps { display: flex; flex-direction: column; gap: 16px; margin: 26px auto 0; width: 640px; }
      .step { display: flex; align-items: center; gap: 22px; background: var(--dark); border-radius: 24px; padding: 14px 24px; border: 4px solid rgba(255,255,255,0.15); opacity: 0.45; }
      .step .n { width: 74px; height: 74px; border-radius: 50%; background: rgba(255,255,255,0.15); font-family: "Anton"; font-size: 50px; display: flex; align-items: center; justify-content: center; }
      .step .t { font-weight: 900; font-size: 46px; }
      .step.on { opacity: 1; border-color: var(--yellow); }
      .step.on .n { background: var(--yellow); color: #111; }

      /* problems */
      .prob { display: inline-flex; align-items: center; gap: 22px; background: var(--dark); border-radius: 28px; padding: 18px 36px 18px 22px; border: 5px solid var(--blue); }
      .prob .A { font-size: 92px; }
      .prob svg { width: 110px; height: 110px; }
      #rainTint { background: linear-gradient(180deg, rgba(10,25,60,0.6), rgba(10,25,60,0.35) 50%, rgba(5,10,30,0.7)); }
      .drop { position: absolute; top: 0; width: 3px; border-radius: 3px; background: linear-gradient(180deg, rgba(200,225,255,0), rgba(200,225,255,0.75)); }

      /* timers */
      #m30 { display: inline-flex; flex-direction: column; align-items: center; background: var(--dark); border: 6px solid var(--yellow); border-radius: 36px; padding: 18px 56px 24px; }
      #m30 .A { font-size: 190px; } #m30 .u { font-weight: 900; font-size: 46px; letter-spacing: 0.14em; color: var(--yellow); }
      #kering { margin-top: 24px; }
      #dialWrap { position: relative; width: 400px; height: 400px; margin: 0 auto; }
      #dialWrap svg { position: absolute; inset: 0; }
      #dialC { position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; }
      #dialNum { font-family: "Anton"; font-size: 160px; line-height: 0.95; }
      #dialU { font-weight: 900; font-size: 40px; letter-spacing: 0.12em; color: var(--yellow); }
      #maxLbl { margin-top: 24px; }

      /* temp */
      #tempBadge { display: inline-flex; align-items: center; gap: 20px; padding: 22px 42px 22px 30px; border-radius: 36px; background: var(--dark); border: 6px solid var(--orange); }
      #tempNum { font-family: "Anton"; font-size: 200px; line-height: 1; min-width: 280px; text-align: right; }
      #tempU { font-family: "Anton"; font-size: 110px; color: var(--orange); align-self: flex-start; margin-top: 16px; }
      #lockRow { margin-top: 26px; display: flex; justify-content: center; align-items: center; gap: 18px; }
      #lockRow .A { font-size: 92px; } #lockRow .A span { color: var(--yellow); }

      #smallCard { display: inline-flex; align-items: center; gap: 22px; background: var(--dark); border-radius: 30px; padding: 18px 40px 18px 24px; border: 5px solid var(--yellow); }
      #smallCard .A { font-size: 104px; }
      #mana { margin-top: 26px; }
      /* safe */
      #shield { width: 210px; height: 240px; display: block; margin: 0 auto; }
      #safeLbl { margin-top: 18px; font-size: 104px; }
      #safeLbl span { color: var(--green); }

      /* price */
      #burst { position: relative; width: 560px; height: 560px; margin: -40px auto 0; }
      #burst svg { position: absolute; inset: 0; }
      #burstTxt { position: absolute; inset: 0; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #111; transform: rotate(-8deg); }
      #burstTxt .a { font-family: "Anton"; font-size: 84px; line-height: 0.95; }
      #burstTxt .b { font-family: "Anton"; font-size: 150px; line-height: 0.9; color: var(--red); }
      #rugi { position: absolute; left: 0; right: 0; top: 860px; text-align: center; }
      #rugi .A { display: inline-block; font-size: 112px; color: var(--red); border: 10px solid var(--red); border-radius: 18px; padding: 4px 30px 10px; transform: rotate(-10deg); background: rgba(255,255,255,0.92); }

      /* CTA */
      #naik .box { display: inline-block; background: var(--red); padding: 18px 40px 24px; border-radius: 26px; transform: rotate(-3deg); box-shadow: 0 18px 50px rgba(0,0,0,0.5); }
      #naik .A { font-size: 110px; }
      #ctaCard { position: absolute; left: 70px; right: 150px; top: 860px; text-align: center; }
      #ctaCard .card { background: var(--yellow); color: #111; border-radius: 34px; padding: 26px 30px 32px; box-shadow: 0 24px 60px rgba(0,0,0,0.5); }
      #ctaCard .A { font-size: 112px; }
      #ctaCard .w { font-weight: 900; font-size: 40px; margin-top: 8px; }
      #ctaCard .w b { background: #111; color: var(--yellow); padding: 0 14px; border-radius: 10px; }
      #bag { position: absolute; left: 395px; top: 1400px; width: 150px; }
      #arrows { position: absolute; left: 410px; top: 1570px; width: 120px; }
    </style>
  </head>
  <body>
    <div id="root" data-composition-id="main" data-start="0" data-duration="__TOTAL__" data-width="1080" data-height="1920" data-fps="60">
      <!--VIDEOS-->

      <div id="vig" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>
      <div id="shade" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>
      <div id="rainTint" class="layer clip" data-start="16.31" data-duration="0.85"></div>
      <div id="rain" data-layout-allow-overflow class="layer clip" data-start="16.31" data-duration="0.85"></div>

      <!-- G1 hook 0–1.40 -->
      <div id="g1" class="layer clip" data-start="0.00" data-duration="1.86">
        <div class="top"><div id="hookA" class="A sh">Kaki travel?</div></div>
        <svg id="plane" viewBox="0 0 1080 260">
          <path id="trail" d="M-40 210 Q 380 40 760 120" fill="none" stroke="#ffd60a" stroke-width="8" stroke-dasharray="22 18" stroke-linecap="round" />
          <g id="planeG"><path d="M0 -14 L70 -6 L100 -40 L116 -40 L100 -4 L150 0 L100 4 L116 40 L100 40 L70 6 L0 14 L-10 30 L-24 30 L-14 0 L-24 -30 L-10 -30 Z" fill="#fff" stroke="#111" stroke-width="5" stroke-linejoin="round" /></g>
        </svg>
      </div>
      <!-- G2 portable 1.40–3.24 -->
      <div id="g2" class="layer clip" data-start="1.86" data-duration="1.86">
        <div class="top"><div id="hookB" class="A sh">Wajib bawa<br />benda ni!</div><div id="portable"><span class="pill py">PENGERING PORTABLE</span></div></div>
      </div>
      <!-- G3 kasut/stokin/baju 3.24–6.76 -->
      <div id="g3" class="layer clip" data-start="3.72" data-duration="4.17">
        <div class="top"><div id="chipsHead" class="A sh">Senang nak keringkan</div>
          <div class="chips">
            <div class="chip" id="c1"><span class="tk"><svg viewBox="0 0 26 26"><path d="M5 13 l5 5 l11-11" fill="none" stroke="#ffd60a" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/></svg></span>KASUT</div>
            <div class="chip" id="c2"><span class="tk"><svg viewBox="0 0 26 26"><path d="M5 13 l5 5 l11-11" fill="none" stroke="#ffd60a" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/></svg></span>STOKIN</div>
            <div class="chip" id="c3"><span class="tk"><svg viewBox="0 0 26 26"><path d="M5 13 l5 5 l11-11" fill="none" stroke="#ffd60a" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/></svg></span>BAJU</div>
          </div>
        </div>
      </div>
      <!-- G4 hotel 6.76–9.64 -->
      <div id="g4" class="layer clip" data-start="7.89" data-duration="2.64">
        <div class="top">
          <div id="hotelCard">
            <svg width="110" height="110" viewBox="0 0 110 110"><rect x="18" y="14" width="74" height="90" rx="6" fill="#ffd60a"/><g fill="#111"><rect x="30" y="26" width="14" height="12"/><rect x="66" y="26" width="14" height="12"/><rect x="30" y="46" width="14" height="12"/><rect x="66" y="46" width="14" height="12"/><rect x="30" y="66" width="14" height="12"/><rect x="66" y="66" width="14" height="12"/><rect x="46" y="82" width="18" height="22"/></g></svg>
            <div class="A">Duduk hotel?</div>
          </div>
          <div><div id="susah"><div class="A">Susah nak kering!</div></div></div>
        </div>
      </div>
      <!-- G5 steps 9.64–13.57 -->
      <div id="g5" class="layer clip" data-start="10.54" data-duration="2.54">
        <div class="top"><div id="stepsHead" class="A sh">Cara guna</div>
          <div class="steps">
            <div class="step" id="st1"><div class="n">1</div><div class="t">LETAK KASUT</div></div>
            <div class="step" id="st2"><div class="n">2</div><div class="t">SET TIMER</div></div>
            <div class="step" id="st3"><div class="n">3</div><div class="t">TINGGAL JE!</div></div>
          </div>
        </div>
      </div>
      <!-- G6 problems -->
      <div id="g6a" class="layer clip" data-start="13.06" data-duration="2.04">
        <div class="top"><div class="prob"><svg viewBox="0 0 110 110"><path d="M55 10 C 35 40 22 58 22 74 a33 33 0 0 0 66 0 C 88 58 75 40 55 10z" fill="#3aa0ff" stroke="#fff" stroke-width="5"/><path d="M40 76 a15 15 0 0 0 15 15" fill="none" stroke="#fff" stroke-width="6" stroke-linecap="round"/></svg><div class="A">Kasut lembab</div></div></div>
      </div>
      <div id="g6b" class="layer clip" data-start="15.11" data-duration="1.20">
        <div class="top"><div class="prob"><svg viewBox="0 0 110 110"><path d="M38 14 L20 24 L10 46 L26 52 L28 98 H82 L84 52 L100 46 L90 24 L72 14 Q55 30 38 14Z" fill="#dfe8f7" stroke="#fff" stroke-width="4" stroke-linejoin="round"/><g fill="#3aa0ff"><path d="M45 50 q6 12 0 18 q-6-6 0-18z"/><path d="M64 62 q6 12 0 18 q-6-6 0-18z"/><path d="M52 78 q5 10 0 15 q-5-5 0-15z"/></g></svg><div class="A">Baju basah</div></div></div>
      </div>
      <div id="g6c" class="layer clip" data-start="16.31" data-duration="0.85">
        <div class="top"><div class="prob"><svg viewBox="0 0 110 110"><path d="M30 64 a22 22 0 0 1 4-43 a29 29 0 0 1 53 9 a19 19 0 0 1 2 38 z" fill="#dfe8f7"/><g stroke="#3aa0ff" stroke-width="6" stroke-linecap="round"><path d="M36 78 l-6 16"/><path d="M56 78 l-6 16"/><path d="M76 78 l-6 16"/></g></svg><div class="A">Musim hujan</div></div></div>
      </div>
      <!-- G7 30 minit 19.02–20.62 -->
      <div id="g7" class="layer clip" data-start="17.16" data-duration="2.11">
        <div class="top"><div id="m30"><div class="A">30</div><div class="u">MINIT</div></div><div id="kering"><span class="pill py">DAH KERING &#10003;</span></div></div>
      </div>
      <!-- G8 120 20.62–22.89 -->
      <div id="g8" class="layer clip" data-start="19.27" data-duration="2.77">
        <div class="top">
          <div id="dialWrap"><svg viewBox="0 0 400 400"><circle cx="200" cy="200" r="178" fill="rgba(8,10,20,0.86)"/><circle cx="200" cy="200" r="160" fill="none" stroke="rgba(255,255,255,0.18)" stroke-width="24"/><circle id="dialArc" cx="200" cy="200" r="160" fill="none" stroke="#ffd60a" stroke-width="24" stroke-linecap="round" transform="rotate(-90 200 200)" stroke-dasharray="1005.3" stroke-dashoffset="1005.3"/></svg>
            <div id="dialC"><div id="dialNum">0</div><div id="dialU">MINIT</div></div></div>
          <div id="maxLbl"><span class="pill pd">MAKSIMUM 120 MINIT</span></div>
        </div>
      </div>
      <!-- G9 48C 22.89–25.67 -->
      <div id="g9" class="layer clip" data-start="22.04" data-duration="2.60">
        <div class="top">
          <div id="tempBadge"><svg width="64" height="160" viewBox="0 0 70 170"><rect x="22" y="6" width="26" height="120" rx="13" fill="none" stroke="#fff" stroke-width="6"/><rect id="merc" x="29" y="40" width="12" height="90" rx="6" fill="#ff6a1a"/><circle cx="35" cy="140" r="26" fill="#ff6a1a" stroke="#fff" stroke-width="6"/></svg><div id="tempNum">0</div><div id="tempU">&deg;C</div></div>
          <div id="lockRow"><svg width="84" height="100" viewBox="0 0 92 110"><path id="shackle" d="M22 52 V32 a24 24 0 0 1 48 0 V52" fill="none" stroke="#ffd60a" stroke-width="12" stroke-linecap="round"/><rect x="8" y="50" width="76" height="58" rx="12" fill="#ffd60a"/><circle cx="46" cy="75" r="8" fill="#111"/><rect x="42" y="78" width="8" height="16" rx="3" fill="#111"/></svg><div class="A sh">Suhu <span>locked</span></div></div>
        </div>
      </div>
      <!-- G10 kain selamat 25.67–27.39 -->
      <div id="g10" class="layer clip" data-start="24.64" data-duration="2.48">
        <div class="top">
          <svg id="shield" viewBox="0 0 210 240"><path d="M105 10 L190 42 V112 C190 170 152 210 105 230 C58 210 20 170 20 112 V42 Z" fill="#2bd96b" stroke="#fff" stroke-width="10" stroke-linejoin="round"/><path id="shCheck" d="M62 120 l30 30 l58-62" fill="none" stroke="#fff" stroke-width="18" stroke-linecap="round" stroke-linejoin="round" stroke-dasharray="160" stroke-dashoffset="160"/></svg>
          <div id="safeLbl" class="A sh">Kain <span>tak rosak</span></div>
        </div>
      </div>
      <!-- G10b saiz kecil 27.12–30.30 (Task 2) -->
      <div id="g10b" class="layer clip" data-start="27.12" data-duration="3.18">
        <div class="top">
          <div id="smallCard"><svg viewBox="0 0 120 120" width="120" height="120"><rect x="34" y="34" width="52" height="52" rx="10" fill="#ffd60a"/><g fill="none" stroke="#fff" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"><path d="M8 30 V8 H30"/><path d="M8 8 L30 30"/><path d="M112 90 V112 H90"/><path d="M112 112 L90 90"/></g></svg><div class="A">Saiz kecil je!</div></div>
          <div id="mana"><span class="pill py"><svg viewBox="0 0 40 40" width="40" height="40" style="vertical-align:-8px;margin-right:10px"><rect x="5" y="12" width="30" height="24" rx="5" fill="#111"/><path d="M14 12 V7 h12 v5" fill="none" stroke="#111" stroke-width="4"/></svg>BAWA KE MANA-MANA</span></div>
        </div>
      </div>
      <!-- G11 harga 27.39–29.70 -->
      <div id="g11" class="layer clip" data-start="30.30" data-duration="2.48">
        <div class="top">
          <div id="burst"><svg viewBox="0 0 560 560"><polygon id="star" fill="#ffd60a" stroke="#111" stroke-width="8" points=""/></svg>
            <div id="burstTxt"><div class="a">Harga</div><div class="b">Murah<br />gila!</div></div></div>
        </div>
        <div id="rugi"><div class="A">Rugi tak grab!</div></div>
      </div>
      <!-- G12 CTA 29.70–33 -->
      <div id="g12" class="layer clip" data-start="32.96" data-duration="3.46">
        <div class="top" id="naik"><div class="box"><div class="A">Sebelum<br />harga naik!</div></div></div>
      </div>
      <div id="g13" class="layer clip" data-start="34.23" data-duration="2.19">
        <div id="ctaCard"><div class="card"><div class="A">Check out sekarang</div><div class="w">kat <b>beg kuning</b> bawah ni</div></div></div>
        <svg id="bag" viewBox="0 0 170 170"><path d="M52 62 V48 a33 33 0 0 1 66 0 V62" fill="none" stroke="#111" stroke-width="11" stroke-linecap="round"/><path d="M22 58 H148 L138 158 H32 Z" fill="#ffd60a" stroke="#111" stroke-width="9" stroke-linejoin="round"/><path d="M60 98 a25 25 0 0 0 50 0" fill="none" stroke="#111" stroke-width="9" stroke-linecap="round"/></svg>
        <svg id="arrows" viewBox="0 0 120 200"><path class="ar" d="M15 20 L60 60 L105 20" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/><path class="ar" d="M15 80 L60 120 L105 80" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/><path class="ar" d="M15 140 L60 180 L105 140" fill="none" stroke="#ffd60a" stroke-width="16" stroke-linecap="round" stroke-linejoin="round"/></svg>
      </div>

      <!--CAPTIONS-->

      <div id="flash" class="layer clip" data-start="0" data-duration="__TOTAL__"></div>

      <audio id="vo" src="assets/audio/vo_original.m4a" data-start="0" data-duration="36.11" data-volume="1"></audio>
      <!--SFX-->
    </div>

    <script>
      window.__timelines = window.__timelines || {};
      const tl = gsap.timeline({ paused: true });
      const punch = (s, t, f = 1.12, d = 0.3) => tl.fromTo(s, { scale: f }, { scale: 1, duration: d, ease: "power3.out" }, t);
      const drift = (s, t, d) => tl.fromTo(s, { scale: 1 }, { scale: 1.07, duration: d, ease: "none", immediateRender: false }, t);
      const flash = (t, a) => tl.fromTo("#flash", { opacity: a }, { opacity: 0, duration: 0.18, ease: "power2.out", immediateRender: false }, t);
      const hl = (s, t, c) => {
        tl.set(s, { className: c + " on" }, t);
        tl.fromTo(s, { scale: 1.12 }, { scale: 1, duration: 0.18, ease: "back.out(3)", immediateRender: false }, t);
      };
      const pop = (s, t, extra = {}) => tl.from(s, Object.assign({ scale: 0.3, opacity: 0, duration: 0.3, ease: "back.out(2.2)" }, extra), t);

      /*VIDJS*/

      /* rain */
      (function () {
        const rain = document.getElementById("rain");
        let seed = 7;
        const rnd = () => ((seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648);
        for (let i = 0; i < 60; i++) {
          const d = document.createElement("div");
          d.className = "drop";
          d.style.left = Math.round(rnd() * 1120 - 20) + "px";
          d.style.height = Math.round(60 + rnd() * 110) + "px";
          d.style.opacity = (0.35 + rnd() * 0.6).toFixed(2);
          rain.appendChild(d);
          const sp = 0.35 + rnd() * 0.3, off = rnd() * sp;
          for (let r = 0; r < Math.ceil(2.7 / sp) + 1; r++)
            tl.fromTo(d, { y: -220, x: 0, rotation: 12 }, { y: 2000, x: -120, rotation: 12, duration: sp, ease: "none", immediateRender: false }, Math.max(16.31, 16.81 + r * sp - off));
        }
      })();

      /* G1 hook */
      tl.fromTo("#hookA", { scale: 1.6, opacity: 0.0 }, { scale: 1, opacity: 1, duration: 0.25, ease: "power4.out" }, 0);
      tl.fromTo("#planeG", { x: -100, y: 210, rotation: -20 }, { x: 760, y: 120, rotation: 8, duration: 1.1, ease: "power1.inOut" }, 0.13);
      tl.from("#trail", { attr: { "stroke-dashoffset": 900 }, opacity: 0, duration: 1.1, ease: "power1.inOut" }, 0.13);
      tl.to("#g1", { scale: 1.3, opacity: 0, duration: 0.14, ease: "power2.in" }, 1.71);
      /* G2 */
      tl.from("#hookB", { y: -80, scale: 0.6, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 1.88);
      pop("#portable", 2.07);
      tl.fromTo("#hookB", { scale: 1 }, { scale: 1.12, duration: 0.12, yoyo: true, repeat: 1, immediateRender: false }, 2.88);
      /* G3 */
      tl.from("#chipsHead", { y: -50, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 3.74);
      tl.from(".chip", { y: -40, opacity: 0, duration: 0.25, stagger: 0.05, ease: "back.out(2)" }, 3.78);
      [["#c1", 4.50], ["#c2", 5.34], ["#c3", 6.42]].forEach(([c, t]) => { tl.set(c, { className: "chip on" }, t); tl.fromTo(c, { scale: 1.35 }, { scale: 1, duration: 0.3, ease: "back.out(3)", immediateRender: false }, t); });
      /* G4 hotel */
      tl.from("#hotelCard", { x: -900, duration: 0.4, ease: "power4.out" }, 7.91);
      tl.from("#susah .A", { scale: 2.6, opacity: 0, rotation: -12, duration: 0.3, ease: "power4.out" }, 9.26);
      tl.to("#susah .A", { x: 10, duration: 0.05, yoyo: true, repeat: 5, ease: "none" }, 9.52);
      /* G5 steps */
      tl.from("#stepsHead", { y: -50, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 10.62);
      tl.from(".step", { x: 500, opacity: 0, duration: 0.3, stagger: 0.08, ease: "power3.out" }, 10.64);
      [["#st1", 10.89], ["#st2", 11.16], ["#st3", 12.16]].forEach(([c, t]) => { tl.set(c, { className: "step on" }, t); tl.fromTo(c, { scale: 1.12 }, { scale: 1, duration: 0.3, ease: "back.out(3)", immediateRender: false }, t); });
      /* G6 problems */
      ["#g6a", "#g6b", "#g6c"].forEach((g, i) => pop(g + " .prob", [13.10, 15.12, 16.32][i], { x: -300, scale: 0.8 }));
      tl.fromTo("#g6a svg", { y: -6 }, { y: 6, duration: 0.25, yoyo: true, repeat: 5, ease: "sine.inOut", immediateRender: false }, 13.59);
      /* G7 30 minit */
      pop("#m30", 17.20);
      pop("#kering", 18.68, { y: 40 });
      /* G8 dial */
      tl.from("#dialWrap", { scale: 0.3, rotation: -90, opacity: 0, duration: 0.4, ease: "back.out(1.6)" }, 19.29);
      const dial = { v: 0 };
      tl.to(dial, { v: 120, duration: 1.1, ease: "power2.out", onUpdate: () => { document.getElementById("dialNum").textContent = Math.round(dial.v); } }, 19.76);
      tl.to("#dialArc", { attr: { "stroke-dashoffset": 0 }, duration: 1.1, ease: "power2.out" }, 19.76);
      pop("#maxLbl", 21.02, { y: 40 });
      /* G9 temp */
      tl.from("#tempBadge", { y: -260, opacity: 0, scale: 0.6, duration: 0.4, ease: "back.out(1.7)" }, 22.05);
      const temp = { v: 0 };
      tl.to(temp, { v: 48, duration: 1.0, ease: "power2.out", onUpdate: () => { document.getElementById("tempNum").textContent = Math.round(temp.v); } }, 22.38);
      tl.fromTo("#merc", { attr: { y: 120, height: 10 } }, { attr: { y: 30, height: 100 }, duration: 1.0, ease: "power2.out" }, 22.38);
      tl.from("#lockRow", { y: 70, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 22.89);
      tl.fromTo("#shackle", { y: -22 }, { y: 0, duration: 0.16, ease: "power4.in", immediateRender: false }, 23.10);
      tl.fromTo("#tempBadge", { boxShadow: "0 0 0 rgba(255,106,26,0)" }, { boxShadow: "0 0 70px rgba(255,106,26,0.9)", duration: 0.3, yoyo: true, repeat: 2, immediateRender: false }, 23.47);
      /* G10 */
      pop("#shield", 24.65);
      tl.to("#shCheck", { attr: { "stroke-dashoffset": 0 }, duration: 0.3, ease: "power2.out" }, 25.04);
      tl.from("#safeLbl", { y: 50, opacity: 0, duration: 0.3, ease: "back.out(2)" }, 25.13);
      /* G10b saiz kecil */
      tl.from("#smallCard", { scale: 2.2, opacity: 0, duration: 0.3, ease: "power4.out" }, 27.14);
      tl.fromTo("#smallCard svg", { scale: 1.3 }, { scale: 0.85, duration: 0.5, yoyo: true, repeat: 3, ease: "sine.inOut", immediateRender: false }, 27.5);
      pop("#mana", 28.76, { y: 50 });
      tl.fromTo("#mana .pill", { x: 0 }, { x: 18, duration: 0.3, yoyo: true, repeat: 3, ease: "sine.inOut", immediateRender: false }, 29.1);
      /* G11 price burst */
      (function () { const pts = []; for (let i = 0; i < 32; i++) { const a = (i / 32) * Math.PI * 2, r = i % 2 ? 210 : 265; pts.push((280 + r * Math.cos(a)).toFixed(1) + "," + (280 + r * Math.sin(a)).toFixed(1)); } document.getElementById("star").setAttribute("points", pts.join(" ")); })();
      tl.from("#burst", { scale: 0, rotation: -60, duration: 0.45, ease: "back.out(1.8)" }, 30.41);
      tl.to("#burst svg", { rotation: 30, duration: 2.2, ease: "none" }, 30.41);
      tl.fromTo("#burstTxt .b", { scale: 1 }, { scale: 1.15, duration: 0.14, yoyo: true, repeat: 1, immediateRender: false }, 30.90);
      tl.from("#rugi .A", { scale: 3, opacity: 0, duration: 0.25, ease: "power4.out" }, 31.68);
      /* G12/13 CTA */
      tl.from("#naik .box", { scale: 2.6, opacity: 0, rotation: -12, duration: 0.3, ease: "power4.out" }, 32.98);
      tl.to("#naik .box", { rotation: 2, duration: 0.07, yoyo: true, repeat: 7, ease: "none" }, 33.64);
      tl.from("#ctaCard", { y: 700, duration: 0.45, ease: "back.out(1.4)" }, 34.24);
      tl.from("#bag", { scale: 0, rotation: -30, duration: 0.35, ease: "back.out(2.5)" }, 35.31);
      tl.to("#bag", { y: -24, duration: 0.25, yoyo: true, repeat: 3, ease: "sine.inOut" }, 35.70);
      tl.from("#arrows", { opacity: 0, duration: 0.15 }, 35.38);
      tl.fromTo("#arrows .ar", { opacity: 0.15 }, { opacity: 1, duration: 0.15, stagger: 0.1, repeat: 3, yoyo: true, ease: "none", immediateRender: false }, 35.38);

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
