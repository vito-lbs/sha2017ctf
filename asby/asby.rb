require 'expect'

IO.popen("wine asby.exe",
         "r+") do |asby|

  start = "flag{024baa8ac03ef"

  asby.expect "What is the flag? "
  asby.puts start + "\r"
  start.length.times do |n|
    got = asby.expect(/Checking char \d+:CORRECT!\r\n/, 1)
    p got
  end

  actual_flag = ''

  flag_chars = %w{0 1 2 3 4 5 6 7 8 9 a b c d e f}

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

      if asby.expect(/Checking char \d+:\w+\!\r\n/, 1).join =~ /CORRECT/
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

end
