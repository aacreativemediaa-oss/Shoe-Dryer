import json, subprocess, re, sys
D=36.734
sil=[(1.15194,1.45556),(6.01156,6.35588),(7.05463,7.361),(8.44731,8.69844),(10.216,10.5234),(11.6723,12.0558),(12.834,13.4176),(14.0954,14.4832),(15.2449,15.6218),(17.0923,17.4537),(18.9433,19.3171),(23.2482,23.555),(24.5785,24.8546),(25.8117,26.0971),(28.8779,29.2402),(30.6864,30.9862),(32.3221,32.6894),(33.3829,33.7809)]
rm=[(a+0.07,b-0.07) for a,b in sil]
rm.append((20.46,20.72))   # gap + stutter "nak"
rm.sort()
keep=[];t=0
for a,b in rm: keep.append((t,a)); t=b
keep.append((t,D))
def remap(x):
    o=0
    for a,b in keep:
        if x<a: return o
        if x<=b: return o+(x-a)
        o+=b-a
    return o
parts=[];f=""
for i,(a,b) in enumerate(keep):
    f+=f"[0:a]atrim={a:.4f}:{b:.4f},asetpts=PTS-STARTPTS,afade=t=in:d=0.008,afade=t=out:st={b-a-0.008:.4f}:d=0.008[a{i}];"
f+="".join(f"[a{i}]" for i in range(len(keep)))+f"concat=n={len(keep)}:v=0:a=1,highpass=f=70,acompressor=threshold=-20dB:ratio=3:attack=5:release=80,loudnorm=I=-16:TP=-1.5[o]"
subprocess.run(["ffmpeg","-nostdin","-v","error","-y","-i","task1.mov","-filter_complex",f,"-map","[o]","-ar","48000","-ac","2","vo.wav"],check=True)
d=json.load(open("tx.json"))
W=[]
for s in d:
    for w in s["w"]:
        if 20.46<=w[0]<20.72: continue
        W.append([round(remap(w[0]),3),round(remap(w[1]),3),w[2].strip()])
fix={"penggering":"pengering","48°C":"48°C"}
for w in W: w[2]=fix.get(w[2],w[2])
json.dump(W,open("words.json","w"),ensure_ascii=False)
print("new dur",remap(D)); print(W[:3],W[-1])
