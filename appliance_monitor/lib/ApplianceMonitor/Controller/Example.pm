package ApplianceMonitor::Controller::Example;
use Mojo::Base 'Mojolicious::Controller';

use lib '../../.';
use Schema;
use Mojo::IOLoop; # to increase inactivity timeout.
use ApplianceMonitor::Model::DbixUtility qw(read_updateDb success_percentage);

# This action will render a template. Before rendering it will call the required subroutines
# and will render the data to template.
sub welcome {
  my $self = shift;
  
  # Increase inactivity timeout for connection to 0 for infinite timeout.
  Mojo::IOLoop->stream($self->tx->connection)->timeout(0);
  my ($pinged_ipAddr, $nopinged_ipAddr, $address) = read_updateDb($self);
  my ($total_ips, $success, $failure) = success_percentage($pinged_ipAddr, $address);
  my $datestring = localtime();
  $self->render(msg => 'Cumulative Total:'.$total_ips, success => $success, failure => $failure, datestring => $datestring, thumbs => $address);
}

1;
