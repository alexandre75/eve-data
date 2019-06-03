class Region < ApplicationRecord
  validates :name, presence: true
  validates :eve_id, uniqueness: {
              message: ->(object, data) do
                "Region id must be unique : #{data[:value]}"
              end
            }
  has_many :stations
end
