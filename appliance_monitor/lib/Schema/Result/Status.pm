use utf8;
package Schema::Result::Status;

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->table("status");

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "appliance_id",
  { data_type => "int", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "customer",
  { data_type => "text", is_nullable => 0 },
  "hostname",
  { data_type => "text", is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 0 },
  "status",
  { data_type => "text", is_nullable => 0 },
);

__PACKAGE__->set_primary_key("id");


1;