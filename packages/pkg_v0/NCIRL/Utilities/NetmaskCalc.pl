#!/usr/bin/perl
use strict;
use warnings;

# genMasks();

# exit;

# print genRandomAddress(),"\n";

my $disp1; my $disp2;

for (my $i=0; $i<30; $i++) {
        my ($add,$class,$classmask,$bits,$hostbits,$mask,$net,$subnetbits,$subnets);
        do {
        $add = genRandomAddress();
        ($class,$classmask) = classify($add);
        } until ($classmask > 0);
        do {
        $bits = int(rand(32));
        } until ($bits > $classmask);
        $subnetbits = $bits - $classmask;
        $subnets = 2^$subnetbits;
        $hostbits = 32 - $bits;
        $mask = genmask($bits);
        $net = $add & $mask;
        $net = $net .  "0" x (32-length($net));
        my ($fsfh,$lsfh) = character($add,$classmask,$subnetbits,$hostbits);
        $fsfh = convBinAddress($fsfh);
        $lsfh = convBinAddress($lsfh);
        my $qdisp = "Netmask bits : $bits, Dotted Decimal : ".convBinAddress($mask)."\n";
        $qdisp .= "Address : ".convBinAddress($add)." Network : ".convBinAddress($net)."\n";
        my $adisp = "Mask : ".bindotify($mask).", Add : ".bindotify($add).", Net : ".bindotify($net)."\n";
        $adisp .= "Hostbits : $hostbits, Class : $class, Class Mask : $classmask, Subnet bits : $subnetbits\n";
        $adisp .= "First subnet First Host : $fsfh, Last subnet First Host : $lsfh\n";
        $disp1 .= $qdisp."\n";
        $disp2 .= $qdisp.$adisp."\n";
}

print $disp1;
print $disp2;

exit;

sub character {
my ($add,$classmask,$subnetbits,$hostbits) = @_;
my $network=substr($add,0,$classmask);
my $firstsubnetfirsthost=$network.("0" x $subnetbits).("0" x ($hostbits-1))."1";
my $lastsubnetfirsthost=$network.("1" x $subnetbits).("0" x ($hostbits-1))."1";
return ($firstsubnetfirsthost,$lastsubnetfirsthost);
}

sub bindotify {
my $binary = shift;
my $byte1 = substr($binary,0,8);
my $byte2 = substr($binary,8,8);
my $byte3 = substr($binary,16,8);
my $byte4 = substr($binary,24,8);
return "$byte1.$byte2.$byte3.$byte4";
}

sub classify {
my $ip = shift;
my $class="E";
my $netmask="";
my ($b0,$b1,$b2,$b3) = map substr( $ip, $_, 1), 0 .. length($ip) -1;
if (!$b0) {
        $class="A";
        $netmask=8;
} elsif (!$b1) {
        $class="B";
        $netmask=16;
} elsif (!$b2) {
        $class="C";
        $netmask=24;
} elsif (!$b3) {
        $class="D";
        $netmask="";
} else {
        $class="E";
        $netmask="";
}
return ($class,$netmask);
}

sub genRandomAddress {
my $v;
for (my $i=0; $i<32; $i++) {
        $v .= (rand(10)>5) ? 0 : 1;
}
return $v;
}

sub genMasks {
for (my $i=0; $i<20; $i++) {
my $bits = int(rand(32));
my $cidr = convbitsCidr($bits);
print "\\$bits -> $cidr\n";
}
}

sub convbitsCidr {
my $bits = shift;
my $mask = genmask($bits);
my $cidr = convMaskCidr($mask);
return $cidr;
}

sub convBinAddress {
my $binary=shift;
my $byte1 = bin2dec(substr($binary,0,8));
my $byte2 = bin2dec(substr($binary,8,8));
my $byte3 = bin2dec(substr($binary,16,8));
my $byte4 = bin2dec(substr($binary,24,8));
return "$byte1.$byte2.$byte3.$byte4";
}

sub convMaskCidr {
my $mask=shift;
my $byte1 = bin2dec(substr($mask,0,8));
my $byte2 = bin2dec(substr($mask,8,8));
my $byte3 = bin2dec(substr($mask,16,8));
my $byte4 = bin2dec(substr($mask,24,8));
return "$byte1.$byte2.$byte3.$byte4";
}

sub genmask {
my $ones = shift;
my $zero = 32-$ones;
return "1" x $ones . "0" x $zero;
}

sub netmask2cidr {
    my ($mask, $network) = @_;
    my @octet = split (/\./, $mask);
    my @bits;
    my $binmask;
    my $binoct;
    my $bitcount=0;

    foreach (@octet) {
      $binoct = dec2bin($_);
      $binmask = $binmask . substr $binoct, -8;
    }

    # let's count the 1s
    @bits = split (//,$binmask);
    foreach (@bits) {
      if ($_ eq "1") {
        $bitcount++;
      }
    }

    my $cidr = $network . "/" . $bitcount;
    return $cidr;
}


sub genbin {
my $range = 255;
my $random_number = int(rand($range));
my $binary_number = dec2bin($random_number);
return pad($binary_number);
}

sub pad {
return sprintf '%.8d', shift;
}

sub pad32 {
return sprintf '%.32d',shift;
}

sub dec2bin {
my $str = unpack("B32", pack("N", shift));
$str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
return $str;
}

sub bin2dec {
return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}
