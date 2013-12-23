class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    copy_file "tested_public_methods.rb", "config/initializers/tested_public_methods.rb"
  end
end