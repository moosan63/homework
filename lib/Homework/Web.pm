package Homework::Web;
 
use strict;
use warnings;
use utf8;
use Kossy;
use Homework::Model;
use Data::Dumper;
sub model{
    my $self = shift;
    $self->{_model} ||= Homework::Model->new;     
}


filter 'set_title' => sub {
    my $app = shift;
    sub {
        my ( $self, $c )  = @_;
        $c->stash->{site_name} = __PACKAGE__;
        $app->($self,$c);
    }
};

get '/' => sub {
    my ( $self, $c )  = @_;
    my $prev_inputs = $self->model->search('todos');
    $c->render('index.tx', { greeting => "Hello", results => $prev_inputs });
};

post '/' => sub {
    my ($self, $c ) = @_;
    my $result = $c->req->validator([
        'body' => {
            rule => [
                ['NOT_NULL','empty body'],
                ],
        },
                                    ]);
    $self->model->insert( todos =>{ 
        body => $result->valid('body')
                   });

    my $prev_inputs = $self->model->search('todos');
    $c->render('index.tx', { results => $prev_inputs });
};
1;

