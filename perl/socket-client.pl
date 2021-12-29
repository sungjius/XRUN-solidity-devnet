#! /usr/bin/perl -w
# client1.pl - a simple client
#----------------

use strict;
use Socket;

# 연결할 호스트 정보를 설정한다. 
my $host = shift || 'localhost';
my $port = shift || 7890;
my $proto = getprotobyname('tcp');

my $iaddr = inet_aton($host);
my $paddr = sockaddr_in($port, $iaddr);

# 소켓을 생성하고 연결한다.
socket(SOCKET, PF_INET, SOCK_STREAM, $proto)
	or die "socket: $!";
connect(SOCKET, $paddr) or die "connect: $!";

my $line;
while ($line = <SOCKET>)
{
	print $line;
}
close SOCKET or die "close: $!"; 
