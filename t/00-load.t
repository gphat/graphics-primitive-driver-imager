#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Graphics::Primitive::Driver::Imager' );
}

diag( "Testing Graphics::Primitive::Driver::Imager $Graphics::Primitive::Driver::Imager::VERSION, Perl $], $^X" );
