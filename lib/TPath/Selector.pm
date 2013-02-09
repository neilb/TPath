package TPath::Selector;

# ABSTRACT : an interface for classes that select nodes from a candidate collection

use Moose::Role;

=head1 REQUIRED METHODS

=head2 select

Takes a node an an index and returns a collection of nodes.

=cut

requires 'select';

1;
