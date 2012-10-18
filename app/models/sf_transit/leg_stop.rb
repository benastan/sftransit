module SfTransit
  class LegStop < ActiveRecord::Base
    attr_accessible :leg_id, :stop_id
    delegate :lat, :lng, :nearbys, :to => :stop

    belongs_to :stop
    belongs_to :leg

    def direct_transfers
      self.leg.direct_transfers
    end
  end
end
