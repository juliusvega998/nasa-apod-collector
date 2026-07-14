#!/bin/bash
set -e

## This script will retrieve only the most recent apod

if [[ -z "$NASA_API_KEY" ]]; then
    echo "[ ERROR ] You will NEED an API KEY!! Sign up and grab one from nasa now! Aftwerwards, set it to env var NASA_API_KEY"
    exit 10
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "[ WARN ] OUTPUT_DIR not set! Please check!!"
    OUTPUT_DIR='apods'
fi

CURR_DATE="$(date -d 'yesterday' +'%Y-%m-%d')"

echo "> Retrieving image URL of APOD for date $CURR_DATE - $(date)"
RESPONSE="$(curl -sS "https://api.nasa.gov/planetary/apod?api_key=$NASA_API_KEY&start_date=$CURR_DATE&end_date=$CURR_DATE")"
echo "> NASA response: $RESPONSE"
if [[ "$(echo "$RESPONSE" | jq -r '.[0].media_type')" == 'image' ]]; then
    IMG_URL="$(echo "$RESPONSE" | jq -r '.[0].hdurl')"
    echo "> Found download URL: $IMG_URL"
    wget $IMG_URL -P "$OUTPUT_DIR"
    echo "Downloading Done! Sleeping for 2 minute..."
else
    echo "> Media type is not image! Skipping..."
fi
echo "> Will start downloading file..."
wget $IMG_URL -P "$OUTPUT_DIR/"
echo "Done!"
