include <screwmetric2.scad>

//csf17 series
csf_od=79.0+0.2+0.3+2.8;
csf_holder_phi=71;
csf_m4_od=3.76+0.4;
csf_phi45_od=4.5; //m4 od, m4id 3.74
csf_align_phi=48+0.2+0.4-0.4;
csf_align_depth=2+0.4+0.4+1.8; //**1.8 for support depth
csf_hole2od_depth=8+1.8; //csf hole to outter plate depth
csf_adaptor_phi=18+0.2+2.5; //adaptor phi=18, add hex butt

m42pln_od=28.0+0.05+0; //!! not std spec!
m42pln_hole_r=2.9+0.4+0.05; //m3 size
echo(m42pln_od,m42pln_hole_r);
m42pln_align_phi=22-0.05/2+0.4+0.1;
m42pln_align_depth=2+0.2;
m42pln_phi=35.9+0.2;
m42pln_depth=23.5;
m42pln_pin=8+0.5;
m42bdy_depth=39.2+0.4-0.25;
m42_total_depth=m42pln_depth+m42bdy_depth;
echo(m42_total_depth);
m42_pin_overlap=10.5;
m42_pin_depht=17.6;

//..m42 house
m42_mot_width=43+0.2+0.4+1.2;
m42_mot_depth=34.0+0.3;
m42_house_depth=53.5+0.5+1.5;
m42_motpln_d=53.5-m42_mot_depth+1.2;
m42_house_tk=4.8;
m42_od_width=m42_mot_width+2*m42_house_tk;
m42_houseExt_phi=15-0.4+0.5;
m42_houseExt_L=14;

m42_bot_depth=9+2.8; //width=43mm
//driver borad
drvpcb_depth=38;
//holder hex screw
hex_od=1.6+0.5;
hex_depth=csf_hole2od_depth-3;

m3screw_head_phi=5.3+0.4+0.05;
m3screw_head_depth=3.3+0.5;
//heater protect
heat_wall_od=csf_od+9;
heat_wall_tk=0.4; //injector diameter*2
heat_wall_height=csf_hole2od_depth+m42_pin_overlap+0.5+1.8;

//bottom rack parameters
rack_od=76;
rack_so=24;  //rack sphere so 24mm thickness
rack_height=csf_od/2+rack_so;
rck_space=0.4;


//1/4" screw
pitch=1;
pitch4=25.4/20;
pitchScale4=pitch4/pitch;
Mscrew4=25.4/4-pitch4+0.4+1.4-0.4;
Tn4=ceil(m42_house_tk/pitch4)+1;
fn4=100;
//m4 screw
m4screw=4+.9;
m4pitch=0.7;
m4pitchScale=m4pitch/pitch;

//main

rotate([180,0,15])
  {
    mt_hds_holder();
    // heat_wall();
   rotate([0,0,60])
      translate([-m42_od_width/2,-m42_od_width/2,-m42_house_depth])
      
      m42_house();
  }
   //heat wall
