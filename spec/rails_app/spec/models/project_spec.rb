require 'spec_helper'

describe Project do

  subject { Project.new subject: 'Testing project' }

  describe '#label' do
    context 'with company' do
      before { subject.company = 'Acme' }

      its(:label) {should eql 'Testing project (Acme)'}
    end

    context 'without company' do
      its(:label) {should eql 'Testing project'}
    end
  end

end
