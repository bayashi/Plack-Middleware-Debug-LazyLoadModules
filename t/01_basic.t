#!/usr/bin/env perl
use warnings;
use strict;
use Plack::Test;
use Plack::Builder;
use Plack::Util;
use HTTP::Request::Common;
use Test::More;
use lib 't/lib';

{
    my $app = sub {
        Plack::Util::load_class("+LazyWay", "Foo");
        return [
            200,
            [ 'Content-Type' => 'text/html' ],
            ['<html><body>Be Lazy!</body></html>']
        ];
    };

    $app = builder {
        enable 'Debug', panels => [qw/LazyLoadModules/];
        $app;
    };

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->(GET '/');

        is $res->code, 200, 'response status 200';

        like $res->content,
          qr/<a href="#" title="Lazy Load Modules" class="plDebugLazyLoadModules\d+Panel">/,
          "HTML contains LazyLoadModules panel";

        like $res->content,
          qr{<td>LazyWay.pm</td>},
          "loaded LazyWay";
    };

}

done_testing;
