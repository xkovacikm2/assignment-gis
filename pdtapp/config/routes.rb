Rails.application.routes.draw do
  root 'map#amenity_criminality'
  get 'police_path' => 'map#police_path'
end
