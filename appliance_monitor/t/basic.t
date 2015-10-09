use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('ApplianceMonitor');
$t->message([text => 'Cumulative Total:']);
$t->get_ok('/')->status_is(200)->content_type_is('text/html;charset=UTF-8');
#$t = $t->finished_ok(1000);
$t = $t->element_exists('html head title', 'has a title');
done_testing();
