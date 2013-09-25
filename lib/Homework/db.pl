use strict;
use warnings;
use utf8;
use DBD::mysql;
use Teng;
use Teng::Schema::Loader;

my $dsn    = 'dbi:mysql:database=homework;host=localhost';
my $user   = 'testuser';
my $passwd = 'testpassword';

my $dbh = DBI -> connect_info( $dsn, $user, $passwd ,{
                          'mysql_enable_utf8' => 1
                          });

my $teng = Teng::Schema::Loader -> load(
    'dbh' => $dbh,
    'namespace' => 'Homework::DB'
    );

1;
