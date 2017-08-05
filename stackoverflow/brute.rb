require 'openssl'

def x(s1, s2)
  s1.bytes.zip(s2.bytes).map{ |c, d| (c.ord ^ d.ord).chr }.join
end

# this is the desired content for the first 16 bytes; the workflow
# i found best was to open a couple known-good PDFs in Hex Fiend
# and figure out which bits (sic) were wrong against:
# `> ruby brute.rb ; hexdump -C flag.halfdec.pdf| head -n20`

pt_header = "%PDF-1.3 \x0a\x31\x20\x30 ob"
raise 'bad length' unless 16 == pt_header.length
ct_file = File.open('flag.pdf.enc', 'r')

ct_header = ct_file.read(pt_header.length)

mask = x(pt_header, ct_header)
# pt_header.bytes.zip(ct_header.bytes).map{ |p, c| p.ord ^ c.ord }

p mask

pt_file = File.open('flag.halfdec.pdf', 'w')
ct_file.rewind

ctr = 0x00000000020

until ct_file.eof?
  block = ct_file.read(mask.length)
  pt_file.write x(block, mask)

  # ctr_s = [ctr].pack 'Q<'

  # block = ct_file.read(ctr_s.length)

  # pt_file.write x(block, ctr_s)

  # ctr += 1
end
