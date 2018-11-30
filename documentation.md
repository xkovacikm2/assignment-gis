# Overview

This application works with San Francisco police dispatch calls. Most important features are:
- display criminal activity around different types of amenities in San Francisco
- navigate police to crime from nearest police station, with stop in nearest coffee house en route to buy donuts.
- total overview of criminality in city districts
- heatmap of crime in the city

This is it in action:

![amenities](amenities.png)
![navigation](navigation.png)
![districts](districts.png)
![heatmap](heatmap.png)

The application has classic MVC architecture and is built in MVC framework.

## Model
Only few database tables actually have representation in Rails model, and those are the police reports and few associated enums imported from csv from kaggle.
Most of the tables are imported from osm and from pg_routing. Model is very thin, only basic generated classes are present.

## Controller
There single map controller in application, with 4 action, each for one described use case.
It sanitizes and then passes user input into service classes that handle raw SQL queries and converts returned data to geojson
that can be fed to mapbox API.

## View
Consists of 2 parts:
- **html**: simple html container for map and forms for user input
- **coffee**: rubylike compiled to javascript language, that connects to mapboxJS api and feeds it with
geojsons provided by controller.

## Services
Services contain raw sql queries for postgis, and methods that serve geojson for mapbox.
Query optimisation story is written in README.rb

## Data
Data comes from 2 sources:
1. **kaggle** provides police calls reports of crimes and their locations
2. **openstreetmaps** provides polygons for amenities and then points and roads for pg_routing to form a graph for navigation.

