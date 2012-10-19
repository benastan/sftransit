module SfTransit
  class Route < ActiveRecord::Base
    attr_accessible :abbr, :agency, :title 
    has_many :route_junctions, :dependent => :destroy
    has_many :legs

    scope :muni, where(:agency => 'sf-muni')
    scope :bart, where(:agency => 'bart')

    def transfer_to(route)
      transfers = self.direct_transfers
      routes = []
      self.legs.each do |leg|
        _route = []
        leg.leg_stops.each do |leg_stop| 
          leg_stop
        end
      end
    end

    def direct_transfers
      if @transfer_routes.nil?
        @transfer_routes = []
        self.legs.each do |leg|
          @transfer_routes += leg.direct_transfers
        end
        @transfer_routes = Leg.select {|l| @transfer_routes.include? l}
      end
      @transfer_routes
    end

    def self.api_pull
      require 'URI'
      require 'next_muni'
      routes = NextMuni.get_routes 'sf-muni'
      routes.each do |r|
        route = Route.find_or_initialize_by_agency_and_abbr 'sf-muni', r[:id]
        route.update_attribute :title, r[:title]
        legs = NextMuni.get_stops URI.escape(route[:abbr]), {
          :stop_fields => ['title', 'lat', 'lon']
        }
        legs.each do |l|
          leg = route.legs.find_or_initialize_by_abbr_and_title l[:id], l[:name]
          leg.save() unless leg.id
          i = 0
          ii = l[:stops].count
          puts l[:name]
          l[:stops].each do |id, attr|
            i += 1
            puts "#{i} of #{ii}"
            stop = Stop.find_or_initialize_by_title id
            stop.update_attributes(
              :address => attr['title'],
              :lat => attr['lng'],
              :lng => attr['lon']
            )
            stop.save
            legstop = LegStop.find_or_initialize_by_stop_id_and_leg_id stop.id, leg.id
            legstop.save unless legstop.id
          end
        end
      end
    end
  end
end
