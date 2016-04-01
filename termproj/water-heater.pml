#define ON  1
#define OFF 0

int water_heater_system		= OFF;
int water_pump_status		= OFF;
int heat_plate_status		= OFF;

#define MIN_WATER_LEVEL 3
#define MAX_WATER_LEVEL 20
#define WATER_INCREASE_RATE 2

#define MIN_TEMPERATURE_OF_HEAT_PLATE 30
#define MAX_TEMPERATURE_OF_HEAT_PLATE 100

#define TEMPERATURE_INCREASE_RATE 1

int current_water_level = 0;

#define p (current_water_level <= MAX_WATER_LEVEL);

/**
active proctype pump_working() 
{
	do
	:: ( ( current_water_level > MIN_WATER_LEVEL ) && ( ON == water_pump_status ) ) ->
		current_water_level = current_water_level + WATER_INCREASE_RATE;
	:: ( ( current_water_level == MAX_WATER_LEVEL ) ) -> 
		water_pump_status = OFF;
		water_pump_chann!water_pump_status;
	od;

	assert(p)
}
**/

active proctype timer() {
	if
	:: (ON == water_pump_status) ->
		if 
		:: (MAX_WATER_LEVEL > current_water_level) -> atomic {
			current_water_level++; /** = current_water_level + 1; **/
			printf("ON: %d\n", current_water_level);
		}
		fi;
	:: (OFF == water_pump_status) ->
		if
		:: (MAX_WATER_LEVEL > current_water_level) -> atomic {
			current_water_level--;
			printf("OFF: Decrease %d\n", current_water_level);
		}
		fi;
	fi;
}

init 
{

	water_pump_status = ON;
	do 
	:: (MAX_WATER_LEVEL == current_water_level) -> water_pump_status = OFF;
	:: (MIN_WATER_LEVEL <= current_water_level) -> water_pump_status = ON;
	od
}
