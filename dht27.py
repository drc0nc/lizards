#! /usr/bin/env python
# -*- coding: utf-8 -*-

# import des librairies
import Adafruit_DHT        # to read the DHT22 probe
import RPi.GPIO as GPIO    # to use GPIOs
import MySQLdb             # to use the database
import datetime            # to use the date and time
import csv                 # to handle CSV files

GPIO.setmode(GPIO.BCM)  # gpio BCM numbering

pin = 27 # gpio used

GPIO.setup(pin, GPIO.OUT)  # gpio in output mode

date = datetime.datetime.now() # set the date

humi, temp = Adafruit_DHT.read_retry(Adafruit_DHT.DHT22, pin) # probe reading
temp = temp * 9/5.0 + 32
# rounded
humi = round(humi,1)
temp = round(temp,1)

# Connection to the DHT22 database
bdd = MySQLdb.connect(host="localhost",           # local
                      user="lizard",              # user
                      passwd="lizard",            # password
                      db="DHT22")                 # database name
req = bdd.cursor()

# insert the date, temperature and humidity in the temphumi table
try:
    req.execute("""insert into temphumi27 (`datetime`,`temp`,`humi`) values (%s,%s,%s)""",(date,temp,humi))
    bdd.commit()

except:
    bdd.rollback()

# closing the connection
bdd.close()

######################### gauges write to CSV file ########################

fname = "/var/www/html/probe/27/probe27.csv" #create the csv
file = open(fname, "wb") #open the file

try:
    writer = csv.writer(file)

    writer.writerow(('Humidity','Temerature'))
    writer.writerow((humi, temp))
finally:
    file.close()
GPIO.cleanup()
exit

