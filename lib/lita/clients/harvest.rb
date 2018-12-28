module Lita
  module Clients
    class Harvest
      API_URL = "https://api.harvestapp.com/api/v2"

      attr_reader :account_id, :token

      def initialize(account_id, token)
        @account_id = account_id
        @token = token
      end

      def users_current_entries
        active_users.map do |user|
          activity_data = user_activity_data(user["id"])
          data = {
            user_name: user_fullname(user),
            user_email: user["email"]
          }

          if !!activity_data
            data[:project_name] = project_name(activity_data)
            data[:description] = activity_description(activity_data)
            data[:time_elapsed] = activity_time(activity_data)
            data[:is_active] = activity_data['is_running']
          end

          UserTimeEntry.new(data)
        end
      end

      private

      def auth_headers
        { "Authorization" => "Bearer #{token}", "Harvest-Account-Id" => account_id }
      end

      def to_param(options)
        return query = options.map { |k,v| "#{k}=#{v}" }.join("&") if query == ""
        "?#{query}"
      end

      def get(resource, options = {})
        resource_url = "#{API_URL}/#{resource}.json#{to_param(options)}"
        response = HTTParty.get(resource_url, headers: auth_headers)
        return JSON.parse(response.body) if response.success?
      end

      def users
        users = get("users")
        return [] unless users
        users["users"]
      end

      def time_entries
        return @time_entries if @time_entries
        result = get("time_entries")
        return [] unless result
        @time_entries = result["time_entries"]
      end

      def activity_description(activity_data)
        [
          activity_data["task"]["name"], activity_data["notes"]
        ].compact.join(": ")
      end

      def project_name(activity_data)
        [
          activity_data["client"]["name"], activity_data["project"]["name"]
        ].compact.join(" - ")
      end

      def user_fullname(user)
        [user["first_name"], user["last_name"]].compact.join(" ")
      end

      def user_activity_data(user_id)
        time_entries.find do |entry|
          entry["user"]["id"] == user_id
        end
      end

      def activity_time(activity_data)
        return unless activity_data['hours']
        Time.at(activity_data['hours'] * 3600).utc.strftime('%H:%M')
      end

      def active_users
        users.select { |user| user['is_active'] }
      end
    end
  end
end
