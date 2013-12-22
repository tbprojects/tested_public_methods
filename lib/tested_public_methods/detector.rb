class TestedPublicMethods::Detector
  SOURCE_DIR = File.join(Rails.root, 'app')
  SPEC_DIR   = File.join(Rails.root, 'spec')
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
      else
        buffer_warning("* missing spec file for #{klass.name}", :missing_spec)
      end
    end
    print_summary
  end

  private
  def buffer_warning(text, type)
    @buffer[type].push(text)
    @problem_counter += 1
  end

  def print_summary
    puts @buffer[:missing_spec].join("\n")
    puts @buffer[:missing_test].join("\n")
    puts "\nFound #{@problem_counter} issues" if @problem_counter > 0
  end

  def has_spec_file?(klass)
    File.exists?(spec_file_path(klass))
  end

  def source_file_path(klass)
    list_of_classes[klass]
  end

  def spec_file_path(klass)
    source_file_path(klass).gsub(SOURCE_DIR, SPEC_DIR).gsub('.rb', '_spec.rb')
  end

  def list_of_classes
    @list_of_classes ||= Dir.glob(File.join(SOURCE_DIR, "**/*.rb")).each_with_object({}) do |file_path, memo|
      klass_names = File.read(file_path).scan(CLASS_NAME_REG_EXP).flatten
      klass_names.each do |klass_name|
        begin
          memo[klass_name.constantize] = file_path
        rescue
          puts("WARNING: can't analyze unsupported class #{klass_name} in #{file_path}")
        end
      end
    end
  end

  def untested_instance_methods(klass)
    instance_methods_in_class(klass) - instance_methods_in_spec(klass)
  end

  def untested_class_methods(klass)
    class_methods_in_class(klass) - class_methods_in_spec(klass)
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
end