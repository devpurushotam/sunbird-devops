#!/bin/bash
# Title: Configuring Consumtion FAQs
# Description: Technical document on configuring consumption FAQs
# Note: Dependencies Install jq before running this script

sunbirdBaseURL="https://staging.ntp.net.in"
Bearer="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJjNDkyM2Y1Mjg1ZmY0NDdjYmYxMzgwNTQyM2ExZTk4YSJ9.hwQiG6OIFoIJ2O9ec6kau09ltJ-5xA5fWi6aM6NoLEU"
ssoUser="ntp-staging-new-admin"
ssoPassword="yw$9(G$R9_"
consumptionFaqsPublicUrl="https://staging.ntp.net.in/faq/consumption-faqs.html" # This value need to be taken from implementation team tomorrow
authToken=$(curl -s -X POST $sunbirdBaseURL/auth/realms/sunbird/protocol/openid-connect/token -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' -H 'postman-token: 15d3852b-de08-ea78-3342-bfaf5d4d4f09' --data "client_id=admin-cli&username=$ssoUser&password=$ssoPassword&grant_type=password" | jq -r '.access_token')
rootOrgIds=()

echo -e "The Auth Token is $authToken\n"
### Coming Soon Page Setting

for rootOrgId in ${rootOrgIds[@]};
do
	curl -X POST \
	  $sunbirdBaseURL/api/data/v1/system/settings/set \
	  -H "Authorization: Bearer $Bearer" \
	  -H 'Content-Type: application/json' \
	  -H "X-Authenticated-User-Token: $authToken" \
	  -d '{
	  "request": {
		"id": "contentComingSoonMsg",
		"field": "contentComingSoonMsg",
		"value": "[{\"rootOrgId\":\"'"$rootOrgId"'\",\"value\":\"Org specific coming soon message\",\"translations\":\"{\\\"en\\\":\\\"Coming soon message\\\"}\"},{\"rootOrgId\":\"'"$rootOrgId"'\",\"value\":\"Org specific coming soon message\",\"translations\":\"{\\\"en\\\":\\\"Coming soon message\\\"}\"}]"
	    }
	}' 
done
###

curl -X GET \
  $sunbirdBaseURL/api/data/v1/system/settings/get/contentComingSoonMsg \
  -H "Authorization: Bearer $Bearer" \
  -H 'Content-Type: application/json'

####
