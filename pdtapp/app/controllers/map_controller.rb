class MapController < ApplicationController
  before_action :amenities_to_geo_json_layer, only: :amenity_criminality

  def amenity_criminality
    gon.init_geo_json = default_amenity_criminality
    gon.action = 'amenity_criminality'
    @crime_categories = Category.all.pluck :name

    gon.init_geo_json[:center] = @centroid unless @centroid.nil?
  end

  def police_path

  end

  private

  def default_amenity_criminality
    {
      container: 'map',
      style: 'mapbox://styles/mapbox/basic-v9',
      zoom: 12,
      center: [-122.4194, 37.7749] # San francisco
    }
  end

  def amenities_to_geo_json_layer
    amenities, gravity, @centroid = Amenities.get_amenities_crimes(params[:amenity],
                                                          params[:crime],
                                                          params[:date_from] || Date.current.to_s,
                                                          params[:date_to] || Date.current.to_s,
                                                          params[:distance] || 0)

    gon.amenities = feature_collection amenities
    gon.crime_gravity = feature_collection gravity
  end

  def feature_collection(features)
    {
      type: 'geojson',
      data: {
        type: 'FeatureCollection',
        features: features
      }
    }
  end
end
