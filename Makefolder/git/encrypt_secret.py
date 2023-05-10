#!/usr/local/bin/python3.11
import sys
import base64
from nacl import public, encoding

public_key_base64 = sys.argv[1]
message = sys.argv[2]

public_key = public.PublicKey(public_key_base64, encoding.Base64Encoder)

box = public.SealedBox(public_key)
encrypted = box.encrypt(message.encode())

print(base64.b64encode(encrypted).decode())