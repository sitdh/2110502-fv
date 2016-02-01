#define ON	1
#define OFF 0

int NS_RED_LIGHT	= OFF
int NS_YELLOW_LIGHT	= OFF
int NS_GREEN_LIGHT	= OFF

int WE_RED_LIGHT	= OFF
int WE_YELLOW_LIGHT	= OFF
int WE_GREEN_LIGHT	= ON

proctype northSouthLane(chan lightSync) 
{
	do
red:	:: NS_RED_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= ON
				NS_GREEN_LIGHT	= OFF
			}

			lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			goto green;

green: :: NS_YELLOW_LIGHT == ON ->

			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= ON
			}

			lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			goto yellow;

yellow:	:: NS_GREEN_LIGHT == ON ->

			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= ON
			}

			lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			goto red;
	od

}

proctype weastEastLane(chan lightSync) 
{
	lightSync ? WE_RED_LIGHT, WE_YELLOW_LIGHT, WE_GREEN_LIGHT;

	do
		:: WE_RED_LIGHT == ON ->
			atomic {
				WE_RED_LIGHT	= OFF
				WE_YELLOW_LIGHT	= ON
				WE_GREEN_LIGHT	= OFF
			}
		:: WE_GREEN_LIGHT == ON ->
			atomic {
				WE_RED_LIGHT	= OFF
				WE_YELLOW_LIGHT	= OFF
				WE_GREEN_LIGHT	= ON
			}
		:: WE_YELLOW_LIGHT == ON ->
			atomic {
				WE_RED_LIGHT	= OFF
				WE_YELLOW_LIGHT	= OFF
				WE_GREEN_LIGHT	= ON
			}
	od
}

active proctype AssertInvariant() 
{
	assert( WE_RED_LIGHT == NS_GREEN_LIGHT )
	assert( WE_GREEN_LIGHT != NS_GREEN_LIGHT )
}

init {
	chan lightSync = [3] of {bit, bit, bit}
	run northSouthLane(lightSync)
	run weastEastLane(lightSync)
}
