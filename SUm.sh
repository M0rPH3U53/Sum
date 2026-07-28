#!/bin/bash

# Banniere
cat <<"EOF"
                                      
   ▄████████ ███    █▄    ▄▄▄▄███▄▄▄▄   
  ███    ███ ███    ███ ▄██▀▀▀███▀▀▀██▄ 
  ███    █▀  ███    ███ ███   ███   ███ 
  ███        ███    ███ ███   ███   ███ 
▀███████████ ███    ███ ███   ███   ███ 
         ███ ███    ███ ███   ███   ███ 
   ▄█    ███ ███    ███ ███   ███   ███ 
 ▄████████▀  ████████▀   ▀█   ███   █▀  
                                        

by M0rPH3U53
      
EOF

# Couleur ASSCI
BLEU='\033[34m'
ROUGE='\033[0;31m'
VERT='\033[0;32m'
GRIS='\033[0;90m'
RESET='\033[0m'
BLANC='\033[1;37m'
JAUNE='\033[0;33m'

# Cree le dossier pour fichiers SNMP
mkdir -p SUm

# Recupere adresse réseau + CIDR
IP=$(ip route | grep -E '^[0-9]' | awk '{print $1}')

echo " "
echo -e "${VERT}[+]${RESET} ${BLANC}Réseau disponible${RESET} "
echo " "
echo "${IP}"
echo " "

# Interface réseau
echo -ne "${BLEU}[i]${RESET} ${BLANC}Network:${RESET} "
read network

# Découverte réseau d'appareil SNMP,UPnP,mDNS
echo " "
echo -ne "🔍 ${BLANC}Scan SNMP,UPnP,mDNS${RESET}..."
hotes=$(nmap -sU -p 1900,5353,161 --open ${network} -oG - | grep "/open" | awk '{print $2}')
echo -e "${JAUNE}100%${RESET}"

# Verifie si la variable est vide
if [ -z "${hotes}" ]; then
    echo "❌ Aucun appareil SNMP,UPnP,mDNS"
    exit 1
fi

# Chemin du fichier
dir=$(pwd)

echo " "
echo -e "🤖 ${BLANC}Hotes SUm${RESET}"
echo " "

# Recupere les info SNMP,UPnP,mDNS & créé un rapport
for hote in ${hotes}; do
   	echo "${VERT}[+]${RESET} ${hote} --> ${hote}-udp.html"
   	nmap -A -sU -p 1900,5353,161 -v -oX ${dir}/SUm/${hote}-udp.xml ${hote} > /dev/null 2>&1
   	xsltproc ${dir}/SUm/${hote}-udp.xml > ${dir}/SUm/${hote}-udp.html
done

echo " "
echo -e "📋 Rapports --> "${dir}"/SUm/"
