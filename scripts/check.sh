#!/usr/bin/env bash
# Verifica cada URL de targets.txt; repete 1x apos 20s antes de declarar queda.
set -uo pipefail
check(){ curl -s -o /dev/null -m 20 -w '%{http_code}' "$1" || true; }
down=(); rows=()
while read -r url codes; do
  [[ -z "$url" || "$url" == \#* ]] && continue
  c=$(check "$url")
  if [[ ",$codes," != *",$c,"* ]]; then sleep 20; c=$(check "$url"); fi
  if [[ ",$codes," == *",$c,"* ]]; then rows+=("| $url | $c | OK |"); else rows+=("| $url | $c | **FORA** |"); down+=("$url ($c)"); fi
done < targets.txt
{
  echo "## Disponibilidade — $(TZ=America/Sao_Paulo date '+%d/%m/%Y %H:%M') (Brasília)"
  echo; echo "| Endereço | HTTP | Status |"; echo "|---|---|---|"
  printf '%s\n' "${rows[@]}"
} > report.md
cat report.md >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
printf '%s\n' "${down[@]}" > down.txt
echo "fora=${#down[@]}" >> "${GITHUB_OUTPUT:-/dev/null}"
echo "Fora do ar: ${#down[@]}"; printf '  %s\n' "${down[@]}"
