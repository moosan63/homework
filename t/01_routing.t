use Test::More;
use Test::Mock::LWP::Conditional;
use LWP::UserAgent;
use HTTP::Response;

subtest 'get / ' => sub{
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get("http://localhost:5000/");
  is $res->code => 200, "ok";

};

subtest 'get /:id' => sub {
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get("http://localhost:5000/5248e9b49167bb728a000002");
  is $res->code => 200, "ok";
};

subtest 'post /' => sub{
  my $ua = LWP::UserAgent->new;
  my $res = $ua->post("http://localhost:5000/");
  is $res->code => 200, "ok";
};

subtest 'post /:id/update' => sub{
  my $ua = LWP::UserAgent->new;
  my $res = $ua->post("http://localhost:5000/52491f279167bb728a000004/update");
  is $res->code => 302, "redirect";
};

subtest 'post /:id/delete' => sub{
  my $ua = LWP::UserAgent->new;
  my $res = $ua->post("http://localhost:5000/52491f279167bb728a000004/delete");
  is $res->code => 200, "ok";
};

done_testing();