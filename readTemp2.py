#!/usr/bin/python
import pigpio
import DHT22
import time
import os
import sys
import datetime
import subprocess
import shlex

# Intervals of about 2 seconds or less will eventually hang the DHT22.
INTERVAL=3
RETRY = 3
SENSOR_GPIO = 22
ISDHT11 =False
Valid=False

pi=pigpio.pi()
probe = DHT22.sensor(pi,SENSOR_GPIO,DHT11=ISDHT11)
probe2 = DHT22.sensor(pi,SENSOR2_GPIO,DHT11=ISDHT11)


#Function to read cpu temperature
def readCpuTemperature():
   fichier = open("/sys/class/thermal/thermal_zone0/temp","r")
   texte =  fichier.readline()
   fichier.close()
   return  (float(texte)/1000.0)


#read the DHT22/11 Sensor at corresponding pin
#return None if it can't
#return [humidity temperature]

def readDHT_sensor(probe):
  global pi
  #retry at least RETRY times if something wrong
  for loop in range(RETRY):

    #put a minimum of interval stabilization
    if loop!=0:
      time.sleep(INTERVAL)

    #start transfer
    #Be aware that the reading will be from the last conversion
    #It is wise to read it twice and keep the last one

    probe.trigger()

    #wait for completion
    time.sleep(0.2)

    temperature = probe.temperature()
    humidity    = probe.humidity()

    if temperature == (-999):
      continue

    if humidity == (-999):
      continue

    return [temperature,humidity]

  #if we are here it is because with retry and it didn't work
  #just return None
  return [None , None]
  
def readDHT_sensor(probe2):
  global pi
  #retry at least RETRY times if something wrong
  for loop in range(RETRY):

    #put a minimum of interval stabilization
    if loop!=0:
      time.sleep(INTERVAL)

    #start transfer
    #Be aware that the reading will be from the last conversion
    #It is wise to read it twice and keep the last one

    probe.trigger()

    #wait for completion
    time.sleep(0.2)

    temperature = probe.temperature()
    humidity    = probe.humidity()

    if temperature == (-999):
      continue

    if humidity == (-999):
      continue

    return [temperature,humidity]

  #if we are here it is because with retry and it didn't work
  #just return None
  return [None , None]  




##### MAIN #######


#read sensor once to capture the current temp
readDHT_sensor()

#read sensor again but now keep the data
time.sleep(INTERVAL)
sensorData = readDHT_sensor()
cpuTemp = readCpuTemperature()

now = datetime.datetime.now()

webdata = "/webdata/"


#put current value into a file
def TempS(value):
  if value == None :
    return "---"
  return value

try:
  file = open(webdata+"CurrentData.txt","w")
  file.write("{}\t{}\t{}\t{}\n".format(now,TempS(cpuTemp),TempS(sensorData[0]),TempS(sensorData[1])))
  file.close()
except:
  pass


########rddtool

def Validate(value):
  if value == None:
    return ":U"
  else:
    return ":{}".format(value)

#create text string to insert data

rdata = "N" + Validate(cpuTemp) + Validate(sensorData[0]) + Validate(sensorData[1])

#now let insert it into the rddtool data

fileRrdtool = "/home/pi/temperatures.rrd"

subprocess.Popen(["/usr/bin/rrdtool","update",fileRrdtool,rdata])

#and now let's extract data to create data file for the web page

def rrdExport(start , step , sortieXML):
  texte = "rrdtool xport -t -s {0} -e now --step {1} ".format(start, step)
  texte += "DEF:a={0}:th_cpu:AVERAGE ".format(fileRrdtool)
  texte += "DEF:b={0}:th_dht22:AVERAGE ".format(fileRrdtool)
  texte += "DEF:c={0}:hm_dht22:AVERAGE ".format(fileRrdtool)
  texte += "XPORT:a:""th_cpu"" "
  texte += "XPORT:b:""th_dht22"" "
  texte += "XPORT:c:""hm_dht22"" "

  fileout = open(webdata+sortieXML,"w")
  args = shlex.split(texte)
  subprocess.Popen(args, stdout=fileout)
  fileout.close()


# ok extact 1 hour data
rrdExport("now-1h",300, "temperature1h.xml")

# ok extact 3 hours data
rrdExport("now-3h",300, "temperature3h.xml")

#ok 24 hours
rrdExport("now-24h",900, "temperature24h.xml")

#ok 48 hours
rrdExport("now-48h",1800, "temperature48h.xml")

#ok 1 week
rrdExport("now-8d",3600, "temperature1w.xml")

#ok 1 month
rrdExport("now-1month",14400, "temperature1m.xml")

#ok 3 month
rrdExport("now-3month",28800, "temperature3m.xml")

#ok 1 year
rrdExport("now-1y",43200, "temperature1y.xml")



if sensorData[0]!=None:
  print("Temp:{} Celsius  Humidity:{}%".format(sensorData[0],sensorData[1],))
else:
  print("Unable to read sensor")


#probe.cancel()
pi.stop()
