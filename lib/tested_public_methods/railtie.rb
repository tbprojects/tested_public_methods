module TestedPublicMethods
  class Railtie < Rails::Railtie
    rake_tasks do
      require "tested_public_methods/rake_task"
    end

    initializer "Include your code in the controller" do
      ActiveSupport.on_load(:action_controller) do
        include TestedPublicMethods
      end
    end
  end
end