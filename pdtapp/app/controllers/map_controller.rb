class MapController < ApplicationController
  before_action :default_geo_json

  def amenity_criminality
    gon.action = 'amenity_criminality'
    amenities_to_geo_json_layer
    gon.init_geo_json[:center] = @centroid unless @centroid.nil?
  end

  def police_path
    gon.action = 'police_path'
    clickpoint_to_police_path unless params[:clickpoint].nil?

    @centroid = JSON.parse(params[:clickpoint])['coordinates'] rescue nil
    gon.init_geo_json[:center] = @centroid unless @centroid.nil?
  end

  def region_heatmap
    gon.action = 'region_heatmap'
    regions = RegionHeatmap.district_crime_map
    gon.regions = feature_collection regions
  end

  def crime_heatmap
    gon.action = 'crime_heatmap'
    heatmap = CrimeHeatmap.get_heatmap params[:date_from] || Date.current,
                                       params[:date_to]|| Date.current,
                                       params[:crime]
    gon.heatmap = feature_collection heatmap
  end

  private

  def clickpoint_to_police_path
    police_path, points = PolicePath.get_police_call params[:date_from] || Date.current,
                                                     params[:date_to] || Date.current,
                                                     params[:clickpoint]

    gon.police_path = feature_collection police_path
    gon.points = feature_collection points
  end

  def default_geo_json
    @crime_categories = Category.all.pluck :name

    gon.init_geo_json = {
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
