package GRU::Math;

use strict;

use Math::Random qw/ random_beta /;

sub beta_function {
    my( $alpha, $beta ) = @_;
    return random_beta( 1, $alpha, $beta );
}

sub check_beta_function {
    my( $alpha, $beta ) = @_;
    return random_beta( 1, $alpha, $beta ) <= rand();

}

1;

__END__
