// chaos_toy.scad

// Chaos Toy part library by W. Craig Trader is dual-licensed under 
// Creative Commons Attribution-ShareAlike 3.0 Unported License and
// GNU Lesser GPL 3.0 or later.

include <MCAD/units.scad>

// ----- Measurements ---------------------------------------------------------

rch = 1 / 128 * inch;

BALL_OD = 92 * rch;

JACK_BASE = 22 * mm; // 111 * rch; 
JACK_SPAR_LEN = 25 * mm; // 126 * rch; // 25 * mm;
JACK_SPAR_WID = 15.5 * mm; // 78 * rch;
JACK_SPAR_DEP = 1.75 * mm; // 9 * rch;
JACK_SIZE = JACK_SPAR_LEN + JACK_BASE + JACK_SPAR_LEN;

TUBE_ID = 78.5 * rch;
TUBE_OD = 96.5 * rch;

TUBE_SMALL = 15 * cm;
TUBE_MEDIUM = TUBE_SMALL + JACK_BASE + TUBE_SMALL;
TUBE_LONG = TUBE_MEDIUM + JACK_BASE + TUBE_SMALL;

CONNECTOR_LENGTH = 39 * rch;

TRACK_RAIL_WIDTH = 25 * rch;
TRACK_RAIL_HEIGHT = 34 * rch;
TRACK_RAIL_SPACING = 96 * rch;
TRACK_BASE_HEIGHT = 26 * rch;
TRACK_BASE_WIDTH = 49 * rch;
TRACK_BASE_ID = 22 * rch;

TRACK_SHORT_LENGTH = 4.5 * inch;
TRACK_LONG_LENGTH = 2 * TRACK_SHORT_LENGTH;

// ----- Measurement Checks ---------------------------------------------------

function inches( d ) =
	str( floor( d/inch ), "+", floor( 128 * ( d/inch - floor( d/inch ) ) ), "/128 in." );

function verbose_measurement( label, dimension ) = 
	str( label, " = ", dimension, "mm or ", inches( dimension ) );

module echo_all_measurements() {
	echo( verbose_measurement( "Ball diameter", BALL_OD ) );

	echo( verbose_measurement( "Tube inside diameter", TUBE_ID ) );
	echo( verbose_measurement( "Tube outside diameter", TUBE_OD ) );

	echo( verbose_measurement( "Small tube length", TUBE_SMALL ) );
	echo( verbose_measurement( "Medium tube length", TUBE_MEDIUM ) );
	echo( verbose_measurement( "Long tube length", TUBE_LONG ) );

	echo( verbose_measurement( "Jack base", JACK_BASE ) );
	echo( verbose_measurement( "Jack spar length", JACK_SPAR_LEN ) );
	echo( verbose_measurement( "Jack spar width", JACK_SPAR_WID ) );
	echo( verbose_measurement( "Jack spar depth", JACK_SPAR_DEP ) );
	echo( verbose_measurement( "Jack size", JACK_SIZE ) );
}

// echo_all_measurements();

// ----- Ball -----------------------------------------------------------------

module ball () {
	color( [1,1,0,1] ) 
	sphere( r=BALL_DIAMETER );
}

// ----- Tubes ----------------------------------------------------------------

module tube( length ) {
	color( [0,0,1,1] )
	difference() {
		cylinder( h=length, r=TUBE_OD/2, center=true, $fn=90 );
		cylinder( h=length+2*mm, r=TUBE_ID/2, center=true, $fn=90 );
	}
}

// ----- Jacks ----------------------------------------------------------------

module jack_spar() {
	x = JACK_SIZE / 2;
	y = JACK_SPAR_WID / 2;
	difference() {
		cube( [ JACK_SIZE, JACK_SPAR_WID, JACK_SPAR_DEP ], true );
		translate( [+x,+y,0] ) rotate( [0,0,45] ) cube( 4*mm, true );
		translate( [+x,-y,0] ) rotate( [0,0,45] ) cube( 4*mm, true );
		translate( [-x,+y,0] ) rotate( [0,0,45] ) cube( 4*mm, true );
		translate( [-x,-y,0] ) rotate( [0,0,45] ) cube( 4*mm, true );
	}
}

module jack() {
	color( [0,0,0,1] )
	union() {
		jack_spar();
		rotate( [00,00,90] ) jack_spar();
		rotate( [00,90,00] ) jack_spar();
		rotate( [00,90,90] ) jack_spar();
		rotate( [90,00,00] ) jack_spar();
		rotate( [90,00,90] ) jack_spar();
		cube( JACK_BASE, center=true );
	}
}

// ----- Straight Track -------------------------------------------------------

module track_base( length ) {
	offset = -1 * mm;
	difference() {
		cube( [ length, TRACK_BASE_WIDTH, TRACK_BASE_HEIGHT ], true );
		translate( [0, 0, offset ] ) rotate( [ 0, 90, 0 ] ) 
			cylinder( h=length+2*mm, r=TRACK_BASE_ID/2, center=true, $fn=45 );
		translate( [0, 0, -TRACK_BASE_ID/2+offset ] ) 
			cube( [ length+2*mm, TRACK_BASE_ID, TRACK_BASE_ID ], center=true );
	}
}

track_base( TRACK_SHORT_LENGTH );
