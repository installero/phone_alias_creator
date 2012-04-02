#!/bin/bash
if [ "$2" == "" ]
then
  echo "Usage: $0 name group_id"
  exit 1
fi

NAME=$1
GROUP_ID=$2

PROFILE_PATH="http://universe.uiscom.ru/profile/phone_book"

curl --cookie cookie.txt "$PROFILE_PATH/get_contacts/?start=0&limit=999&rel_id=929&rnd=0.$RANDOM" > index.html

grep $NAME index.html > /dev/null

exit $?
