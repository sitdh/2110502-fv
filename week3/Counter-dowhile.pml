int count = 0;
proctype counter() 
{
	do
		:: count = count + 1
		:: count = count - 1
		:: (count == 0)->break
	od
}
init{ run counter() }
