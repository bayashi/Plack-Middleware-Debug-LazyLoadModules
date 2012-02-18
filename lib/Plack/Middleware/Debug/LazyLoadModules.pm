package Plack::Middleware::Debug::LazyLoadModules;
use strict;
use warnings;
use Plack::Util::Accessor qw/filter/;
use parent qw/Plack::Middleware::Debug::Base/;
our $VERSION = '0.01';

sub run {
    my($self, $env, $panel) = @_;

    my %modules = ();
    $modules{$_}++ for keys %INC;

    return sub {
        my $res = shift;

        my @lazy_load_modules;
        for my $module (keys %INC) {
            next if $modules{$module};
            my $filter = $self->filter;
            if ( !$filter || (_is_regexp($filter) && $module =~ /$filter/) ) {
                push @lazy_load_modules, $module;
            }
        }

        $panel->nav_subtitle(
            sprintf(
                "%d/%d lazy loaded",
                    scalar(@lazy_load_modules), scalar(keys %modules),
            )
        );
        $panel->content(
            $self->render_lines([sort @lazy_load_modules]),
        );
    };
}

sub _is_regexp {
    (ref($_[0]) eq 'Regexp') ? 1 : 0;
}

1;

__END__

=head1 NAME

Plack::Middleware::Debug::LazyLoadModules - debug panel for Lazy Load Modules


=head1 SYNOPSIS

    use Plack::Builder;
    builder {
      enable 'Debug::LazyLoadModules';
      $app;
    };

or you can set `filter` option(Regexp reference).

      enable 'Debug::LazyLoadModules', filter => qr/\.pm$/;


=head1 DESCRIPTION

Plack::Middleware::Debug::LazyLoadModules is debug panel for watching lazy loaded modules.


=head1 METHOD

=head2 run

see L<Plack::Middleware::Debug::Base>


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
