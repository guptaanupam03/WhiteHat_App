use strict;
use warnings;

use lib '../.';
use Schema;
use Net::Ping;
use BSD::Resource; # to limit hard and soft limit of files.

setrlimit(RLIMIT_NOFILE, 4096, 4096);   # raise hard+soft limit to 4096

# This script works as a stand alone application.
# 1) It will read the database to get IP addresses.
# 2) It will ping the IP addresses.
# 3) It will update the database.

my ($status, $name, $customer, $address, $hostname, $id, $host, $rtt, $ip, @ip_Status, @ping_ipAddr, @ips, %ip_addr, @address);
my ($connect, $rst, $rs, $rest, $res);

# We connect to the database.
$connect = Schema->connect('dbi:SQLite:database.db');
read_db();
ping_ip(@address);
update_db(\@ip_Status);


######################################################################################
#Author: Anupam Gupta
#
#Sub-routine - read_db.
#
#Parameters - Null.
#
#Return Type - @address
#
#Usage - This subroutine reads data from two different tables and merge the data
#        based on id's of both the table for further processing of the data.
######################################################################################
sub read_db{
    print "Inside read\n";
    undef @address;
    $rst = $connect->resultset('Target');
    # Sql equivqlent
    # SELECT me.id, me.name, me.customer, target.appliance_id, target.hostname,
    # target.address FROM appliance me LEFT JOIN target target ON
    # target.appliance_id = me.id WHERE ( me.id = appliance_id ) ORDER BY target.appliance_id
    
    $rs = $connect->resultset('Appliance')->search(
      {
        'me.id' => { -ident => 'appliance_id' },
      },
      {
        select => ['id', 'name', 'customer', 'targets.appliance_id', 'targets.hostname', 'targets.address'],
        join => 'targets',
        order_by  => ['targets.appliance_id'],
      }
    );
    
    while ($res = $rs->next and $rest = $rst->next) {
        push @address, $res->name .":". $res->customer .":". $rest->appliance_id .":". $rest->hostname .":". $rest->address;
    }
    return @address;
}


######################################################################################
#Author: Anupam Gupta
#
#Sub-routine - ping_ip.
#
#Parameters - @address.
#
#Return Type - @ip_Status
#
#Usage - This subroutine accepts an array of ip addresses & will ping every   
#        ip in return using Net::Ping module. Once done we will return the status.
######################################################################################

sub ping_ip {
    
    undef @ips;
    undef @ping_ipAddr;
    undef @ip_Status;
    undef %ip_addr;
    
    my @ips = @_;
    
    foreach ( @ips ) {
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
    foreach $host ( @ping_ipAddr ) {
      # For every loop storing $ip_addr{$host} as values appending with Down status to host key.
      push @ip_Status, "$ip_addr{$host}:Down\n";
      $p->ping($host);
    }
    #
    #### Then check which hosts responded.
    while( ( $host, $rtt, $ip ) = $p->ack ) {
      # If the IP is active or responded back, we will push the value $ip_addr{$host}:Active to host key.
      push @ip_Status, "$ip_addr{$host}:Active\n";
      print "@ip_Status\n";
    }
    
    return @ip_Status;
}

######################################################################################
#Author: Anupam Gupta
#
#Sub-routine - update_db.
#
#Parameters - @ip_Status.
#
#Return Type - Null
#
#Usage - This subroutine accepts an array of ip addresses along with their statuses & will 
#        update the database.
######################################################################################

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
