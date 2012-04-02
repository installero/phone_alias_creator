#!/bin/bash
if [ "$4" == "" ]
then
  echo "Usage: $0 name short_number full_number group_id"
  exit 1
fi

NAME=$1
SHORT=$2
PHONE=$3
GROUP_ID=$4

UISCOM_PATH="http://universe.uiscom.ru"
PROFILE_PATH="$UISCOM_PATH/profile/phone_book"
CENTREX_PATH="$UISCOM_PATH/centrex/phone_book"

PARAMS="update=[{\"id\":\"\",\"name\":\"$NAME\",\"short_phone\":\"$SHORT\",\"group_id\":\"$GROUP_ID\"}]&remove="

curl --cookie cookie.txt -d $PARAMS "$PROFILE_PATH/update_contacts/" > index.html

curl --cookie cookie.txt "$PROFILE_PATH/get_contacts/?start=0&limit=9999&rel_id=$GROUP_ID&rnd=0.$RANDOM" > index.html

PHONE_ID=$(cat index.html | sed "s/.*{\"id\":\"\([0-9]*\)\",\"name\":\".*\",\"user_id\":\"\",\"short_phone\":\"$SHORT\"}.*/\1/g")

PARAMS="protocol_id=1&phone=$PHONE&contact_id=$PHONE_ID"

curl --cookie cookie.txt -d $PARAMS "$PROFILE_PATH/add_phone/" > index.html

MESSAGE=$(cat index.html | sed 's/.*"message":"\(.*\)".*/\1/g')
CODE=$(cat index.html | sed 's/.*"code":\([0-9]*\).*/\1/g')

if [ $CODE != "0" ]
then
  echo $MESSAGE
  exit $(($CODE))
fi

curl --cookie cookie.txt "$CENTREX_PATH/get_phones/?start=0&limit=9999&rel_id=0&rnd=0.$RANDOM" > index.html

PHONE_ID=$(cat index.html | sed "s/.*{\"id\":\"\",\"cp_id\":\"\([0-9]*\)\",\"p_id\":\".*\",\"c_id\":\".*\",\"fifth\":\".*\",\"short_phone\":\"$SHORT\",.*/\1/g")

PARAMS="is_global_record_conversation=True&phone_id=$PHONE_ID"

curl --cookie cookie.txt -d $PARAMS "$CENTREX_PATH/update_centrex_param/" > index.html

MESSAGE=$(cat index.html | sed 's/.*"message":"\(.*\)".*/\1/g')
CODE=$(cat index.html | sed 's/.*"code":\([0-9]*\).*/\1/g')

echo $MESSAGE
exit $(($CODE))
