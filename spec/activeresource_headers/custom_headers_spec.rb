require 'spec_helper'

describe ActiveresourceHeaders::CustomHeaders do

  require File.expand_path('spec/spec_helper')

  describe "while using #custom_headers class method" do
    before(:each) do
      unset_const(:Profile)
      class Profile < ActiveResource::Base
        include ActiveresourceHeaders::CustomHeaders

        self.site = REMOTE_HOST

        custom_headers do
          {time: self.time}
        end
      end
      FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json", body: [].to_json)
      Profile.stub(:time).and_return("yesterday")
    end

    it "runs it's block each time" do
      Profile.find(:all)
      FakeWeb.last_request[:time].should eq('yesterday')

      Profile.stub(:time).and_return("tomorrow")

      Profile.find(:all)
      FakeWeb.last_request[:time].should eq('tomorrow')
    end

    it "deeply merges it's headers from #with_headers method" do
      Profile.with_headers(time: 'Soon!').find(:all)
      FakeWeb.last_request[:time].should eq('Soon!')
    end
  end

  it "adds #with_headers chainable method" do
    unset_const(:Profile)
    class Profile < ActiveResource::Base
      include ActiveresourceHeaders::CustomHeaders
      self.site = REMOTE_HOST
    end
    FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json", body: [].to_json)

    Profile.with_headers('Authorization' => 'OAuth2 token', 'Client-Id' => 'xyz').find(:all)
    FakeWeb.last_request["authorization"].should eq('OAuth2 token')
    FakeWeb.last_request["client-id"].should eq('xyz')
  end

end
