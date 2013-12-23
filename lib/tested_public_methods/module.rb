module TestedPublicMethods
  VERSION = '1.0.0'

  attr_writer :configuration

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= OpenStruct.new(skip_classes: [], skip_methods: {})
  end
end