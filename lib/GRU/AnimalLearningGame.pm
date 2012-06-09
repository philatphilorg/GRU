package GRU::AnimalLearningGame;

use strict;

use base 'Yote::AppRoot';

use GRU;
use GRU::Node;

sub init {
    my $self = shift;
    $self->set__animal_gru( new GRU() );
}

sub Guess {
    my( $self, $data, $acct ) = @_;

    my $gru = $self->get__animal_gru();
    my $cues = $data->{cues};

    return $gru->_guess( $cues );
} #sub Guess

sub Train {
    my( $self, $data, $acct ) = @_;

    my $gru   = $self->get__animal_gru();

    my $cues  = $data->{cues};
    my $name  = $data->{name};
    my $node  = $gru->_train( $cues, $data->{guessed_node} );

    $node->set_name( $name ) if $name;

    return 1;    
} #sub Train

1;

__END__
