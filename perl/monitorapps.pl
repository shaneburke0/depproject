#!/home/scripts/perl
 
use strict;
 
my @services = ( 'apache2', 'mysql' );
my $alert_email = 'shaneob121@hotmail.com';
my $host = `/bin/hostname`;
my $error_log  = 'logs/system/system_errors.txt';  # File to store
my $localtime  = localtime;
chomp $host;
 
foreach my $service (@services) {
	my $status = `/bin/ps cax | /bin/grep $service`;
	if (!$status) { 
		print "Service has stopped: $service\n";
		open ERR,">> $error_log" or die "Cannot open log file $error_log : $!\n";
		print ERR "$localtime\: Service has stopped: $service $!\n";
		close ERR or die "Cannot close log file $error_log : $!\n";
	} else {
		print "Service is running: $service\n";
	}
}
