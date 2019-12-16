#!/usr/bin/python3
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setup(17, GPIO.OUT)
import psutil
import time
from datetime import datetime
from datetime import timedelta
#import csv

#def getCPUuse():
#    return(str(os.popen("top -n1 | awk '/Cpu\(s\):/ {print $2}'").readline().strip(\
#)))

def cpuTemp():
  while True:
    try:
      outputFile = open('cpuTemp.csv','a')
      tFile = open('/sys/class/thermal/thermal_zone0/temp')
      temp = float(tFile.read())
      tempC = temp/1000
      cpuUsage=psutil.cpu_percent()
      cpuFreqTup=psutil.cpu_freq()
      cpuFreq=cpuFreqTup.current

      time.sleep(1)#

      timeStamp=time.strftime("%Y/%m/%d %H:%M:%S",time.localtime())
      outText=timeStamp+","+str(tempC)+","+str(cpuUsage)+"%,"+str(cpuFreq)+"\n"
      print (timeStamp,",",tempC,",",cpuUsage,"%,",cpuFreq)
      
      outputFile.writelines(outText)
  
    except KeyboardInterrupt:
      print("Keyboard break.")
      tFile.close()
      #GPIO.cleanup()
      outputFile.close()
      break

def main():
    cpuTemp()

if __name__=='__main__' :
    main()

