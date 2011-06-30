#!/usr/bin/perl

use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
          author      => 'Tony G.',
          contact     => 'tonyskapunk@tonyskapunk.net',
          name        => 'coffee',
          description => 'Tells you how to make coffee',
          license     => 'GNU GPL v2',
          url         => 'http://www.tonyskapunk.net'
         );

sub coffee {
  my ($server, $msg, $nick, $address, $target) = @_;
  my $instructions = "Boil water, serve it in a cup(better if clean), add instant coffe(yeah, low budget), add sugar, stir a bit(better if you do the last 3 steps with a spoon), sip it, burns? is ok, enjoy!  Damn easy, even humans can do it!!";
  my $make_tea = "a nice glass of iced tea is comming your way, would you like some fritos or rancheritos with it ? ";
  if ( $msg =~ /c0ff33/i ) {
    $server->command('msg '.$target.' '.$nick.': '.$instructions); 
  }
  elsif ( $msg =~ /n3st34/i ) {
    $server->command('msg '.$target.' '.$nick.': '.$make_tea); 
  }
  else {
    return 0;
  }
}

Irssi::signal_add("message public", "coffee");
