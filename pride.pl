#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use lib ".";
use Pixel;

print "--- pride ---\nparameters:\n --ip --port --fork\n --position=y\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
	"position=s" => \$opts{position},
);

my $start = $opts{position} || 50;
my $height = 30;

my $forks = $opts{forks} || 1;
my $PP = Pixel->new($opts{server}, $opts{port}, $forks);


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

	sleep(2.5);
	# print STDERR ".";

	return 1;
}
