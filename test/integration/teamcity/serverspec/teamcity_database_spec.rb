
require 'serverspec'
require "spec_helper"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Team City Database" do

	describe service("postgresql") do
		 it { should be_enabled }
		 it { should be_running }
	end

	it "should have created teamcity database" do
		database_exists? "teamcity"
	end

end