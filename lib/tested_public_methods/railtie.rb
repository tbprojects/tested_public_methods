module TestedPublicMethods
  class Railtie < Rails::Railtie
    rake_tasks do
      require "tested_public_methods/rake"
    end
  end
end