#!/bin/bash

TARGETS=(
http://www.bauprojekte.gesundheitsverbund.at
http://www.ybbs.gesundheitsverbund.at
https://48ertandler.wien.at
https://48ertandler.wien.gv.at
https://abfallberatung.wien.gv.at
https://ausbildung.gesundheitsverbund.at
https://basemap.wien.at
https://bau.gesundheitsverbund.at
https://bauprojekt.gesundheitsverbund.at
https://bauprojekte.akhwien.at
https://bauprojekte.gesundheitsverbund.at
https://beruf.gesundheitsverbund.at
https://blog.stadtentwicklung.wien.gv.at
https://campus-alsergrund.gesundheitsverbund.at
https://campus-donaustadt.gesundheitsverbund.at
https://campus-favoriten.gesundheitsverbund.at
https://campus-floridotower.gesundheitsverbund.at
https://campus-leopoldstadt.gesundheitsverbund.at
https://compliance.gesundheitsverbund.at
https://diabeteszentrum.gesundheitsverbund.at
https://digitales.wien.at
https://digitales.wien.gv.at
https://gesundheitsfoerderung.gesundheitsverbund.at
https://gesundheitsziele.wien.at
https://gesundheitsziele.wien.gv.at
https://info.gesundheitsverbund.at
https://jobs.gesundheitsverbund.at
https://karriere.gesundheitsverbund.at
https://kdo.gesundheitsverbund.at
https://kfl.gesundheitsverbund.at
https://kfn.gesundheitsverbund.at
https://khi.gesundheitsverbund.at
https://kja.wien.at
https://kja.wien.gv.at
https://kla.gesundheitsverbund.at
https://klinik-donaustadt.gesundheitsverbund.at
https://klinik-favoriten.gesundheitsverbund.at
https://klinik-floridsdorf.gesundheitsverbund.at
https://klinik-hietzing.gesundheitsverbund.at
https://klinik-landstrasse.gesundheitsverbund.at
https://klinik-ottakring.gesundheitsverbund.at
https://klinik-penzing.gesundheitsverbund.at
https://klinik-ybbs.gesundheitsverbund.at
https://klinikdonaustadt.gesundheitsverbund.at
https://klinikfavoriten.gesundheitsverbund.at
https://klinikfloridsdorf.gesundheitsverbund.at
https://klinikhietzing.gesundheitsverbund.at
https://kliniklandstrasse.gesundheitsverbund.at
https://klinikottakring.gesundheitsverbund.at
https://klinikpenzing.gesundheitsverbund.at
https://klinikybbs.gesundheitsverbund.at
https://kor.gesundheitsverbund.at
https://kpe.gesundheitsverbund.at
https://kyd.gesundheitsverbund.at
https://open.wien.at
https://open.wien.gv.at
https://pflege.gesundheitsverbund.at
https://pflegewien.gesundheitsverbund.at
https://projektbau.gesundheitsverbund.at
https://respekt.wien.gv.at
https://schule.gesundheitsverbund.at
https://simulation.gesundheitsverbund.at
https://smartcity.wien.at
https://smartcity.wien.gv.at
https://sprachen.wien.at
https://sprachen.wien.gv.at
https://standort-penzing.gesundheitsverbund.at
https://standortpenzing.gesundheitsverbund.at
https://therapie-zentrum-ybbs.gesundheitsverbund.at
https://therapie-zentrumybbs.gesundheitsverbund.at
https://therapiezentrum-ybbs.gesundheitsverbund.at
https://therapiezentrumybbs.gesundheitsverbund.at
https://unternehmen.oekobusiness.wien.at
https://unternehmen.oekobusinessplan.wien.at
https://vorlesungen.wien.at
https://vorlesungen.wien.gv.at
https://wien1x1.wien.gv.at
https://wiengibtraum.wien.at
https://wiengibtraum.wien.gv.at
https://wienpflege.gesundheitsverbund.at
https://wlan.wien.at
https://www.48ertandler.wien.at
https://www.48ertandler.wien.gv.at
https://www.ausbildung.gesundheitsverbund.at
https://www.basemap.wien.at
https://www.bau.gesundheitsverbund.at
https://www.bauprojekt.gesundheitsverbund.at
https://www.bauprojekte.akhwien.at
https://www.digitales.wien.at
https://www.digitales.wien.gv.at
https://www.gesundheitsverbund.at
https://www.gesundheitsziele.wien.at
https://www.gesundheitsziele.wien.gv.at
https://www.karriere.gesundheitsverbund.at
https://www.klinik-donaustadt.gesundheitsverbund.at
https://www.klinik-favoriten.gesundheitsverbund.at
https://www.klinik-floridsdorf.gesundheitsverbund.at
https://www.klinik-hietzing.gesundheitsverbund.at
https://www.klinik-landstrasse.gesundheitsverbund.at
https://www.klinik-ottakring.gesundheitsverbund.at
https://www.klinik-penzing.gesundheitsverbund.at
https://www.klinik-ybbs.gesundheitsverbund.at
https://www.open.wien.at
https://www.open.wien.gv.at
https://www.pflege.gesundheitsverbund.at
https://www.projektbau.gesundheitsverbund.at
https://www.schule.gesundheitsverbund.at
https://www.smartcity.wien.at
https://www.smartcity.wien.gv.at
https://www.sprachen.wien.at
https://www.sprachen.wien.gv.at
https://www.standort-penzing.gesundheitsverbund.at
https://www.unternehmen.oekobusiness.wien.at
https://www.unternehmen.oekobusinessplan.wien.at
https://www.vorlesungen.wien.at
https://www.vorlesungen.wien.gv.at
https://www.wien1x1.wien.at
https://www.wien1x1.wien.gv.at
https://www.wiengibtraum.wien.at
https://www.wiengibtraum.wien.gv.at
https://www.wlan.wien.at
https://www.zustellung.wien.at
https://www.zustellung.wien.gv.at
https://ybbs.gesundheitsverbund.at
https://zustellung.wien.at
https://zustellung.wien.gv.at
)


