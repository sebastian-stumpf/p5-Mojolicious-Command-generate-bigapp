use Test::More tests => 3;
use Mojolicious::Command::generate::big_app;

require_ok('Mojolicious::Command::generate::big_app');

my $ba = Mojolicious::Command::generate::big_app->new;
isa_ok($ba, 'Mojolicious::Command::generate::big_app');
can_ok($ba, 'run');
