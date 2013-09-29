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
    my $todos = $self->model->search('todos',{},{order_by => {'priority' => 'DESC' }});
    $c->render('index.tx', { todos => $todos} );
};

#create
post '/' => sub {
    my ($self, $c ) = @_;
    my $body = $c->req->parameters->{body};
    my $genre = $c->req->parameters->{genre};
    my $priority = $c->req->parameters->{priority};

    $self->model->insert( 'todos', { 
        body => $body,
        genre => $genre,
        priority => $priority,
                   });

    my $todos = $self->model->search('todos',{},{order_by => {'priority' => 'DESC' }});
    $c->render('index.tx', { todos => $todos} );
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

    my $body = $c->req->parameters->{body};    
    my $genre = $c->req->parameters->{genre};    
    my $priority = $c->req->parameters->{priority};

    my $todo = $self->model->single('todos',{id => $id});
    $todo ->update({
        body => $body,
        genre => $genre,
        priority => $priority,    
                   });

    $c->redirect('/');
};

#delete deleteメソッドが欲しい
post '/:id/delete' => sub{
    my ($self, $c) = @_;
    my $id = $c->args->{id};

    my $todo = $self->model->single('todos',{id => $id});
    $todo -> delete;

    my $todos = $self->model->search('todos',{},{order_by => {'priority' => 'DESC' }});
    $c->render('index.tx', { todos => $todos} );
};
1;

