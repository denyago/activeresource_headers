require 'spec_helper'

describe ActiveresourceHeaders::CustomHeaders do

  before(:each) do
    unset_const(:Profile)
    class Profile < ActiveResource::Base
      include ActiveresourceHeaders::CustomHeaders

      self.site = REMOTE_HOST

      custom_headers do
        {time: Time.now}
      end
    end
  end

  it "add class method for defining custom headers in the model" do
    FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json", body: [].to_json)
    Time.stub(:now).and_return("yesterday")

    Profile.find(:all)
    FakeWeb.last_request[:time].should eq('yesterday')

    Time.stub(:now).and_return("tomorrow")

    Profile.find(:all)
    FakeWeb.last_request[:time].should eq('tomorrow')
  end

  it "add method for headers in find request" do
    FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json", body: [].to_json)

    Profile.with_headers(time: 'Soon!').find(:all)
    FakeWeb.last_request[:time].should eq('Soon!')
  end

end
