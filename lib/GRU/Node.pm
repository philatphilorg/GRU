package GRU::Node;

use strict;

use base 'Yote::Obj';

use GRU::Math;

sub init {
    my $self = shift;
    $self->set__cue( {} );
}
sub _train {
    my( $self, $cues, $was_guessed_correctly ) = @_;
    $self->set__train_count( 1 + $self->get__train_count() );

    if( $was_guessed_correctly ) {
	for my $cue (@$cues) {
	    $self->get__cue()->{$cue}++;
	}
    }
} #train

1;

__END__
