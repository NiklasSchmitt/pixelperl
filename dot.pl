#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use lib ".";
use Pixel;

my $server = shift;
my $port = shift;
my $color = shift || "02f553";
my $forks = shift || 1;

die "no ip:port given!" if !$server || !$port;

my $PP = Pixel->new($server,$port,$forks);

sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $socket = $self->{'socket'};


	for (my $x = 0; $x <= $max_x; $x=($x+5)) {
		for (my $y = 0; $y <= $max_y; $y=($y+5)) {
			$socket->send("PX $x $y $color\n");
		}
	}

	sleep(1);
	# print STDERR ".";

	return 1;
}
