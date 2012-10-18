module SfTransit
  class LegJunction < ActiveRecord::Base
    attr_accessible :junction_id, :leg_id, :weight
    belongs_to :leg
    belongs_to :junction
  end
end
