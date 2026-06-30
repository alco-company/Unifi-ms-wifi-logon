# UniFi

## Formål

UniFi-controlleren skal være den Wi-Fi-aktiveringspunkt, som bruger RADIUS til at validere klienter.

## Konfiguration

1. Gå til UniFi-controllerens RADIUS-indstillinger.
2. Tilføj FreeRADIUS-serveren med IP, port 1812 og fælleshemmelighed.
3. Opret en WPA Enterprise SSID.
4. Vælg EAP-TLS og RADIUS som autentificeringsmekanisme.
5. Tilknyt VLANer for Corporate, Guest og IoT.

## Vigtige valg

- Brug WPA2/3 Enterprise.
- Aktiver dynamisk VLAN, hvis du vil adskille netværk efter gruppe eller bruger.
- Test først med en pilotgruppe.
