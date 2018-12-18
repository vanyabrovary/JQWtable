package JQWtable::Role;

use Moose::Role;

requires 'colls';
requires 'from';
requires 'where';
requires 'limit';
requires 'order_by';
requires 'group_by';

1;
