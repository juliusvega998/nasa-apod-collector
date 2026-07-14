# NASA APODs Retriever

## Prerequisites
* NASA API Key - sign up for a NASA Open API Key: https://api.nasa.gov/
* jq binaries - can be installed via apt/dnf/yum

## How To Run
### Environment Variable
The script will only run when the API key is properly set on the environment variable. This can be done in two ways:

Method One:
```bash
NASA_API_KEY="api key" ./get_apod.sh
```

Method Two:
Create a file containing the environment variable
```bash
export NASA_API_KEY="api key"
```
And then run the bash script
```bash
source [env filename]
./get_apod.sh
```

This can also work in cron. The example below will run daily at 12 midnight on the server timezone:
```cron
NASA_API_KEY="api key"
0 0 * * * /path/to/get_apod.sh
```

### Scripts
* `get_apod.sh` - retrieves the latest apod. Can be used to run in cron
* `get_old_apods.sh` - retrieves the old apods. Starts from START_DATE upto the apod a month after. Highly recommended to use only once a day to retrieve apods until fully caught up
