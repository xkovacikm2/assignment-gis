# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

mapboxgl.accessToken = 'pk.eyJ1IjoiaG9jaWt0bzE5IiwiYSI6ImNqb3NxMGluczBkYWgzcm85MXEzYWxuaW8ifQ.nUwtVum6Bl648NNmJrxJ8Q';

$ ->
  amenity_criminality() if gon.action == 'amenity_criminality'

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

    popup.setLngLat(coordinates).setHTML(html).addTo(map)

  map.on 'mouseleave', 'paint-amenities', () ->
    map.getCanvas().style.cursor = ''
    popup.remove()
