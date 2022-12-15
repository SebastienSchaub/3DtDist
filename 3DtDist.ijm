
/*
This macro let to mesaure 3D distance in a single frame or a timelapse, based in pixelsize calibration.

For any information contact :

Sebastien Schaub - PIM platform
> sebastien.Schaub@imev-mer.fr

 */

macro "3DDistances [1]"{
	Stack.getDimensions(Width, Height, NChannels, NSlices, NFrames);
	setTool("point");
	if (NFrames==1) Dist3D();
	else Dist3Dt();

	
}

//==========================================================
function Dist3D(){
	PreTitle=getTitle();
	getPixelSize(unit, pw, ph, pd);
	rename("Select A ------- tip: [Alt]+[Scroll] for Z");
	A=getLoc("A>");
	CreateROI("M"+nResults+"-A");
	rename("Select B ------- tip: [Alt]+[Scroll] for Z");
	B=getLoc("A=["+d2s(A[0],1)+";"+d2s(A[1],1)+";"+d2s(A[1],1)+"] B>");	
	CreateROI("M"+nResults+"-B");
	WriteRes(PreTitle,A,B);
	rename(PreTitle);
}

//==========================================================
function Dist3Dt(){
ctrlleft=18;
	PreTitle=getTitle();
	getPixelSize(unit, pw, ph, pd);
	Stack.getDimensions(Width, Height, NChannels, NSlices, NFrames);
	AllA=newArray(5*NFrames);
	Array.fill(AllA,-1);
	AllB=newArray(5*NFrames);
	Array.fill(AllB,-1);
	rename("Select A ------- tip: [Alt]+[Scroll] for Z. [Crl]+[Click] to finish");
	A=newArray(5);
	do {
		Stack.getPosition(channel, slice, frame);
		A=getLoc("A>");
		Stack.getPosition(channel, slice, frame);
		CreateROI("t"+frame+"-A");
		for (i=0;i<5;i++) AllA[A[3]*5+i]=A[i];
		Stack.setFrame(A[3]+2);
		Stack.getPosition(channel, slice, frame);
	} while ((A[4]!=ctrlleft)&&(A[3]<NFrames-1));
	rename("Select B ------- tip: [Alt]+[Scroll] for Z");
	it=1;
	while(it<=NFrames){
		print(it);
		if (AllA[(it-1)*5]!=-1){
			Stack.setFrame(it);
			B=getLoc("A=["+d2s(AllA[(it-1)*5],1)+";"+d2s(AllA[(it-1)*5+1],1)+";"+d2s(AllA[(it-1)*5+2],1)+"] B>");	
			Stack.getPosition(channel, slice, frame);
			CreateROI("t"+frame+"-B");
			for (i=0;i<5;i++) AllB[B[3]*5+i]=B[i];
		}
		it++;
	}
	WriteResTime(PreTitle,AllA,AllB);
	rename(PreTitle);
}

//==========================================================
function getLoc(PreTxt){
// Coord X,Y,Z,T,modifier	
	getPixelSize(unit, pw, ph, pd);
	CoordOut=newArray(4);
	run("Select None");
	getCursorLoc(x2, y2, z2, modifiers);
	x2*=pw;
	y2*=ph;
	z2*=pd;
	TxtB="B=[ : : ]";
	TxtD="AB= "+unit;
	while (selectionType()==-1) {
		getCursorLoc(x1, y1, z1, modifiers);
		x1*=pw;
		y1*=ph;
		z1*=pd;
		if ((x1!=x2) || (y1!=y2) || (z1!=z2)){
			showStatus(PreTxt+"["+d2s(x1,1)+" : "+d2s(y1,1)+" : "+d2s(z1,1)+"]");	
			x2=x1;
			y2=y1;
			z2=z1;		
		}
	}
	Roi.getCoordinates(xpoints, ypoints);
	Stack.getPosition(channel, slice, frame);
	CoordOut[0]=xpoints[0]*pw;
	CoordOut[1]=ypoints[0]*ph;	
	CoordOut[2]=slice*pd;	
	CoordOut[3]=frame-1;
	CoordOut[4]=modifiers;
	return CoordOut;
}

//==========================================================
function WriteRes(PreTitle,A,B){
	D=sqrt(pow(A[0]-B[0],2)+pow(A[1]-B[1],2)+pow(A[2]-B[2],2));
	idx=nResults;
	
	setResult("Filename", idx, PreTitle);
	setResult("Dist ["+unit+"]", idx, D);
	setResult("A-X ["+unit+"]", idx, A[0]);
	setResult("A-Y ["+unit+"]", idx, A[1]);
	setResult("A-Z ["+unit+"]", idx, A[2]);
	setResult("B-X ["+unit+"]", idx, B[0]);
	setResult("B-Y ["+unit+"]", idx, B[1]);
	setResult("B-Z ["+unit+"]", idx, B[2]);	
}

//==========================================================
function WriteResTime(PreTitle,AllA,AllB){
	it=0;
	Stack.getDimensions(Width, Height, NChannels, NSlices, NFrames);
	while(it<NFrames){
		if ((AllA[it*5]!=-1) && (AllB[it*5]!=-1)){
			A=newArray(AllA[it*5],AllA[it*5+1],AllA[it*5+2]);
			B=newArray(AllB[it*5],AllB[it*5+1],AllB[it*5+2]);
			D=sqrt(pow(A[0]-B[0],2)+pow(A[1]-B[1],2)+pow(A[2]-B[2],2));
			idx=nResults;
			
			setResult("Filename", idx, PreTitle);
			setResult("Frame", idx, it+1);
			setResult("Dist ["+unit+"]", idx, D);
			setResult("A-X ["+unit+"]", idx, A[0]);
			setResult("A-Y ["+unit+"]", idx, A[1]);
			setResult("A-Z ["+unit+"]", idx, A[2]);
			setResult("B-X ["+unit+"]", idx, B[0]);
			setResult("B-Y ["+unit+"]", idx, B[1]);
			setResult("B-Z ["+unit+"]", idx, B[2]);	
		}
		it++;
	}
	return idx;
}

function CreateROI(Name){
	NotCreated=true;
	idx=RoiManager.getIndex(Name);
	if (idx==-1){
		roiManager("add");
		roiManager("select", roiManager("count")-1);
		roiManager("rename",Name);
	}
	else {
		run("Select None");
		roiManager("Select", idx);
		run("Restore Selection");
		roiManager("Update");
	}
}
