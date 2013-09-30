package Homework::Mongo;

use strict;
use warnings;
use utf8;

use MongoDB;
use MongoDB::OID;

sub init {
    my $client = MongoDB::MongoClient ->new;
    my $db = $client->get_database('homework');
    my $todos = $db->get_collection('todos');
}

1;
