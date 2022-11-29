#!/usr/bin/perl

package Pixel;

use strict;
use warnings;
use Data::Dumper;
use IO::Socket::INET;

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;

    $self->{'ip'} = shift;
    $self->{'port'} = shift;

	print STDERR "Connecting to $self->{'ip'}:$self->{'port'}\n";

	my $socket = IO::Socket::INET->new(
	    # where to connect
	    PeerAddr => $self->{'ip'},
	    PeerPort => $self->{'port'},
	    Timeout => 10,
	) or die "failed to connect to $self->{'ip'}:$self->{'port'} !";

	my $size;
	$socket->send("SIZE\n");
	$socket->recv($size,1024);
	my ($max_x,$max_y) = $size =~/^SIZE (\d+) (\d+)/;
	print STDERR "Connected. Size: x=$max_x | y=$max_y\n----------\n";
	
	$self->{'max_x'} = $max_x;
	$self->{'max_y'} = $max_y;
	$self->{'socket'} = $socket;

	while ( $socket->connected() ) {
		loop_content($self);
	}

	$socket->close();

	return $self;
}

# overwrite
sub loop_content {
	my ($self) = @_;

	print STDERR "overwrite me!";

	return;
}

sub rgb2hex {
    my ($r, $g, $b,) = @_;

    return sprintf("%02lx%02lx%02lx", $r, $g, $b);
}

1;