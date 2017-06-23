require "spec_helper"
require 'pry'

describe Lita::Client do
  describe "#new" do
    it "with no TIME_TRACKER_CLIENT env var" do
      expect { described_class.new }.to raise_error(
        'Invalid TIME_TRACKER_CLIENT env var. Must be: "toggl" or "harvest"'
      )
    end

    it "with invalid TIME_TRACKER_CLIENT env var" do
      set_client_env_var('harvester_of_sorrow')
      expect { described_class.new }.to raise_error(
        'Invalid TIME_TRACKER_CLIENT env var. Must be: "toggl" or "harvest"'
      )
    end

    it "initializes Harvest client setting TIME_TRACKER_CLIENT env var as harvest" do
      set_client_env_var('harvest')
      allow(ENV).to receive(:fetch).with('HARVEST_ACCOUNT_ID').and_return('123')
      allow(ENV).to receive(:fetch).with('HARVEST_TOKEN').and_return('XYZ')
      client = described_class.new.client
      expect(client).to be_a(Lita::Clients::Harvest)
      expect(client.account_id).to eq('123')
      expect(client.token).to eq('XYZ')
    end

    it "initializes Harvest client setting TIME_TRACKER_CLIENT env var as harvest" do
      set_client_env_var('toggl')
      allow(ENV).to receive(:fetch).with('TOGGL_API_KEY').and_return('ABC')
      client = described_class.new.client
      expect(client).to be_a(Lita::Clients::Toggl)
      expect(client.api_token).to eq('ABC')
    end
  end

  describe "#users_current_entries" do
    before do
      set_client_env_var('toggl')
      allow(ENV).to receive(:fetch).with('TOGGL_API_KEY').and_return('ABC')
    end

    it "delegates to specific client" do
      expect_any_instance_of(Lita::Clients::Toggl).to receive(:users_current_entries).and_return([])
      described_class.new.users_current_entries
    end
  end
end
