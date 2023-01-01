#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use GD;
use Getopt::Long;
use lib ".";
use Pixel;

print "--- images ---\nparameters:\n --ip --port --fork\n --img=/full/path --position=x:y\n----------\n";


my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
	"file=s" => \$opts{file},
	"img=s" => \$opts{file},
	"position=s" => \$opts{position},
);

my $position = $opts{position} || "0:0";
die "no --img given!" if !$opts{file};

my $image = GD::Image->new($opts{file});
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
my ($pos_x, $pos_y) = $position =~ /^(\-?\d+):(\-?\d+)$/;

my $forks = $opts{forks} || 1;
my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

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
