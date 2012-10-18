module SfTransit
  class Engine < ::Rails::Engine
    isolate_namespace SfTransit

    rake_tasks do
      load "lib/tasks/sf_transit_tasks.rake"
    end
  end
end
