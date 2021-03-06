package TPath::Context;

# ABSTRACT: the context in which a node is evaluated during a search

=head1 DESCRIPTION

Basically a data structure holding all the different bits of information that may be useful
to selectors, predicates, or attributes during the evaluation of a node. This class simplifies
method signatures -- instead of passing a list of parameters one passes a single context.

A C<TPath::Context> is a blessed array rather than a hash, and it is a non-Moose class, for a 
little added efficiency.

=cut

use strict;
use warnings;

use Scalar::Util qw(refaddr);

use overload '""' => \&to_string;

# To be regarded as private. Let TPath code create contexts.
sub new {
    my $class  = shift;
    my %params = @_;
    my $self   = [ $params{n}, $params{i}, [] ];
    bless $self, $class;
}

# A constructor that constructs a new context by augmenting an existing context.
# Expects a new node and the collection from which it was chosen. To be regarded
# as private.
sub bud {
    my ( $self, $n ) = @_;
    return bless [ $n, $self->[1], [ $self->[0], @{ $self->[2] } ] ];
}

#Makes a context that doesn't preserve the path.
sub wrap {
    my ( $self, $n ) = @_;
    return bless [ $n, $self->[1], [] ];
}

=method previous

Returns the context of the node selected immediately before the context node.

=cut

sub previous {
    my $self     = shift;
    my @previous = @{ $self->[2] };
    my $n        = shift @previous;
    return () unless $n;
    return bless [ $n, $self->[1], \@previous ];
}

=method first

Returns the first context in the selection history represented by this context.

=cut

sub first {
    my $self = shift;
    return $self unless @{ $self->[2] };
    $self->wrap( $self->[2][-1] );
}

=method n

The context node.

=cut

sub n { $_[0][0] }

=method i

The L<TPath::Index>.

=cut

sub i { $_[0][1] }

=method path

The previous nodes selected in the course of selecting the context node. These ancestor
nodes are in reverse order, so the node's immediate predecessor is at index 0.

=cut

sub path { $_[0][2] }

=method to_string

The stringification of a context is the stringification of its node.

=cut

sub to_string {
    my $s;
    eval { $s = "$_[0][0]" };
    if ($@) {    # workaround for odd overload bug
        $s = 'memaddr' . refaddr $_[0][0];
    }
    return $s;
}

1;
