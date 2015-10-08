package ApplianceMonitor::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use lib '../../.';
use Schema;
use Mojo::IOLoop; # to increase inactivity timeout.
use BSD::Resource; # to limit hard and soft limit of files.

setrlimit(RLIMIT_NOFILE, 4096, 4096);   # raise hard+soft limit to 4096

my ($connect, $total_ips, $success, $failure, $id,$name, $customer, $hostname, $address, $status, $res, $rs, %address, @pinged_ipAddr, @nopinged_ipAddr, @total_ips);

# This action will render a template. Before rendering it will call the required subroutines
# to process the IPs and after that will render the data to welcome template.
sub welcome {
  my $self = shift;
  
  # We are connecting to the database.
  $connect = Schema->connect('dbi:SQLite:./lib/Schema/database.db');
  
  # Increase inactivity timeout for connection to 0 for infinite timeout.
  Mojo::IOLoop->stream($self->tx->connection)->timeout(0);
  
  read_updateDb();
  success_percentage(\@pinged_ipAddr, \@total_ips);
  my $datestring = localtime();
  $self->render(msg => 'Cumulative Total:'.$total_ips, success => $success, failure => $failure, datestring => $datestring, thumbs => \%address);
}

######################################################################################
#Author: Anupam Gupta
#
#Sub-routine - read_updateDb.
#
#Parameters - Null.
#
#Return Type - @pinged_ipAddr, @nopinged_ipAddr, @total_ips, %address
#
#Usage - This subroutine reads the updated IP data status from the database and push
#        it inside the arrays based on status. These arrays are then used to calculate
#        the success percentage.
######################################################################################
sub read_updateDb {
  
  undef @pinged_ipAddr;
  undef @nopinged_ipAddr;
  undef @total_ips;
  undef %address;
  
  my $rdup = $connect->resultset('Status')->search(
      {},
      {
        select => ['appliance_id', 'name', 'customer', 'hostname', 'address', 'status'],
        order_by  => ['appliance_id'],
      }
    );

  while (my $rdupt = $rdup->next) {
      $address{$rdupt->address}  = $rdupt->appliance_id .":". $rdupt->name .":". $rdupt->customer .":". $rdupt->hostname .":". $rdupt->address .":". $rdupt->status."\n";
  }
  
  foreach ( values %address ) {
    push @total_ips, $_;
    ($id,$name,$customer,$hostname,$address,$status) = split /:/, $_;
    if ($status =~ /Active/) {
      push @pinged_ipAddr, $_;
    }else {
      push @nopinged_ipAddr, $_;
    }
  }
  return @pinged_ipAddr, @nopinged_ipAddr, @total_ips, %address;
}

######################################################################################
#Author: Anupam Gupta
#
#Sub-routine - success_percentage.
#
#Parameters - \@pinged_ipAddr, \@ping_ipAddr.
#
#Return Type - $total_ips, $success, $failure.
#
#Usage - This subroutine accepts an array of all the IP addresses & the array which conatins   
#        only the Active IP's. Do success and failure calculation and return the values.
######################################################################################

sub success_percentage {
  print "Inside Success\n";
  my $total = $_[1];
  my $pinged = $_[0];
  $total_ips = scalar @$total;
  $success = scalar @$pinged;
  $failure = @$total - $success;
  return $total_ips, $success, $failure;
}

1;
