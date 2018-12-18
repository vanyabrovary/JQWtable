package JQWtable::JQWtableType;

use latest;

use Moose;
use Method::Signatures;
use Data::Types qw(:all);

method get_datatype( $val ) {
  return 'int'    if is_int(    $val );
  return 'float'  if is_float(  $val );
  return 'string' if is_string( $val );
  return 'number' if is_count(  $val )  or is_real($val);
  return 'date'   if is_int(    $val ) and length($val) == 8;
  return 'bool'   if is_string( $val ) and length($val) == 1;
}

method get_filtertype( $val ) {
  return 'date'     if $val eq 'date';
  return 'checkbox' if $val eq 'bool';
  return 'textbox'  if $val eq 'string';
  return 'number'   if $val eq 'float' or $val eq 'number' or $val eq 'int';
}


1;


