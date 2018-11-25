Rails.application.routes.draw do
  root 'map#amenity_criminality'

  get 'police_path' => 'map#police_path'
  get 'region_heatmap' => 'map#region_heatmap'
  get 'crime_heatmap' => 'map#crime_heatmap'
end
