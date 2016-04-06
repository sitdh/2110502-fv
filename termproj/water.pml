/**
#define on	1
#define off 0
**/

mtype = { ON, OFF }

#define MIN_TEMPERATURE 25
#define MAX_TEMPERATURE 40

#define MIN_WATER 5 
#define MAX_WATER 20

mtype water_heater_system			= OFF
mtype pump_system_status			= OFF
mtype heater_system_status			= OFF

int water_level						= 0
int water_temperature				= MIN_TEMPERATURE

/** 
 * Atomic property 
 **/
#define o1   (water_heater_system == OFF)
#define o2   (water_heater_system == ON)

//--
// water
#define p1   (water_level >= 0)
#define p2   (water_level >= MIN_WATER)
#define p2_1 (water_level == MIN_WATER)
#define p3   (water_level <= MAX_WATER)
#define p3_1 (water_level == MAX_WATER)
#define p4   (pump_system_status == ON)
#define p5   (pump_system_status == OFF)

//--
// temperture
#define q1   (water_temperature >= MIN_TEMPERATURE)
#define q1_1 (water_temperature == MIN_TEMPERATURE)
#define q2   (water_temperature <= MAX_TEMPERATURE)
#define q2_1 (water_temperature == MAX_TEMPERATURE)
#define q3   (heater_system_status == OFF)
#define q4   (heater_system_status == ON)

/** 
 * LTL
 **/
//--
// water
ltl { []p1 }
ltl { []<>p2 }
ltl { []<>p3 }
ltl { []<>p4 }
ltl { p4-><>p5 }
ltl { p5-><>p4 }

//--
// temperature
ltl { []<>q1 }
ltl { []<>q2 }
ltl { q3 -> <>q4 }
ltl { []<>(q3 -> <>q4) }
ltl { []<>(q4 -> <>q3) }

//--
// Extra
ltl { [](q3 -> <>q1_1) }
ltl { [](q4 -> <>q2_1) }
ltl { (q4 && p2_1) -> q3 }
ltl { o1 -> <>o2 }
ltl { <>[]o2 }
ltl { [](o2 -> <>(q4 && p4)) }
ltl { [](o1 -> [](q3 && p5)) }

/**
 * Abstraction
 **/
active proctype pump() {
	do 
	:: (ON == pump_system_status) ->
		if
		:: (water_level <  MAX_WATER) -> water_level++
		:: (water_level >= MAX_WATER) -> pump_system_status = OFF
		fi;
	:: (OFF == pump_system_status) ->
		if
		:: (water_level >  MIN_WATER) -> water_level--
		:: (water_level <= MIN_WATER) -> pump_system_status = ON
		fi;
	od;
}

active proctype heater() {
	if
	:: (ON == water_heater_system) ->
		do 
		:: (ON == heater_system_status) ->
			if
			:: (water_temperature <  MAX_TEMPERATURE) -> 
				water_temperature++
			:: (water_temperature >= MAX_TEMPERATURE) -> 
				heater_system_status = OFF
			fi;
		:: (OFF == heater_system_status) ->
			if
			:: (MIN_WATER == water_level) -> skip
			:: (water_temperature > MIN_TEMPERATURE) -> 
				water_temperature--
			:: ((MIN_TEMPERATURE == water_temperature) && (MIN_WATER >= water_level)) -> 
				heater_system_status = ON
			fi;
		od;
	fi;
}

init {
	if 
	:: (OFF == water_heater_system) -> water_heater_system = ON
	fi;
}
