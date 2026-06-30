Denne mappe bruges af FreeRADIUS-containeren.

Krævede filer:
- `ca.pem`
- `server.pem`
- `dh`

Til lokal udvikling kan de genereres med:

```bash
./deploy/generate-dev-certs.sh
```

I produktion skal filerne erstattes af certifikater udstedt af Step-CA eller din interne CA.
