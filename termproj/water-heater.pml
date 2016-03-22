mtype { ON, OFF };

mtype water_heater_system	= OFF;
mtype water_pump_status		= OFF;
mtype heat_plate_status		= OFF;

chan heat_plate_chann = [2] of {mtype};
chan water_pump_chann = [2] of {mtype};

#define MIN_WATER_LEVEL 3
#define MAX_WATER_LEVEL 20
#define WATER_INCREASE_RATE 2

#define MIN_TEMPERATURE_OF_HEAT_PLATE 30
#define MAX_TEMPERATURE_OF_HEAT_PLATE 100

#define TEMPERATURE_INCREASE_RATE 1

int current_water_level = 0;

#define p ( water_heater_system == ON )
/**  -> <>(water_pump_status == ON) **/

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
