#define ON	1
#define OFF 0

int NS_RED_LIGHT	= ON
int NS_YELLOW_LIGHT	= OFF
int NS_GREEN_LIGHT	= OFF

active proctype northSouthLane() 
{
red:	NS_RED_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= ON
				NS_GREEN_LIGHT	= OFF
			}
			goto green;

green: NS_YELLOW_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= ON
			}
			goto yellow;

yellow:	NS_GREEN_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= ON 
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= OFF
			}
			goto red;
}

active proctype AssertInvariant() 
{
	/**
	 * All Traffic light could not turn on at once
	 **/
	assert(
		( NS_RED_LIGHT <> NS_GREEN_LIGHT )
		OR	
		( NS_RED_LIGHT <> NS_YELLOW_LIGHT )
		OR	
		( NS_YELLOW_LIGHT <> ON )
	)

	/**
	 * 2 of 3 Traffic light could not turn on at the same time
	 * --
	 * Red and Yellow
	 **/
	assert(
		( NS_RED_LIGHT <> NS_YELLOW_LIGHT )
		AND
		( NS_YELLOW_LIGHT <> ON )
	)

	/**
	 * Red and Green
	 **/
	assert(
		( NS_RED_LIGHT <> NS_GREEN_LIGHT )
		AND
		( NS_GREEN_LIGHT <> ON )
	)

	/**
	 * Yellow and Green
	 **/
	assert(
		( NS_YELLOW_LIGHT <> NS_GREEN_LIGHT )
		AND
		( NS_GREEN_LIGHT <> ON )
	)

	/**
	assert( 
		(NS_RED_LIGHT <> NS_GREEN_LIGHT) 
		OR 
		(NS_YELLOW_LIGHT <> NS_GREEN_LIGHT) 
		OR 
		(NS_RED_LIGHT <> NS_YELLOW_LIGHT) 
	)

	assert(
		NS_RED_LIGHT == NS_GREEN_LIGHT
		AND
		NS_RED_LIGHT <> ON
	)
	**/
}
