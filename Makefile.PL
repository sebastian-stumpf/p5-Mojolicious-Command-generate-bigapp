use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Command::generate::big_app',
  VERSION_FROM => 'lib/Mojolicious/Command/generate/big_app.pm',
  AUTHOR       => 'Sebastian Stumpf <sepp@perlhacker.org>',
  PREREQ_PM    => {'Mojolicious' => '5.37'},
  test         => {TESTS => 't/*.t'}
);
