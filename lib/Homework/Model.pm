package Homework::Model;

use strict;
use warnings;
use utf8;
use DBIx::Skinny connect_info =>{
    dsn    => 'dbi:mysql:database=homework;host=localhost',
    username   => 'testuser',
    password => 'testpasswd'
};
1;

package Homework::Model::Schema;
use strict;
use warnings;
use DBIx::Skinny::Schema;

install_table 'todos' => schema {
    pk 'id';
    columns qw/id body genre priority/;
    
};
1;
