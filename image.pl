#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use GD;

use lib ".";
use Pixel;

my $server = shift;
my $port = shift;
my $file = shift;
my $position = shift || "0:0";
my $forks = shift || 1;

die "no image given!" if !$file;
die "no ip:port given!" if !$server || !$port;

my $image = GD::Image->new($file);

my $width = $image->width;
my $height = $image->height;
my %colorHash;

for (my $x = 0; $x <= $width; $x++) {
	for (my $y = 0; $y <= $height; $y++) {
		my $index = $image->getPixel($x, $y);
		my ($r, $g, $b) = $image->rgb($index);
		my $color = Pixel::rgb2hex($r, $g, $b);
		$colorHash{$x}{$y} = $color;
	}
}
my ($pos_x, $pos_y) = $position =~ /^(\d+):(\d+)$/;

my $PP = Pixel->new($server,$port,$forks);

sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $socket = $self->{'socket'};

	for (my $x = 0; $x <= $width; $x++) {
		for (my $y = 0; $y <= $height; $y++) {
			my $color = $colorHash{$x}{$y};
			my $px = $x + $pos_x;
			my $py = $y + $pos_y;
	 		$socket->send("PX $px $py $color\n");
		}
	}

	sleep(1);

	return 1;
}