module heat_wall(){
    difference(){
        cylinder(r=heat_wall_od/2+0.2+heat_wall_tk, h=heat_wall_height,$fn=50);
        translate([0,0,-0.05])
        cylinder(r=heat_wall_od/2+0.2, h=heat_wall_height+0.1,$fn=25);
        
    }
    
    
}
//motor and hds holder
module mt_hds_holder()
{
   difference()
    {
       holder_height=csf_hole2od_depth+m42_pin_overlap+0.5+1.8; 
       cylinder(r=csf_od*0.5,h=holder_height,$fn=300);
        echo(csf_hole2od_depth+m42_pin_overlap);
        i=0;
       for (i=[0:1:5])
       {
        //m4 screw..#@#
           r0=csf_holder_phi*0.5;
           m4screw=csf_phi45_od-m4pitch+0.38+1.0-0.05; //M4 screw dia here!!
           m4Tn=ceil(holder_height/m4pitch)+1;
           translate([1*r0*(cos(60*i)),1*r0*(sin(60*i)),-0.1])
                                            
           //cylinder(r=(csf_phi45_od-0.525)/2,h=holder_height+0.2,$fn=100);
         scale([1,1,m4pitchScale])
          screwMetric(m4screw,1,m4Tn,fn4/5); 
		  //echo(i,r0,r0*(cos(60*i)-sin(60*i)),r0*(sin(60*i)+cos(60*i)));
           //i=i+1;
       }   
       //top cluch
       translate([0,0,holder_height-csf_align_depth-0.1])
       cylinder(r=csf_align_phi/2,h=csf_align_depth+0.2,$fn=100);
       //draw pln house
    translate([0,0,-0.1-1.8])
    cylinder(r=m42pln_phi/2+0.3,h=holder_height-m42_pin_overlap+0.2,$fn=100);
       echo(holder_height-m42_pin_overlap+0.2);
       //draw pln alignment
       translate([0,0,holder_height-m42_pin_overlap-m42pln_align_depth+m42pln_align_depth-0.1-1.8])
       cylinder(r=m42pln_align_phi/2,h=m42pln_align_depth+0.2,$fn=100);
       
       //draw pln 4 holes
       r1=m42pln_od/2;
       theta=360/(3+1);
       for(j=[0:1:3])
       {
          translate([1*r1*(cos(theta*j+15)),1*r1*(sin(theta*j+15)),-0.1-1.8])
                                            
           cylinder(r=(m42pln_hole_r+0+0.1)/2,h=holder_height+0.2,$fn=100);
         translate([1*r1*(cos(theta*j+15)),1*r1*(sin(theta*j+15)),holder_height-1*csf_hole2od_depth-0.1+0.22])
                                            
           cylinder(r=(m3screw_head_phi+0+0.1)/2,h=m3screw_head_depth+0*csf_hole2od_depth+1.2,$fn=100);     

           
           
           
       }
       
       //draw the pin
    translate([0,0,-0.1])
       cylinder(r=m42pln_pin/2+0.05,h=holder_height+0.1,$fn=250);
      //draw the adaptoe cylinder hole
     translate([0,0,holder_height-csf_hole2od_depth+0.5+2.0])
      cylinder(r=csf_adaptor_phi/2,h=csf_hole2od_depth+0.3,$fn=100);    
   
   
   
       //draw the hex screw holes
     
       
    #for(k=[0:1:4])
     {  
      translate([0,0,holder_height-hex_depth+3.1]) {
      rotate([0,90,45+90*(k+1)])
       scale([1.2,1.550,1]) 
        cylinder(r=hex_od/2,h=csf_od/2,$fn=24);}
     }
     //minus the ring for crack avoid, by-passed
     /*
     translate([0,0, holder_height-hex_depth+3])
     rotate_extrude(convexity = 30)
        translate([csf_od/2+hex_od/2*1.2, 0,0])
        scale([0.8,1.3,1])
        circle(r = hex_od*0.9, $fn = 50);
    // echo("ring",holder_height-hex_depth+2.5);
     translate([0,0, hex_depth-3])
     rotate_extrude(convexity = 30)
        translate([csf_od/2+hex_od/2*1.2, 0,0])
         scale([0.8,1.3,1])
        circle(r = hex_od*.9, $fn = 50);
     */
   //  echo("ring",holder_height-hex_depth+2.5);
     
            //draw the hex spare
     /*
     Nm=12;
     deltaNang=360/Nm;
    for(m=[0:1:Nm-1])
    {
               //m4 screw..#@#
           rm=csf_od*0.5+12;
           prePhase=0.917;
        postPhase=1.083;
          hull(){
              
                      // scale([1.0,0.8,1.0])
           translate([1*rm*(cos(deltaNang*m+deltaNang*prePhase)),1*rm*(sin(deltaNang*m+deltaNang*prePhase)),-0.1])    
                    
             cylinder(r=13.6,h=0.3,$fn=72);
               
         translate([1*rm*(cos(deltaNang*m+deltaNang)),1*rm*(sin(deltaNang*m+deltaNang)),holder_height*0.5-0.4])
             //scale([1.0,0.8,1.0])   
             cylinder(r=14.6,h=0.8,$fn=36);             
         translate([1*rm*(cos(deltaNang*m+deltaNang*postPhase)),1*rm*(sin(deltaNang*m+deltaNang*postPhase)),holder_height-0.1])
             //scale([1.0,0.8,1.0])   
             cylinder(r=13.6,h=0.3,$fn=72);
    }
    }*/
  } 
}

