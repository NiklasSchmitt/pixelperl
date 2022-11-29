#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Pixel;

my $server = shift;
my $port = shift;

die "no ip:port given!" if !$server || !$port;

my $PP = Pixel->new($server,$port);

sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $socket = $self->{'socket'};

	my $dice = int(rand(40)); # top to bottom?
	my $cr = int(rand(255));
	my $cg = int(rand(255));
	my $cb = int(rand(255));
	my $color = Pixel::rgb2hex($cr,$cg,$cb);

	my $x_or_y = int(rand(10));

	if ($x_or_y >= 5) {
		# x has won!
		my $height = int(rand($max_x));
		for (my $y = 0; $y <= $max_y; $y++) {
			$socket->send("PX $height $y $color\n");
		}
	} else {
		# y has won!
		my $height = int(rand($max_y));
		for (my $x = 0; $x <= $max_x; $x++) {
			$socket->send("PX $x $height $color\n");
		}
	}

	# sleep(5);
	print STDERR ".";

	return 1;
}
