module Lita
  class Client
    extend Forwardable

    attr_reader :client

    def_delegators :client, :users_current_entries

    def initialize
      @client = specific_client
    end

    private

    def specific_client
      case ENV.fetch('TIME_TRACKER_CLIENT', 'invalid').to_sym
      when :toggl
        Lita::Clients::Toggl.new(ENV.fetch('TOGGL_API_KEY'))
      when :harvest
        Lita::Clients::Harvest.new(ENV.fetch('HARVEST_ACCOUNT_ID'), ENV.fetch('HARVEST_TOKEN'))
      else
        fail 'Invalid TIME_TRACKER_CLIENT env var. Must be: "toggl" or "harvest"'
      end
    end
  end
end
