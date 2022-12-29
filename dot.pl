#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Data::Dumper;
use lib ".";
use Pixel;

print "--- dots ---\nparameters:\n --ip --port --fork\n --color=hex\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"color=s" => \$opts{color},
);

my $color = $opts{color} || "02f553";
my $forks = $opts{forks} || 1;

my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

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