module m42_house(){
      holder_height=csf_hole2od_depth+m42_pin_overlap+0.5+1.8;
    m42_od_width=m42_mot_width+2*m42_house_tk;
    intersection(){
       translate([m42_od_width/2,m42_od_width/2,0])     
    cylinder(r=(m42_od_width)*sqrt(2)/2-1.9,h=m42_house_depth+m42_house_tk+10,$fn=60);  
    difference(){
        cube([m42_od_width,m42_od_width,m42_house_depth+m42_house_tk]);
       translate([m42_house_tk+1.0,m42_house_tk+1.0,m42_bot_depth-0.1]) //adjust center 0.5, 0.7, 0.9
        intersection(){
        cube([m42_mot_width-2.15,m42_mot_width-2.15,m42_house_depth+m42_house_tk-m42_bot_depth+0.2]); 
        translate([4*m42_house_tk+1.9,4*m42_house_tk+1.9,-0.1])
        cylinder(r=(m42_od_width)*sqrt(2)/2-1.9-m42_house_tk*2+0.75,h=m42_house_depth+m42_house_tk-m42_bot_depth+0.2,$fn=36);
        }
        echo("intsectM42",2*((m42_od_width)*sqrt(2)/2-1.9-m42_house_tk*2+0.75));
     //bottom line house
       translate([m42_house_tk,m42_house_tk,-0.1])
        intersection(){       
        cube([m42_mot_width,m42_mot_width,m42_bot_depth+0.2]);  
       translate([4*m42_house_tk+2.9,4*m42_house_tk+2.90,-0.1])  //2.9 adjusr center
        cylinder(r=(m42_od_width)*sqrt(2)/2-1.9-m42_house_tk*2+1.9,h=m42_bot_depth+0.2,$fn=36);   
        }
      //1/4" screw hole
       translate([m42_od_width/2,pitch4*(Tn4+1),m42_house_depth*.5+m42_house_tk]) 
        rotate([90,0,0])
        scale([1,4.3/4.0,pitchScale4])
       screwMetric(Mscrew4, 1, Tn4+2,fn4/5); 
    }
   }
    //draw the m42 pln house
     translate([m42_house_tk+0.5,m42_house_tk+0.5,m42_house_depth+m42_house_tk-m42_bot_depth-8]) {
   difference(){
         
        cube([m42_mot_width-1.6,m42_mot_width-1.6,m42_motpln_d-8+0.6]); 
       echo("m42_motpln_d",m42_motpln_d);
       
       
    translate([(m42_od_width-0.71*(m42_mot_width-m42pln_phi/2+3)/2)/2,(m42_od_width-0.71*(m42_mot_width-m42pln_phi/2+3)/2)/2,-0.1])
        {
             cylinder(r=m42pln_phi/2+0.8,h=m42_motpln_d-8+0.8,$fn=100);
            //draw thee arch
            translate([-0.0,-0.0,-m42pln_phi*.263])
       scale([1,1,0.5])
          sphere(r=m42pln_phi+0.5,$fn=50);
        }
     }
        
    }
    
