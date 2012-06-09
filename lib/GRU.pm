package GRU;

use strict;

use base 'Yote::Obj';

use GRU::Math;

sub init {
    my $self = shift;
    $self->set__cue2node( {} );
    $self->set__cue_stats( {} );
}

sub _winnow_cues {
    my( $self, $cues ) = @_;

    my $cue_stats = $self->get__cue_stats();
    return [ grep { GRU::Math::check_beta_function( $cue_stats->{$_}{hits}, $cue_stats->{$_}{tries} ) } @$cues ];
}

sub _guess {
    my( $self, $cues ) = @_;
    my $cue2node = $self->get__cue2node();

    # pick node candidates
    my( %node_id, %scores );

    $cues = $self->_winnow_cues( $cues );
    
    for my $cue (@$cues) {
	my @nodes = keys %{$cue2node->{$cue}||{}};
	for my $n (@nodes) {
	    $node_id{$n->{ID}} = $n;
	}
    } #each cue candidate

    for my $n (values %node_id) {
	my $score = $n->_score( $cues );
	if( $score > 0 ) {
	    $scores{ $n->{ID} } = $score;
	}
    } #each node
    
    #
    # TODO: have this return rather than a list of nodes, return a list of groups of related nodes
    #
    return [ map { Yote::ObjProvider::fetch( $_ ) } sort { $scores{$b} <=> $scores{$a} } keys %scores ];
} #_guess

sub _train {
    my( $self, $cues, $correctly_guessed_node ) = @_;
    
    my $cue_stats = $self->get__cue_stats();
    for my $cue (@$cues) {
	$cue_stats->{$cue}{tries}++;
	$cue_stats->{$cue}{hits}++ if $correctly_guessed_node;
    }
    
    my $train_node = $correctly_guessed_node || new GRU::Node();
    $train_node->train( $cues );

} #_train

1;

__END__
