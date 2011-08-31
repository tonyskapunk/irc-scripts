#!/usr/bin/perl
#

use HTML::TableContentParser;
use strict;

my $html = '';
my $link = "http://www.linux-mx.org/ensartadas/list/";
my %list = ();


sub listar {
  my $list_ref = shift;
  my %list = %$list_ref;
  return (sort keys %list);
}

sub sort_asc {
  my $list_ref = shift;
  my %list = %$list_ref;
  my @lista;
  foreach (keys %list) {
    push @lista, "$list{$_},$_";
  }
  return sort { $a <=> $b } @lista;
}

sub sort_desc {
  my $list_ref = shift;
  my %list = %$list_ref;
  my @lista;
  foreach (keys %list) {
    push @lista, "$list{$_},$_";
  }
  return sort { $b <=> $a } @lista;
}

sub top5_ensarte {
  my $list_ref = shift;
  my %list = %$list_ref;
  my @top_ensart = sort_desc \%list;
  for (my $i=0; $i <5; $i++) {
    my ($count, $ensart) = split(/,/, $top_ensart[$i]);
    printf "%s) %s -> %s\n", ($i + 1), $ensart, $count;
  }
}

sub bot5_ensarte {
  my $list_ref = shift;
  my %list = %$list_ref;
  my @bot_ensart = sort_asc \%list;
  for (my $i=0; $i <5; $i++) {
    my ($count, $ensart) = split(/,/, $bot_ensart[$i]);
    printf "%s) %s -> %s\n", ($i + 1), $ensart, $count;
  }
}

sub ensartometro {
  my $list_ref = shift;
  my %list = %$list_ref;
  my %ensartados = ();
  my %ensartadores = ();
  foreach my $id (keys %list) {
    my $ensartado = $list{$id}[0];
    my $por = $list{$id}[1];
    if (exists $ensartados{$ensartado}) {
      $ensartados{$ensartado} += 1;
    }
    else {
      $ensartados{$ensartado} = 1;
    }
    if (exists $ensartadores{$por}) {
      $ensartadores{$por} += 1;
    }
    else {
      $ensartadores{$por} = 1;
    }
  }
  return (\%ensartados, \%ensartadores);
}

my $parsetable = HTML::TableContentParser->new();
open(FILE, "/home/tonyskapunk/ensartadas.html") or die $!;
while (<FILE>) {
  $html .= $_;
}
close(FILE);

my $tables = $parsetable->parse($html);
# [0] Menu [1] Sesion [2] Lista [3] Empty [4] Calendario [5] Contador [6] Null
my $ensartes = ${@$tables}[2];

for my $row (@{$ensartes->{rows}}) {
  my $id = ${@{$row->{cells}}}[0]->{data};
  my $ensartado = ${@{$row->{cells}}}[1]->{data};
  my $fecha = ${@{$row->{cells}}}[2]->{data};
  my $por = ${@{$row->{cells}}}[3]->{data};
  next if $id =~ /[^\d]+/;
  $list{$id} = [$ensartado, $por, $fecha];
  #printf "%s: [%s] fue ensartado por (%s) el %s\n", $id,$ensartado,$por,$fecha;
}

my ($ref_ensartados, $ref_ensartadas) = ensartometro(\%list);
my %ensartados = %{$ref_ensartados};
my %ensartadas = %{$ref_ensartadas};
my @ensartados = listar(\%ensartados);
my @ensartadas = listar(\%ensartadas);

#top5_ensarte \%ensartados;
#bot5_ensarte \%ensartados;
top5_ensarte \%ensartadas;
#bot5_ensarte \%ensartadas;


