#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use Getopt::Long;
use lib ".";
use Pixel;
use GD;
use GD::Text;

print "--- text | writes a text ---\nparameters:\n --ip --port --fork\n --position=x:y --text=Text --color=hex --bgcolor=hex\n----------\n";

my %opts;

GetOptions(
	"server=s" => \$opts{server},
	"ip=s" => \$opts{server},
	"port=i" => \$opts{port},
	"fork=i" => \$opts{forks},
	"forks=i" => \$opts{forks},
	"position=s" => \$opts{position},
	"text=s" => \$opts{text},
	"color=s" => \$opts{color},
	"bgcolor=s" => \$opts{bgcolor},
);

my $position = $opts{position} || "0:0";
my $bgc = $opts{bgcolor} || "000000";
my $tc = $opts{color} || "ffffff";
my $text = $opts{text};

my $image_length = (16 * length($text));
my $text_img = GD::Image->new($image_length,30);

# $text_img->alphaBlending(1);
# $text_img->saveAlpha(1);
# my $black11 = $text_img->colorAllocate(0,0,0);
# $text_img->transparent($text_img->colorAllocateAlpha(0,0,0,127));
# $text_img->interlaced('true');
# my $white = ;
# my $white = $text_img->colorAllocate(255,255,255);


my $font = "/usr/share/fonts/truetype/freefont/FreeMonoBold.ttf";

# my $background_color = $text_img->colorAllocate(0,0,0);
my @background_color = Pixel::hex2rgb($bgc);
$text_img->colorAllocate($background_color[0],$background_color[1],$background_color[2]);
my @tca = Pixel::hex2rgb($tc);
my $color = $text_img->colorAllocate($tca[0],$tca[1],$tca[2]);

# fgcolor, fontname, ptsize, angle, x, y, string
$text_img->stringFT($color, $font, 20, 0, 2, 25, $text);

my $png = $text_img->png;
# print Dumper($png);



# my $image = GD::Image->new($png);
my $width = $text_img->width;
my $height = $text_img->height;
my %colorHash;
for (my $x = 0; $x <= $width; $x++) {
	for (my $y = 0; $y <= $height; $y++) {
		my $index = $text_img->getPixel($x, $y);
		my ($r, $g, $b) = $text_img->rgb($index);
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



# print Dumper(%colorHash);
# my ($pos_x, $pos_y) = $position =~ /^(\-?\d+):(\-?\d+)$/;

# my $forks = $opts{forks} || 1;
# my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

# sub Pixel::loop_content {
# 	my $self = shift;
# 	my $max_y = $self->{'max_y'};
# 	my $max_x = $self->{'max_x'};
# 	my $socket = $self->{'socket'};

# 	for (my $x = 0; $x <= $width; $x++) {
# 		for (my $y = 0; $y <= $height; $y++) {
# 			my $color = $colorHash{$x}{$y};
# 			my $px = $x + $pos_x;
# 			my $py = $y + $pos_y;
# 	 		$socket->send("PX $px $py $color\n");
# 		}
# 	}

# 	sleep(1);

# 	return 1;
# }


# my $forks = $opts{forks} || 1;

# my $PP = Pixel->new($opts{server}, $opts{port}, $forks);

# sub Pixel::loop_content {
# 	my $self = shift;
# 	my $max_y = $self->{'max_y'};
# 	my $max_x = $self->{'max_x'};
# 	my $client = $self->{'socket'};


# 	my $color = $opts{color} || "000000";

# 	for (my $y = 0; $y <= $max_y; $y++) {
# 		for (my $x = 0; $x <= $max_x; $x++) {
# 			$client->send("PX $x $y $color\n");
# 		}
# 	}

# 	sleep(10);
# 	return 1;
# }
