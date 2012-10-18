module SFTransit
  class Leg < ActiveRecord::Base
    attr_accessible :abbr, :route_id, :title
    belongs_to :route
    has_many :leg_junctions
    has_many :leg_stops

    def stops
      if @stops.nil?
        @stops = []
        self.leg_stops.each do |ls|
          @stops << ls.stop
        end
      end
      @stops
    end

    def direct_transfers
      if @transfer_routes.nil?
        @transfer_routes = []
        self.leg_stops.each do |leg_stop|
          leg_stop.stop.leg_stops.each do |ls|
            @transfer_routes << ls.leg unless ls == leg_stop
          end
        end
      end
      @transfer_routes
    end
  end
end
