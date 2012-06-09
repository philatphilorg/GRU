package GRU::Node;

use strict;

use base 'Yote::Obj';

use GRU::Math;

sub init {
    my $self = shift;
    $self->set__cue( {} );
}

sub _score_cue {
    my( $self, $cue ) = @_;

    my $alpha = $self->get__cue()->{$cue} || 1;
    my $beta  = $self->get__train_count() || 1;

    return GRU::Math::beta_function( $alpha, $beta );

} #_score_cue

sub _score {
    my( $self, $cues ) = @_;
    my $score = 0;
    $self->{vol}{active_cues} = {};
    for my $cue (@$cues) {
	my $cue_score = $self->_score_cue( $cue );
	if( $cue_score <= rand() ) {
	    $score += $cue_score;
	}
    } #each cue
    return $score;
} #_score

sub train {
    my( $self, $cues ) = @_;
    $self->set__train_count( 1 + $self->get__train_count() );
    for my $cue (@$cues) {
	$self->get__cue()->{$cue}++;
    }
    return $self;
} #train


sub cues {
    my $self = shift;
    my $cues = $self->get__cue();
    my %c2s = map { $_ => $self->_score_cue( $_ ) } @$cues;
    return [ sort { $c2s{$b} <=> $c2s{$a} } @$cues ];
} #cues

1;

__END__
