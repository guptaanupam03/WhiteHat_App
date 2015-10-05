use utf8;
package Schema::Result::Target;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Target

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<target>

=cut

__PACKAGE__->table("target");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 appliance_id

  data_type: 'int'
  is_foreign_key: 1
  is_nullable: 0

=head2 hostname

  data_type: 'text'
  is_nullable: 0

=head2 address

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "appliance_id",
  { data_type => "int", is_foreign_key => 1, is_nullable => 0 },
  "hostname",
  { data_type => "text", is_nullable => 0 },
  "address",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<hostname_unique>

=over 4

=item * L</hostname>

=back

=cut

__PACKAGE__->add_unique_constraint("hostname_unique", ["hostname"]);

=head1 RELATIONS

=head2 appliance

Type: belongs_to

Related object: L<Schema::Result::Appliance>

=cut

__PACKAGE__->belongs_to(
  "appliance",
  "Schema::Result::Appliance",
  { id => "appliance_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-02-13 16:56:00
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IMVNFonhHk4iOWhKqSU4IA

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
