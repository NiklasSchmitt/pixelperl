#!/bin/perl

use strict;
use warnings;
use Data::Dumper;
use IO::Socket::INET;

use Image::PNG::Libpng ':all';

my $ip = shift;
my $port = shift;

my $image = shift;

my $client = IO::Socket::INET->new(
    # where to connect
    PeerAddr => $ip,
    PeerPort => $port,
) or die "failed to connect!";

my $size;
$client->send("SIZE\n");
$client->recv($size,1024);
my ($max_x,$max_y) = $size =~/^SIZE (\d+) (\d+)/;
print "pixelperle.pl == x: $max_x | y: $max_y == \n";

use GD;

my $myImage = GD::Image->newFromPng('/home/niklas/Bilder/bandwidt.png');
print Dumper($myImage);

    # my $png = create_read_struct ();
    # open my $file, '<:raw', '/home/niklas/Bilder/bandwidt.png' or die $!;
    # $png->init_io ($file);
    # $png->read_png ();
    # close $file;
    # # Get all valid chunks
    # my $valid = $png->get_valid ();
    # my @valid_chunks = sort grep {$valid->{$_}} keys %$valid;
    # print "Valid chunks are ", join (", ", @valid_chunks), "\n";
    # # Print image information
    # my $header = $png->get_IHDR ();
    # for my $k (keys %$header) {
    #     print "$k: $header->{$k}\n";
    # }

# sub send_more_pride {

# 	for (my $x = 0; $x <= $max_x; $x++) {
# 		# red
# 		for (my $y = 75; $y < 100; $y++) {
# 			$client->send("PX $x $y e50000\n");
# 		}
# 		# orange
# 		for (my $y = 100; $y < 125; $y++) {
# 			$client->send("PX $x $y ff8d00\n");
# 		}
# 		# yellow
# 		for (my $y = 125; $y < 150; $y++) {
# 			$client->send("PX $x $y ffee00\n");
# 		}
# 		# green
# 		for (my $y = 150; $y < 175; $y++) {
# 			$client->send("PX $x $y 008121\n");
# 		}
# 		# blue
# 		for (my $y = 175; $y < 200; $y++) {
# 			$client->send("PX $x $y 004cff\n");
# 		}
# 		# purple
# 		for (my $y = 200; $y < 225; $y++) {
# 			$client->send("PX $x $y 760188\n");
# 		}
# 	}

# return 1;

# }

# while ($client->connected()) {
# 	send_more_pride(550);
# 	print STDERR ".";
# #	sleep(5);
# }

$client->close();
