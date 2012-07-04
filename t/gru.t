#!/usr/bin/perl

use strict;

use Yote::YoteRoot;

use Test::More;

use vars qw($VERSION);
$VERSION = '0.01';

use Carp;
$SIG{ __DIE__ } = sub { Carp::confess( @_ ) };

use File::Temp qw/ :mktemp /;

# -----------------------------------------------------
#               init
# -----------------------------------------------------
unlink( "GruTest" );
Yote::ObjProvider::init(
    sqlitefile     => "GruTest",
    );
test_suite();

done_testing();

sub test_suite {
    my $root = Yote::YoteRoot::fetch_root();
    my $alg  = $root->fetch_app_by_class( 'GRU::AnimalLearningGame' );
    ok( $alg, "Loaded animal learning game app" ) || BAIL_OUT( "Unable to load animal learning game" );

    my $cues = {  map { $_ => $_ } qw/ big brown growly/ };
    my $res = $alg->Guess( $cues );
    is( scalar( @$res ), 0, 'no results at first' );
    my $r = $alg->Train( { cues => $cues, name => 'bear' } );
    is( $r, 1, 'train result' );

    my $res = $alg->Guess( $cues );
    is( scalar( @$res ), 1, 'one results at first' );

} #test_suite
