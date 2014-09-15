package Mojolicious::Command::generate::big_app;
use Mojo::Base 'Mojolicious::Command';
use Mojo::Util qw(class_to_file class_to_path);

our $VERSION = '0.1';

has description => "Generate Mojolicious application directory structure with bootstrap and jquery.\n";
has usage => "Usage: $0 generate big_app Foo::Bar\n";

sub run {
    my ($self, $class) = @_;

    # Prevent bad applications
    die "Invalid package name" unless defined $class && $class =~ /^[A-Z](?:\w|::)+$/;

    # Script
    my $name = class_to_file $class;
    $self->render_to_rel_file('mojo', "$name/script/$name", $class);
    $self->chmod_rel_file("$name/script/$name", 0744);

    # Application class
    my $app = class_to_path $class;
    $self->render_to_rel_file('appclass', "$name/lib/$app", $class);

    # Controller
    my $controller = "${class}::Controller::Home";
    my $path = class_to_path $controller;
    $self->render_to_rel_file('controller', "$name/lib/$path", $controller);

    # Test
    $self->render_to_rel_file('test', "$name/t/basic.t", $class);

    # Static file
    $self->render_to_rel_file('static', "$name/public/index.html");
    $self->create_rel_dir("$name/public/vendor");

    # Templates
    $self->render_to_rel_file('layout', "$name/templates/layouts/default.html.ep");
    $self->render_to_rel_file('index', "$name/templates/home/index.html.ep");

    # .bowerrc
    $self->render_to_rel_file('bowerrc', "$name/.bowerrc");

    # bower.json
    $self->render_to_rel_file('bower', "$name/bower.json", $name);

    # .gitignore
    $self->render_to_rel_file('gitignore', "$name/.gitignore");
}


1;
__DATA__

@@ gitignore
log/
public/vendor/

@@ bowerrc
{
  "directory": "public/vendor"
}

@@ bower
% my $class = shift;
{
  "name": "<%= $class %>",
  "version": "0.0.1",
  "dependencies": {
    "bootstrap": "~3.2.0",
    "jquery": "~2.1.1"
  },
  "ignore": [
    "**/.*",
    "public/vendor",
    "log"
  ]
}

@@ mojo
% my $class = shift;
#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/../lib" }

# Start command line interface for application
require Mojolicious::Commands;
Mojolicious::Commands->start_app('<%= $class %>');

@@ appclass
% my $class = shift;
package <%= $class %>;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    my $r = $self->routes;
    $r->get('/')->to('Home#index');
}

1;

@@ controller
% my $class = shift;
package <%= $class %>;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render();
}

1;

@@ test
% my $class = shift;
use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('<%= $class %>');
$t->get_ok('/')->status_is(200)->content_like(qr/Index/i);

done_testing();

@@ static
<!DOCTYPE html>
<html><body></body></html>

@@ layout
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title><%%= title %></title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="icon" href="/favicon.png" type="image/png" />
    <link rel="stylesheet" type="text/css" href="/vendor/bootstrap/dist/css/bootstrap.min.css"/>
    <script type="text/javascript" src="/vendor/jquery/dist/jquery.min.js"></script>
    <script type="text/javascript" src="/vendor/bootstrap/dist/js/bootstrap.min.js"></script>
  </head>
  <body>
    <div class="container">
    <%%= content %>
    </div>
  </body>
</html>

@@ index
%% layout 'default';
%% title 'Welcome';
<h2>Index</h2>
Here be content
