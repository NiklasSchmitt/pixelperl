#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use lib ".";
use Pixel;

print "--- color jumper | grid with two colors ---\nparameters:\n --ip --port --fork\n --color1=hex --color2=hex\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
	"color1=s" => \$opts{color1},
	"color2=s" => \$opts{color2},
);


my $color1 = $opts{color1} || "000000";
my $color2 = $opts{color2} || "025e1b";

my $switch = 1;
my $mod = 30;

my $mod_x = 1;
my $mod_y = 1;

my $forks = $opts{forks} || 1;
my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

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
			my $result_x = $x % $mod;
			my $result_y = $y % $mod;
# print "mod: $mod_x $mod_y\n";
			if ($result_y == 0 || $result_x == 0) {
				if ( ($x >= ($result_x * $mod_x) && $x <= ($result_x * $mod_x) ) && ($y >= ($result_y * $mod_y) && $y <= ($result_y * $mod_y) ) ) {
					$socket->send("PX $x $y $tmp2\n");

				} else {
					$socket->send("PX $x $y $tmp1\n");
				}
			} else {


				if ( ($x >= ($result_x * $mod_x) && $x <= ($result_x * $mod_x) ) && ($y >= ($result_y * $mod_y) && $y <= ($result_y * $mod_y) ) ) {
					$socket->send("PX $x $y $tmp1\n");

				} else {
					$socket->send("PX $x $y $tmp2\n");
				}




#				$socket->send("PX $x $y $tmp2\n");
			}
		}
		$mod_y++;
	}
	$mod_x++;

	sleep(int(rand(20)));

	if ($switch == 1) {
		$switch = 0;
	} else {
		$switch = 1;
	}

	return 1;
}
