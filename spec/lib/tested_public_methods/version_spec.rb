require 'spec_helper'

describe TestedPublicMethods do
  it('version must be defined') { expect(described_class::VERSION).to be_present }
end