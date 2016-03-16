#define ON	1
#define OFF	0

int water_temperature = 25

init proctype waterHeaterSystem() 
{
	if 
		:: water_temperature >= 25 -> water_temperature += 1;
		:: water_temperature <= 100 -> water_temperature += 1;
	fi;
}


active proctype waterHeaterInvarience() 
{
	assert(water_temperature >= 25 && water_temperature <= 100)
}
