require 'spec_helper'

describe TestedPublicMethods::Detector do

  describe '#analyze' do
    let(:expected_buffer_test) {["* missing test for Task#project_name",
                                 "* missing test for Task.with_description",
                                 "* missing test for Project#formatted_start_at",
                                 "* missing test for ProjectsController#index"]}
    let(:expected_buffer_spec) {["* missing spec file for User"]}
    before { subject.analyze }

    it { expect(subject.instance_variable_get('@problem_counter')).to eql 5 }
    it { expect(subject.instance_variable_get('@buffer')[:missing_test]).to match_array expected_buffer_test }
    it { expect(subject.instance_variable_get('@buffer')[:missing_spec]).to match_array expected_buffer_spec }
  end

  describe '#list_of_classes' do
    it { expect(subject.send(:list_of_classes).keys).to match_array [Project, Task, User, ProjectsController]}
  end

  describe '#has_spec_file?' do
    { Project => true, Task => true, User => false, ProjectsController => true }.each do |klass, presence|
      it { expect(subject.send(:has_spec_file?, klass)).to eql presence}
    end
  end

  describe '#untested_instance_methods' do
    context 'without custom config' do
      { Project => [:formatted_start_at],
        Task => [:project_name],
        ProjectsController => [:index]}.each do |klass, methods|
        it { expect(subject.send(:untested_instance_methods, klass)).to match_array methods}
      end
    end

    context 'with custom config' do
      before { TestedPublicMethods.stub(:configuration).
               and_return(OpenStruct.new(skip_methods: {Project => [:formatted_start_at]})) }

      it { expect(subject.send(:untested_instance_methods, Project)).to match_array []}
    end
  end

  describe '#untested_class_methods' do
    context 'without custom config' do
      { Project => [],
        Task => [:with_description],
        ProjectsController => []}.each do |klass, methods|
        it { expect(subject.send(:untested_class_methods, klass)).to match_array methods}
      end
    end

    context 'with custom config' do
      before { TestedPublicMethods.stub(:configuration).
          and_return(OpenStruct.new(skip_methods: {Task => [:with_description]})) }

      it { expect(subject.send(:untested_class_methods, Task)).to match_array []}
    end
  end

  describe '#instance_methods_in_class' do
    { Project => [:label, :formatted_start_at],
      Task => [:project_name, :task_label],
      User => [:label],
      ProjectsController => [:index, :create]}.each do |klass, methods|
      it { expect(subject.send(:instance_methods_in_class, klass)).to match_array methods}
    end
  end

  describe '#class_methods_in_class' do
    { Project => [],
      Task => [:with_description, :without_description],
      User => [],
      ProjectsController => []}.each do |klass, methods|
      it { expect(subject.send(:class_methods_in_class, klass)).to match_array methods}
    end
  end

  describe '#instance_methods_in_spec' do
    { Project => [:label],
      Task => [:task_label],
      ProjectsController => [:create]}.each do |klass, methods|
      it { expect(subject.send(:instance_methods_in_spec, klass)).to match_array methods}
    end
  end

  describe '#class_methods_in_spec' do
    { Project => [],
      Task => [:without_description],
      ProjectsController => []}.each do |klass, methods|
      it { expect(subject.send(:class_methods_in_spec, klass)).to match_array methods}
    end
  end
end