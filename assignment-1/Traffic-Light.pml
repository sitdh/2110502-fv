#define ON	1
#define OFF 0

int RED_LIGHT		= ON
int YELLOW_LIGHT	= OFF
int GREEN_LIGHT		= OFF

active proctype northSouthLane() 
{
red:	( ( RED_LIGHT == YELLOW_LIGHT ) AND ( YELLOW_LIGHT == GREEN_LIGHT ) AND ( RED_LIGHT == OFF ) ) OR ( GREEN_LIGHT == ON ) ->
			atomic {
				RED_LIGHT		= ON
				YELLOW_LIGHT	= OFF
				GREEN_LIGHT		= OFF
			}
			assert( GREEN_LIGHT == OFF )
			assert( RED_LIGHT == ON )
			goto yellow;

yellow: RED_LIGHT == ON ->
			atomic {
				RED_LIGHT		= OFF
				YELLOW_LIGHT	= ON
				GREEN_LIGHT		= OFF
			}
			assert( RED_LIGHT == OFF )
			assert( YELLOW_LIGHT == ON )
			goto yellow;

green:	YELLOW_LIGHT == ON ->
			atomic {
				RED_LIGHT		= OFF 
				YELLOW_LIGHT	= OFF
				GREEN_LIGHT		= ON
			}
			assert( YELLOW_LIGHT == OFF )
			assert( GREEN_LIGHT == ON )
			goto red;
}

active proctype AssertInvariant() 
{
	/**
	 * All Traffic light could not turn on at once
	 **/
	assert(
		( RED_LIGHT <> GREEN_LIGHT )
		OR	
		( RED_LIGHT <> YELLOW_LIGHT )
		OR	
		( YELLOW_LIGHT <> ON )
	)

	/**
	 * 2 of 3 Traffic light could not turn on at the same time
	 * --
	 * Red and Yellow
	 **/
	assert(
		( RED_LIGHT <> YELLOW_LIGHT )
		AND
		( YELLOW_LIGHT <> ON )
	)

	/**
	 * Red and Green
	 **/
	assert(
		( RED_LIGHT <> GREEN_LIGHT )
		AND
		( GREEN_LIGHT <> ON )
	)

	/**
	 * Yellow and Green
	 **/
	assert(
		( YELLOW_LIGHT <> GREEN_LIGHT )
		AND
		( GREEN_LIGHT <> ON )
	)

}
