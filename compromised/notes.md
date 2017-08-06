use csysdig to open up the pcap, wireshart can't make sense of it

pid 1625 grabs /tmp/[crypto] from an scp remote, which runs as pid 1660

PID 1660 reads a bunch of files, writes /tmp/challenge.py

/tmp/challenge.py runs as pids 1697 and 1730

challenge.py arg:
cnKlXI1pPEbuc1Av3eh9vxEpIzUCvQsQLKxKGrlpa8PvdkhfU5yyt9pJw43X9Mqe

you can see really detailed syscall hits with sysdig, including args
