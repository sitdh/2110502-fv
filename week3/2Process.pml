byte n = 0, finish = 0;
active [2] proctype P() 
{
	byte register1;
	byte counter = 0;

	do :: counter == 10 -> break
		:: else -> 
			register1 = n
			register1++
			n = register1;
			counter++
	od;
	finish++
}
active proctype WaitForFinish() {
	finish == 2;
	printf("n = %d\n", n);
	assert(3<=n);
}
