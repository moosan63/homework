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
subtest 'get /nothing' => sub {
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get("http://localhost:5000/hoge/5248e9b49167bb728a000002");
  is $res->code => 404, "not found";
};

done_testing();