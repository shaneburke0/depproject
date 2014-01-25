#!/usr/bin/perl
use strict;
use warnings;

my ($res,$disp);
my ($disp1, $disp2);

for (my $i=0; $i<30; $i++) {
my $x = genbin();
my $y = genbin();

if (rand(10) > 5) {
        $res = pad($x & $y);
        $disp1 .= "$x AND $y = ?\n";
        $disp2 .= "$x AND $y = $res\n";
} else {
        $res = pad($x | $y);
        $disp1 .= "$x OR $y = ?\n";
        $disp2 .= "$x OR $y = $res\n";
}
print "$disp1\n";
print "$disp2\n";
}

exit;

sub genbin {
my $range = 255;
my $random_number = int(rand($range));
my $binary_number = dec2bin($random_number);
return pad($binary_number);
}

sub pad {
return sprintf '%.8d', shift;
}

sub dec2bin {
my $str = unpack("B32", pack("N", shift));
$str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
return $str;
}
