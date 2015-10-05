package Schema::ResultSet::Appliance;

use base 'DBIx::Class::ResultSet';

sub by_name {
  return shift->find({name => {LIKE => pop}});
}

1;

__END__
