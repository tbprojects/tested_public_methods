require 'spec_helper'

describe ProjectsController do
  describe 'GET #create' do
    let(:attributes) {{subject: 'New project'}}
    let(:call_request) {post :create, project: attributes}

    it { expect{call_request}.to change{Project.count}.by(1) }
  end

end