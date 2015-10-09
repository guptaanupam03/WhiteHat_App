package ApplianceMonitor;
use Mojo::Base 'Mojolicious';
use Schema;

# This method will run once at server start
sub startup {
    my ($self) = @_;
    
    my $schema = Schema->connect('dbi:SQLite:./lib/Schema/database.db');
    $self->helper(db => sub { return $schema; });
    # Router
    my $r = $self->routes;
    # Normal route to controller
    $r->get('/')->to('Example#welcome', namespace => 'ApplianceMonitor::Controller');
}

1;
