package _Test::Schema::Appliance;
use Mojo::Base 'Test::Class';

use Test::More;
use Test::Exception;

use Test::DBIx::Class {
    schema_class => 'Schema',
    connect_info => ['dbi:SQLite:dbname=:memory:','',''],
}, qw/Appliance/;

sub teardown : Test(teardown => 1) {
    my ($self) = @_;

    reset_schema();
}

sub test_appliances_can_be_created : Test(3) {
    my $appliance_name = 'test_name';
    my $appliance_customer = 'test_customer';

    my $appliance = _create_appliance(
        $appliance_name,
        $appliance_customer,
    );

    ok defined $appliance->id, 'appliance id';
    is $appliance->name => $appliance_name, 'appliance name';
    is $appliance->customer => $appliance_customer, 'appliance customer';
}

sub test_duplicate_appliance_names_are_rejected : Test {
    my $name = 'app1';

    _create_appliance($name, 'fake customer 1');
    throws_ok(
        sub { _create_appliance($name, 'fake customer 2') },
        'DBIx::Class::Exception'
    );
}

sub _create_appliance {
    my ($name, $customer) = @_;

    my $appliance = Appliance->create({ 
        name     => $name,
        customer => $customer,
    });

    return $appliance;
}

package main;
Test::Class->runtests();
