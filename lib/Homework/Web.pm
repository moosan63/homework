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

#index
get '/' => [qw/set_title/] => sub {
    my ( $self, $c )  = @_;
    my $id = $c->args->{id};
    my $todos = $self->model->search('todos');
    $c->render('index.tx', { greeting => "Hello", results => $todos, id=>$id });
};

#create
post '/' => sub {
    my ($self, $c ) = @_;
    my $id = $c->args->{id};
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

    my $todos = $self->model->search('todos');
    $c->render('index.tx', { results => $todos, id=>$id });
};

#show
get '/:id' => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};

    my $todo = $self->model->single('todos',{id => $id});
    $c->render('show.tx',{todo => $todo }); 
};
#update putもしくはpatchメソッドが欲しい
post '/:id/update' => sub{
    my ($self, $c) = @_;
    my $id = $c->args->{id};
    
    my $result = $c->req->validator([
        'body' => {
            rule => [
                ['NOT_NULL','empty body'],
                ],
        },
                                    ]);
    my $todo = $self->model->single('todos',{id => $id});
    $todo ->({body => $result->valid('body')});

    $c->redirect('/');
};

#delete deleteメソッドが欲しい
post '/:id/delete' => sub{
    my ($self, $c) = @_;
    my $id = $c->args->{id};

    my $todo = $self->model->single('todos',{id => $id});
    $todo -> delete;

    $c->redirect('/');
};
1;

