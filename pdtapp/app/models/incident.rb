class Incident < ApplicationRecord
  belongs_to :category
  belongs_to :resolution
  belongs_to :police_district
end
