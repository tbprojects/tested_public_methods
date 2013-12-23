require 'spec_helper'

describe TestedPublicMethods do
  it('version must be defined') { expect(described_class::VERSION).to be_present }

  describe '.configuration' do
    context 'without defining custom config' do
      let(:expected_config) { OpenStruct.new(skip_classes: [], skip_methods: {}) }

      it { expect(described_class.configuration).to eql expected_config }
    end

    context 'with defining custom config' do
      let(:expected_config) { OpenStruct.new(skip_classes: [ProjectsController], skip_methods: { Project => [:label]})}
      before do
        TestedPublicMethods.configure do |config|
          config.skip_classes = [ProjectsController]
          config.skip_methods = {Project => [:label]}
        end
      end

      it { expect(described_class.configuration).to eql expected_config }
    end
  end
end