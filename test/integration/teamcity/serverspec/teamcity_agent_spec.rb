require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Team City Agent" do

	describe service("teamcity-agent") do
		 it { should be_enabled }
		 it { should be_running }
	end

end

