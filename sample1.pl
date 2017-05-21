#!/usr/bin/perl
use lib './.cpan/lib/perl5';
use Encode;
use WWW::Mechanize;
use Web::Scraper;

my $baseUrl  = 'http://dailynews.yahoo.co.jp';
#my $yahooUrl = 'http://dailynews.yahoo.co.jp/fc/';
my $yahooUrl = 'https://news.yahoo.co.jp/topics';
my $encstr   = 'euc-jp';
my $mech     = WWW::Mechanize->new(autocheck=>1);
 
my $topicsMenuParse = scraper {
      process '//div[@id="globalNav"]/ul[@id="gnSec"]//li',  "menulinks[]"=> scraper {
           process "a", href=>'@href';
           process "a", text=>"TEXT";
      }
};
 
my $topicsLinkParse = scraper {
      process '//div[@id="topics"]/div[@class="topicsList"]/ul[@class="clr"]//li', "topiclinks[]"=> scraper {
           process "span", date=>"TEXT";
           process "a",    href=>'@href';
           process "a",    text=>"TEXT";
      }
};

my $menuResult;
 
  $mech->agent_alias("Windows Mozilla");
 
  $mech->get( $yahooUrl );
  $menuResult = $topicsMenuParse->scrape( $mech->content );
 
  foreach my $categoryLink ( @{ $menuResult->{menulinks} } )
  {
      my $topicResult;
      my $text = encode($encstr, $categoryLink->{text});
      my $href = encode($encstr, $categoryLink->{href});
 
        printf("*** %s ( %s )\n",  $text, $href);
 
        $mech->get( "".$categoryLink->{href} );
        $topicResult = $topicsLinkParse->scrape( $mech->content );
 
        foreach my $topicLink ( @{ $topicResult->{topiclinks} } )
        {
           my $date = encode($encstr, $topicLink->{date});
           my $text = encode($encstr, $topicLink->{text});
           my $href = encode($encstr, $topicLink->{href});
 
             printf("%s %s ( %s )\n",  $date, $text, $baseUrl.$href);
        }
  }
