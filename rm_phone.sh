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

PHONE_ID=$(cat index.html | sed "s/.*{\"id\":\"\([0-9]*\)\",\"name\":\"$NAME\",\"user_id\":\"\",\"short_phone\":\".*\"}.*/\1/g")

PARAMS="rel_id=$PHONE_ID&is_force=false"

curl --cookie cookie.txt -d $PARAMS "$PROFILE_PATH/remove/contact/" > index.html

MESSAGE=$(cat index.html | sed 's/.*"message":"\(.*\)".*/\1/g')
CODE=$(cat index.html | sed 's/.*"code":\([0-9]*\).*/\1/g')

echo $MESSAGE
exit $(($CODE))
