use strict;
use warnings;

use lib '../lib';
use Schema;
use Net::Ping; # implements ping functionality.
use BSD::Resource; # to limit hard and soft limit of files.

setrlimit(RLIMIT_NOFILE, 4096, 4096);   # raise hard+soft limit to 4096

# This script works as a stand alone application.
# 1) It will read the database to get IP addresses.
# 2) It will ping the IP addresses.
# 3) It will update the database.

my ($status, $name, $customer, $address, $hostname, $id, $rtt, $ip);
my (@ip_Status, @ping_ipAddr, @ips, %ip_addr, @address);

# We connect to the database.
my $connect = Schema->connect('dbi:SQLite:.././lib/Schema/database.db');

my $read_add = read_db();
my $ping_status = ping_ip($read_add);
update_db($ping_status);



#Usage - This subroutine reads data from two different tables and merge the data
#        based on id's of both the table for further processing of the data.

sub read_db{
    undef @address;
    my $rst = $connect->resultset('Target');
    
    my $rs = $connect->resultset('Appliance')->search(
      {
        'me.id' => { -ident => 'appliance_id' },
      },
      {
        select => ['id', 'name', 'customer', 'targets.appliance_id', 'targets.hostname', 'targets.address'],
        join => 'targets',
        order_by  => ['targets.appliance_id'],
      }
    );
    
    while (my $res = $rs->next and my $rest = $rst->next) {
        push @address, $res->name .":". $res->customer .":". $rest->appliance_id .":". $rest->hostname .":". $rest->address;
    }
    return \@address;
}


#Usage - This subroutine accepts an array of ip addresses & will ping every   
#        IP in return using Net::Ping module. Once done we will return the status.

sub ping_ip {
    
    undef @ips;
    undef @ping_ipAddr;
    undef @ip_Status;
    undef %ip_addr;
    
    my $ips = shift;
    
    foreach ( @$ips ) {
        # Spliting every element based on : into seperate variables.
        ($name, $customer, $id, $hostname, $address) = split (/:/, $_);
        # Making address as key of hash storing all other data as values.
        $ip_addr{$address} = $id .":". $name .":". $customer .":". $hostname .":". $address;
        # Pushing only the address variable which contains the IPs to the array.
        push @ping_ipAddr, $address;
    }
    
    # Creating an object of Net::Ping
    my $p = Net::Ping->new( "syn" );
  
    ###### send all the pings first
    foreach $address ( @ping_ipAddr ) {
      # For every loop storing $ip_addr{$host} as values appending with Down status to host key.
      push @ip_Status, "$ip_addr{$address}:Down\n";
      $p->ping($address);
    }
    #
    #### Then check which hosts responded.
    while( ( $address, $rtt, $ip ) = $p->ack ) {
      # If the IP is active or responded back, we will push the value $ip_addr{$host}:Active to host key.
      push @ip_Status, "$ip_addr{$address}:Active\n";
    }
    
    return \@ip_Status;
}


#Usage - This subroutine accepts an array of ip addresses along with their statuses & will 
#        update the database.

sub update_db {
    my $update_ip = shift;
    #$connect->deploy;
    my $upd = $connect->resultset('Status');
    $upd->delete_all;
    foreach (@$update_ip) {
        ($id,$name,$customer,$hostname,$address,$status) = split /:/, $_;
        $upd->populate([
          [qw( appliance_id name customer hostname address status )],
          [$id, $name, $customer, $hostname, $address, $status],
        ]);
    }
}

1;
