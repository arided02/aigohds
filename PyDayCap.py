#!/usr/bin/python3
from picamera import PiCamera
import time
from time import sleep
import ephem
import pytz
from tzlocal import get_localzone
from datetime import datetime
from datetime import timedelta
from fractions import Fraction
import PIL
from PIL import Image
import PIL.ExifTags
from PIL.ExifTags import TAGS
import math 
import io
import numpy as np
#import string

#from PIL import exifread

#camera = PiCamera()
#camera.resolution = (2048,1920)
#myPicTimeStamp="1"+time.strftime("%Y%m%d_%H%M%S",time.localtime())+".jpg"

##sub routine
   ##sun never rise or never set
def SunHorizon (tex1):
   BAFlag='normal'
   pnr=str(tex1).find('below')
   pns=str(tex1).find('above')
  # print(pnr,pns)

   if pnr >0:
        BAFlag='never rise'
   if pns>0:
        BAFlag='never set'
   return BAFlag
   
def sunPos(hori):
    #define the tuple :beg_twlight,end_twlight,BA
   
    myHome=ephem.Observer()
    tz=get_localzone()
    gpsfile=open("../gps.txt",mode='r+')  ##read file for aigo gps sync
    gps=np.array([181.0,91.0,9999990,99999999999999.00,99990],dtype=float)
    k=0
    for line in gpsfile.readlines():
        #myLoc=gpsfile.readline()
        for i in range(0,len(line)):
          if (line[i]=="="):
             charTest=line[i+1:-1]
             if (charTest!="null"): 
                gps[k]=float(charTest)
             else:
                gps[k]=0.0
        k=k+1
    print (gps)  ##default taiwan geo center
    if (gps[0]==0.0 or gps[1]==0.0):
       myHome.lon = '120.974'
       myHome.lat = '22.974'
       myHome.elevation=305
      
    else:
       myHome.lon=str(gps[0])
       myHome.lat=str(gps[1])
       myHome.elevation=gps[2]+2
    #compute the presure
    myHome.pressure=1010.8*(1-2.257e-5*myHome.elevation)**5.25588
    #myHome.compute_pressure()
    #print("pressure:",myHome.pressure,1013.3*(1-2.257e-5*myHome.elevation)**5.22588)
    myHome.date = datetime.now(tz).date() ##strftime("%Y-%m-%d", time.localtime())

 

    BA='normal'
    try:
        sunrise=myHome.previous_rising(ephem.Sun())
    except Exception as e:
        sunrise=0
        BA=SunHorizon(e)
        if BA=='never set':
           sunrise=0
        else:
           sunrise=9.99e99

        print(BA)
    
    try:
        suntransit=myHome.next_transit(ephem.Sun())
    except Exception as e:
        suntransit=0
        print(e)
        BA=SunHorizon(e)
        print(BA)
    try:    
        sunset=myHome.next_setting(ephem.Sun())
    except Exception as e:
        print("Suntransit:",e)
        sunset=0
        BA=SunHorizon(e)
        print(BA)
    
        ## civ timet
    myHome.horizon=hori
    try:
        beg_twlight=myHome.previous_rising(ephem.Sun(),use_center=True) #.astimezone(pytz.utc)
    except Exception as e:
        print(e)
        beg_twlight=0
        BA=SunHorizon(e)
        if BA=='never set':
          beg_twlight=0
        else:
          beg_twlight=9.99e99
        print(BA)
    try:    
        end_twlight=myHome.next_setting (ephem.Sun(),use_center=True)
    except Exception as e:
        print("Twinlight:",e)
   
        end_twlight=0
        BA=SunHorizon(e)
        if BA=='never rise':
          end_twlight=0
        else:
          end_twlight=9.99e99
        print(BA)
    print (beg_twlight,"sunrise:",sunrise, suntransit,"sunset",sunset,end_twlight,"BA",BA)
    currentTime=ephem.now()
    return(beg_twlight,end_twlight,currentTime,BA)



##main
def main():

    ##stack parameter in night cap
    totalStackNo=4
    imgTemp = [io.BytesIO() for i in range(totalStackNo)]
    picWidth=96 #2048  #32x
    picHeight=96 #1936 #16x
    beg_twlight,end_twlight,currentTime,BA=sunPos('-6.33')  ##horizon=-6.33 for civ twilight


    if (currentTime > beg_twlight) and( currentTime < end_twlight) and (BA=='never set'):
    #if  (currentTime < beg_twlight) or ( currentTime > end_twlight) or (BA=='never rise'):
    
        print ("Day cap mode")
        camera = PiCamera()
        camera.resolution = (picWidth,picHeight)
        myPicTimeStamp="1"+time.strftime("%Y%m%d_%H%M%S",time.localtime())
        filename=myPicTimeStamp+".jpg"
        camera.capture(filename)
   
    else:
        print ("preset camera for long exposure", time.strftime("%Y%m%d%H%M%S",time.localtime()))
        ncamera = PiCamera(
         framerate=Fraction(1,6),
         sensor_mode=3,
         resolution=(picWidth,picHeight),
        )
        #print "preset 1st stage done",time.strftime("%Y%m%d%H%M%S",time.localtime())
        nexposureTime=6000
        ncamera.shutter_speed=nexposureTime
        ncamera.iso= 800
        waitTime=int(nexposureTime/1e+6)+1   
        sleep(waitTime)
        print ("preset 2nd stage done", waitTime)
        ncamera.exposure_mode='off'
        #expo 5 frames
  
        myPicTimeStamp="2"+time.strftime("%Y%m%d_%H%M%S",time.localtime())
        image = np.empty((picWidth, picHeight, 3), dtype=np.uint8)
        for num in range(totalStackNo):
            try:
                  imgTemp = myPicTimeStamp+"_"+str(num)+".jpg"
	          # print (imgTemp)
          #   while True:
          #     try:
                  ncamera.capture_sequence(imgTemp,format='jpg',use_video_port=True)
                  #time.sleep(0.5)
                  print ("Night cap mode", time.strftime("%Y%m%d%H%M%S",time.localtime()))
       
            except KeyboardInterrupt:
                  print("Breaked by kb")
                  break
            except Exception as e:
                  print(e)
            except IOError:
                  pass
        
        #exit camera
        ncamera.framerate=Fraction(10,1)
        ncamera.shutter_speed=1000
        #save file
        for i in range(totalStackNo):
            buf=imgTemp[i]
            buf.seek(0)
            filename=myPicTimeStamp+"_" + str(i)+".jpg"
            with open (filename,"wb+") as f:
                 f.write(buf.read())

 
       # time.sleep(1)




    #imfile=myPicTimeStamp
    im=Image.open(filename)
    print ("capImg size", im.size,"\n")
    myexif={ 
            PIL.ExifTags.TAGS[k]: v
            for k,v in im._getexif().items()
            if k in PIL.ExifTags.TAGS
        
           }
    #print myexif
    def get_field (exif, field):
        for (k,v) in exif.iteritems():
             if TAGS.get(k) == field:
                 return v
    myexif2=im._getexif()

    print ("ExposureTime", get_field(myexif2, 'ExposureTime'),"ISO",get_field(myexif2,'ISOSpeedRatings'))


if __name__=='__main__':
    main()

