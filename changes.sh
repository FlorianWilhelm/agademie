#!/bin/sh
# Schreibt die letzten drei veröffentlichten Versionen aus CHANGELOG.md als CHANGES in index.html,
# damit „Was ist neu“ in der Hilfe immer zur Version der Seite passt. Ruft release.sh auf.
# Aufruf: ./changes.sh          index.html aktualisieren
#         ./changes.sh --check  nur prüfen, Exit-Code 1 bei Abweichung
set -eu
cd "$(dirname "$0")"
gen() {
  awk 'function q(s){gsub(/\\/,"\\\\",s);gsub(/"/,"\\\"",s);return "\"" s "\""}
    /^## [0-9][0-9.]* \([0-9]{4}-[0-9][0-9]-[0-9][0-9]\)$/{
      if(open) print "]},"
      if(++n>3){open=0;exit}
      d=$3;gsub(/[()]/,"",d);printf "{v:%s,d:%s,items:[\n",q($2),q(d);open=1;next}
    /^## /{if(open) print "]},";open=0;next}
    open&&/^- /{print q(substr($0,3)) ","}
    END{if(open) print "]},"}' CHANGELOG.md
}
new="$(mktemp)"; trap 'rm -f "$new"' EXIT
gen | awk 'NR==FNR{b=b $0 "\n";next} $0=="const CHANGES=["{print;printf "%s",b;skip=1;found=1;next}
  skip&&$0=="]; // Ende CHANGES"{skip=0} !skip{print} END{exit !found||skip}' - index.html >"$new" \
  || { echo "CHANGES-Block in index.html nicht gefunden." >&2; exit 1; }
# Neueste Version in CHANGES muss zur Versionszeile passen
vd="$(sed -n -E "s/^const VERSION='([^']*)', UPDATED='([^']*)';.*/{v:\"\1\",d:\"\2\",items:[/p" index.html)"
first="$(grep -m1 '^{v:' "$new" || true)"
if [ "${1:-}" = --check ]; then
  cmp -s "$new" index.html || { echo "index.html: CHANGES passt nicht zu CHANGELOG.md, ./changes.sh ausführen." >&2; exit 1; }
  [ "$first" = "$vd" ] || { echo "index.html: Versionszeile und neueste Version im Changelog weichen ab." >&2; exit 1; }
  echo "CHANGES ist aktuell."
else
  cat "$new" >index.html
fi
