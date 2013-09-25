package Homework::Web;

use strict;
use warnings;
use utf8;
use Kossy;
use DBD::mysql;
use Teng;
use Teng::Schema::Loader;

my $dsn    = 'dbi:mysql:database=homework;host=localhost';
my $user   = 'testuser';
my $passwd = 'testpassword';

my $dbh = DBI -> connect( $dsn, $user, $passwd ,{
                          'mysql_enable_utf8' => 1
                          });

my $teng = Teng::Schema::Loader -> load(
    'dbh' => $dbh,
    'namespace' => 'Homework::DB'
    );

filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        $c->stash->{site_name} = __PACKAGE__;
        $app->($self,$c);
    }
};

get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    my $prev_inputs = $teng->search('inputs', {}, +{limit => 10, order_by => 'id desc'});
    $c->render('index.tx', { greeting => "Hello", results => $prev_inputs });
};

post '/inputs' => sub {
    my ($self, $c ) = @_;
    my $result = $c->req->validator([
        'body' => {
            rule => [
                ['NOT_NULL','empty body'],
                ],
        },
                                    ]);
    $teng->insert( inputs =>{ 
        body => $result->valid('body')
                   });

    my $prev_inputs = $teng->search('inputs', {}, +{limit => 10, order_by => 'id desc'});
    $c->render('index.tx', { results => $prev_inputs });
};
1;

