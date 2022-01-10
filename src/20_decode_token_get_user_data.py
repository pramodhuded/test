# Copyright 2016-2021 Apple, Inc.
# All Rights Reserved.

import base64
import gzip
import json
import jwt
import requests

from auth_util import decrypt_auth_token

def get_user_data_from_auth_endpoint(decoded_token, service_title_to_user, \
    decrypted_token_endpoint):
    """Retrieve information for the newly authentication user from the authentication endpoint
    using the decrypted token."""

    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer %s" % decoded_token
        }

    response = requests.get(
        decrypted_token_endpoint,
        headers=headers,
        timeout=30  # <--- This should be longer than the 10 seconds used on other requests
    )
    try:
        jcontent = json.loads(response.content)
    except ValueError:
        print("SYSTEM: No JSON object could be found using decrypted token.")
        return None
    except:
        print("SYSTEM: Endpoint %s taking too long to repond" % decrypted_token_endpoint)
        return None

    return jcontent


def decrypt_token_and_call():

    # Enter the fields here from previous exercises
    encrypted_token = "<encrypted_token>"
    public_key_str = "<use-base64-from-previous-excercise>"
    private_key_str = "<use-base64-from-previous-excercise>"

    auth = decrypt_auth_token(
        encrypted_token,
        public_key_str,
        private_key_str
        )
    auth_response = get_user_data_from_auth_endpoint(
        auth,
        "LinkedIn",
        "https://api.linkedin.com/v2/me"
        )

    if auth_response is None:
        print("Empty response.")
    else:
        # print(pretty_print(auth_response))
        print(auth_response)
    print("Our work is done for this routine.")


if __name__ == "__main__":
    decrypt_token_and_call()

# Expected output:
# CryptographyDeprecationWarning: Support for unsafe construction of public numbers from encoded data will be removed in a future version. Please use EllipticCurvePublicKey.from_encoded_point
# CryptographyDeprecationWarning: int_from_bytes is deprecated, use int.from_bytes instead
# CryptographyDeprecationWarning: Support for unsafe construction of public numbers from encoded data will be removed in a future version. Please use EllipticCurvePublicKey.from_encoded_point
# token (decrypted): WL07<REDACTED>
# {'https://example.com/favorite_color': 'blue'}
# Our work is done for this routine.