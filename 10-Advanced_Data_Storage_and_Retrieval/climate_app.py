import numpy as np
import pandas as pd
import datetime as dt

import sqlalchemy
from sqlalchemy.ext.automap import automap_base
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, func
from sqlalchemy import inspect

from flask import Flask, jsonify

#################################
# Database setup 
#################################

engine = create_engine("sqlite:///Resources/hawaii.sqlite")

# reflect an existing database into a new model
Base = automap_base()

# reflect the tables
Base.prepare(engine, reflect=True)

# Save references to each table
Measurement = Base.classes.measurement
Station = Base.classes.station


#################################
# Flask app set up
#################################
app = Flask(__name__)
app.config['JSON_SORT_KEYS'] = False
#################################
# Flask routes
#################################
@app.route("/")
def home():
    return(
        f"Available Routes:<br/>"
        f"/api/v1.0/precipitation<br/>"
        f"/api/v1.0/stations<br/>"
        f"/api/v1.0/tobs<br/>"
        f"/api/v1.0/start_date<br/>"
        f"/api/v1.0/start_date/end_date<br/>"
        f"#NOTE# dates are selected by user as YYYY-MM-DD format (valid dates are 2010-01-01 to 2017-08-23)"
    )

#define Flask route
@app.route("/api/v1.0/precipitation")
#create function to display data
def precip():

    #start session 
    session = Session(engine)

    #define date variables
    last_date = dt.datetime.strptime(session.query(Measurement.date).order_by(Measurement.date.desc())\
                .first()[0],"%Y-%m-%d")
    query_date = last_date - dt.timedelta(days=365)

    #Quering precipitation measurements for 12 months before the last measurement date
    results = session.query(Measurement.date, Measurement.prcp)\
               .filter(Measurement.date <= last_date)\
               .filter(Measurement.date >= query_date).all()
    #close session   
    session.close()

    #read data from query into a dictionary
    precip_data = []  
    for date, prcp in results:
        precip_dict = {}
        precip_dict["Date"] = date
        precip_dict["Prcp"] = prcp
        precip_data.append(precip_dict)
        
    #return JSON version of results       
    return jsonify(precip_data)
    

@app.route("/api/v1.0/stations")

def stations():

    #start session 
    session = Session(engine)
    
    #query station details 
    results = session.query(Station.station, Station.name, Station.latitude, Station.longitude, Station.elevation).all()
    
    #close session 
    session.close()
    
    #read data from query into a dictionary
    station_data = []
    for station, name, latitude, longitude, elevation in results:
        station_dict = {}
        station_dict["Station ID"] = station
        station_dict["Name"] = name
        station_dict["Latitude"] = latitude
        station_dict["longitude"] = longitude
        station_dict["Elevation"] = elevation
        station_data.append(station_dict)
   
    #return JSON version of results          
    return jsonify(station_data)

@app.route("/api/v1.0/tobs")
def tobs():
    
    #start session
    session = Session(engine)
    
    #define date variables
    last_date = dt.datetime.strptime(session.query(Measurement.date).order_by(Measurement.date.desc())\
                .first()[0],"%Y-%m-%d")
    query_date = last_date - dt.timedelta(days=365)
    
    #query measurment table for TOBs data over 12 monts before the last measurement date
    results = session.query(Measurement.station, Measurement.date, Measurement.tobs)\
                .filter(Measurement.date <= last_date)\
                .filter(Measurement.date >= query_date).all()
    
    #close session
    session.close()
    
    #read data from query into dictionary
    tobs_data = []
    for station, date, tobs in results:
        tobs_dict = {}
        tobs_dict["Station"] = station
        tobs_dict["Date"] = date
        tobs_dict["Tobs"] = tobs
        tobs_data.append(tobs_dict)
        
    #return JSON version of results    
    return jsonify(tobs_data)

@app.route("/api/v1.0/<start>")
def start_date(start):
    
    session = Session(engine)
    
    #query results using user start date input in the route URL
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs))\
              .filter(Measurement.date >= start).all()
    
    session.close
    
    #read query data into dictionary 
    start_data = []
    for tmin, tavg, tmax in results: 
        start_dict = {}
        start_dict["Min Temperature"] = tmin
        start_dict["Avg Temperature"] = tavg
        start_dict["Max Temerature"] = tmax
        start_data.append(start_dict)
        
    #return JSON version of the query data    
    return jsonify(start_data)

@app.route("/api/v1.0/<start>/<end>")
def start_end_date(start,end):
    
    session = Session(engine)
    
    #query results using user start & end date input in the route URL
    results = session.query(func.min(Measurement.tobs), func.avg(Measurement.tobs), func.max(Measurement.tobs))\
              .filter(Measurement.date >= start).filter(Measurement.date <= end).all()
    
    session.close
    
    #read query data into dictionary
    start_end_data = []
    for tmin, tavg, tmax in results: 
        start_end_dict = {}
        start_end_dict["Min Temperature"] = tmin
        start_end_dict["Avg Temperature"] = tavg
        start_end_dict["Max Temerature"] = tmax
        start_end_data.append(start_end_dict)
    
    #return JSON version of the query data
    return jsonify(start_end_data)
        
    


if __name__ == '__main__':
    app.run(debug=True)
