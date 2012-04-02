curl -d "login=$1&password=$2&redirect_to" http://universe.uiscom.ru/auth/login/ --cookie-jar cookie.txt --dump-header header.txt > index.html
