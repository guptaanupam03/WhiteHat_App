package ApplianceMonitor::Model::DbixUtility;

use strict;
use warnings;

use lib '../../.';
use Schema;
use Exporter;

use vars qw(@ISA @EXPORT);
@ISA=qw(Exporter);
@EXPORT = qw(read_updateDb success_percentage);

my ($total_ips, $success, $failure, $id, $name, $customer, $hostname, $address, $status);
my (%address, @pinged_ipAddr, @nopinged_ipAddr);


#Usage - This subroutine reads the updated IP data status from the database and push
#        it inside the arrays based on status. These arrays are then used to calculate
#        the success percentage.

sub read_updateDb {
  
  undef @pinged_ipAddr;
  undef @nopinged_ipAddr;
  undef %address;
  
  my $self = shift;
  my $rdup = $self->db->resultset('Status')->search(
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
    ($id, $name, $customer, $hostname, $address, $status) = split /:/, $_;
    if ($status =~ /Active/) {
      push @pinged_ipAddr, $_;
    }else {
      push @nopinged_ipAddr, $_;
    }
  }
  return \@pinged_ipAddr, \@nopinged_ipAddr, \%address;
}


#Usage - This subroutine accepts an array of all the IP addresses & the array which conatins   
#        only the Active IP's. Do success and failure calculation and return the values.

sub success_percentage {
  my $pinged = shift;
  my $total = shift;
  $total_ips = scalar keys %$total;
  $success = scalar @$pinged;
  $failure = $total_ips - $success;
  return $total_ips, $success, $failure;
}

1;
