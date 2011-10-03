#!/usr/bin/perl
#

package ensartadas;

use Exporter;
use HTML::TableContentParser;
use LWP::Simple;
use strict;
use vars qw($VERSION @ISA);
@ISA = qw(Exporter);

$VERSION = '0.1';

sub listar {
  my $list_ref = shift;
  my %list = %{$list_ref};
  my @lista = sort keys %list;
  return \@lista;
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
    #printf "%s: [%s] por (%s)\n", $id,$ensartado, $por;
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

sub new {
  my $proto = shift;
  my $class = ref($proto) || $proto;
  my $self  = {};
  $self->{URL} = "http://www.linux-mx.org/ensartadas/list/all";
  $self->{URL_BY_ID} = "http://www.linux-mx.org/ensartadas/%i";
  my %list = ();
  #
  my $html = get $self->{URL} || die $self->{URL}." Fail!";
  my $parsetable = HTML::TableContentParser->new();
  my $tables = $parsetable->parse($html);
  # [0] Menu [1] Sesion [2] Lista [3] Empty [4] Calendario [5] Contador [6] Null
  my $ensartes = ${@$tables}[2];
  #
  for my $row (@{$ensartes->{rows}}) {
    my $id = ${@{$row->{cells}}}[0]->{data};
    my $ensartado = ${@{$row->{cells}}}[1]->{data};
    my $fecha = ${@{$row->{cells}}}[2]->{data};
    my $por = ${@{$row->{cells}}}[3]->{data};
    next if $id =~ /[^\d]+/;
    $list{$id} = [$ensartado, $por, $fecha];
    #printf "%s: [%s] fue ensartado por (%s) el %s\n", $id,$ensartado,$por,$fecha;
  }
  #
  $self->{LIST} = \%list;
  my ($ref_ensartados, $ref_ensartadas) = ensartometro( $self->{LIST} );
  $self->{ENSARTADOS_HASH} = $ref_ensartados;
  $self->{ENSARTADAS_HASH} = $ref_ensartadas;
  $self->{ENSARTADOS_LIST} = listar( $self->{ENSARTADOS_HASH} );
  $self->{ENSARTADAS_LIST} = listar( $self->{ENSARTADAS_HASH} );
  bless ($self, $class);
  return $self;
}

sub top5_ensartados {
  my $self = shift;
  top5_ensarte $self->{ENSARTADOS_HASH};
  return 0;
}

sub bot5_ensartados {
  my $self = shift;
  bot5_ensarte $self->{ENSARTADOS_HASH};
  ;return 0;
}

sub top5_ensartadas {
  my $self = shift;
  top5_ensarte $self->{ENSARTADAS_HASH};
  return 0;
}

sub bot5_ensartadas {
  my $self = shift;
  bot5_ensarte $self->{ENSARTADAS_HASH};
  return 0;
}

sub ensartadas_por{
  #  $list{$id} = [$ensartado, $por, $fecha];
  my $self = shift;
  my $nickname = '';
  if (@_) { 
    $nickname = shift;
  }
  my @nicks = @{$self->{ENSARTADAS_LIST}};
  unless ( grep($_ eq lc $nickname, @nicks) ) {
    return 0; # nickname not found
  }
  my @lista_de_ensartadas = ();
  my %list = %{$self->{LIST}};
  foreach my $id (keys %list) {
    #printf "%s: [%s] por (%s) |%s\n", $id, $list{$id}[0], $list{$id}[1], $list{$id}[2];
    if ( lc $list{$id}[1] eq lc $nickname  ) {
      push @lista_de_ensartadas, $id;
    }
  }
  return sort @lista_de_ensartadas;
}

sub ensartados_de {
  #  $list{$id} = [$ensartado, $por, $fecha];
  my $self = shift;
  my $nickname = '';
  if (@_) {
    $nickname = shift;
  }
  my @nicks = @{$self->{ENSARTADOS_LIST}};
  unless ( grep($_ eq lc $nickname, @nicks) ) {
    return 0; # nickname not found
  }
  my @lista_de_ensartados = ();
  my %list = %{$self->{LIST}};
  foreach my $id (keys %list) {
    printf "%s: [%s] por (%s) |%s\n", $id, $list{$id}[0], $list{$id}[1], $list{$id}[2];
    if ( lc $list{$id}[0] eq lc $nickname  ) {
      push @lista_de_ensartados, $id;
    }
  }
  return sort @lista_de_ensartados;
}

1;
