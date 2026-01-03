#!/bin/bash

# ==========================
# WordPress Passive Audit
# Bugcrowd Safe - Vienna
# ==========================

TARGETS=(
  blog.stadtentwicklung.wien.gv.at
  open.wien.at
  open.wien.gv.at
  digitales.wien.at
  digitales.wien.gv.at
  projektbau.gesundheitsverbund.at
  bauprojekte.gesundheitsverbund.at
  bauprojekte.akhwien.at
  campus-donaustadt.gesundheitsverbund.at
  campus-favoriten.gesundheitsverbund.at
  campus-floridotower.gesundheitsverbund.at
  pflege.gesundheitsverbund.at
  pflegewien.gesundheitsverbund.at
  wiengibtraum.wien.at
  wiengibtraum.wien.gv.at
)

OUTDIR="wp-audit"
mkdir -p "$OUTDIR"
SUMMARY="$OUTDIR/summary.txt"
> "$SUMMARY"

USER_AGENT="Mozilla/5.0 (Bugcrowd Research)"

echo "[*] Starting WordPress passive audit..." | tee -a "$SUMMARY"

for TARGET in "${TARGETS[@]}"; do
  echo -e "\n===============================" | tee -a "$SUMMARY"
  echo "[+] Target: $TARGET" | tee -a "$SUMMARY"

  TDIR="$OUTDIR/$TARGET"
  mkdir -p "$TDIR"

  BASE="https://$TARGET"

  # 1️⃣ WordPress detection
  curl -sk -A "$USER_AGENT" "$BASE" | grep -qi "wp-content" || {
    echo "[-] Not WordPress or heavily protected" | tee -a "$SUMMARY"
    continue
  }

  echo "[+] WordPress detected" | tee -a "$SUMMARY"

  # 2️⃣ REST API
  curl -sk "$BASE/wp-json/" > "$TDIR/rest.txt"
  echo "[+] REST API checked" >> "$SUMMARY"

  # Users
  curl -sk "$BASE/wp-json/wp/v2/users" > "$TDIR/users.txt"

  # Posts / Pages
  curl -sk "$BASE/wp-json/wp/v2/posts" >> "$TDIR/rest.txt"
  curl -sk "$BASE/wp-json/wp/v2/pages" >> "$TDIR/rest.txt"

  # 3️⃣ XML-RPC
  curl -sk -i "$BASE/xmlrpc.php" > "$TDIR/xmlrpc.txt"

  # 4️⃣ Plugins detection
  curl -sk "$BASE" \
    | grep -oE 'wp-content/plugins/[^/]+' \
    | sort -u > "$TDIR/plugins.txt"

  # Try plugin readme (passive)
  while read -r PLUGIN; do
    PLUGIN_NAME=$(basename "$PLUGIN")
    curl -sk "$BASE/wp-content/plugins/$PLUGIN_NAME/readme.txt" \
      | head -n 20 >> "$TDIR/plugins_readme.txt"
  done < "$TDIR/plugins.txt"

  # 5️⃣ Sensitive files
  for FILE in debug.log .env .git/config wp-config.php~; do
    STATUS=$(curl -sk -o /dev/null -w "%{http_code}" "$BASE/$FILE")
    echo "$FILE => $STATUS" >> "$TDIR/sensitive.txt"
    [[ "$STATUS" == "200" ]] && echo "[!!] $FILE exposed on $TARGET" | tee -a "$SUMMARY"
  done

  echo "[✓] Done: $TARGET" | tee -a "$SUMMARY"
  sleep 2
done

echo -e "\n[*] Audit completed." | tee -a "$SUMMARY"
