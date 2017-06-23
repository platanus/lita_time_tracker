require "lita-toggl"
require "lita/rspec"

# A compatibility mode is provided for older plugins upgrading from Lita 3. Since this plugin
# was generated with Lita 4, the compatibility mode should be left disabled.
Lita.version_3_compatibility_mode = false

# Support methods

def expect_entry_to_match_data(entry, data)
  expect(entry.owner).to eq(data[:owner])
  expect(entry.user_name).to eq(data[:user_name])
  expect(entry.user_email).to eq(data[:user_email])
  expect(entry.project_name).to eq(data[:project_name])
  expect(entry.description).to eq(data[:description])
  expect(entry.active).to eq(data[:active])
  expect(entry.started_at).to eq(data[:started_at])
end

def set_client_env_var(client_name)
  allow(ENV).to receive(:fetch).with('TIME_TRACKER_CLIENT', 'invalid').and_return(client_name)
end
