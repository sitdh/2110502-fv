#define ON	1
#define OFF 0

#define MIN_TEMPERATURE 25
#define MAX_TEMPERATURE 100

#define MIN_WATER 30 
#define MAX_WATER 500

#define p (water_temperature >= MIN_TEMPERATURE)
#define q (water_temperature <= MAX_TEMPERATURE)

ltl { []p }
ltl { []q }

int water_heater_system_status = OFF;

int heater_system_status	= OFF;
int pump_system_status		= OFF;

int water_level;
int water_temperature;

chan heater_system = [0] of { int };

active proctype pump(chan heater_channel) {

	int flood_out = 0;

	do 
	:: (ON == pump_system_status) ->
		if
		:: (MAX_WATER > water_level) -> atomic {
			water_level++;
		}
		:: (MAX_WATER == water_level) ->
			pump_system_status = OFF;
		fi;
	:: (OFF == pump_system_status) ->
		if
		:: (MIN_WATER < water_level) -> atomic {
			water_level--;
		}
		:: (MIN_WATER >= water_level) ->
			pump_system_status = ON;
		fi;
	od;
}

active proctype heater() {

	water_temperature = MIN_TEMPERATURE;

	do 
	:: (ON == heater_system_status) ->
		if
		:: (MAX_TEMPERATURE > water_temperature) -> 
			water_temperature++;
		:: (MAX_TEMPERATURE == water_temperature) ->
			heater_system_status = OFF;
		fi;
	:: (OFF == heater_system_status) ->
		if
		:: (MIN_TEMPERATURE < water_temperature - 1) ->
			water_temperature--;
		:: (MIN_TEMPERATURE >= water_temperature) ->
			heater_system_status = ON;
		fi;
	:: (MIN_TEMPERATURE >= water_temperature) -> 
		water_temperature = MIN_TEMPERATURE;
	od;
}

init {
	water_heater_system_status = ON;
}
