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
    return [ grep { GRU::Math::check_beta_function( $cue_stats->{$_}{hits}, $cue_stats->{$_}{tries} ) < rand() } @$cues ];
}

sub _guess {
    my( $self, $cues ) = @_;
    my $cue2node = $self->get__cue2node();

    # pick node candidates
    my( %node_id, %scores );

    my $cue_stats = $self->get__cue_stats();
    print STDERR Data::Dumper->Dump(["To winnow : ".join(',',map { "($_,$cue_stats->{$_}{hits},$cue_stats->{$_}{tries})" } @$cues)]);

    $cues = $self->_winnow_cues( $cues );

    print STDERR Data::Dumper->Dump(["Winnowed to ", join( ',', @$cues ) ]);

    for my $cue (@$cues) {
	my @nodes = values %{$cue2node->{$cue}||{}};
	print STDERR Data::Dumper->Dump(["$cue => ".join(',',map { $_->get_name() } @nodes)]);
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
    my( $self, $cues, $guessed_node, $was_guessed_correctly ) = @_;

    my $train_node = $guessed_node || new GRU::Node();

    my $cue2node  = $self->get__cue2node();
    my $cue_stats = $self->get__cue_stats();
    for my $cue (@$cues) {
	$cue_stats->{$cue}{tries}++;
	if( $was_guessed_correctly ) { 
	    $cue_stats->{$cue}{hits}++;
	}
	$cue2node->{$cue}{ $train_node->{ID} } = $train_node;
    }
    
    $train_node->train( $cues );

    print STDERR Data::Dumper->Dump(["Trained " . $train_node->get_name() . " with : " . join( ',', @$cues )]);

    return $train_node;

} #_train

1;

__END__
