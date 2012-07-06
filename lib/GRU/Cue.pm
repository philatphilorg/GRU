package GRU::Cue;

use strict;

use base 'Yote::Obj';

use GRU::Math;

sub init {
    my $self = shift;
    $self->set__tries( 1 );
    $self->set__hits( 1 );
    $self->set__node_stats( {} );
} #init

# return true if this should be used
sub _use {
    my $self = shift;
    return GRU::Math::check_beta_function( $self->get__hits(), $self->get__tries() );
} #_use

sub _train {
    my( $self, $node, $succeeded ) = @_;
    $self->set__tries( $self->get__tries() + 1 );
    my $node_stats = $self->get__node_stats();
    $node_stats->{ $node->{ID} }{ tries }++;
    if( $succeeded ) {
	$self->set__hits( $self->get__hits() + 1 );
	$node_stats->{ $node->{ID} }{ hits }++;
    }
} #_train

sub _score_nodes {
    my $self = shift;
    
    my $cue_val = GRU::Math::beta_function(
	$self->get__hits(),
	$self->get__tries()
	);
    return {} unless $cue_val;
    my %node_id2score;
    my $node2stats = $self->get__node_stats();
    for my $node_id (keys %$node2stats) {
	$node_id2score{$node_id} = $cue_val * GRU::Math::beta_function( 
	    $node2stats->{$node_id}{ hits },
	    $node2stats->{$node_id}{ tries },
	    );
    }
    print STDERR Data::Dumper->Dump([$self->get_label()." score $cue_val", [ map { Yote::ObjProvider::fetch( $_ )->get_name() . " : $node_id2score{$_}" } keys %node_id2score ]]);
    return \%node_id2score;
} #_score

1;

__END__
