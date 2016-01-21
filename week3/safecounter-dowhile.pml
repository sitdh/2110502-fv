int count = 1;
proctype safercounter()
{
	do
		:: (count != 0) -> count = count + 1
		:: (count != 0) -> count = count - 1
		:: (count == 0) -> goto done
	od;
	done: skip
}
init { run safercounter() }
