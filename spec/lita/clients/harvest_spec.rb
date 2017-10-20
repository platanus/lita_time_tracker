require "spec_helper"

describe Lita::Clients::Harvest do
  let(:client) do 
    described_class.new ENV.fetch('HARVEST_ACCOUNT_ID', 'XXX'), ENV.fetch('HARVEST_TOKEN', 'XXX')
  end

  before do 
    allow_any_instance_of(described_class).to receive(:to_param).and_return("?to=2017-10-20T23:59:59Z")
  end

  describe "#users_current_entries", vcr: { cassette_name: 'harvest-entries' } do 
    let!(:entries) { client.users_current_entries }
    it { expect(entries[3].owner).to eq("Mario López") }
    it { expect(entries[3].description).to eq("Programming: lita_time_tracker") }
    it { expect(entries[3].user_email).to eq("mario@platan.us") }
  end

  describe "#time_entries", vcr: { cassette_name: 'harvest-time_entries' } do 
    let!(:entry) { client.send("time_entries")[0] }
    it { expect(entry["spent_date"]).to eq("2017-10-20") }
    it { expect(entry["started_time"]).not_to eq(nil) } 
  end
end
