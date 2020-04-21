//Example macro that does a diffusion analysis on a results table of tracking data
//The required format is as generated by the Manual Tracking plugin 
//http://rsbweb.nih.gov/ij/plugins/track/track.html
//assuming Results Table column headings; Track > Slice > X > Y
//It requires many tracks and many time points!
//Plots the cumulative mean squared displacement (MSD) per time point
//For a more accurate approach see the time ensemble average example

dis2 = 0;
for (i=0; i<nResults(); i++){
	if (getResult("Slice", i)==1) {setResult("Dis^2", i, 0);}

	else{ if (getResult("Track", i)>getResult("Track", i-1)) {setResult("Dis^2", i, 0);} 
	
	else {
	B9 = getResult("X", i);
	B8 = getResult("X", i-1);
	C9 = getResult("Y", i);
	C8 = getResult("Y", i-1);
	disx=(B9-B8)*(B9-B8);
	disy=(C9-C8)*(C9-C8);
	dis2 = (disx+disy);
	setResult("Dis^2", i, dis2);
		}
	}
}
updateResults;

//get last slice
maxslice = 0;
for (b=0; b<nResults(); b++) {
    if (getResult("Slice",b)>maxslice)
    {
     maxslice = getResult("Slice",b);
    	}
    	else{};
}

//get first slice
minslice = maxslice;
for (c=0; c<nResults(); c++) {
    if (getResult("Slice",c)<minslice)
    {
     minslice = getResult("Slice",c);
    	}
    	else{};
}

//Calculate MSD for each slice and append to a new array (MSD)
MSD = newArray();
t=0;
time = newArray();
z = 0;

for (m=minslice; m<maxslice; m++){
	slice = newArray();
	for (l=0; l<nResults(); l++) {if (getResult("Slice", l)==m) {	
		x = getResult("Dis^2", l);
		slice = Array.concat(slice, x);
	}
}
t++;
Array.getStatistics(slice, min, max, mean, std);
z = mean+z;
MSD = Array.concat(MSD, z);
time = Array.concat(time, t);
}
//Plot cumulative MSD against time
Fit.doFit("Straight Line", time, MSD);
Fit.plot();

//Richard Mort 26/01/2013
