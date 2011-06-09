#!/usr/bin/perl

use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
                    author      => 'Tony G.',
          contact     => 'tonyskapunk@tonyskapunk.net',
          name        => 'coin',
          description => 'Says a Random user in channel',
          license     => 'GNU GPL v2',
          url         => 'http://www.tonyskapunk.net'
         );

sub coin {
  my ($server, $msg, $nick, $address, $target) = @_;
  # Add nicks to blacklist them
  my @blacklist = ("gnubot" );
  if ( $msg =~ /!coin/i ) {
    my $channel = Irssi::channel_find $target;
    my @nicks = $channel->nicks;
    my @nicklist = ();
    foreach my $nick (@nicks) {
      unless ( grep /$nick->{nick}/i, @blacklist ) {
        push( @nicklist, $nick->{nick} );
      }
    }
    my $total_nicks = @nicklist;
    my $winner = int(rand($total_nicks));
    $server->command('msg '.$target.' '.$nick.': '.$nicklist[$winner]);
  }
  else {
    return 0;
  }
}

Irssi::signal_add("message public", "coin");
