module SfTransit
  class Stop < ActiveRecord::Base
    attr_accessible :address, :lat, :lng, :title, :transfer_id
    geocoded_by :full_address, :latitude => :lat, :longitude => :lng
    after_validation { self.geocode unless self.lat && self.lng }

    has_many :leg_stops
    belongs_to :transfer

    def full_address
      "#{self.address}, San Francisco, California"
    end

    def transfer_to stop, route = nil
      if route && route.count > 2
        return
      end
      if not @valid_routes 
        @valid_routes = []

        # Run through each of this stop's leg stops
        self.leg_stops.each do |ls|
          route = [ls] unless route
          ls.leg.direct_transfers.each do |leg|
            leg.leg_stops.each do |ls|
              alternate_route = route.clone
              if ls.stop == stop
                alternate_route << ls
                @valid_routes << alternate_route
                puts alternate_route
                break
              else
                transfer_routes = ls.stop.transfer_to(stop)
                if transfer_routes.count
                  transfer_routes = transfer_routes.collect do |r|
                    alternate_route + r
                  end
                end
                @valid_routes += transfer_routes
              end
            end
          end
        end
      end
      @valid_routes
    end
  end
end
