JSSuck
=======

JSSuck is encoder/decoder on top of jsfuck.
See [jsfuck.com][1] for more details.

```
Usage: jssuck [OPTION]... [FILE]...

JSSuck takes multiple files and both directions at once.
Just put the files that you want to do encode or decode.

Encoding:
  -1: Process jsfuck [DEFAULT]
  -2: Process uglified jsfuck.
Decoding:
  -p: Enable pretty print. This option is unactivated in default.
Output:
-s: Store the result in each files. Default is stdout.
```

## Installation

```sh
$ npm install jssuck
```

[1]: http://www.jsfuck.com