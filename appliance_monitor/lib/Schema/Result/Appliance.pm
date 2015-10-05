use utf8;
package Schema::Result::Appliance;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Appliance

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<appliance>

=cut

__PACKAGE__->table("appliance");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 customer

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "customer",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<name_unique>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("name_unique", ["name"]);

=head1 RELATIONS

=head2 targets

Type: has_many

Related object: L<Schema::Result::Target>

=cut

__PACKAGE__->has_many(
  "targets",
  "Schema::Result::Target",
  { "foreign.appliance_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-13 17:05:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MTRjC2ZXWs61G1iYcD+nNg

1;
