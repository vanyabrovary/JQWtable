package JQWtable::EventPrice;

use latest; use Moose;
use Method::Signatures;

extends 'JQWtable::JQWtable';
with    'JQWtable::Role';

method colls    { " id, event_id, price, quote, reserved, created_at, updated_at "; }
method from     { " fm_events_prices "; }

method where    { " "; }
method limit    { " "; }
method order_by { " "; }
method group_by { " "; }

my $o = JQWtable::EventPrice->new->list;
print $o->col_jqw_json;

1;
