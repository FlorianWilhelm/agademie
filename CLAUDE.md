# AGAdemy

## Branches und Releases

- Gearbeitet und committet wird **immer auf `dev`**. Vor dem ersten Commit prüfen, dass `dev` ausgecheckt ist.
- `main` wird nie direkt verändert. GitHub Pages veröffentlicht von `main`, Änderungen
  kommen nur über `/release` dorthin (Fast-Forward von `dev`, dann `release.sh`).
- Jede für Nutzer sichtbare Änderung bekommt im selben Commit einen Eintrag unter
  `## Unveröffentlicht` in `CHANGELOG.md`.
- Pushen von `dev` ist erlaubt, wenn der Nutzer es möchte. Veröffentlichen nur per `/release`.
