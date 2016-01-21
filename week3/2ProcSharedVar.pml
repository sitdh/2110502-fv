int state = 1;
proctype MyProcess()
{ 
	int tmp;
	(state==1) -> tmp = state;
	tmp = tmp + 1;
	state = tmp
}
proctype YourProcess()
{
	int tmp;
	(state==1) -> tmp = state;
	tmp = tmp - 1;
	state = tmp
}
init { run MyProcess(); run YourProcess() }
