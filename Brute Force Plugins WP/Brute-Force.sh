#!/bin/bash
WORDLIST="/home/kali/Desktop/wordlist.txt" # Ta wordlist avec URLs complètes
PROXY="socks5h://127.0.0.1:9050"
CONTROL_PORT=9051
# Changement d'IP via Tor
change_ip() {
    printf "\r[*] Changement d'IP via Tor... "
    echo -e 'AUTHENTICATE ""\nSIGNAL NEWNYM\nQUIT' | nc 127.0.0.1 "$CONTROL_PORT" > /dev/null
    sleep 4
    printf "OK\n"
}
TOTAL=$(wc -l < "$WORDLIST" | awk '{print $1}')
COUNT=0
printf "[*] Total URLs à tester : %d\n" "$TOTAL"
printf "[*] Progression : 0/%d (0%%)\n" "$TOTAL"
while IFS= read -r FULL_URL; do
    FULL_URL=$(echo "$FULL_URL" | sed 's/^[ \t]*//;s/[ \t]*$//')
    [[ -z "$FULL_URL" ]] && continue
    while : ; do
        # Commande curl en une seule ligne pour éviter les erreurs de continuation
        STATUS=$(curl -s -o /dev/null -w "%{http_code}" --proxy "$PROXY" --connect-timeout 10 --max-time 20 -I -L "$FULL_URL" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36")
        CURL_EXIT=$?
        if [[ $CURL_EXIT -eq 0 && "$STATUS" != "000" && -n "$STATUS" && "$STATUS" != "403" ]]; then
            ((COUNT++))
            PERCENT=$((COUNT * 100 / TOTAL))
            printf "\r[*] Progression : %d/%d (%d%%) | Testé : %s " "$COUNT" "$TOTAL" "$PERCENT" "$(basename "$FULL_URL")"
            if [[ "$STATUS" != "404" ]]; then
            	GREEN='\033[0;32m'
            	NC='\033[0m'

                echo -e "\n${GREEN}[+] TROUVÉ → $FULL_URL → HTTP $STATUS${NC}"
               
            
            fi
            break
        else
            echo -e "\n[!] Timeout/erreur sur $FULL_URL (code: $STATUS, exit: $CURL_EXIT) → changement IP"
            
            change_ip
        fi
    done
done < "$WORDLIST"
echo -e "\n[*] Fuzzing des plugins terminé. $COUNT/$TOTAL testés."
