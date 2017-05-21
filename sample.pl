use lib './.cpan/lib/perl5';
use Encode;
use WWW::Mechanize;
use Web::Scraper;
use Data::Dumper;

$userid = shift || '';
$password = shift || '';

#my $baseUrl  = 'https://dailynews.yahoo.co.jp';
#my $mech     = WWW::Mechanize->new(autocheck=>1);
#$mech->agent_alias("Windows Mozilla");
#$mech->get( $baseUrl );
 


$mech=new WWW::Mechanize(autocheck=>1);
$mech->get("https://www.google.co.jp/");
$mech->submit_form(fields => {q=>"Englsh"});

print $mech->content;

