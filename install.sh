#!/usr/bin/env bash

echo Dobrý den, vítejte v instalátoru systému Gamajun. V následujících krocích bude potřeba vyplnit několik proměných. Pokud nevíte, co zde zadávat, nechte výchozí hodnotu.
echo

defaultHostname=$(hostname --ip-address)
echo "Začneme konfigurací hostname. Ten bude použit pro přístup k serveru z internetu."
echo "Pakliže máte nastavenou DNS doménu, můžete ji zde zadat. Pokud ne, zadejte IP adresu serveru."
echo "Výchozí hodnota je $defaultHostname, která byla zjištěna automaticky."
read -r -p "Zadejte hostname [$defaultHostname]: " hostname
hostname=${hostname:-$defaultHostname}

echo
echo "Konfigurace OAuth2 proměných, bezestrachu můžete ponechat výchozí hodnoty."

read -r -p "Zadejte client id [gamajun]: " clientId
clientId=${clientId:-gamajun}

defaultSecret=$(openssl rand -base64 32)
read -r -p "Zadejte client secret [$defaultSecret]: " clientSecret
clientSecret=${clientSecret:-$defaultSecret}

echo
read -r -p "Zadejte tajný kód, kterým se budou registrovat administrátoři [supersecret]: " adminCode
adminCode=${adminCode:-supersecret}

# Create server env file
echo "Vytvářím soubor gamajun-server/.env"
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

echo "Vytvářím soubor gamajun-client/.env"
rm gamajun-client/.env >> /dev/null
{
echo "OAUTH2_CLIENT_ID=$clientId"
echo "OAUTH2_CLIENT_SECRET=$clientSecret"
echo "OAUTH2_PROVIDER_URL=http://$hostname:8080"
echo "NEXTAUTH_URL=http://$hostname:3000"
echo "NEXTAUTH_SECRET=$(openssl rand -base64 32)"
echo "NEXT_PUBLIC_GAMAJUN_API_URL=http://$hostname:8080"
} >> gamajun-client/.env

echo "Čas na to rozjed docker kontejnery. To může chvíli trvat. 🐳⌛"
docker-compose build
docker-compose up