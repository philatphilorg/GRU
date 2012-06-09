package GRU::Node;

use strict;

use base 'Yote::Obj';

use GRU::Math;

sub _score_cue {
    my( $self, $cue ) = @_;

    my $alpha = $self->get__train_count() || 1;
    my $beta = $self->get__cue()->{$cue} || 1;

    return GRU::Math::beta_function( $alpha, $beta );

} #_score_cue


1;

__END__
