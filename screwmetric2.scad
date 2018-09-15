
module screwMetric(Mscrew, pitch, Tn,fn){
halfpitch=pitch/2; 
PitchRatio=pitch*(-0.545); 
ShapeConsTrainRatio=0.9995; 
OR = Mscrew/2; 
//echo(OR); 
IR=(Mscrew+PitchRatio*2)/2; 
cylinder(r=IR,h=(Tn)*pitch+0.2,$fn=fn+1); 
SSA=360/(fn+1); 
//echo(SSA); 
//initial stepL 
StepL1=0; 
StepL2=StepL1+halfpitch;; 
StepL3=(StepL1+StepL2)/2;
   intersection() { 
for(j=[0:Tn-1]){ 
  
  for (i=[0:SSA:360]){ 

      StepH1=pitch*(j+(i/SSA+1)*pitch/(fn+1)); //lower corner 
      StepH2 = StepH1+pitch*.6; 
      StepH1_5=(StepH1+StepH2)/2; 
      StepL1=pitch*(j+(i/SSA)*pitch/(fn+1)); //lower corner 
      StepL2 = StepL1+pitch*.6; 
      StepL1_5=(StepL1+StepL2)/2; 
      //echo(j,i,StepH1,StepL1); 
      color([0,0,1]) 
            polyhedron(points=[[IR*cos(i+SSA),IR*sin(i+SSA),StepH1],[OR*cos(i+SSA),OR*sin(i+SSA),StepH1_5],[IR*cos(i+SSA),IR*sin(i+SSA),StepH2],[IR*cos(i),IR*sin(i),StepL1],[OR*cos(i),OR*sin(i),StepL1_5],[IR*cos(i),IR*sin(i),StepL2]],faces=[[0,1,2],[0,2,3],[3,2,5],[5,4,3],[5,1,4],[5,2,1],[1,0,3],[4,1,3]]); 
    //StepL1=StepH1; 
    //StepL2=StepH2; 
    //StepL1_5=(StepL1+StepL2)/2; 
 } 
}
  cylinder(  r=OR*ShapeConsTrainRatio,h=Tn*pitch+0.0,$fn=2*fn+2);
}
};

module screwMetricHallow(Mscrew, pitch, Tn,fn){
halfpitch=pitch/2; 
PitchRatio=pitch*(-0.545); 
ShapeConsTrainRatio=0.9995; 
OR = Mscrew/2; 
//echo(OR); 
IR=(Mscrew+PitchRatio*2)/2; 
cylinder(r=IR,h=(Tn)*pitch+0.2,$fn=fn+1); 
SSA=360/(fn+1); 
//echo(SSA); 
//initial stepL 
StepL1=0; 
StepL2=StepL1+halfpitch;; 
StepL3=(StepL1+StepL2)/2;
   intersection() { 
for(j=[0:Tn-1]){ 
  
  for (i=[360:-SSA:0]){ 

      StepH1=pitch*(j+(i/SSA+1)*pitch/(fn+1)); //lower corner 
      StepH2 = StepH1+pitch*.6; 
      StepH1_5=(StepH1+StepH2)/2; 
      StepL1=pitch*(j+(i/SSA)*pitch/(fn+1)); //lower corner 
      StepL2 = StepL1+pitch*.6; 
      StepL1_5=(StepL1+StepL2)/2; 
      //echo(j,i,StepH1,StepL1); 
      color([0,0,1]) 
            polyhedron(points=[[IR*cos(i+SSA),IR*sin(i+SSA),StepH1],[OR*cos(i+SSA),OR*sin(i+SSA),StepH1_5],[IR*cos(i+SSA),IR*sin(i+SSA),StepH2],[IR*cos(i),IR*sin(i),StepL1],[OR*cos(i),OR*sin(i),StepL1_5],[IR*cos(i),IR*sin(i),StepL2]],faces=[[0,1,2],[0,2,3],[3,2,5],[5,4,3],[5,1,4],[5,2,1],[1,0,3],[4,1,3]]); 
    //StepL1=StepH1; 
    //StepL2=StepH2; 
    //StepL1_5=(StepL1+StepL2)/2; 
 } 
}
 // cylinder(  r=OR*ShapeConsTrainRatio,h=Tn*pitch+0.0,$fn=2*fn+2);
}
};