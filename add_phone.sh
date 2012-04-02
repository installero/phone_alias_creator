#!/bin/bash
if [ "$4" == "" ]
then echo "Usage: $0 name short_number full_number group_id"

HTTP_PATH='http://universe.uiscom.ru/profile/phone_book'

NAME=$1
SHORT=$2
PHONE=$3
GROUP_ID=$4

PARAMS="update=[{\"id\":\"\",\"name\":\"$NAME\",\"short_phone\":\"$SHORT\",\"group_id\":\"$GROUP_ID\"}]&remove="

curl --cookie cookie.txt -d $PARAMS "$HTTP_PATH/update_contacts/?" > index.html

curl --cookie cookie.txt "$HTTP_PATH/get_contacts/?start=0&limit=9999&rel_id=$GROUP_ID&rnd=0.$RANDOM" > index.html

PHONE_ID=$(cat index.html | sed 's/.*{"id":"\([0-9]*\)","name":".*","user_id":"","short_phone":"8002"}.*/\1/g')

PARAMS="protocol_id=1&phone=$PHONE&contact_id=$PHONE_ID"

curl --cookie cookie.txt -d $PARAMS "$HTTP_PATH/add_phone/" > index.html

MESSAGE=$(cat index.html | sed 's/.*"message":"\(.*\)".*/\1/g')
CODE=$(cat index.html | sed 's/.*"code":\([0-9]*\).*/\1/g')

echo $MESSAGE

exit $(($CODE))
