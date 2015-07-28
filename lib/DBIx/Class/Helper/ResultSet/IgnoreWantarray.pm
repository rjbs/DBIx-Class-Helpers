package DBIx::Class::Helper::ResultSet::IgnoreWantarray;

# ABSTRACT: Get rid of search context issues

use strict;
use warnings;

use parent 'DBIx::Class::ResultSet';

sub search {
   $_[0]->throw_exception ('->search is *not* a mutator, calling it in void context makes no sense')
      if !defined wantarray && (caller)[0] !~ /^\QDBIx::Class::/;

   shift->search_rs(@_);
}

1;

=pod

=head1 SYNOPSIS

 package MyApp::Schema::ResultSet::Foo;

 __PACKAGE__->load_components(qw{Helper::ResultSet::IgnoreWantarray});

 ...

 1;

And then elsewhere, like in a controller:

 my $rs = $self->paginate(
   $schema->resultset('Foo')->search({
      name => 'frew'
   })
 );

=head1 DESCRIPTION

This component makes search always return a ResultSet, instead of
returning an list of rows when called in list context.  See
L<DBIx::Class::Helper::ResultSet/NOTE> for a nice way to apply it to your
entire schema.

=head1 METHODS

=head2 search

Override of the default search method to force it to return a ResultSet.

