require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Team City Server" do

	describe service("teamcity-server") do
		 it { should be_enabled }
		 it { should be_running }
	end

	describe port(8111) do
  	it { should be_listening }
	end

	describe group('teamcity') do
	  it { should exist }
	end

	describe user('teamcity') do
  	it { should exist }
  	it { should belong_to_group 'teamcity' }
	end

	describe file('/opt/teamcity/current') do
  	it { should be_directory }
  	it { should be_owned_by 'teamcity' }
  	it { should be_grouped_into 'teamcity' }
	end

	describe file('/var/lib/teamcity') do
  	it { should be_directory }
  	it { should be_owned_by 'teamcity' }
  	it { should be_grouped_into 'teamcity' }
	end

	describe file('/opt/teamcity/current/webapps/ROOT/WEB-INF') do
		it { should be_directory }
  	it { should be_owned_by 'teamcity' }
  	it { should be_grouped_into 'teamcity' }
  end

end

