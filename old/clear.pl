#!/bin/perl

use strict;
use warnings;
use Data::Dumper;
use IO::Socket::INET;

my $ip = shift;
my $port = shift;

my $color = shift;

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

	my $dice = int(rand(40)); # top to bottom?
	my $cr = int(rand(255));
	my $cg = int(rand(255));
	my $cb = int(rand(255));
	$color = rgb2hex($cr,$cg,$cb);

	if ($dice >= 0 && $dice <=10) {
		# top to bottom
		for (my $y = 0; $y <= $max_y; $y++) {
			for (my $x = 0; $x <= $max_x; $x++) {
				$client->send("PX $x $y $color\n");
			}
		}
	} elsif($dice >= 10 && $dice <= 20) {
		# bottom to top
		for (my $y = $max_y; $y > 0; $y--) {
			for (my $x = $max_x; $x > 0; $x--) {
				$client->send("PX $x $y $color\n");
			}
		}
	} elsif ($dice >= 20 && $dice <= 30) {
		# right to left
		for (my $x = $max_x; $x > 0; $x--) {
			for (my $y = 0; $y <= $max_y; $y++) {
				$client->send("PX $x $y $color\n");
			}
		}
	} elsif ($dice >= 30 && $dice <= 40) {
		# left to right
		for (my $x = 0; $x <= $max_x; $x++) {
			for (my $y = $max_y; $y > 0; $y--) {
				$client->send("PX $x $y $color\n");
			}
		}
	}
	# sleep(5);
	print STDERR ".";
}

$client->close();

sub rgb2hex {
    my ($r, $g, $b,) = @_;

    return sprintf("%02lx%02lx%02lx", $r, $g, $b);
}