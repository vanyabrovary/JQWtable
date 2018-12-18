package JQWtable::JQWtable;

use latest;

use FindBin qw/$Bin/;
use lib "$Bin/../../lib";

use DBI; use Moose; use Method::Signatures; use Common::Cfg;

extends 'JQWtable::JQWtableType', 'JQWtable::JQWtablePrint';

has 'db'         => ( is => 'rw', default => sub { DBI->connect( $cfg->{pg}->{socket}, 'ttg', 'gtt' ) } );

before 'list'    => sub {
    $_[0]->{list_query}  = "SELECT " . $_[0]->colls . " FROM " . $_[0]->from . $_[0]->where . $_[0]->group_by . $_[0]->order_by . $_[0]->limit;
};

method list {
  my $h = $self->db->prepare( $self->{list_query} );
  $h->execute();
  ## ckeck cols length;

  my $i = 0;

  while ( my $data = $h->fetchrow_hashref ) {
    $self->{i} = $i++;
    $self->check_col_lenght( $i, $_, $data->{$_} ) for (sort keys %$data);
  }

  return $self;
}



method check_col_lenght( Int $i!, Str $col_name!, Str $col_value!) {
  ## save rows to hash for printing
  push @{ $self->{rows}->{$i} }, $col_value;
  $self->{col_lenght}->{$col_name} ||= 0;
  ## update max value length for column if previous is lower than current
  if (length $col_value > $self->{col_lenght}->{$col_name}) {
    $self->{col_lenght}->{$col_name} = length $col_value;
    $self->{col_info}->{$col_name} = {
      val         => $col_value,
      type        => $self->get_datatype($col_value),
      #filtertype  => $self->get_filtertype( $self->{col_info}->{$col_name}->{type} )
    }
  }
}

#################################################################################################################

before 'col_info', 'col_jqw' => sub {
  my $self = shift;

  $self->{percent} += $self->{col_lenght}->{$_} foreach ( sort keys %{$self->col_lenght()} );
  $self->{percent}  = 100 / $self->{percent};
  $self->{percent}  = sprintf "%.2f", $self->{percent};

  foreach ( sort keys %{ $self->{col_info} } ) {

    $self->{col_info}->{$_}->{col_percent} = $self->{col_lenght}->{$_} * $self->{percent};

    push @{$self->{col_jqw}->{datafields}}, {
      name => $_,
      type => $self->{col_info}->{$_}->{type}
    };

    push @{$self->{col_jqw}->{columns}}, {
      text       => $_,
      datafield  => $_,
      cellsalign => 'right',
      width      => $self->{col_info}->{$_}->{col_percent}.'%',
      filtertype => $self->{col_info}->{$_}->{filtertype}
    };

  }
};

method col_jqw          { $self->{col_jqw};    }
method col_info         { $self->{col_info};   }

#################################################################################################################

method col              { my @b = sort keys %{$self->col_info};  return @b; }
method rows             { $self->{rows};       }
method col_lenght       { $self->{col_lenght}; }

##################################################################################################################

=pod

=encoding UTF-8

=head1 NAME

JQWtable::JQWtable

=head1 VERSION

0.1

=head1 DESCRIPTION

Show JQWidgets table settings from database query

=head1 SYNOPSIS

Create module which contain

  package JQWtable::Activity;

  use Moose; use Method::Signatures;

  extends 'JQWtable::JQWtable';
  with    'JQWtable::Role';

  method colls    { " id, name, alias "; }
  method from     { " activity "; }
  method where    { " "; }
  method limit    { " "; }
  method order_by { " "; }
  method group_by { " "; }

Then call this module

  print JQWtable::Activity->new->list->col_info;

=head1 METHODS

=head2 list_show

Show data in MySQL cli console view

=head2 col

Return array which contain cols names:
  say $_ foreach $o->col;

=head2 col_info

Return hashref with contain cols info. Like this:
 'id' => {
    'type'        => 'string',
    'filtertype'  => 'textbox',
    'col_percent' => '13.68',
    'val'         => '03c1df67-e01d-449f-b6a5-16be3b6e2bfc'
  }

=head2 col_jqw

Return hashref with contain cols info foe JQWidgets Grid. Like this:
{
 'datafields' => [{'name' => 'id','type' => 'string'}],
 'columns' => [
   {
     'text' => 'id',
     'datafield' => 'id',
     'filtertype' => 'textbox',
     'width' => '23.04%',
     'cellsalign' => 'right'
   },
 ]
};

=head1 TODO

=over 4

=item *
new

=item *
one

=back

=head1 AUTHORS

Babiychuk Ivan

=head1 COPYRIGHT AND LICENSE

This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.

=head1 HISTORY

Version 0.1: first release; 2018

=cut

1;


