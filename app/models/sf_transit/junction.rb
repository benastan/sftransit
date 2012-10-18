module SfTransit
  class Junction < ActiveRecord::Base
    attr_accessible :address, :lat, :lng, :name
    reverse_geocoded_by :lat, :lng
  end
end
