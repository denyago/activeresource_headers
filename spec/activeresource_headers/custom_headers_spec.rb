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
      allow(Profile).to receive(:time).and_return("yesterday")
    end

    it "runs it's block each time" do
      Profile.find(:all)
      expect(FakeWeb.last_request[:time]).to eq('yesterday')

      allow(Profile).to receive(:time).and_return("tomorrow")

      Profile.find(:all)
      expect(FakeWeb.last_request[:time]).to eq('tomorrow')
    end

    it "deeply merges it's headers from #with_headers method" do
      Profile.with_headers(time: 'Soon!').find(:all)
      expect(FakeWeb.last_request[:time]).to eq('Soon!')
    end

    it 'can save results' do
      FakeWeb.register_uri(:post, "#{REMOTE_HOST}/profiles.json", body: {post: {body: 'The post'}}.to_json)
      profile = Profile.create(body: 'The post')
      expect(profile.body).to eq('The post')
      expect(FakeWeb.last_request[:time]).to eq('yesterday')
    end
  end

  describe "#with_headers" do
    before(:each) do
      unset_const(:Profile)
      class Profile < ActiveResource::Base
        include ActiveresourceHeaders::CustomHeaders
        self.site = REMOTE_HOST
      end
      FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json", body: [].to_json)
      Profile.with_headers('Authorization' => 'OAuth2 token', 'Client-Id' => 'xyz').find(:all)
    end
    it "is chainable method for adding custom headers for the request" do
      expect(FakeWeb.last_request["authorization"]).to  eq('OAuth2 token')
      expect(FakeWeb.last_request["client-id"]).to      eq('xyz')
    end

    it "don't remembers it's custom headers between requests" do
      FakeWeb.register_uri(:get, "#{REMOTE_HOST}/profiles.json?hello=world", body: [].to_json)
      Profile.find(:all, params: {hello: 'world'})
      expect(FakeWeb.last_request["authorization"]).to  be_nil
      expect(FakeWeb.last_request["client-id"]).to      be_nil
    end
  end
end
