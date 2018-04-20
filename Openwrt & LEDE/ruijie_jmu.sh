#!/bin/sh

if [ "$#" -lt "3" ]; then
  echo "Usage: ./ruijie_jmu.sh interface username password"
  echo "interface can be \"chinamobile\", \"chinanet\" and \"chinaunicom\". If this parameter do not set as these value, it will use campus network as default interface."
  echo "Example: ./ruijie_jmu.sh chinanet 201620000000 123456"
  exit 1
fi

loginPageURL=`curl -s "http://139.199.182.194/Ruijie.html" | awk -F \' '{print $2}'`
#Get Ruijie login page URL. If device already online, loginPageURL will be null. The jmuRuijie.html is a blank page.

chinamobile="%25E7%25A7%25BB%25E5%258A%25A8%25E5%25AE%25BD%25E5%25B8%25A6%25E6%258E%25A5%25E5%2585%25A5"
chinanet="%25E7%2594%25B5%25E4%25BF%25A1%25E5%25AE%25BD%25E5%25B8%25A6%25E6%258E%25A5%25E5%2585%25A5"
chinaunicom="%25E8%2581%2594%25E9%2580%259A%25E5%25AE%25BD%25E5%25B8%25A6%25E6%258E%25A5%25E5%2585%25A5"
campus="%25E6%2595%2599%25E8%2582%25B2%25E7%25BD%2591%25E6%258E%25A5%25E5%2585%25A5"

interface=""

if [ "$1" = "chinamobile" ]; then
  echo "Use ChinaMobile as auth interface."
  interface="$chinamobile"
fi

if [ "$1" = "chinanet" ]; then
  echo "Use ChinaNet as auth interface."
  interface="$chinanet"
fi

if [ "$1" = "chinaunicom" ]; then
  echo "Use ChinaUnicom as auth interface."
  interface="$chinaunicom"
fi

if [ -z "$interface" ]; then
  echo "Use Campus Network as auth interface."
  interface="$campus"
fi

#Exit when already online
if [ -z "$loginPageURL" ]; then
  echo "You are already online!"
  exit 0
fi

#Structure loginURL
loginURL=`echo $loginPageURL | awk -F \? '{print $1}'`
loginURL="${loginURL/index.jsp/InterFace.do?method=login}"

#Structure quertString
queryString=`echo $loginPageURL | awk -F \? '{print $2}'`
queryString="${queryString//&/%2526}"
queryString="${queryString//=/%253D}"

#Login and output the result
if [ -n "$loginURL" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "$loginPageURL" -b "EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_COOKIE_SERVER=; EPORTAL_COOKIE_SERVER_NAME=; EPORTAL_AUTO_LAND=; EPORTAL_USER_GROUP=%E5%AD%A6%E7%94%9F%E5%8C%85%E6%9C%88; EPORTAL_COOKIE_OPERATORPWD=;" -d "userId=$2&password=$3&service=$interface&queryString=$queryString&operatorPwd=&operatorUserId=&validcode=&passwordEncrypt=false" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" "$loginURL"`
  echo $authResult
fi
