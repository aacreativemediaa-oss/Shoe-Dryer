import numpy as np, wave, sys, os
SR=48000; out=sys.argv[1]; rng=np.random.default_rng(7)
def save(n,x):
    x=np.asarray(x,dtype=np.float64)
    if x.ndim==1: x=np.stack([x,x],1)
    x=x/ (np.abs(x).max()+1e-9)*0.89
    w=wave.open(os.path.join(out,n+".wav"),"w"); w.setnchannels(2); w.setsampwidth(2); w.setframerate(SR)
    w.writeframes((x*32767).astype(np.int16).tobytes()); w.close()
def t(d): return np.arange(int(SR*d))/SR
def lp(x,a):  # one-pole lowpass, a may be array
    y=np.zeros_like(x); s=0.0; a=np.broadcast_to(a,x.shape)
    for i in range(len(x)): s+= a[i]*(x[i]-s); y[i]=s
    return y
def env(n,att,rel):
    e=np.ones(n); a=int(att*SR); r=int(rel*SR)
    if a: e[:a]=np.linspace(0,1,a)
    if r: e[-r:]*=np.linspace(1,0,r)**2
    return e
# whoosh: noise with sweeping lowpass, stereo pan
d=0.55; n=int(SR*d); tt=t(d); nz=rng.standard_normal(n)
cut=0.02+0.35*np.sin(np.pi*tt/d)**2
w=lp(nz,cut)-lp(nz,cut*0.15); e=np.sin(np.pi*tt/d)**1.5
pan=tt/d; save("whoosh",np.stack([w*e*(1-pan*0.6),w*e*(0.4+pan*0.6)],1))
# pop
d=0.12; tt=t(d); f=900*np.exp(-tt*30)+300
save("pop",np.sin(2*np.pi*np.cumsum(f)/SR)*np.exp(-tt*40))
# ding (bell)
d=1.4; tt=t(d); x=sum(a*np.sin(2*np.pi*f*tt)*np.exp(-tt*k) for f,a,k in [(1318.5,1,3),(2637,0.4,5),(3951,0.2,7),(1975.5,0.3,4)])
save("ding",x*env(len(tt),0.002,0.05))
# riser: rising noise + saw sweep, 1.5s
d=1.5; tt=t(d); n=len(tt); nz=rng.standard_normal(n)
x=lp(nz,0.01+0.4*(tt/d)**2)*(tt/d)**2
f=200+1200*(tt/d)**2; s=np.sin(2*np.pi*np.cumsum(f)/SR)*0.25*(tt/d)**2
save("riser",(x+s)*env(n,0.01,0.02))
# impact boom
d=1.2; tt=t(d); f=55+120*np.exp(-tt*18)
x=np.sin(2*np.pi*np.cumsum(f)/SR)*np.exp(-tt*4)+0.5*lp(rng.standard_normal(len(tt)),0.08)*np.exp(-tt*14)
save("impact",np.tanh(x*2))
# click/tick
d=0.05; tt=t(d); save("tick",np.sin(2*np.pi*2500*tt)*np.exp(-tt*150)+0.3*rng.standard_normal(len(tt))*np.exp(-tt*300))
# ka-ching: metallic hits + bells
d=1.3; tt=t(d); n=len(tt)
k=np.zeros(n); k[:int(0.06*SR)]=rng.standard_normal(int(0.06*SR))*np.exp(-np.arange(int(0.06*SR))/SR*60)
b=np.zeros(n); o=int(0.09*SR); tb=tt[:n-o]
b[o:]=sum(a*np.sin(2*np.pi*f*tb)*np.exp(-tb*k2) for f,a,k2 in [(2093,1,3),(2637,0.8,3.5),(3136,0.6,4),(4186,0.3,6)])
save("kaching",k*0.6+b)
# rain ambience 4s + thunder rumble
d=4.0; tt=t(d); n=len(tt); nz=rng.standard_normal(n)
rain=lp(nz,0.25)-lp(nz,0.02)
drops=np.zeros(n); idx=rng.integers(0,n-2000,350)
for i in idx: L=600; drops[i:i+L]+=rng.uniform(0.2,1)*np.sin(2*np.pi*rng.uniform(1500,4000)*np.arange(L)/SR)*np.exp(-np.arange(L)/SR*250)
thunder=lp(rng.standard_normal(n),0.004)*np.exp(-np.maximum(tt-0.3,0)*1.2)*(tt>0.3)*25
save("rain",(rain*0.5+drops*0.4+thunder)*env(n,0.05,0.8))
# swipe up (short whoosh high)
d=0.3; n=int(SR*d); tt=t(d); nz=rng.standard_normal(n); cut=0.05+0.5*(tt/d)
save("swipe",(lp(nz,cut)-lp(nz,cut*0.2))*np.sin(np.pi*tt/d))
print("ok")
