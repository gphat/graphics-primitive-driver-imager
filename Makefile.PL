use inc::Module::Install;

name     'Graphics-Primitive-Driver-Imager';
all_from 'lib/Graphics/Primitive/Driver/Imager.pm';
author   q{Cory G Watson <gphat@cpan.org>};
license  'perl';

build_requires 'Test::More';

requires 'Imager' => '0.72';

WriteAll;

