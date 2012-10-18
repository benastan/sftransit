# desc "Explaining what the task does"
# task :sf_transit do
#   # Task goes here
# end

namespace :sf_transit do
  namespace :sync do
    desc "pull muni data from the next bus api"
  	task :muni => :environment do
    	SFTransit::Route.api_pull
  	end
  end
end
