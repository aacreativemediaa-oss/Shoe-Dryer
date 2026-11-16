"""Maps a time on the old tightened-VO timeline to the original VO timeline."""

D=36.734
sil=[(1.15194,1.45556),(6.01156,6.35588),(7.05463,7.361),(8.44731,8.69844),(10.216,10.5234),(11.6723,12.0558),(12.834,13.4176),(14.0954,14.4832),(15.2449,15.6218),(17.0923,17.4537),(18.9433,19.3171),(23.2482,23.555),(24.5785,24.8546),(25.8117,26.0971),(28.8779,29.2402),(30.6864,30.9862),(32.3221,32.6894),(33.3829,33.7809)]
rm=sorted([(a+0.07,b-0.07) for a,b in sil]+[(20.46,20.72)])
keep=[];t=0
for a,b in rm: keep.append((t,a)); t=b
keep.append((t,D))
def f(x):  # new (tight) time -> original time
    o=0
    for a,b in keep:
        L=b-a
        if x<=o+L+1e-9: return a+(x-o)
        o+=L
    return D+(x-o)
