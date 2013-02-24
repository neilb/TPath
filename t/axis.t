# checks whether attributes are working as expected

use strict;
use warnings;
use File::Basename qw(dirname);

BEGIN {
    push @INC, dirname($0);
}

use Test::More;    # tests => 32;
use ToyXMLForester;
use ToyXML qw(parse);

my $f = ToyXMLForester->new;
my ( $p, $path, @c );

$p    = parse q{<a><b/><c><b/><d><b/></d></c><b foo='bar'/><b/><c><b/></c></a>};
$path = q{//b[@attr('foo') = 'bar']/preceding::b};
@c    = $f->path($path)->select($p);
is @c, 3, "received expected from $p with $path";

$p = parse
q{<a><b/><c><b quux='corge'/><d><b/></d></c><b foo='bar'/><b/><c><b/></c></a>};
$path = q{//b[@attr('foo') = 'bar']/preceding::b[1]};
@c    = $f->path($path)->select($p);
is @c, 1, "received expected from $p with $path";
is $c[0]->attributes->{quux}, 'corge', 'expected value of @quux';

$p = parse
q{<a><b/><c><b quux='corge'/><d><b/></d></c><b foo='bar'/><b/><c><b/></c></a>};
$path = q{//b[@attr('foo') = 'bar']/preceding::b[-2]};
@c    = $f->path($path)->select($p);
is @c, 1, "received expected from $p with $path";
is $c[0]->attributes->{quux}, 'corge', 'expected value of @quux';

$p    = parse q{<a><b/><c/><d/></a>};
$path = q{/a/child::*};
@c    = $f->path($path)->select($p);
is @c, 3, "received expected from $p with $path";

$p    = parse q{<a><b><c><d/></c></b></a>};
$path = q{//d/ancestor::*};
@c    = $f->path($path)->select($p);
is @c, 3, "received expected from $p with $path";

done_testing();