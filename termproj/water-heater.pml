#define ON	1
#define OFF	0

#define p [](water_temperature <= 25)
#define q [](water_temperature >= 100)

int water_temperature = 25

init {
	do
		:: water_temperature >= 25 -> water_temperature += 1;
		:: water_temperature <= 100 -> water_temperature += 1;
	od unless -> { true };
}


active proctype waterHeaterInvarience() 
{
	assert(water_temperature >= 25 && water_temperature <= 100)
}
