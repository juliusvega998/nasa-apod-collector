#!/bin/bash
set -e

## This script will retrieve all apods starting from START_DATE to a month later.
## This should only be used once a day until caught up with the more recent ones.

if [[ -z "$NASA_API_KEY" ]]; then
    echo "[ ERROR ] You will NEED an API KEY!! Sign up and grab one from nasa now! Aftwerwards, set it to env var NASA_API_KEY"
    exit 10
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "[ WARN ] OUTPUT_DIR not set! Please check!!"
    OUTPUT_DIR='apods'
fi

START_DATE="07/10/2025"
END_DATE="$(date -d"$START_DATE + 1 month" +'%m/%d/%Y')"
CURR_DATE=$START_DATE
while [[ $(date -d "$CURR_DATE" +%s) -lt $(date -d "$END_DATE" +%s) && $(date -d "$CURR_DATE" +%s) -lt $(date +%s) ]]; do
    API_DATE=$(date -d "$CURR_DATE" +'%Y-%m-%d')
    echo "> Retrieving image URL of APOD for date $API_DATE - $(date)"
    RESPONSE="$(curl -sS "https://api.nasa.gov/planetary/apod?api_key=$NASA_API_KEY&start_date=$API_DATE&end_date=$API_DATE")"
    echo "> NASA response: $RESPONSE"
    if [[ "$(echo "$RESPONSE" | jq -r '.[0].media_type')" == 'image' ]]; then
        IMG_URL="$(echo "$RESPONSE" | jq -r '.[0].hdurl')"
        echo "> Found download URL: $IMG_URL"
        wget -q $IMG_URL -P "$OUTPUT_DIR"
        echo "Downloading Done! Sleeping for 2 minute..."
    else
        echo "> Media type is not image! Skipping..."
    fi
    sleep 120

    CURR_DATE=$(date -d "$CURR_DATE + 1 day" +'%m/%d/%Y')
done
