package DDG::Goodie::CssAnimations;
# ABSTRACT: Shows examples of CSS Animations from various references

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Data::Dumper;
use strict;
use warnings;
use JSON;

zci answer_type => 'css_animations';

zci is_cached => 1;

triggers start => 'css animations', 'css animations example', 'css animation', 'css animation examples', 
                  'css animation demo', 'css animations demos', 'css animations demos', 'css animation demos';

my $animations = LoadFile(share('data.yml'));

handle remainder => sub {
    return unless $_ eq '';
    
    my $demo_count = keys $animations;
    
    my @result = ();
    
    for (my $i=0; $i < $demo_count; $i++) {
        my $demo = "demo_$i";
        my $title = $animations->{$demo}->{'title'};
        my $html = share("$demo/demo.html")->slurp if -e share("$demo/demo.html");
        my $css = share("$demo/style.css")->slurp if -e share("$demo/style.css");
        my $links = share("$demo/links.html")->slurp if -e share("$demo/links.html");
        my %value = ('title' => $title, 'html' => $html, 'css' => $css, 'head' => $links);
        
        $animations->{$demo}->{'html'} = $html;
        $animations->{$demo}->{'css'} = $css;
        $animations->{$demo}->{'links'} = $links;
        $animations->{$demo}->{'value'} = encode_json \%value;
        push(@result, $animations->{$demo});
    }
    
    return 'CSS Animations',
        structured_answer => {
            id => 'css_animations',
            name => 'CSS Animations',
            data => \@result,
            templates => {
                group => 'base',
                detail => 0,
                item_detail => 0,
                options => {
                    content => 'DDH.css_animations.content'
                },
                variants => {
                    tile => 'xwide'
                }
            }
        };
};

1;
