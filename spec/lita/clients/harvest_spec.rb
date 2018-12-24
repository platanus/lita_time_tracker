require 'spec_helper'

describe Lita::Clients::Harvest do
  let(:client) do
    described_class.new ENV.fetch('HARVEST_ACCOUNT_ID', 'XXX'), ENV.fetch('HARVEST_TOKEN', 'XXX')
  end

  before do
    allow_any_instance_of(described_class).to \
      receive(:to_param).and_return('?to=2018-12-24T23:59:59Z')
  end

  describe '#users_current_entries' do
    context 'with no inactive users', vcr: { cassette_name: 'harvest-entries-active-users' } do
      let(:entries) { client.users_current_entries }
      it { expect(entries.count).to eq(5) }
      it { expect(entries.last.owner).to eq('Felipe Domínguez') }
      it { expect(entries.last.user_email).to eq('felipe.dominguez@platan.us') }
      it { expect(entries.last.description).to eq('Project Management') }
    end

    context 'with inactive users', vcr: { cassette_name: 'harvest-entries-inactive-users' } do
      let(:entries) { client.users_current_entries }
      it { expect(entries.count).to eq(5) }
      it 'returns only active users entries' do
        entries_emails = entries.map(&:user_email)
        expect(entries_emails).not_to include('jose@platan.us')
      end
    end
  end
end
