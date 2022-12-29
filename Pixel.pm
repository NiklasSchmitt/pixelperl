#!/usr/bin/perl

package Pixel;

use strict;
use warnings;
use Data::Dumper;
use IO::Socket::INET;

use YAML qw(LoadFile);

my $conf = ".local.conf";
my $ip_conf;
my $port_conf;

if (-e $conf) {
	my $data = LoadFile($conf);

	$ip_conf = $data->{ip};
	$port_conf = $data->{port};
}

sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;

    $self->{'ip'} = shift;
    $self->{'port'} = shift;
	my $ip = ($self->{'ip'} ? $self->{'ip'} : $ip_conf);
	my $port = ($self->{'port'} ? $self->{'port'} : $port_conf);
	
	$self->{'ip'} = $ip;
	$self->{'port'} = $port;

	die "no ip:port given!" if !$self->{'ip'} || !$self->{'port'};

    $self->{'forks'} = shift || 0;
    $self->{'parent'} = $$;
	my @forks;

	if ($self->{'forks'} > 1) {
		for (my $i = 0; $i <= ($self->{'forks'} - 1); $i++) {
			push @forks, fork() if $$ eq $self->{'parent'};
		}
	}
	print STDERR "$$ - Connecting to $self->{'ip'}:$self->{'port'}\n";

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
	print STDERR "$$ - Connected. Size: x=$max_x | y=$max_y\n----------\n";
	
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