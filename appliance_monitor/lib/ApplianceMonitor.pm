package ApplianceMonitor;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my ($self) = @_;

    # Router
    my $r = $self->routes;
    # Normal route to controller
    $r->get('/')->to('example#welcome');
}

1;
