require "spec_helper"

describe Lita::Clients::Harvest do
  let(:client) do 
    described_class.new ENV.fetch('HARVEST_ACCOUNT_ID', 'XXX'), ENV.fetch('HARVEST_TOKEN', 'XXX')
  end

  before do 
    allow_any_instance_of(described_class).to receive(:to_param).and_return("?to=2017-09-07T23:59:59Z")
  end

  describe "#users_current_entries", vcr: { cassette_name: 'harvest-entries' } do 
    let!(:entry) { client.users_current_entries[0] }
    it { expect(entry.owner).to eq("René A. Morales") }
    it { expect(entry.user_email).to eq("rene.morales.sanchez@gmail.com") }
  end

  describe "#time_entries", vcr: { cassette_name: 'harvest-time_entries' } do 
    let!(:entry) { client.send("time_entries")[0] }
    it { expect(entry["spent_date"]).to eq("2017-09-07") }
    # TODO: API should provide the started_time =S
    # it { expect(entry["started_time"]).not_to eq(nil) } 
  end
end
