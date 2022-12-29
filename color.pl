#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use lib ".";
use Pixel;

print "--- color | clears the screen with given color ---\nparameters:\n --ip --port --fork\n --color=hex\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
	"color=s" => \$opts{color},
);

my $forks = $opts{forks} || 1;

my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

sub Pixel::loop_content {
	my $self = shift;
	my $max_y = $self->{'max_y'};
	my $max_x = $self->{'max_x'};
	my $client = $self->{'socket'};


	my $color = $opts{color} || "000000";

	for (my $y = 0; $y <= $max_y; $y++) {
		for (my $x = 0; $x <= $max_x; $x++) {
			$client->send("PX $x $y $color\n");
		}
	}

	sleep(10);
	return 1;
}
