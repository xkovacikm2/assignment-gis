# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

mapboxgl.accessToken = 'pk.eyJ1IjoiaG9jaWt0bzE5IiwiYSI6ImNqb3NxMGluczBkYWgzcm85MXEzYWxuaW8ifQ.nUwtVum6Bl648NNmJrxJ8Q';

$ ->
  amenity_criminality() if gon.action == 'amenity_criminality'
  police_path() if gon.action == 'police_path'

amenity_criminality = ->
  map = new mapboxgl.Map gon.init_geo_json
  popup = new mapboxgl.Popup({
    closeButton: false,
    closeOnClick: false
  })

  map.on 'load', () ->
    map.loadImage 'images/red-dot.png', (e, image) ->
      map.addImage('dot', image)

    map.addLayer({
      id: 'paint-amenities'
      type: 'fill'
      source: gon.amenities
      paint:
        'fill-color': '#000'
        'fill-opacity': 0.7
    })

    console.log gon.crime_gravity

    map.addLayer({
      id: 'crime-gravity'
      type: 'symbol'
      source: gon.crime_gravity
      layout:
        'icon-image': 'dot'
        'icon-size': ['get', 'gravity']
    })

  map.on 'mouseenter', 'paint-amenities', (e) ->
    map.getCanvas().style.cursor = 'pointer'

    coordinates = e.features[0].geometry.coordinates.slice()[0][0]
    properties = e.features[0].properties

    html = "<h3>#{properties.name}</h3>\
     <br>\
     <p>occurences: #{properties.occurences}</p>\
     <p>#{properties.descriptions}</p>"

    while (Math.abs(e.lngLat.lng - coordinates[0]) > 180)
      coordinates[0] += e.lngLat.lng > coordinates[0] ? 360 : -360

    popup.setLngLat(coordinates).setHTML(html).addTo(map)

  map.on 'mouseleave', 'paint-amenities', () ->
    map.getCanvas().style.cursor = ''
    popup.remove()

police_path = ->
  map = new mapboxgl.Map gon.init_geo_json
  popup = new mapboxgl.Popup({
    closeButton: false,
    closeOnClick: false
  })

  console.log gon.police_path
  console.log gon.points

  map.on 'load', ->
    map.loadImage 'images/red-dot.png', (e, image) ->
      map.addImage('dot', image)

    map.addLayer({
      id: 'points'
      type: 'circle'
      source: gon.points
      paint:
        'circle-color': ['get', 'color']
    })

    map.addLayer({
      id: 'routes'
      type: 'line'
      source: gon.police_path
      layout:
        'line-join': 'round'
        'line-cap': 'round'
      paint:
        'line-color': '#888'
        'line-width': 8
    })

  map.on 'mouseenter', 'points', (e) -> set_popup(e, map, popup)
  map.on 'mouseleave', 'points', (e) -> unset_popup(e, map, popup)
  map.on 'mouseenter', 'routes', (e) -> set_popup(e, map, popup)
  map.on 'mouseleave', 'routes', (e) -> unset_popup(e, map, popup)

  map.on 'click', (e) ->
    clickpoint_value = JSON.stringify({
      type: 'Point'
      coordinates: [e.lngLat.lng, e.lngLat.lat]
    })

    $('#clickpoint').val(clickpoint_value)

    map.addLayer({
      id: 'clickpoint'
      type: 'symbol'
      source:
        type: 'geojson'
        data:
          type: 'Feature'
          geometry:
            type: 'Point'
            coordinates: [e.lngLat.lng, e.lngLat.lat]
      layout:
        'icon-image': 'dot'
        'icon-size': 1
    })

unset_popup = (e, map, popup) ->
  map.getCanvas().style.cursor = ''
  popup.remove()

set_popup = (e, map, popup) ->
  map.getCanvas().style.cursor = 'pointer'

  coordinates = e.features[0].geometry.coordinates.slice()
  properties = e.features[0].properties

  html = "<p>#{properties.text}</p>"

  try
    popup.setLngLat(coordinates).setHTML(html).addTo(map)
  catch
    try
      popup.setLngLat(coordinates[0]).setHTML(html).addTo(map)
    catch
      popup.setLngLat(coordinates[0][0]).setHTML(html).addTo(map)
