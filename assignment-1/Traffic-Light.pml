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
	assert( 
		(NS_RED_LIGHT <> NS_GREEN_LIGHT) 
		OR 
		(NS_YELLOW_LIGHT <> NS_GREEN_LIGHT) 
		OR 
		(NS_RED_LIGHT <> NS_YELLOW_LIGHT) 
	)
}
