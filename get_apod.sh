#!/bin/bash
set -e

## This script will retrieve only the most recent apod

cd "$(dirname $0)"

if [[ -f 'nasa.env' && -z "$NASA_API_KEY" ]]; then
    echo "$(date) - Found file nasa.env in current directory. Using that instead."
    source nasa.env
fi

if [[ -z "$NASA_API_KEY" ]]; then
    echo "$(date) - [ ERROR ] You will NEED an API KEY!! Sign up and grab one from nasa now! Aftwerwards, set it to env var NASA_API_KEY"
    exit 10
fi

if [[ -z "$OUTPUT_DIR" ]]; then
    echo "$(date) - [ WARN ] OUTPUT_DIR not set! Defaulting to './apods'"
    OUTPUT_DIR='apods'
fi

CURR_DATE="$(date -d 'yesterday' +'%Y-%m-%d')"

echo "$(date) - Retrieving image URL of APOD for date $CURR_DATE - $(date)"
RESPONSE="$(curl -sS "https://api.nasa.gov/planetary/apod?api_key=$NASA_API_KEY&start_date=$CURR_DATE&end_date=$CURR_DATE")"
echo "$(date) - NASA response: $RESPONSE"
if [[ "$(echo "$RESPONSE" | jq -r '.[0].media_type')" == 'image' ]]; then
    IMG_URL="$(echo "$RESPONSE" | jq -r '.[0].hdurl')"
    echo "$(date) - Found download URL: $IMG_URL"
    echo "$(date) - Downloading..."
    curl -OSs $IMG_URL --output-dir "$OUTPUT_DIR"
else
    echo "$(date) - Media type is not image! Skipping..."
fi
echo "$(date) - Done!"
