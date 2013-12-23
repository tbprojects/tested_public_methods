class TestedPublicMethods::Detector
  CLASS_NAME_REG_EXP = /^[\s]*class[\s]+([\S]+)[\s]+/
  CLASS_METHOD_REG_EXP = /['"]\.([\S]+)['"]/
  INSTANCE_METHOD_REG_EXP = /['"](?:POST|GET|DELETE|PUT|)*[\s]*#([\S]+)['"]/

  def analyze
    @problem_counter = 0
    @buffer = {missing_test: [], missing_spec: []}
    list_of_classes.keys.each do |klass|
      if  has_spec_file? klass
        untested_instance_methods(klass).each do |method_name|
          buffer_warning("* missing test for #{klass.name}##{method_name}", :missing_test)
        end
        untested_class_methods(klass).each do |method_name|
          buffer_warning("* missing test for #{klass.name}.#{method_name}", :missing_test)
        end
      elsif !class_skipped? klass
        buffer_warning("* missing spec file for #{klass.name}", :missing_spec)
      end
    end
    print_summary
  end

  private
  def source_dir
    File.join(Rails.root, 'app')
  end

  def spec_dir
    File.join(Rails.root, 'spec')
  end

  def buffer_warning(text, type)
    @buffer[type].push(text)
    @problem_counter += 1
  end

  def print_summary
    puts @buffer[:missing_spec].join("\n").red
    puts @buffer[:missing_test].join("\n").red
    if @problem_counter > 0
      puts "\nFound #{@problem_counter} issues".red
    else
      puts "\nGreat, all public methods are tested!".green
    end
  end

  def has_spec_file?(klass)
    File.exists?(spec_file_path(klass))
  end

  def class_skipped?(klass)
    config_skip_classes.include? klass.to_s
  end

  def source_file_path(klass)
    list_of_classes[klass]
  end

  def spec_file_path(klass)
    source_file_path(klass).gsub(source_dir, spec_dir).gsub('.rb', '_spec.rb')
  end

  def list_of_classes
    @list_of_classes ||= Dir.glob(File.join(source_dir, "**/*.rb")).each_with_object({}) do |file_path, memo|
      klass_names = File.read(file_path).scan(CLASS_NAME_REG_EXP).flatten
      klass_names.each do |klass_name|
        begin
          memo[klass_name.constantize] = file_path
        rescue
          puts "WARNING: can't analyze unsupported class #{klass_name} in #{file_path}".yellow
        end
      end
    end
  end

  def untested_instance_methods(klass)
    instance_methods_in_class(klass) - instance_methods_in_spec(klass) - skipped_methods(klass)
  end

  def untested_class_methods(klass)
    class_methods_in_class(klass) - class_methods_in_spec(klass) - skipped_methods(klass)
  end

  def skipped_methods(klass)
    (config_skip_methods[klass.to_s] || []).map(&:to_sym)
  end

  def instance_methods_in_class(klass)
    klass.instance_methods(false).select do |method_name|
      klass.instance_method(method_name).source_location.try(:first) == source_file_path(klass)
    end
  end

  def class_methods_in_class(klass)
    klass.public_methods(false).select do |method_name|
      klass.method(method_name).source_location.try(:first) == source_file_path(klass)
    end
  end

  def instance_methods_in_spec(klass)
    File.read(spec_file_path(klass)).scan(INSTANCE_METHOD_REG_EXP).flatten.map(&:to_sym)
  end

  def class_methods_in_spec(klass)
    File.read(spec_file_path(klass)).scan(CLASS_METHOD_REG_EXP).flatten.map(&:to_sym)
  end

  def config_skip_methods
    TestedPublicMethods.configuration.skip_methods.stringify_keys
  end

  def config_skip_classes
    TestedPublicMethods.configuration.skip_classes.map(&:to_s)
  end
end