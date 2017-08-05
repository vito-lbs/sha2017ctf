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
