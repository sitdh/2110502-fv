proctype MyProcess(chan my_end_of_channel)
{
	int my_value = 79;
	my_end_of_channel ! my_value; /* send '79' into channel */ 
}
proctype YourProcess(chan your_end_of_channel)
{
	int your_value;
	your_end_of_channel ? your_value; /* read from channel */
	printf("Received %d\n", your_value);
}
init
{ 
	chan c = [1] of { int };
	run MyProcess(c);
	run YourProcess(c);
}
