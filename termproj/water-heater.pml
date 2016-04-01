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
int current_water_temperature = 25;

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

active proctype timer() {
	do
	:: (OFF == water_heater_system) -> water_heater_system = ON;
	:: (ON == water_heater_system) ->
		if
		:: (ON == water_pump_status) ->
			if 
			:: (MAX_WATER_LEVEL > current_water_level) -> atomic { 
				current_water_level++; 
				current_water_temperature = current_water_temperature - 1;
			}
			:: (MAX_WATER_LEVEL == current_water_level) -> water_pump_status = OFF;
			fi;
		:: (OFF == water_pump_status) ->
			if
			:: (MIN_WATER_LEVEL < current_water_level) -> current_water_level--;
			:: (MIN_WATER_LEVEL >= current_water_level) -> water_pump_status = ON;
			fi;
		fi;

		if
		:: (ON == heat_plate_status) -> 
			if
			:: (MAX_TEMPERATURE_OF_HEAT_PLATE > current_water_temperature) -> 
				current_water_temperature++;
			:: (MAX_TEMPERATURE_OF_HEAT_PLATE == current_water_temperature) -> 
				heat_plate_status = OFF;
			fi;
		:: (OFF == heat_plate_status) -> 
			if
			:: (MIN_TEMPERATURE_OF_HEAT_PLATE > current_water_temperature) -> 
				current_water_temperature = current_water_temperature + 1;
				current_water_temperature++;
			:: (MIN_TEMPERATURE_OF_HEAT_PLATE == current_water_temperature) -> 
				current_water_temperature--;
				heat_plate_status = OFF;
			fi;
		fi;

		printf("Hello");
	od;
}
**/

proctype pump() {
pump_on: (ON == water_pump_status) ->
		if 
		:: (MAX_WATER_LEVEL > current_water_level) -> atomic { 
			current_water_level++; 
			current_water_temperature--;
			goto pump_on;
		}
		:: (MAX_WATER_LEVEL == current_water_level) -> atomic {
			water_pump_status = OFF;
			goto pump_off;
		}
		fi;
pump_off: (OFF == water_pump_status) ->
		if
		:: (MIN_WATER_LEVEL < current_water_level) -> atomic {
			current_water_level--;
			goto pump_off;
		}
		:: (MIN_WATER_LEVEL >= current_water_level) -> goto pump_on;
		fi;
}

proctype heater() {
heater_on: (ON == heat_plate_status) -> 
	if
	:: (MAX_TEMPERATURE_OF_HEAT_PLATE > current_water_temperature) -> atomic {
			current_water_temperature++;
			goto heater_on;
		}
	:: (MAX_TEMPERATURE_OF_HEAT_PLATE == current_water_temperature) -> atomic {
			heat_plate_status = OFF;
			goto heater_off;
		}
	fi;

heater_off: (OFF == heat_plate_status) -> 
	if
	:: (MIN_TEMPERATURE_OF_HEAT_PLATE > current_water_temperature) -> atomic {
			current_water_temperature--;
			goto heater_off;
		}
	:: (MIN_TEMPERATURE_OF_HEAT_PLATE == current_water_temperature) -> atomic {
			heat_plate_status = ON;
			goto heater_on;
		}
	fi;
}

init {

	run pump();
	run heater();

	/**
	do
	:: (MIN_WATER_LEVEL > current_water_level) -> 
		water_pump_status = ON;
		run pump();
	:: (MAX_WATER_LEVEL == current_water_level) ->
		water_pump_status = OFF;

	:: (MIN_TEMPERATURE_OF_HEAT_PLATE > current_water_temperature) ->
		heat_plate_status = ON;
		run heater();
	:: (MAX_TEMPERATURE_OF_HEAT_PLATE == current_water_temperature) ->
		heat_plate_status = OFF;
	od;
	**/
}


