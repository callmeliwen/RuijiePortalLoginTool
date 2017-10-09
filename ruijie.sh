#!/bin/sh

if [ "$#" -lt "3" ]; then
  echo "Parameter must not be null!"
  echo "Usage: ./openwrt.sh interface username password"
  echo "interface can be \"chinamobile\", \"chinanet\" and \"chinaunicom\". If this parameter do not set as these value, it will use campus network as default interface."
  exit 1
fi

loginURL=`curl -s "http://139.199.182.194/jmuRuijie.html" | awk -F \' '{print $2}'`
#Get Ruijie auth URL, if user already online loginURL will be null

chinamobile="%40%D2%C6%B6%AF%BF%ED%B4%F8%BD%D3%C8%EB"
chinanet="%40%B5%E7%D0%C5%BF%ED%B4%F8%BD%D3%C8%EB"
chinaunicom="%40%C1%AA%CD%A8%BF%ED%B4%F8%BD%D3%C8%EB"

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
  echo "Use Campus Network as auto interface."
fi

if [ -z "$loginURL" ]; then
  echo "You are already online!"
  exit 0
fi

if [ -n "$loginURL" ]; then
  authResult=`curl -s -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.91 Safari/537.36" -e "$loginURL" -b "EPORTAL_USER_GROUP=null; EPORTAL_COOKIE_USERNAME=; EPORTAL_COOKIE_PASSWORD=; EPORTAL_AUTO_LAND=false; " -d "is_auto_land=false&usernameHidden=$2$interface&username_tip=Username&username=$2$interface&strTypeAu=&uuidQrCode=&authorMode=&pwd_tip=Password&pwd=$3" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" -H "Origin: http://210.34.130.210" -H "Content-Type: application/x-www-form-urlencoded" "${loginURL/index.jsp/userV2.do?method=login&param=true&}"`
  echo $authResult
fi
