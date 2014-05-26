package Mojolicious::Plugin::RenderSteps;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.02';

sub register {
  my ($self, $app) = @_;
  $app->helper(
    render_steps => sub {
      my ($self, @steps) = @_;
      $self->render_later;
      my $delay = Mojo::IOLoop->delay(@steps);
      $delay->on(error => sub { $self->render_exception });
      $delay->on(
        finish => sub {
          my $delay = shift;
          $self->render_maybe or $self->render_not_found;
        }
      );
      $delay->wait unless Mojo::IOLoop->is_running;
    }
  );
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::RenderSteps - ASync controllers without the boilerplate

=head1 SYNOPSIS

  # Mojolicious::Lite
  plugin 'RenderSteps';

  get '/foo' => sub {
    my $self->shift;
    $self->render_steps(sub {
      my $delay=shift;
      $self->ua->get('reddit.com/',$delay->begin);
    }, sub {
      my $delay=shift;
      $self->stash(res=>shift);
    });
  };

=head1 DESCRIPTION

L<Mojolicious::Plugin::RenderSteps> lets you run async callbacks easily. When
you call render_steps, it will automatically call render_later, and create
a L<Mojo::IOLoop::Delay> object, pass it your steps, and set up automatic
rendering and error handling. This makes async actions behave like sync ones.

render_steps also automatically calls wait if the ioloop isn't running, so steps
will function under PSGI, for instance.

=head1 METHODS

L<Mojolicious::Plugin::RenderSteps> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Creates the render_steps helper.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=head1 LICENSE

This module is licensed under the same terms as Perl itself.

=head1 COPYRIGHT

Copyright 2014 Marcus Ramberg


=cut
