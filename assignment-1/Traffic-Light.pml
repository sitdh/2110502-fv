int RLight = 0
int YLight = 0
int GLight = 0

proctype TrafficLight() 
{
	int t = 1;

	S0: goto SR

	SR: do
		::(t==1)-> t = 0; 
		::RLight = 1
		::YLight = 0
		::GLight = 0
		::t = 1
		od;
		goto SG

	SG: do
		::(t==1)-> t = 0; 
		::RLight = 0
		::YLight = 1
		::GLight = 0
		::t = 1
		od;
		goto SY

	SY: do
		::(t==1)-> t = 0; 
		::RLight = 0
		::YLight = 0
		::GLight = 1
		::t=1
		od;
		goto S0
}
