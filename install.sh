#!/usr/bin/env bash

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

HyperLink='\e]8'


echo -e "${BBlue}Dobrý den, vítejte v instalátoru systému Gamajun. V následujících krocích bude potřeba vyplnit několik proměných. Pokud nevíte, co zde zadávat, nechte výchozí hodnotu.$Color_Off"
echo

# Setup hostname
defaultHostname=$(hostname --ip-address)
echo "Začneme konfigurací hostname. Ten bude použit pro přístup k serveru z internetu."
echo -e "${BRed}Varování:$Red Tento instalátor není určen k vývojovým učelům k provozu na lokální síti. Hostname musí být veřejná adresa, která je přístupná z internetu.$Color_Off"
echo "Pakliže máte nastavené DNS, zadejte doménu, pokud ne, zadejte veřejnou IP adresu serveru."
echo "Výchozí hodnota je $defaultHostname, která byla zjištěna automaticky."
read -r -p "❓ Zadejte hostname [$defaultHostname]: " hostname
hostname=${hostname:-$defaultHostname}

# Check if hostname is valid
ipv4_loopback_regex="^(127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|0\.0\.0\.0)$"
ipv6_loopback_regex="^(::1)$"
if [[ "$hostname" == "localhost" || \
      "$hostname" =~ $ipv4_loopback_regex || \
      "$hostname" =~ $ipv6_loopback_regex ]]; then

  echo -e "❌ ${BRed}Hostname '$hostname' vypadá jako lokální adresa, výsledek instalace nebude funkční!$Color_Off"
else
  echo "✅ Hostname '$hostname' vypadá v pořádku."
fi
echo

# Setup OAuth2

echo "⌛ Konfigurace OAuth2 proměných, bezestrachu můžete ponechat výchozí hodnoty."
read -r -p "❓ Zadejte client id [gamajun]: " clientId
clientId=${clientId:-gamajun}

defaultSecret=$(openssl rand -base64 32)
read -r -p "❓ Zadejte client secret [$defaultSecret]: " clientSecret
clientSecret=${clientSecret:-$defaultSecret}
echo

# Setup admin code
read -r -p "❓ Zadejte tajný kód, kterým se budou registrovat administrátoři [supersecret]: " adminCode
adminCode=${adminCode:-supersecret}
echo


# Check if all variables are correct
echo -e "${BWhite}Zkontrolujte nastavení:$Color_Off"
echo "🔍 Hostname: $hostname"
echo "🔍 Client id: $clientId"
echo "🔍 Client secret: $clientSecret"
echo "🔍 Admin code: $adminCode"
read -p "❓ Je vše v pořádku? [yY/nN]" -n 1 -r

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo

# Create server env file
echo "⌛ Vytvářím soubor gamajun-server/.env"
rm gamajun-server/.env >> /dev/null
{
echo "POSTGRES_HOST=jdbc:postgresql://gamajun-db/gamajun"
echo "POSTGRES_USER=gamajun"
echo "POSTGRES_PASSWORD=gamajun"
echo "ADMIN_CODE=$adminCode"
echo "OAUTH2_CLIENT_ID=$clientId"
echo "OAUTH2_CLIENT_SECRET=$clientSecret"
echo "CLIENT_URL=http://$hostname:3000"
} >> gamajun-server/.env
echo

echo "⌛ Vytvářím soubor gamajun-client/.env"
rm gamajun-client/.env >> /dev/null
{
echo "OAUTH2_CLIENT_ID=$clientId"
echo "OAUTH2_CLIENT_SECRET=$clientSecret"
echo "OAUTH2_PROVIDER_URL=http://$hostname:8080"
echo "NEXTAUTH_URL=http://$hostname:3000"
echo "NEXTAUTH_SECRET=$(openssl rand -base64 32)"
echo "NEXT_PUBLIC_GAMAJUN_API_URL=http://$hostname:8080"
} >> gamajun-client/.env
echo

echo "✅ Soubory .env byly úspěšně vytvořeny."

# Deploy!
echo "⌛ Čas na to zkompilovat aplikaci. To bude chvilku trvat, běžte si dát kafíčko! ☕🐳"
docker compose build
echo "✅ Aplikace byla úspěšně zkompilována."
echo "⌛ Nyní se aplikace spustí v pozadí. Pokud chcete aplikaci později zastavit, použijte příkaz docker compose down."
docker compose up -d
echo "✅ Aplikace byla úspěšně spuštěna."
echo
echo -e "🌐 Adresa klienta: http://$hostname:3000"
echo -e "🌐 Adresa serveru: http://$hostname:8080"

