namespace :tested_public_methods do
  desc "Returns list of public methods that do not have their own unit tests."
  task analyze: :environment do
    TestedPublicMethods::Detector.new.analyze
  end
end