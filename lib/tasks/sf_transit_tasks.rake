# desc "Explaining what the task does"
# task :sf_transit do
#   # Task goes here
# end

namespace :sf_transit do
  namespace :sync do
    desc "pull muni data from the next bus api"
  	task :muni => :environment do
    	SfTransit::Route.api_pull 'sf-muni'
  	end
  end
end

desc "blah"
task :directions => :environment do
  require 'directions'
  directions = TransitDirections.get_json '139 townsend street, san francisco, ca', '345 63rd Street, oakland, ca', :departure_time => (Time.now + 14.hours).to_i, :sensor => false
  puts directions
end
