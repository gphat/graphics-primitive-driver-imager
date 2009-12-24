use strict;

use Graphics::Color::RGB;
use Graphics::Primitive::Border;
use Graphics::Primitive::Component;
use Graphics::Primitive::Driver::Imager;

my $c = Graphics::Primitive::Component->new(
  background_color => Graphics::Color::RGB->new(
      red => 1, green => 1, blue => 0, alpha => 1
  ),
  width => 500, height => 350,
  border => new Graphics::Primitive::Border->new( width => 5 )
);

my $driver = Graphics::Primitive::Driver::Imager->new;

$driver->prepare($c);
$driver->finalize($c);
$driver->draw($c);
$driver->write('foo.png');
