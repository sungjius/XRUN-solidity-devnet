#! /usr/bin/perl -w
# server0.pl
#--------------------

use strict;
use Socket;

# use port 7890 as default
my $port = shift || 7890;
my $proto = getprotobyname('tcp');

# reusable socket(:12)을 생성한다.
socket(SERVER, PF_INET, SOCK_STREAM, $proto) or die "socket: $!";
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "setsock: $!";

# grab a port on this machine
my $paddr = sockaddr_in($port, INADDR_ANY);

# port(:12)를 bind() 한다. 
bind(SERVER, $paddr) or die "bind: $!";
listen(SERVER, SOMAXCONN) or die "listen: $!";
print "SERVER started on port $port ";

# 연결을 받아들인다. 
my $client_addr;
while ($client_addr = accept(CLIENT, SERVER))
{
	# 연결된 호스트의 정보를 얻어낸다. 
	my ($client_port, $client_ip) = sockaddr_in($client_addr);
	my $client_ipnum = inet_ntoa($client_ip);
	my $client_host = gethostbyaddr($client_ip, AF_INET);

	# 연결된 호스트의 정보를 출력한다. 
	print "got a connection from: $client_host","[$client_ipnum] ";

	# 연결된 호스트에 메시지를 전송한다. 
	print CLIENT "Smile from the server";
	print CLIENT "Test Socket"; 
	close CLIENT;
} 
