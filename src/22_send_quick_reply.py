# Copyright 2016-2021 Apple, Inc.
# All Rights Reserved.

import requests
import uuid

from config import BIZ_ID, AMB_SERVER
from jwt_util import get_jwt_token

def send_quick_reply(destination_id):
    message_id = str(uuid.uuid4())
    request_id = str(uuid.uuid4())
    payload ={
	   "sourceId": BIZ_ID,
	   "destinationId": destination_id,
	   "v": 1,
	   "type":"interactive",
	   "id": message_id,
	   "interactiveData":{
		  "bid":"com.apple.messages.MSMessageExtensionBalloonPlugin:0000000000:com.apple.icloud.apps.messages.business.extension",
		  "data":{
			 "quick-reply":{
				"summaryText":"summary text 1",
				"items":[
				   {
					  "identifier":"1",
					  "title":"item1"
				   },
				   {
					  "identifier":"2",
					  "title":"item2"
				   },
				   {
					  "identifier":"3",
					  "title":"item3"
				   },
				   {
					  "identifier":"4",
					  "title":"item4"
				   }
				]
			 },
			 "version": "1.0",
			 "requestIdentifier": request_id
		  }
	   }
	}
    headers ={
	   "Content-Type":"application/json",
	   "Authorization":"Bearer %s" % get_jwt_token(),
	   "id": message_id,
	   "Source-Id": BIZ_ID,
	   "Destination-Id": destination_id,
	   "include-data-ref":"true"
	}
    r = requests.post("%s/message" % ,json=payload,headers=headers,timeout=10)
    print("Messages for Business server return code: %s" % r.status_code)

if __name__ == "__main__":
    destination_id = ""
    send_quick_reply(destination_id)



# Expected output:
# Messages for Business server return code: 200