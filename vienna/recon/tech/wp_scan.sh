#!/bin/bash

INPUT_FILE="wp-top15.txt"
API_TOKEN="pa1kNhR9SuHb4QKqJbufX6GE3WaKyQk2Dh0vMI4Yh1w"
OUTPUT_DIR="wpscan_results_top15"

mkdir -p $OUTPUT_DIR

while read -r url; do
    url=$(echo $url | xargs)  # Nettoie espaces
    
    # Nom safe pour fichier (échappe les points correctement)
    safe_name=$(echo $url | sed 's/https*:\/\///' | sed 's/\//_/g' | sed 's/\./_/g')
    
    echo "[+] Scanning $url ..."
    
    wpscan --url "$url" \
           --enumerate vp,vt,u \
           --api-token $API_TOKEN \
           --no-banner \
           --ignore-main-redirect \
           --random-user-agent \
           --format json \
           -o "$OUTPUT_DIR/${safe_name}.json" \
           | tee "$OUTPUT_DIR/${safe_name}_console.txt"

    sleep 2  # Pause anti-blocage
done < "$INPUT_FILE"

echo "Scan lot terminé ! Résultats dans $OUTPUT_DIR"
