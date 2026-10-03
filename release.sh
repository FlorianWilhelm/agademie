#!/bin/sh
# Neue Version veröffentlichen: setzt Version, Datum und „Was ist neu“ (über changes.sh) in index.html und CHANGELOG.md, committet, taggt, pusht
# und legt das GitHub-Release mit dem Changelog-Abschnitt als Text an. Läuft nur auf main.
# Aufruf: ./release.sh 0.2
set -eu
v="${1:?Aufruf: ./release.sh <version>, z. B. 0.2}"
v="${v#v}"
case "$v" in *[!0-9.]*|'') echo "Ungültige Version: $v" >&2; exit 1;; esac
[ "$(git branch --show-current)" = main ] || { echo "Nur auf main ausführen (gearbeitet wird auf dev)." >&2; exit 1; }
git diff --quiet && git diff --cached --quiet || { echo "Erst alle Änderungen committen." >&2; exit 1; }
git rev-parse -q --verify "refs/tags/v$v" >/dev/null && { echo "Tag v$v gibt es schon." >&2; exit 1; }
d="$(date +%F)"
awk '/^## Unveröffentlicht$/{f=1;next} /^## /{f=0} f&&/^- /{n++} END{exit !n}' CHANGELOG.md || { echo "CHANGELOG.md: Abschnitt „## Unveröffentlicht“ mit Einträgen fehlt." >&2; exit 1; }
sed -i.bak -E "s/^## Unveröffentlicht$/## $v ($d)/" CHANGELOG.md && rm CHANGELOG.md.bak
sed -i.bak -E "s/^const VERSION='[^']*', UPDATED='[^']*';/const VERSION='$v', UPDATED='$d';/" index.html && rm index.html.bak
grep -q "^const VERSION='$v', UPDATED='$d';" index.html || { echo "Versionszeile in index.html nicht gefunden." >&2; exit 1; }
./changes.sh && ./changes.sh --check
git commit -q -m "Version $v" index.html CHANGELOG.md
git tag -a "v$v" -m "Version $v"
git push origin HEAD "v$v"
notes="$(awk -v h="## $v ($d)" '$0==h{f=1;next} /^## /{f=0} f' CHANGELOG.md | sed -e '/./,$!d')"
gh release create "v$v" --verify-tag --title "Version $v" --notes "$notes"
echo "Version $v ($d) veröffentlicht."
