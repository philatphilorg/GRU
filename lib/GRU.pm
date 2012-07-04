package GRU;

use strict;

use base 'Yote::Obj';

use GRU::Cue;
use GRU::Math;

sub init {
    my $self = shift;
    $self->set__label2cue( {} );
}

sub _cues {
    my( $self, $labels ) = @_;
    my $label2cue = $self->get__label2cue();
    my @res;
    for my $label (@$labels) {
	my $cue = $label2cue->{ $label };
	unless( $cue ) {
	    $cue = new GRU::Cue();
	    $cue->set_label( $label );
	    $label2cue->{ $label } = $cue;
	}
	push( @res, $cue );
    }
    return \@res;
} #_cues

sub _guess {
    my( $self, $cue_labels ) = @_;

    my $cues = $self->_cues( $cue_labels );

    my( %scores );
    
    for my $cue (@$cues) {
	my $nodes = $cue->_score_nodes();
	for my $node_id (keys %$nodes) {
	    $scores{ $node_id } += $nodes->{$node_id};
	}
    } #each cue

    return [ map { Yote::ObjProvider::fetch( $_ ) } sort { $scores{$b} <=> $scores{$a} } keys %scores ];
    #
    # TODO: have this return rather than a list of nodes, return a list of groups of related nodes
    #
} #_guess

sub _train {
    my( $self, $cue_labels, $guessed_node, $was_guessed_correctly ) = @_;

    my $train_node = $was_guessed_correctly ?  $guessed_node : new GRU::Node();

    my $cues = $self->_cues( $cue_labels );

    for my $cue (@$cues) {
	$cue->_train( $train_node, $was_guessed_correctly );
    }
    
    $train_node->_train( $cues, $was_guessed_correctly );

    return $train_node;

} #_train

1;

__END__
