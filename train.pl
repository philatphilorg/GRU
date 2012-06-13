#!/usr/bin/perl

use strict;

use Yote::YoteRoot;

use Carp;
$SIG{ __DIE__ } = sub { Carp::confess( @_ ) };

# -----------------------------------------------------
#               init
# -----------------------------------------------------
Yote::ObjProvider::init(
    sqlitefile     => "/usr/local/yote/data/SQLite.yote.db",
    );

my $root = Yote::YoteRoot::fetch_root();
my $app   = $root->fetch_app_by_class( 'GRU::AnimalLearningGame' );
my $gru   = $app->get__animal_gru();

my $sets = '
elephant : big grey with a trunk afriad of mice eats peanuts
hedgehog : curls up into a spikey ball cuffs cute
cat : this animal is kept as a pet and is cute and eats mice and meows and purrs
dog : mans best friend with a waggly tail and woofs and barks and bowwows with a woof bark
wolf : howls at the moon and hunts in the forest and lives in a pack or packs
snake : slithers in the grass. with a slither and a forked tongue this animal will hiss and has scales
fish : swims in the ocean and breathes water and has scales
dolphin : playful mammal that lives in the ocean
shark : preditor fish of the ocean with rows of teeth
mosquito : a bug that sucks your blood
bat : a flying mammal
squirrel : eats nuts and lives in trees with a big bushy tail
beaver : flat tail and buck teeth and builds dams and knaws trees
capybara : biggest rodent
mouse : small cheese eating rodent that squeaks
whale : huge big ocean mammal with a blowhole
cheetah : fastest land animal big feline cat
lion : king of the jungle with a mane and hunts in prides and roars
horse : has a mane and a tufted tail and gallops and races and whickers and whinnies
zebra : black and white striped horse from africa
tiger : orange and black striped large cat
walrus : big sea mammal with tusks
ferret : slinky playful pet with a long body
spider : eight legs 8 and fangs
insect : a tiny animal with 6 six legs sometimes with wings
';
for my $set (split( /[\n\r]+/, $sets ) ) {
    my( $animal, $cues ) = split( /:/, $set );
    $animal =~ s/[^a-z]//g;
    my @cues = grep { /\S/ } split( /\s+/, $cues );
    print STDERR Data::Dumper->Dump([$animal,\@cues]);
    my $node  = $gru->_train( \@cues );
    $node->set_name( $animal );
}

Yote::ObjProvider::stow_all();
