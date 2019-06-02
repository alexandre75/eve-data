
class Station < ApplicationRecord
  validates :eveid, uniqueness: true
  
  belongs_to :region
end
