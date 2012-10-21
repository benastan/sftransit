module SfTransit
  class Route < ActiveRecord::Base
    attr_accessible :abbr, :agency, :title 
    has_many :route_junctions, :dependent => :destroy
    has_many :legs

    scope :muni, where(:agency => 'sf-muni')
    scope :bart, where(:agency => 'bart')

    def self.find_by_abbr abbr
      self.select { |r|
        return true if r.abbr == abbr
        not r.legs.find_by_title(abbr).nil?
      } [0]
    end

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

    def self.api_pull agency
      if agency == 'sf-muni'
        self.muni_api_pull
      else
        self.bart_api_pull
      end
    end

    private

    def self.muni_api_pull
      require 'uri'
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

    def self.bart_api_pull
      require 'bart'
      routes_data = Bart.routes
      processed = []
      routes = []
      routes_data = routes_data.collect do |r|
        Bart.routes(r[:number])[0]
      end

      routes_data.each do |leg|
        if not processed.include? leg
          reverse_abbr = leg[:abbr].split('-').reverse.join('-')
          analogue = routes_data.select {|r| r[:abbr] == reverse_abbr}[0]

          processed << leg
          processed << analogue

          route = {}

          if leg[:direction] == 'north'
            route[:north] = leg
            route[:south] = analogue
          else
            route[:south] = leg
            route[:north] = analogue
          end

          routes << route
        end
      end

      routes.each do |r|
        route = Route.find_or_initialize_by_agency_and_abbr 'bart', r[:north][:abbr]
        route.update_attribute :title, r[:north][:name]

        [:north, :south].each do |l|
          leg = route.legs.find_or_initialize_by_abbr_and_title r[l][:number], r[l][:abbr]
          leg.save() unless leg.id
        end
      end
    end
  end
end
