# vod kaonockers

the html for this challenge has a comment:

```html
    <!-- *Knock Knock* 88 156 983 1287 8743 5622 9123 -->
```

"port knocking" is a technique where you do *something* to a port (either udp
or tcp) before you're allowed to do something, like a secret knock to get
into a 1920s speakeasy through an unmarked door in a rainy alley in chicago

so let's give it a shot

```ruby
require 'socket'

host = 'vod.stillhackinganyway.nl'

ports = %w{88 156 983 1287 8743 5622 9123}

u = UDPSocket.new

$sox = ports.map do |p|
  begin
    u.send 'x', 0, host, p
  end
end
```

i ran this and lol it didn't do anything because i only send packets, and never
receive or actually make a connection, and the web page didn't change either

this is a common complaint with almost every ctf challenge is that they
tend to require some kind of "leap of faith" to go from unsolvable mystery to
solved; in this case i knew what to try next, but if i was less persistent or
didn't have even my limited amount of experience i'd be pretty stymied. ctfs
are hard to build and hard to play for these reasons and i don't have a great
answer beyond "hack all the things" and just play moar ctfs

that rant aside, i tried tcp next

```ruby
require 'socket'

host = 'vod.stillhackinganyway.nl'

ports = %w{88 156 983 1287 8743 5622 9123}

u = UDPSocket.new

$sox = ports.map do |p|
  begin
    s = TCPSocket.new host, p
  rescue => e
    p e # `p(value)` in ruby is basically `puts(value.inspect)`
    next
  end
end
```

this almost worked but 9123 didn't do anything and i just totally forgot to
add a `s.read` call; also note i never removed the line that creates the
`UDPSocket` because i forgot

finally, i just did something that i've done before when having problems with
tcp sockets in a ctf before: Just Call Netcat

```ruby
require 'socket'

host = 'vod.stillhackinganyway.nl'

ports = %w{88 156 983 1287 8743 5622 9123}

u = UDPSocket.new

$sox = ports.map do |p|
  begin
    s = TCPSocket.new host, p
  rescue => e
    p e
    next
  end

  exec "nc -v vod.stillhackinganyway.nl 9123"
end
```

it's noisy and unnecessary (adding a `s.read` after creating the `TCPSocket`
works today (aug. 10, 2017) but
that's not how i solved it during the game) but hey there's the flag:

```
> ruby knock.rb
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 88>
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 156>
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 983>
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 1287>
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 8743>
#<Errno::ECONNREFUSED: Connection refused - connect(2) for "vod.stillhackinganyway.nl" port 5622>
found 0 associations
found 1 connections:
     1:	flags=82<CONNECTED,PREFERRED>
    outif en0
    src 10.2.14.222 port 59876 # at the klm lounge at schiphol, heh
    dst 34.249.81.124 port 9123
    rank info not available
    TCP aux info available

Connection to vod.stillhackinganyway.nl port 9123 [tcp/*] succeeded!
flag{6283a3856ce4766d88c475668837184b}
```
