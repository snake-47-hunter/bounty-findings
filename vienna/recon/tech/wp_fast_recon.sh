#!/bin/bash

# ==============================
# WordPress Fast Recon Script
# Target: WordPress (Formidable / Multisite)
# ==============================

if [ -z "$1" ]; then
  echo "Usage: $0 https://target.tld"
  exit 1
fi

TARGET="$1"
OUTDIR="recon_$(echo $TARGET | sed 's|https\?://||g')"

mkdir -p "$OUTDIR"
echo "[*] Target : $TARGET"
echo "[*] Output : $OUTDIR"
echo

# ==============================
# 1. Sitemap enumeration
# ==============================

echo "[*] Fetching sitemaps..."
SITEMAPS=("post" "page" "portfolio" "portfolio_entries" "category" "post_tag")

> "$OUTDIR/urls.txt"

for sm in "${SITEMAPS[@]}"; do
  curl -sk "$TARGET/${sm}-sitemap.xml" \
  | grep -Eo "$TARGET[^<]+" >> "$OUTDIR/urls.txt"
done

sort -u "$OUTDIR/urls.txt" -o "$OUTDIR/urls.txt"
echo "[+] URLs collected: $(wc -l < "$OUTDIR/urls.txt")"
echo

# ==============================
# 2. Formidable Forms detection
# ==============================

echo "[*] Scanning for Formidable Forms..."
> "$OUTDIR/formidable_hits.txt"

while read url; do
  body=$(curl -sk --max-time 5 "$url")
  echo "$body" | grep -qiE "frm_form|item_meta\\[|frm_submit" && \
  echo "[+] FORMIDABLE: $url" | tee -a "$OUTDIR/formidable_hits.txt"
done < "$OUTDIR/urls.txt"

echo "[+] Formidable hits: $(wc -l < "$OUTDIR/formidable_hits.txt")"
echo

# ==============================
# 3. WordPress Multisite checks
# ==============================

echo "[*] Checking Multisite endpoints..."
> "$OUTDIR/multisite.txt"

for ep in "/wp-signup.php" "/wp-admin/network/" "/wp-admin/network/sites.php"; do
  code=$(curl -sk -o /dev/null -w "%{http_code}" "$TARGET$ep")
  echo "$ep -> HTTP $code" | tee -a "$OUTDIR/multisite.txt"
done

echo

# ==============================
# 4. REST API exposure
# ==============================

echo "[*] Checking REST API..."
> "$OUTDIR/rest_api.txt"

for ep in "/wp-json/wp/v2/users" "/wp-json/wp/v2/sites" "/wp-json/wp/v2/pages?per_page=100"; do
  code=$(curl -sk -o /dev/null -w "%{http_code}" "$TARGET$ep")
  echo "$ep -> HTTP $code" | tee -a "$OUTDIR/rest_api.txt"
done

echo

# ==============================
# 5. admin-ajax exposure
# ==============================

echo "[*] Checking admin-ajax..."
ajax=$(curl -sk "$TARGET/wp-admin/admin-ajax.php")

if [ "$ajax" = "0" ]; then
  echo "[+] admin-ajax.php reachable (0 response)" | tee "$OUTDIR/admin_ajax.txt"
else
  echo "[-] admin-ajax.php not exposed" | tee "$OUTDIR/admin_ajax.txt"
fi

echo
echo "[✓] Recon completed for $TARGET"
