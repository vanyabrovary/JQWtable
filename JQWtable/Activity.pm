package JQWtable::Activity;

use latest; use Moose;
use Method::Signatures;

extends 'JQWtable::JQWtable';
with    'JQWtable::Role';

method colls    { " activityid, eventid,  activityname, eventname, eventdate, salesendtime, reserveendtime, created_at, updated_at "; }
method from     { " fm_events "; }
method where    { " "; }
method limit    { " "; }
method order_by { " "; }
method group_by { " "; }

my $o = JQWtable::Activity->new->list;
print $o->col_jqw_json;

1;

