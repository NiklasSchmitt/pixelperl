#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use lib ".";
use Pixel;

print "--- clear | clears the screen with a random color---\nparameters:\n --ip --port --fork\n --position\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
);

my $forks = $opts{forks} || 1;

my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $client = $self->{'socket'};

	my $dice = int(rand(40)); # top to bottom?
	my $cr = int(rand(255));
	my $cg = int(rand(255));
	my $cb = int(rand(255));
	my $color = Pixel::rgb2hex($cr,$cg,$cb);

	if ($dice >= 0 && $dice <=10) {
		# top to bottom
		for (my $y = 0; $y <= $max_y; $y++) {
			for (my $x = 0; $x <= $max_x; $x++) {
				$client->send("PX $x $y $color\n");
			}
		}
	} elsif ($dice >= 10 && $dice <= 20) {
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

	sleep(int(rand(15)));
	#print STDERR ".";

	return 1;
}
