package Graphics::Primitive::Driver::Imager;
use Moose;

our $VERSION = '0.01';

use Imager;

with 'Graphics::Primitive::Driver';

has 'imager' => (
    is => 'ro',
    isa => 'Imager',
    lazy_build => 1
);

sub _build_imager {
    my ($self) = @_;

    return Imager->new(xsize => $self->width, ysize => $self->height, channels => 4);
}

sub _do_fill {}
sub _do_stroke {}
sub _draw_bezier {}
sub _draw_complex_border {}
sub _draw_ellipse {}
sub _draw_line {}
sub _draw_path {}
sub _draw_polygon {}
sub _draw_rectangle {}
sub _draw_textbox {}
sub _finish_page {}
sub _resize {}
sub data {}
sub get_textbox_layout {}
sub reset {}

sub write {
    my ($self, $file) = @_;

    # my $fh = IO::File->new($file, 'w')
    #     or die("Unable to open '$file' for writing: $!");
    # $fh->binmode;
    # $fh->print($self->data);
    # $fh->close;
    my $img = $self->imager;
    $img->write(file => $file) or die $img->errstr;
}

sub _draw_canvas {
    my ($self, $comp) = @_;

    $self->_draw_component($comp);

    foreach (@{ $comp->paths }) {
        $self->_draw_path($_->{path}, $_->{op});
    }
}

sub _draw_circle {
    my ($self, $circle) = @_;

    my $img = $self->imager;

    my $o = $circle->origin;
    # Fill?
    $img->circle(x => $o->x, y => $o->y);
}

sub _draw_component {
    my ($self, $comp) = @_;

    my $img = $self->imager;

    my $bc = $comp->background_color;
    if(defined($bc)) {
        my ($mt, $mr, $mb, $ml) = $comp->margins->as_array;
        my $color = Imager::Color->new($bc->red * 255, $bc->green * 255, $bc->blue * 255, $bc->alpha * 255);
        # X,Y position is wrong
        $img->box(
            color => $color,
            filled => 1,
            xmin => $mr,
            xmax => $comp->width - $mr - $ml,
            ymin => $mt,
            ymax => $comp->height - $mt - $mb
        );
    }

    my $border = $comp->border;
    if(defined($border)) {
        if($border->homogeneous) {
            if($border->top->width) {
                $self->_draw_simple_border($comp);
            }
        } else {
            $self->_draw_complex_border($comp);
        }
    }
}

sub _draw_simple_border {
    my ($self, $comp) = @_;

    my $img = $self->imager;

    my $border = $comp->border;
    my $top = $border->top;
    my $bswidth = $top->width;

    $context->set_source_rgba($top->color->as_array_with_alpha);

    my @margins = $comp->margins->as_array;

    $context->set_line_width($bswidth);
    $context->set_line_cap($top->line_cap);
    $context->set_line_join($top->line_join);

    $context->new_path;
    my $swhalf = $bswidth / 2;
    my $width = $comp->width;
    my $height = $comp->height;
    my $mx = $margins[3];
    my $my = $margins[1];

    my $dash = $top->dash_pattern;
    if(defined($dash) && scalar(@{ $dash })) {
        $context->set_dash(0, @{ $dash });
    }

    $context->rectangle(
        $margins[3] + $swhalf, $margins[0] + $swhalf,
        $width - $bswidth - $margins[3] - $margins[1],
        $height - $bswidth - $margins[2] - $margins[0]
    );
    $context->stroke;

    # Reset dashing
    $context->set_dash(0, []);
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Graphics::Primitive::Driver::Imager - The great new Graphics::Primitive::Driver::Imager!

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Graphics::Primitive::Driver::Imager;

    my $foo = Graphics::Primitive::Driver::Imager->new();
    ...

=head1 AUTHOR

Cory G Watson, C<< <gphat at cpan.org> >>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 Cory G Watson.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.
