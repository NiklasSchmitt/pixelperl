#!/bin/perl

use strict;
use warnings;
use Data::Dumper;
use IO::Socket::INET;

my $ip = shift;
my $port = shift;

my $client = IO::Socket::INET->new(
    # where to connect
    PeerAddr => $ip,
    PeerPort => $port,
) or die "failed to connect!";


my $size;
$client->send("SIZE\n");
$client->recv($size,1024);
my ($max_x,$max_y) = $size =~/^SIZE (\d+) (\d+)/;
print "== x: $max_x | y: $max_y == \n";


while ($client->connected()) {
	for (my $x = 0; $x <= $max_x; $x=($x+3)) {
		for (my $y = 0; $y <= $max_y; $y=($y+3)) {
			$client->send("PX $x $y 02f553\n");
		}
	}
	print STDERR ".";
#	sleep(5);
}

$client->close();
