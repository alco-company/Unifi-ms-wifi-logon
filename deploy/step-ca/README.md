# Step-CA

## Formål

Step-CA bruges som intern certificate authority til at udstede og forny klientcertifikater til Wi-Fi-brugere.

## Grundlæggende opsætning

1. Udfyld Step-CA-værdierne i `deploy/.env`.
2. Start containeren med `docker compose up -d`.
3. Hent root-certifikatets fingerprint:
   ```bash
   docker compose exec step-ca step certificate fingerprint /home/step/certs/root_ca.crt
   ```
4. Hent eller fastlæg CA-password:
   ```bash
   docker compose exec step-ca cat /home/step/secrets/password
   ```
5. Importer det offentlige root-certifikat på Windows/macOS-enheder via Intune.
6. Brug certifikater til EAP-TLS på klienter.

## Vigtige noter

- Brug en stærk, veldefineret certifikatpolitik.
- Sæt passende levetid, f.eks. 90 dage.
- Planlæg automatisk fornyelse og backup.
- Den første containerstart opretter CA-konfigurationen i `deploy/step-ca/data/`.
- I Portainer skal de samme Step-CA-værdier sættes som stack-miljøvariabler.
