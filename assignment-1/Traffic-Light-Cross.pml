#define ON	1
#define OFF 0

int NS_RED_LIGHT	= ON
int NS_YELLOW_LIGHT	= OFF
int NS_GREEN_LIGHT	= OFF

int WE_RED_LIGHT	= OFF
int WE_YELLOW_LIGHT	= OFF
int WE_GREEN_LIGHT	= ON

proctype northSouthLane(chan lightSync) 
{
red:	NS_RED_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= ON
				NS_GREEN_LIGHT	= OFF
				lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			}
			goto green;

green: NS_YELLOW_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= OFF
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= ON
				lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			}
			goto yellow;

yellow:	NS_GREEN_LIGHT == ON ->
			atomic {
				NS_RED_LIGHT	= ON 
				NS_YELLOW_LIGHT	= OFF
				NS_GREEN_LIGHT	= OFF
				lightSync ! NS_RED_LIGHT, NS_YELLOW_LIGHT, NS_GREEN_LIGHT
			}
			goto red;
}

proctype weastEastLane(chan lightSync) 
{
	byte tmp_red_light, tmp_yellow_light, tmp_green_light

	lightSync ? tmp_red_light, tmp_yellow_light, tmp_green_light;
	printf("NS: RED %d, Yellow %d, Green %d", tmp_red_light, tmp_yellow_light, tmp_green_light)

	do
		:: tmp_red_light == ON ->
			atomic {
				WE_RED_LIGHT	= OFF
				WE_YELLOW_LIGHT	= OFF
				WE_GREEN_LIGHT	= ON
			}

		:: tmp_yellow_light == ON ->
			atomic {
				WE_RED_LIGHT	= OFF
				WE_YELLOW_LIGHT	= ON
				WE_GREEN_LIGHT	= OFF
			}

		:: tmp_green_light == ON ->
			atomic {
				WE_RED_LIGHT	= ON
				WE_YELLOW_LIGHT	= OFF
				WE_GREEN_LIGHT	= OFF
			}
	od
}

active proctype AssertInvariant() 
{
	assert( NS_RED_LIGHT == WE_GREEN_LIGHT )
	assert( NS_GREEN_LIGHT == WE_RED_LIGHT )

	assert( NS_GREEN_LIGHT <> WE_GREEN_LIGHT )
	assert( NS_RED_LIGHT <> WE_RED_LIGHT )
}

init {

	chan lightSync = [3] of {int, int, int}

	run northSouthLane(lightSync)
	run weastEastLane(lightSync)
}
