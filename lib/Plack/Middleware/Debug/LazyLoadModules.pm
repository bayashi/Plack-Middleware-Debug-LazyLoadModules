package Plack::Middleware::Debug::LazyLoadModules;
use strict;
use warnings;
use parent qw/Plack::Middleware::Debug::Base/;
our $VERSION = '0.01';

our %modules;

sub run {
    my($self, $env, $panel) = @_;

    %modules = ();
    $modules{$_}++ for keys %INC;

    return sub {
        my $res = shift;

        my @lazy_load_modules = grep { !$modules{$_} } keys %INC;

        $panel->nav_subtitle(
            sprintf "%d modules loaded", scalar(@lazy_load_modules)
        );
        $panel->content(
            $self->render_lines(\@lazy_load_modules),
        );
    };
}

1;

__END__

=head1 NAME

Plack::Middleware::Debug::LazyLoadModules - debug panel for Lazy Load Modules


=head1 SYNOPSIS

    use Plack::Builder;
    builder {
      enable 'Debug', panels => [qw/LazyLoadModules/];
      $app;
    };

=head1 DESCRIPTION

Plack::Middleware::Debug::LazyLoadModules is debug panel for watching lazy loaded modules.


=head1 REPOSITORY

Plack::Middleware::Debug::LazyLoadModules is hosted on github
<http://github.com/bayashi/Plack-Middleware-Debug-LazyLoadModules>


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<Plack::Middleware::Debug>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
