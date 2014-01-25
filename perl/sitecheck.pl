#!/home/scripts/perl
use warnings;
use strict;
use Tie::File;
use Net::SMTP;
use LWP::UserAgent;

# Program  Settings

my $error_log  = 'logs/site/sitecheck_errors.txt';  # File to store errors of program
my $input_file = 'perl/urls.txt';              # From where program will read WEB Addresses
my $response_limit = 10; #In Seconds      # Positively diggit -> SendMail; 0 -> will not send mail

# END OF SETTINGS

die "File $input_file is not exist\n" unless (-e $input_file);
my $localtime     = localtime;
our @errors;
my ($day,$month,$date,$hour,$year) = split /\s+/,scalar localtime;
my $output_file = 'logs/site/report-'.$date.'.'.$month.'.'.$year.'.txt';
my @all_addr = ();
tie @all_addr, 'Tie::File', $input_file or error("Cant open $input_file to read addresses");
if (-e $output_file) {
   open(OUT,">> $output_file") or error("Cant open exist file $output_file for append");
} else {
   open(OUT,"> $output_file") or error("Cant open new file $output_file for writting");
}

print OUT "\n+" .('-' x 84) . "+\n";
print OUT   "|", ' ' x 30,"Time: $hour",' ' x 40,"|\n";
print OUT   "|",' 'x 10,'HOST',' ' x 37,'STATUS',' ' x 7,"RESPONSE            |\n";
print OUT   "+" .('-' x 84) . "+\n";
for (0 .. $#all_addr) {
 chop $all_addr[$_] if ($all_addr[$_] =~ /\s+$/);
 next if ($all_addr[$_]  eq "");
 if ($all_addr[$_] =~ /^http:\/\/\S+\.\w{2,4}$/) {  #address will beginnig with http://,next some string
                                                    # finish with point and 2 to 4 letters
   check_url($all_addr[$_]);    #call subroutine check_url()
 } else {
   my $out_format = sprintf "| %-50.50s %-10s  %-20s|\n", $all_addr[$_], "WRONG", "N/A";
   printf OUT $out_format;
   printf $out_format;
         push @errors, "$all_addr[$_] is WRONG Address.";
 }
}

my $err = join "\015\012",@errors;
my $err_num = scalar @errors;  # How match DOWN + WRONG Sites have
untie @all_addr or error("Unable to close file $input_file");


close OUT or error("Unable to close file $output_file");
print "\nSite check completed.\n";




sub check_url {  # subroutine who check given URL
    my $target = $_[0];
        my $ua = LWP::UserAgent->new;
        $ua->agent("$0/0.1 " . $ua->agent);
        my $req = HTTP::Request->new(GET => "$target");
        $req->header('Accept' => 'text/html');          #Accept HTML Page
        # send request
        my $start = time;      # Start timer
        my $res = $ua->request($req);
        # check the outcome
        if ($res->is_success) {# Success....all content of page has been received
          my $time = time;     # End timer
          my $out_format;
          $time = ($time - $start); # Result of timer
          if ($response_limit && ($response_limit <= $time)) {
             push(@errors, "Slow response from $target\: $time seconds");
             $out_format = sprintf "| %-44s %-10s %-20s |\n", $target, "SLOW", "Response $time seconds";
          } else {
             $out_format = sprintf "| %-44s %-10s %-20s |\n", $target, "ACCESSED", "Response $time seconds";
          }
          print OUT $out_format; # write to file
          print $out_format;     # print to console
        } else {                 # Error .... Site is DOWN
          my $out_format = sprintf "| %-44s %-10s %-20s |\n", $target, "DOWN", " N/A";
          push(@errors, "$target is DOWN." . $res->status_line) or error("Cannot push error for DOWN");
          print OUT $out_format; # write to file
          print $out_format;     # print to console
	  error($out_format);
    }


}
sub error {      # subroutine who print in Error Log
  my $error_msg = shift;
  open ERR,">> $error_log" or die "Cannot open log file $error_log : $!\n";
  print ERR "$localtime\: $error_msg : $!\n";
  close ERR or die "Cannot close log file $error_log : $!\n";
}