    //draw flower on dapator
   translate([m42_od_width/2,m42_od_width/2,m42_house_depth+m42_house_tk])
    difference()
    {
        zfactor=0.4;
        rfactor=0.94;
        scale([1,1,zfactor])
        sphere(r=csf_od/2*rfactor,$fn=100);
        translate([0,0,-m42_motpln_d-8+0.8-0.1])
        cylinder(r=m42pln_phi/2+0.45,h=m42_motpln_d-8+0.8+csf_od/2*rfactor,$fn=100);
        translate([-csf_od/2*rfactor,-csf_od/2*rfactor,zfactor*rfactor])
        cube([csf_od/2*rfactor*2,csf_od/2*rfactor*2,csf_od/2*rfactor]);
        //not arch
        translate([-csf_od/2*rfactor,-csf_od/2*rfactor,-csf_od/2*rfactor*1-11])
        cube([csf_od/2*rfactor*2,csf_od/2*rfactor*2,csf_od/2*rfactor]); 
        
        
        
        //not hex screw hole
       i=0;
       for (i=[0:1:5])
       {
        //m4 screw..#@#
           r0=csf_holder_phi*0.5;
           translate([1*r0*(cos(60*i)),1*r0*(sin(60*i)),-holder_height/2])
                                            
           cylinder(r=(csf_phi45_od-0.525)/2+2.7,h=holder_height+0.2,$fn=100);//echo(i,r0,r0*(cos(60*i)-sin(60*i)),r0*(sin(60*i)+cos(60*i)));
           //i=i+1;
       }  
      
      //draw not hex P, by-passed
       /*
     Nm=12;
     deltaNang=360/Nm;
    for(m=[0:1:Nm-1])
    {
               //m4 screw..#@#
           rm=csf_od*0.5+12;
           prePhase=0.96;
        postPhase=1.04;
          hull(){
              
                      // scale([1.0,0.8,1.0])
           translate([1*rm*(cos(deltaNang*m+deltaNang*prePhase)),1*rm*(sin(deltaNang*m+deltaNang*prePhase)),-5.8])    
                    
             cylinder(r=13.6,h=0.3,$fn=72);
               
         translate([1*rm*(cos(deltaNang*m+deltaNang)),1*rm*(sin(deltaNang*m+deltaNang)),holder_height*0.5-0.4])
             //scale([1.0,0.8,1.0])   
             cylinder(r=14.6,h=0.8,$fn=36);             
         translate([1*rm*(cos(deltaNang*m+deltaNang*postPhase)),1*rm*(sin(deltaNang*m+deltaNang*postPhase)),holder_height-0.1])
             //scale([1.0,0.8,1.0])   
             cylinder(r=13.6,h=0.3,$fn=72);
   }
  } 
 */
 } 
  //draw the extender for rack support arm
      //leftt arm
   translate([m42_od_width+m42_houseExt_L-0.1,m42_od_width/2,holder_height*.8+m42_houseExt_phi/2])
      rotate([90,0,270])
     arm_inner();
     //right arm
    translate([-m42_houseExt_L+0.1,m42_od_width/2,holder_height*.8+m42_houseExt_phi/2])
      rotate([90,0,90])
     arm_inner();

}
module arm_inner()
{
    
         cylinder(r=m42_houseExt_phi/2,h=m42_houseExt_L+0.2,$fn=300);
     difference()
    {   
       translate([0,0,m42_houseExt_L-0.5])
        rotate([0,0,156])  //alt = 24 degrees
        scale([1.10,0.9,0.55])
         
         sphere(r=m42_houseExt_phi/2+4,$fn=100);
        translate([-m42_houseExt_phi/2-4,-m42_houseExt_phi/2-4,m42_houseExt_L+0.1])
          cube([m42_houseExt_phi+8,m42_houseExt_phi+8,m42_houseExt_phi]);
       
    } 
}

//rack adaptor per
module rack_adaptor()
{
    
}