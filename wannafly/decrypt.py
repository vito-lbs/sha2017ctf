import random, string, sys, os, base64
from Crypto.Cipher import AES
import base64

mtime = int(sys.argv[1])
fname = sys.argv[2]

password = 'Hb8jnSKzaNQr5f7p'

mtime_start = 1497975278
mtime_end   = 1497975282

random.seed(mtime)

iv = ""
for i in range(0,16):
    iv += random.choice(string.letters + string.digits)


aes = AES.new(password, AES.MODE_CFB, iv)

data = base64.b64decode(open(fname, 'r').read())

open(fname + '.dec.png', 'w').write(aes.decrypt(data))
