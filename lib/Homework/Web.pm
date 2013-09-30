package Homework::Web;
 
use strict;
use warnings;
use utf8;
use Kossy;
use Homework::Model;
use Data::Dumper;
use Homework::Mongo;

# $self->model : MySQL
# $self->mongo : MongoDB

sub model{
    my $self = shift;
    $self->{_model} ||= Homework::Model->new;     
}

sub mongo{
    my $self = shift;
    $self->{_mongo} ||=Homework::Mongo->init;
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
    #my $todos = $self->model->search('todos',{},{order_by => {'priority' => 'DESC' }});
    my $todos = $self->mongo->query->sort({priority=>-1});
    $c->render('index.tx', { todos => $todos} );
};

#create
post '/' => sub {
    my ($self, $c ) = @_;
    my $body = $c->req->parameters->{body};
    my $genre = $c->req->parameters->{genre};
    my $priority = $c->req->parameters->{priority};

    $self->mongo->insert({ 
        body => $body,
        genre => $genre,
        priority => $priority,
                   });
    my $todos = $self->mongo->find;
    #my $todos = $self->model->search('todos',{},{order_by => {'priority' => 'DESC' }});
    $c->render('index.tx', { todos => $todos} );
};

#show
get '/:id' => sub {
    my ($self, $c) = @_;
    my $id = $c->args->{id};

    my $todo = $self->mongo->find_one({_id=>MongoDB::OID->new(value => $id)}); 
    $c->render('show.tx',{todo => $todo, id =>$c->args->{id} },); 
};


#update putもしくはpatchメソッドが欲しい
post '/:id/update' => sub{
    my ($self, $c) = @_;
    my $id = $c->args->{id};

    my $body = $c->req->parameters->{body};    
    my $genre = $c->req->parameters->{genre};    
    my $priority = $c->req->parameters->{priority};
   
    $self->mongo->update(
        {"_id"=>MongoDB::OID->new(value => $id)},
        {
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
    print Dumper $c->args->{id};

    $self->mongo->remove({_id => MongoDB::OID->new(value => $id)});

    my $todos = $self->mongo->find;
    $c->render('index.tx', { todos => $todos} );
};
1;

