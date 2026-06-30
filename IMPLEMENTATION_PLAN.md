# Implementeringsplan

## 1. Infrastruktur
- Opsæt Ubuntu 24.04 VM med Docker og Docker Compose.
- Opret DNS-navne: ca.firma.dk og radius.firma.dk.
- Sørg for at UniFi-controlleren kan nå RADIUS på port 1812.

## 2. Step-CA
- Installer Step-CA og opret en intern CA.
- Udsted certifikater til Wi-Fi-klienter og servere.
- Eksporter root-certifikatet til Intune.

## 3. FreeRADIUS
- Konfigurer RADIUS til EAP-TLS.
- Tilføj UniFi-controller som klient.
- Accepter kun klienter med gyldige certifikater.

## 4. Intune
- Udrul trusted root CA.
- Udrul Wi-Fi-profil med EAP-TLS.
- Udrul klientcertifikater til relevante enheder.

## 5. Entra ID og grupper
- Opret grupper: Wifi-Users, Wifi-Admins, Guests.
- Brug gruppemedlemskab til adgangskontrol.

## 6. UniFi
- Opret WPA Enterprise SSID.
- Tilføj RADIUS-serveren.
- Brug VLANer til Corporate, Guest og IoT.

## 7. Pilot og rollout
- Test med et lille antal enheder.
- Valider certifikatfornyelse og autentificering.
- Udrul derefter til resten af organisationen.
