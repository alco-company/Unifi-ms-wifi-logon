# Intune

## Formål

Intune skal distribuere:
- Trusted Root CA-certifikat
- Klientcertifikater til Windows/macOS-enheder
- Wi-Fi-profiler til WPA Enterprise / EAP-TLS

## Anbefalet flow

1. Opret et root CA-certifikat i Step-CA.
2. Upload root-certifikatet til Intune som trusted root.
3. Opret en device configuration profile for Wi-Fi.
4. Konfigurer EAP-type til TLS.
5. Vælg det korrekte klientcertifikat.

## Noter for Windows/macOS

- Windows: brug SCEP eller PKCS-certifikater afhængigt af din MDM-strategi.
- macOS: brug Apple profile payloads med EAP-TLS og certifikatvalg.