OUTDIR="wp-fast"
mkdir -p "$OUTDIR"

UA="Mozilla/5.0 (Bugcrowd Research)"
TIMEOUT=5

for T in "${TARGETS[@]}"; do
  echo -e "\n============================"
  echo "[+] $T"

  BASE="https://$T"
  DIR="$OUTDIR/$T"
  mkdir -p "$DIR"

  # 1️⃣ WP detection (1 request)
  HTML=$(curl -sk --max-time $TIMEOUT -A "$UA" "$BASE")
  if ! echo "$HTML" | grep -qi "wp-content"; then
    echo "[-] No WP"
    continue
  fi
  echo "[+] WordPress"

  # 2️⃣ REST API (HEAD)
  curl -skI --max-time $TIMEOUT "$BASE/wp-json/" \
    | grep -i "200 OK" && echo "[+] REST API"

  # 3️⃣ Users (HEAD only)
  CODE=$(curl -sk -o /dev/null -w "%{http_code}" \
    --max-time $TIMEOUT "$BASE/wp-json/wp/v2/users")
  [[ "$CODE" == "200" ]] && echo "[!!] Users exposed"

  # 4️⃣ XML-RPC
  XML=$(curl -skI --max-time $TIMEOUT "$BASE/xmlrpc.php")
  echo "$XML" | grep -qi "200\|405" && echo "[+] XML-RPC active"

  # 5️⃣ Plugins (regex, no extra requests)
  echo "$HTML" \
    | grep -oE 'wp-content/plugins/[^/"]+' \
    | sort -u > "$DIR/plugins.txt"

  COUNT=$(wc -l < "$DIR/plugins.txt")
  [[ "$COUNT" -gt 0 ]] && echo "[+] $COUNT plugin(s) found"

done
