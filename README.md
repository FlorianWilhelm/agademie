# AGAdemy

**Die AGA für Zivis.** Bundeswehr-Grundwissen spielerisch lernen.

AGA steht für Allgemeine Grundausbildung. AGAdemy ist die zivile Variante:
für alle, die mit der Bundeswehr zusammenarbeiten wollen und verstehen möchten,
wie sie tickt.

> **Hinweis:** Privates Projekt. **Kein Angebot der Bundeswehr oder des BMVg**
> und mit diesen in keiner Verbindung. Verbindlich sind allein die offiziellen Quellen.

## Inhalte

* Strukturen: BMVg, Teilstreitkräfte, Organisationsbereiche, Karrierecenter
* Bundeswehr im Staat: Parlamentsarmee, Befehlsgewalt, Innere Führung, Wehrbeauftragte, Statusgruppen, Wehrdienst
* Bündnis: NATO, Artikel 5, Brigade Litauen, Drehscheibe Deutschland, Heimatschutz, EU
* Dienstgrade, Abzeichen und Anreden
* Waffenfarben (Litze, Kragenspiegel) und Barettfarben
* Gliederung vom Trupp zur Division, Großverbände, NATO-Größenzeichen
* Stabsabteilungen (J1 bis J9)
* Abkürzungen, Buchstabieralphabet und Datum-Zeit-Gruppe
* Beschaffung und Haushalt: Bedarfsträger, BAAINBw, BWI, Einzelplan 14, Sondervermögen
* Anrede, Gelöbnis, Zeremonien und Auszeichnungen

Lektionen, Lernkarten mit Karteikasten-System, Quiz und Nachschlagetabellen.
Der Lernstand wird nur lokal im Browser gespeichert.

## Quellen

Alle Inhalte basieren auf öffentlich zugänglichen Quellen (u. a. bundeswehr.de,
NATO STANAG 2116, NATO APP-6). Fehler gefunden? Gern ein Issue aufmachen.

## Technik

Eine einzelne statische `index.html`, ausgeliefert über GitHub Pages.
Ein Service Worker (`sw.js`) und das Manifest (`icons/site.webmanifest`) machen
daraus eine installierbare PWA, die nach dem ersten Aufruf auch offline läuft.
Die Seite ist per `<meta name="robots" content="noindex">` von der Indizierung
durch Suchmaschinen ausgenommen.

Änderungen kommen in [CHANGELOG.md](CHANGELOG.md) unter „Unveröffentlicht“.
Neue Versionen erscheinen über `./release.sh 0.2`: Das Skript setzt Version und
Datum (YYYY-MM-DD) in `index.html` und im Changelog, committet, legt den Tag `v0.2`
an und pusht. Die Hilfe-Seite zeigt so immer die Version des aktuellen Tags und
die letzten Einträge aus dem Changelog.

## Lizenz

Code: MIT (siehe [LICENSE](LICENSE)). Inhalte: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
