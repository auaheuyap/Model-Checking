#ifndef N
	#define N	3	/* nr of processes */
#endif

bool w,b;


int strue=1,sfalse=1;

byte ncrit;	/* auxiliary var to check mutual exclusion */

active [N] proctype user()
{
bool c;
again:
c=w;
if
::c==true->
	strue==1
	strue--;
::else ->
	sfalse==1
	sfalse--;
fi
if
::c==w->
	if
	::!c==true->
		strue==1
		strue--;
	::else ->
		sfalse==1
		sfalse--;
	fi
	b=true;
	do
	::b==true->
		b=false;
		if
		::!c==true->
			strue==0
			strue++;
		::else ->
			sfalse==0
			sfalse++;
		fi
		if
		::!c==true->
			strue==1
			strue--;
		::else ->
			sfalse==1
			sfalse--;
		fi
	::b==false->break
	od
	w=!w;
	if
	::!c==true->
		strue==1
		strue--;
	::else ->
		sfalse==1
		sfalse--;
	fi
::else -> skip
fi
ncrit++;
assert(ncrit==1);
ncrit--;
b=true;
if
::c==true->
	strue==1
	strue--;
::else ->
	sfalse==1
	sfalse--;
fi
goto again
}
