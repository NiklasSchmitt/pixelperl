#!/usr/bin/perl

use strict;
use warnings;

use lib ".";
use Pixel;

my $server = shift;
my $port = shift;

die "no ip:port given!" if !$server || !$port;

my $start = shift || 50;
my $height = 30;

my $PP = Pixel->new($server,$port);

sub Pixel::loop_content {
	my $self = shift;
	my $max_x = $self->{'max_x'};
	my $socket = $self->{'socket'};
	$self->{'start'} = $start; # store original start of y

	foreach my $color (qw(e50000 ff8d00 ffee00 008121 004cff 760188)) {
		for (my $x = 0; $x <= $max_x; $x++) {
			for (my $y = $start; $y < ($start + $height); $y++) {
				$socket->send("PX $x $y $color\n");
			}
		}
		$start = $start + $height;
	}
	$start = $self->{'start'};

	# sleep(5);
	print STDERR ".";

	return 1;
}
