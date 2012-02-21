#!/usr/bin/perl
#
use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
          author      => 'Tony G.',
          contact     => 'tonyskapunk@tonyskapunk.net',
          name        => 'op',
          description => 'Provides op mode based on a list if op is granted',
          license     => 'GNU GPL v2',
          url         => 'http://www.tonyskapunk.net'
         );

sub op {
  my ($server, $channel_name, $nick, $address) = @_;
  my @oplist= qw(gnubot);
  my $channel = Irssi::channel_find $channel_name;
  my $opstatus = $channel->{'chanop'};
  if ($opstatus) {
    if (grep /$nick/i, @oplist) {
      $channel->command('op '.$nick);
    }
  }   
 else {
   return 0;
 }
}

  else {
    return 0;
  }
}

Irssi::signal_add("message join", "op");
