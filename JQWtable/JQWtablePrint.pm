package JQWtable::JQWtablePrint;

use latest;

use Moose;
use Method::Signatures;
use Text::SimpleTable;

method col_print        { say $_.", " foreach $self->col; }

method list_show {
  ## set header
  my @cols;
  push @cols, [ $self->{col_lenght}{$_} , $_ ] for ( sort sort keys %{ $self->col_lenght } );
  my $t = Text::SimpleTable->new( @cols );
  ## set rows
  $t->row( @{ $self->{rows}->{$_} } ) for( sort keys %{ $self->rows } );
  return $t->draw;
}

method col_jqw_json     {
 use Data::Dumper;
 {
   local $Data::Dumper::Terse     = 0; # without $VAR1
   local $Data::Dumper::Indent    = 1; # \n
   local $Data::Dumper::Useqq     = 1; # cellsalign:"right" OR cellsalign:'right',
   local $Data::Dumper::Deparse   = 1;
   local $Data::Dumper::Quotekeys = 1;
   local $Data::Dumper::Sortkeys  = 1;
   local $Data::Dumper::Pair      = ':';
   return Dumper($self->col_jqw);
 }
}

1;
