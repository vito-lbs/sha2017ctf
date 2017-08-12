# compromised

> We think our *system* got compromised, our hosting company uses some strange
> logtool. Are you able to *dig* into the logfile and find out if we are
> compromised?

This challenge was a pcap file that was full of system calls and other process
events, not network traffic. Looking at the italicized text in the description,
it refers to "system dig," which I took to refer to `sysdig`, which I'd
researched for a few minutes regarding some DEF CON CTF stuff a month or so
prior.

As is my wont, I grabbed the [`sysdig/sysdig`](https://hub.docker.com/r/sysdig/sysdig/)
docker, and found out I cloud load the `pcap` right in to the `csysdig` tool.

From there, I looked for suspicious stuff, and found out `csysdig` has a
way to aggregate files accessed. Sorting by `bytes out`, I noticed that both
`/tmp/challenge.py` and `/tmp/[crypto]` get written.  `/tmp/challenge.py` even
got written by `/tmp/[crypto]` which is mad sketchy.

Just tracing down, I figured out that pid 1660 is the `/tmp/[crypto]` process
that run. Using the "Dig" feature in `csysdig` (hit F6), I found it opening
`challenge.py` as `fd=5`, and a few syscalls later, the content that was
written to the file.

```python
from Crypto.Cipher import AES
import base64
import sys
obj = AES.new('n0t_just_t00ling', AES.MODE_CBC, '7215f7c61c2edd24')
ciphertext = sys.argv[1]
message = obj.decrypt(base64.b64decode(ciphertext))
```

`challenge.py` expects a ciphertext as an argument, but we can almost certainly
find that lying around.

Just doing a simple CTRL-F search for `challenge.py` in the `csysdig` process
list pulls it right up, as PID 1730:

```
python /tmp/challenge.py cnKlXI1pPEbuc1Av3eh9vxEpIzUCvQsQLKxKGrlpa8PvdkhfU5yyt9pJw43X9Mqe
```

Plugging that into `challenge.py`, and making `challenge.py` print out the
message, we find the flag:

```
> python -i challenge.py
>>> message
'Congrats! flag{1da3207f50d82e95c6c0eb803cdc5daf}'
```
