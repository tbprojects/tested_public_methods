require 'spec_helper'

describe Task do

  subject { Task.new name: 'Testing task', description: 'Just do it' }

  describe '#task_label' do
    its(:task_label) { should eql 'Testing task: Just do it' }
  end

  describe '.without_description' do
    before do
      Task.create name: 'test 1'
      Task.create name: 'test 1', description: 'nice one'
    end

    it { expect(described_class.without_description.to_a).to have(1).project }
  end

end
