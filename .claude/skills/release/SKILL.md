---
name: release
description: Neue AGAdemy-Version veröffentlichen. dev nach main mergen, Changelog prüfen, taggen, pushen und GitHub-Release anlegen.
argument-hint: "[version, z. B. 0.3]"
disable-model-invocation: true
---

# Release

Veröffentlicht den Stand von `dev` als neue Version. GitHub Pages baut von `main`,
erst damit geht die Änderung live.

Gewünschte Version: `$ARGUMENTS` (leer: nächste Minor-Version vorschlagen, z. B. 0.2 → 0.3).

## 1. Vorbedingungen prüfen

Bei einem Fehler abbrechen und sagen, was zu tun ist. Nichts erzwingen.

- Aktueller Branch ist `dev`, Arbeitsverzeichnis sauber (`git status --porcelain` leer).
- `git fetch origin`, dann: `main` ist Vorfahre von `dev` (`git merge-base --is-ancestor origin/main dev`),
  sonst ist kein Fast-Forward möglich.
- `git log --oneline origin/main..dev` ist nicht leer, sonst gibt es nichts zu veröffentlichen.
- Tag `v<version>` existiert noch nicht.

## 2. Changelog prüfen

Den Abschnitt `## Unveröffentlicht` in `CHANGELOG.md` mit `git log origin/main..dev`
und bei Bedarf `git diff origin/main..dev` abgleichen:

- Jede für Nutzer sichtbare Änderung hat einen Eintrag. Reine Interna (Refactoring, Tooling,
  `.claude/`, README) brauchen keinen.
- Kein Eintrag beschreibt etwas, das nicht (mehr) im Diff steckt.
- Stil wie in den bisherigen Einträgen: Deutsch, kurz, aus Sicht der Nutzer, ein Spiegelstrich pro Punkt.

Fehlt etwas oder ist etwas falsch: Korrektur auf `dev` vornehmen und committen
(`Changelog für <version> ergänzen`).

Dann dem Nutzer zeigen: Version, die Changelog-Einträge, die Commits seit dem letzten
Release. **Auf ein klares Ja warten**, bevor es weitergeht: Ab hier wird gepusht und veröffentlicht.

## 3. Veröffentlichen

```sh
git switch main
git merge --ff-only origin/main
git merge --ff-only dev
./release.sh <version>
```

`release.sh` setzt Version und Datum, committet auf `main`, taggt, pusht `main` und Tag
und legt das GitHub-Release mit dem Changelog-Abschnitt an.

## 4. dev nachziehen

```sh
git switch dev
git merge --ff-only main
git push origin dev
```

Danach steht `dev` auf dem Release-Commit und es kann weitergehen.

## 5. Abschluss

Kurz melden: Version, Link zum GitHub-Release (`gh release view v<version> --json url -q .url`)
und dass die Seite unter https://florianwilhelm.info/agademy/ nach dem Pages-Build
(ein bis zwei Minuten) aktuell ist.
