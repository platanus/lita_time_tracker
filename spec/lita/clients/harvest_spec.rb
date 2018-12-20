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

    it { expect(entries.last.owner).to eq('Juan Ignacio Donoso') }
    it { expect(entries.last.description).to eq('Programming: Google Automatic Deploy to Beta') }
    it { expect(entries.last.user_email).to eq('juan.ignacio@platan.us') }
  end

  describe '#time_entries', vcr: { cassette_name: 'harvest-time_entries' } do
    let!(:entries) { client.send('time_entries') }

    it { expect(entries.count).to eq(100) }
  end

  describe '#active_users' do
    let!(:active_users) { client.send('active_users') }
    let!(:users) { client.send('users') }

    it 'returns only active users' do
      expect(active_users.count).not_to eq(users.count)
    end
  end
end
