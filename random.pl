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

	my $cr = int(rand(255));
	my $cg = int(rand(255));
	my $cb = int(rand(255));
	my $color = rgb2hex($cr,$cg,$cb);

	my $x_or_y = int(rand(10));

	my $max;
	if ($x_or_y >= 5) {
		# x has won!
		my $height = int(rand($max_x));
		for (my $y = 0; $y <= $max_y; $y++) {
			$client->send("PX $height $y $color\n");
		}
	} else {
		# y has won!
		my $height = int(rand($max_y));
		for (my $x = 0; $x <= $max_x; $x++) {
			$client->send("PX $x $height $color\n");
		}
	}
	print STDERR ".";
}

$client->close();

sub rgb2hex {
    my ($r, $g, $b,) = @_;

    return sprintf("%02lx%02lx%02lx", $r, $g, $b);
}
