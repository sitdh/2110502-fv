/**
#define on	1
#define off 0
**/

mtype = { ON, OFF }

#define MIN_TEMPERATURE 25
#define MAX_TEMPERATURE 40

#define MIN_WATER 5 
#define MAX_WATER 20

mtype pump_system_status			= OFF;
mtype heater_system_status			= OFF;

int water_level						= 0
int water_temperature				= MIN_TEMPERATURE

/** ltl declaration **/
// /** - water - **/
// #define p1 (water_level >= 0)
// #define p2 (water_level >= MIN_WATER)
// #define p3 (water_level <= MAX_WATER)
// #define p4 (pump_system_status == ON)
// #define p5 (pump_system_status == OFF)

#define q1 (water_temperature >= MIN_TEMPERATURE)
#define q2 (water_temperature <= MAX_TEMPERATURE)
#define q3 (heater_system_status == OFF)
#define q4 (heater_system_status == ON)

// 
// /** ltl: water level **/
// ltl { []p1 }
// ltl { []<>p2 }
// ltl { []<>p3 }
// ltl { []<>p4 }
// ltl { p4-><>p5 }
// ltl { p5-><>p4 }

// /** - temperature - **/
ltl { []<>q1 }
ltl { []<>q2 }
// ltl { q3 -> <>q4 }
// ltl { []<>(q3 -> <>q4) }
// ltl { []<>(q4 -> <>q3) }

active proctype pump() {
	do 
	:: (ON == pump_system_status) ->
		if
		:: (water_level <  MAX_WATER) -> atomic { 
			water_level++;
			printf("water: %d", water_level);
		}
		:: (water_level >= MAX_WATER) -> pump_system_status = OFF;
		fi;
	:: (OFF == pump_system_status) ->
		if
		:: (water_level >  MIN_WATER) -> water_level--;
		:: (water_level <= MIN_WATER) -> pump_system_status = ON;
		fi;
	od;
}

active proctype heater() {
	do 
	:: (ON == heater_system_status) ->
		if
		:: (water_temperature <  MAX_TEMPERATURE) -> water_temperature++;
		:: (water_temperature >= MAX_TEMPERATURE) -> heater_system_status = OFF;
		fi;
	:: (OFF == heater_system_status) ->
		if
		:: (MIN_TEMPERATURE < water_temperature) -> water_temperature--;
		:: ((MIN_TEMPERATURE == water_temperature) && (MIN_WATER >= water_level)) -> 
			heater_system_status = ON;
		fi;
	od;
}
