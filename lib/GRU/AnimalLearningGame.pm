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
    my $cues = [ map { s/[^a-zA-Z0-9_-]+//gs; $_ } map { lc( $_ ) } values %$data];

    my $ret = $gru->_guess( $cues );  #returns a list of node objects

    print STDERR Data::Dumper->Dump(["GUESS : ".join(',',@$cues),[map { $_->get_name() } @$ret]]);

    return $ret;
} #sub Guess

sub Train {
    my( $self, $data, $acct ) = @_;

    my $cues  = [ map { s/[^a-zA-Z0-9_-]+//gs; $_ } map { lc( $_ ) } values %{$data->{cues}} ];
    my $name  = $data->{name};
    my $guessed_node      = $data->{guessed_node};
    my $was_correct_guess = $data->{was_correct_guess};

    my $train_node = $was_correct_guess ? $guessed_node : new GRU::Node();
    print STDERR Data::Dumper->Dump([$train_node,$was_correct_guess]);    
    my $gru   = $self->get__animal_gru();
    my $node  = $gru->_train( $cues, $train_node, $was_correct_guess );

    print STDERR Data::Dumper->Dump(["TRAINING", $node, join( ',', @$cues ), $name]);

    if( ( ! $was_correct_guess ) && $name ) {
	die "Unable to reset name" if $node->get_name();
	$node->set_name( $name );
    }

    return 1;    
} #sub Train

1;

__END__
