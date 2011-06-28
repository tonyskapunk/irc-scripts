#!/usr/bin/perl

use Irssi;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";
%IRSSI = (
          author      => 'Ivan Zenteno',
          contact     => 'izenteno@freebsd.org.mx',
          name        => 'chela',
          description => 'Tells you how to drink a chela, and delivers one',
          license     => 'GNU GPL v2',
          url         => 'http://www.freebsd.org.mx'
         );

sub chela {
  my ($server, $msg, $nick, $address, $target) = @_;
  my $instructions = " Aunque para muchos esto suene a chiste, el tomar ".
  "cerveza con moderación tiene sus beneficios para el organismo. Tomar ".
  "cerveza reduce el riesgo de infarto y otras enfermedades ".
  "cardiovasculares. Reduce el estreñimiento, por su contenido de fibra. ".
  "Dicen que retrasa la menopausia (en un año) y sus consecuencias. Para ".
  "las mujeres embarazadas, previene la anemia y posibles mal formaciones ".
  "en el feto por su contenido de ácido fólico, pues claro se recomienda ".
  "que beban cerveza sin alcohol. Tomar una cerveza al día ayuda a la ".
  "producción de Leche materna. ".
  "Tiene vitaminas como B1, B2 y B12, que facilitan la digestión, retrasa ".
  "el envejecimiento celular, contiene Potasio que ayuda en la potencia ".
  "muscular.";
  my $beer = "A cold beer is delivered right away, enjoy while it last, there is no better thing than washing the taste with another one";
  if ( $msg =~ /!chela/i ) {
    $server->command('msg '.$target.' '.$nick.': '.$instructions); 
  }
  elsif ( $msg =~ /!ch3l4/i ) {
    $server->command('msg '.$target.' '.$nick.': '.$beer); 
  }
  else {
    return 0;
  }
}

Irssi::signal_add("message public", "chela");
