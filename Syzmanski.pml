#ifndef N
	#define N	4	/* nr of processes */
#endif

byte flag[N+1];

byte ncrit;	/* auxiliary var to check mutual exclusion */

active [N] proctype user()
{	byte i,j;
again:
flag[_pid]=1;
i=0;
do
::flag[i]<3 && i<N -> i++
::i>=N -> break
od
flag[_pid]=3;i=0;
do
::i<N && flag[i]!=1 -> 
	i++;
::i>=N -> break
::i<N && flag[i]==1 ->
	flag[_pid]=2;j=0;
	do
	::j<N && flag[j]!=4 -> j++
	::j>=N -> j=0
	::j<N && flag[j]==4 -> break
	od
	break;
od
flag[_pid]=4;i=0;
do
::flag[i]<2 && i<_pid-> i++
::i>=_pid -> break
od
atomic{
ncrit++;
assert(ncrit==1); 
ncrit--;
}
i=_pid+1;
do
::(flag[i]==0 || flag[i]==1 || flag[i]==4) && i<N -> i++
::i>=N->break
od
flag[_pid]=0;
i=0;
do
::i<N ->
	assert(flag[i]==4);
	i++;
::i==_pid->skip
i>=N->break
od
goto again
}
