#define ON	1
#define OFF 0

#define MIN_TEMPERATURE 25
#define MAX_TEMPERATURE 100

#define MIN_WATER 30 
#define MAX_WATER 500

/** LTL declaration **/
#define p1 (water_temperature >= MIN_TEMPERATURE)
#define q1 (water_temperature <= MAX_TEMPERATURE)

#define p2 (water_level >= 0)
#define p3 (water_level >= MIN_WATER)
#define q2 (water_level <= MAX_WATER)

ltl { []p1 }
ltl { []q1 }

ltl { [](p2 -> <>p3) }
ltl { []q2 }

int water_heater_system_status	= OFF;

int heater_system_status		= OFF;
int pump_system_status			= OFF;

int water_level					= 0;
int water_temperature			= MIN_TEMPERATURE;


active proctype pump() {

	int flood_out = 0;

	do 
	:: (ON == pump_system_status) ->
		if
		:: (MAX_WATER > water_level) -> d_step {
			water_level++;
		}
		:: (MAX_WATER == water_level) ->
			pump_system_status = OFF;
		fi;
	:: (OFF == pump_system_status) ->
		if
		:: (MIN_WATER < water_level) -> d_step {
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

never  {    /* [](!p1) */
accept_init:
T0_init:
	do
			:: ((!p1)) -> goto T0_init
				od;
}

