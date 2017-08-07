i had a lot of fun with this one! it was my first time doing anything with a
windows binary in a ctf context, the first time i've had a completely
pleasant experience with wine (the not-emulator, not the beverage) (and that's
not a slag on wine or the wine devs, y'all have done an amazing job with an
incredibly ambitious and long-running project), and not the first time i've
had a problem caused by a regexp ("now you have two problems" etc.)

# getting asby to run

i don't own a windows license, but i do like docker, so i built up a
`Dockerfile` to run both wine and my scripting language of choice (ruby). the
tricky part was the extant, popular, and mildly outdated `wine` image on
docker hub, [suchja/wine](https://hub.docker.com/r/suchja/wine), wanted to run
everything as user `xclient`, which can't sudo or otherwise install stuff. i
had to read their `Dockerfile`s to figure out how to switch users i my
`Dockerfile` (it's the `USER` directive), and then i was ready to interact with
`asby.exe` through stdio and ruby's `IO.popen` and `expect` module

# interacting with stdio in ruby

`IO.popen` returns an `IO` object you can read and write to with normal `IO`
methods. i wanted to be a bit fuzzier since windows binaries have CRLF line
endings instead of just LF, so i required `expect`, which adds an `expect`
method to `IO` objects. it takes a regexp or a string, reads until it matches,
and returns stuff about what matched

```ruby
  start = "flag{"

  asby.expect "What is the flag? "
  asby.puts start + "\r"
  start.length.times do |n|
    got = asby.expect(/Checking char \d:CORRECT!\r\n/, 1)
    p got
  end
```

I hand-brute-forced the first five characters, `flag{`, and then had a little
loop to brute through the remaining flag.

``` ruby
  loop do
    asby.flush
    flag_chars.each do |candidate|
      print "\r#{candidate}"
      asby.expect "What is the flag? "
      asby.puts(start + actual_flag + candidate + "\r")
      print '.'
      (start.length + actual_flag.length).times do |n|
        asby.expect "Checking char #{n+1}:CORRECT!\r\n"
      end

      if asby.expect(/Checking char \d:\w+\!\r\n/, 1).join =~ /CORRECT/
        puts "\r"
        actual_flag += candidate
        puts start + actual_flag
        if '{' == candidate
          puts start + actual_flag
          exit
        end
        break # out of the candidate loop
      end
    end
  end
```

This worked to get the first five hexits of the flag, at which point I realized
the `flag_chars` collection could just be lowercase hexits instead of all the
alphanumerics.

Things started to stall out then, and I decided that it was probably a waste
to continue debugging, so I just hand-brute-forced the next few characters.
During this, I kept thinking "this character I'll start from `f` and go down to
`0`," and the character would be `0` or `3` or something, and then I'd start
from `0` and go up and get `e` or `f`, so I decided to fix my shit.

It turns out that the `\d` matcher in a regex only matches a single digit, and
the tenth and later characters have two digits in their count, so I had to add
the `+` qualifier to match one or more digits.

with that, it was 2ez 8)
