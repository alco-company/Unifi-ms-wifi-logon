# Portainer

## Formål

Denne stack-variant er lavet til Portainer, så du kan deploye uden lokal Docker image-build.

## Anbefalet opsætning

1. Clone dette repository på Docker-hosten, for eksempel til `/srv/wifi-ms-logon`
2. Opret persistent data-mapper:
   - `/srv/wifi-ms-logon-data/step-ca`
   - `/srv/wifi-ms-logon-data/freeradius/certs`
3. Kopier værdierne fra `deploy/portainer.env.example` ind i Portainer stackens miljøvariabler
4. Sæt:
   - `PORTAINER_REPO_ROOT=/srv/wifi-ms-logon/deploy`
   - `PORTAINER_DATA_ROOT=/srv/wifi-ms-logon-data`
5. Læg `ca.pem`, `server.pem` og `dh` i `${PORTAINER_DATA_ROOT}/freeradius/certs`
6. Deploy `deploy/portainer-stack.yml` som en stack i Portainer

## Vigtige noter

- Denne variant bruger den officielle `freeradius/freeradius-server:3.2`-container direkte
- FreeRADIUS-konfigurationen renderes ved opstart fra templates i repoet
- Hvis du opdaterer template-filerne i repoet, bør du redeploye stacken
- Hvis du vil bruge udviklingscertifikater, kan de genereres lokalt med `deploy/generate-dev-certs.sh` og derefter kopieres til data-mappen på Docker-hosten
