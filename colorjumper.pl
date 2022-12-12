#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use lib ".";
use Pixel;

my $server = shift;
my $port = shift;
my $color1 = shift || "000000";
my $color2 = shift || "5b8a21";
my $forks = shift || 1;

my $switch = 1;
my $mod = 30;

my $mod_x = 1;
my $mod_y = 1;

die "no ip:port given!" if !$server || !$port;

my $PP = Pixel->new($server,$port,$forks);


sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $socket = $self->{'socket'};

	my $tmp1;
	my $tmp2;
	if ($switch == 1) {
		$tmp1 = $color1;
		$tmp2 = $color2;
	} else {
		$tmp1 = $color2;
		$tmp2 = $color1;
	}

	for (my $x = 0; $x <= $max_x; $x++) {
		for (my $y = 0; $y < $max_y; $y++) {
			if ($y % $mod == 0 || $x % $mod == 0) {
				$socket->send("PX $x $y $tmp1\n");
			} else {
				$socket->send("PX $x $y $tmp2\n");
			}
		}
		$mod_y++;
	}
	$mod_x++;

	sleep(2);
	if ($switch == 1) {
		$switch = 0;
	} else {
		$switch = 1;
	}

	return 1;
}
