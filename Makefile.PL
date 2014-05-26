use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojolicious::Plugin::RenderSteps',
  VERSION_FROM => 'lib/Mojolicious/Plugin/RenderSteps.pm',
  AUTHOR       => 'Marcus Ramberg <mramberg@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '4.99'},
  test         => {TESTS => 't/*.t'}
);
