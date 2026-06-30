# FreeRADIUS

## Formål

FreeRADIUS kører i en container og validerer EAP-TLS-certifikater for UniFi-controlleren.

## Docker-flow

1. Udfyld `deploy/.env`
2. Læg certifikatfiler i `deploy/freeradius/certs/`
3. Start stacken med `docker compose up -d`

## Krævede certifikatfiler

- `ca.pem`
- `server.pem`
- `dh`

Til lokal test kan de genereres med `./deploy/generate-dev-certs.sh`.

## Portainer-note

Hvis du bruger Portainer, så brug `deploy/portainer-stack.yml` og sæt host-paths samt miljøvariabler i stacken.

## Produktionsnote

I produktion bør `server.pem` og `ca.pem` komme fra Step-CA eller din valgte interne CA, så klienterne validerer samme tillidskæde som Intune distribuerer.
