Rails.application.routes.draw do

  mount SfTransit::Engine => "/sf_transit"
end
