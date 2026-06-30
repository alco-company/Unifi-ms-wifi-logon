# UniFi WiFi med Entra ID, Intune, Step-CA og FreeRADIUS

Dette repository er en starter-implementering af den arkitektur, der er beskrevet i PDF’en.

## Mål

Opsætte en Wi-Fi-løsning hvor:
- Microsoft 365-brugere logger på via deres Entra ID-bruger og password
- Intune distribuerer et tillidstræ, klientcertifikater og Wi-Fi-profiler
- Step-CA udsteder interne certifikater
- FreeRADIUS validerer EAP-TLS-certifikater
- UniFi bruger WPA Enterprise og RADIUS til autentificering

## Arkitektur

Entra ID -> Intune -> Step-CA -> FreeRADIUS -> UniFi WiFi

## Hvad der er inkluderet

- Script til Docker-værtopsætning
- Docker Compose til Step-CA og FreeRADIUS
- Portainer-stack uden lokal image-build
- FreeRADIUS bootstrap via template-baseret konfiguration
- Bootstrap-script til Docker-miljøet
- Script til lokale udviklingscertifikater
- Templates til RADIUS-klienter og EAP-konfiguration
- Checklister til Intune og UniFi

## Forudsætninger

Du har brug for:
- En Docker-host eller Portainer-installation
- DNS-navne for ca.firma.dk og radius.firma.dk
- En Microsoft 365 / Entra ID-tenant med Intune-administrator
- En UniFi-controller med administratoradgang
- Et internt domæne eller almen DNS til at nå RADIUS og CA

## Start

1. Installer Docker på din host, hvis det ikke allerede er installeret.
   På Ubuntu kan du bruge `deploy/ubuntu-24.04-setup.sh`:
   ```bash
   chmod +x deploy/ubuntu-24.04-setup.sh
   ./deploy/ubuntu-24.04-setup.sh
   ```
2. Bootstrap Docker-miljøet ved lokal Docker Compose:
   ```bash
   chmod +x deploy/bootstrap-docker-env.sh deploy/generate-dev-certs.sh
   ./deploy/bootstrap-docker-env.sh
   ```
3. Rediger miljøvariabler i `deploy/.env`
4. Generer udviklingscertifikater til lokal test, eller læg dine egne CA-/serverfiler i `deploy/freeradius/certs/`:
   ```bash
   ./deploy/generate-dev-certs.sh
   ```
5. Start tjenesterne:
   ```bash
   cd deploy
   docker compose up -d
   ```
6. Følg vejledningerne i `deploy/step-ca/README.md`, `deploy/freeradius/README.md`, `deploy/intune/README.md` og `deploy/unifi/README.md`

## Portainer-start

Hvis du vil køre det i Portainer:

1. Clone repoet på Docker-hosten, fx til `/srv/wifi-ms-logon`
2. Opret data-mapper til `step-ca` og `freeradius/certs`
3. Brug [deploy/portainer-stack.yml](/Users/bodiechmann/src/Wifi-MS-logon/deploy/portainer-stack.yml:1) som stack-fil
4. Brug [deploy/portainer.env.example](/Users/bodiechmann/src/Wifi-MS-logon/deploy/portainer.env.example:1) som skabelon til Portainer miljøvariabler
5. Følg [deploy/portainer/README.md](/Users/bodiechmann/src/Wifi-MS-logon/deploy/portainer/README.md:1)

## Docker-noter

- `step-ca` initialiseres automatisk første gang containeren starter, baseret på værdierne i `deploy/.env`
- FreeRADIUS bruger den officielle container og renderer sin konfiguration fra templates ved opstart
- `deploy/generate-dev-certs.sh` er kun til lokal test og smoke tests
- I produktion bør FreeRADIUS bruge certifikater udstedt af Step-CA, så tillidskæden matcher den, der distribueres via Intune

## Vigtige noter

- Denne løsning er en certifikatbaseret 802.1X-opstilling. Den bruger typisk EAP-TLS via Step-CA og Intune, ikke kun et simpelt Microsoft 365-password login på Wi-Fi.
- For at få en brugerdrevet oplevelse med Microsoft 365-konti skal du kombinere Intune, klientcertifikater og en veldefineret Wi-Fi-profil på enhederne.
- Erstat alle eksempelværdier som domæne, hemmeligheder, DNS-navne og IP-adresser med dine egne værdier før deployment.
- De genererede udviklingscertifikater er kun egnede til lokal test og må ikke bruges i produktion.
- Sørg for at firewall, DNS og UDP-port 1812/1813 er åbne mellem UniFi-controlleren og FreeRADIUS-serveren.
- Test først med en pilotgruppe af enheder og brugere, før du ruller det ud til hele organisationen.

## Næste skridt

Følg denne rækkefølge:
1. Opret og valider DNS for ca.firma.dk og radius.firma.dk.
2. Installer og initialiser Step-CA på Docker-hosten eller via Portainer.
3. Udsted et root- og klientcertifikat til testbrugere.
4. Konfigurer FreeRADIUS til EAP-TLS og tilføj UniFi-controlleren som klient.
5. Udrul Wi-Fi-profil og root-certifikat via Intune.
6. Opret SSID på UniFi og test autentificering med en pilotgruppe.

## Bemærkning

Dette er en sikkerheds- og driftsmæssig starter-løsning. I produktion skal du gennemgå:
- Certifikatpolitikker
- CRL/OCSP
- NTP og tidsstyring
- Logging og overvågning
- Backup og restore
- Rollebaseret adgang for administratorer
