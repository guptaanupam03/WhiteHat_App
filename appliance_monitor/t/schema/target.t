package _Test::Schema::Target;
use Mojo::Base 'Test::Class';

use Test::Exception;
use Test::More;

use Test::DBIx::Class {
    schema_class => 'Schema',
    connect_info => ['dbi:SQLite:dbname=:memory:','',''],
}, qw/Appliance Target/;

sub setup : Test(setup => 1) {
    my ($self) = @_;

    fixtures_ok [
        Appliance => [
            [qw/name customer/],
            [$self->appliance_name, 'cust1'],
        ],
    ], 'Installed fixtures';
}

use constant appliance_name => 'app1';

sub teardown : Test(teardown => 1) {
    my ($self) = @_;

    reset_schema();
}

sub test_can_create_valid_target : Test {
    my ($self) = @_;

    lives_ok( sub {
        $self->appliance->add_to_targets( {
            hostname => 'foo', address => '8.8.8.8'
        } );
    } );
}

sub appliance {
    my ($self) = @_;

    return Appliance->by_name($self->appliance_name);
}

package main;
Test::Class->runtests();
