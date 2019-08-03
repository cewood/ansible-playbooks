#!/usr/bin/env bash

set -x

# Define our main variables
EPISODE_NAME_FINAL=${1}
EPISODE_NAME_ORIG=${2}
EPISODE_NAME_RELATIVE=${EPISODE_NAME_FINAL%/*}
EPISODE_NAME=$(basename "${EPISODE_NAME_ORIG%/*}")  # Use EPISODE_NAME_ORIG because it hasn't been lowercased, which EPISODE_NAME_ORIG is sometimes
EPISODE_PATH_RELATIVE=${EPISODE_NAME_RELATIVE%/*}
TRANSMISSION_HOST=http://192.168.88.2:9091/transmission/rpc

# Obtain a valid session id to send in requests
SESSION_ID=$(curl --silent -I ${TRANSMISSION_HOST} | grep -Fi X-Transmission-Session-Id | sed 's/\r//')

# Lookup the ID of the torrent we want to manipulate
TORRENT_ID=$(curl --silent --header "${SESSION_ID}" -d '{
   "arguments": {
      "fields": [ "id", "name", "downloadDir" ]
   },
   "method": "torrent-get"
}' ${TRANSMISSION_HOST} | jq ".arguments.torrents[] | select(.name == \"${EPISODE_NAME}\") | .id")

# Let's update that torrent
curl --silent --header "${SESSION_ID}" -d "{
   \"arguments\": {
      \"ids\": ${TORRENT_ID},
      \"location\": \"${EPISODE_PATH_RELATIVE}\",
      \"move\": true
   },
   \"method\": \"torrent-set-location\"
}" ${TRANSMISSION_HOST}
