module Lita
  module Clients
    class Toggl
      attr_reader :api_token

      def initialize(api_token)
        @api_token = api_token
      end

      def users_current_entires
        platanus_users.map do |user|
          activity_data = get_user_activity_data(user["id"])
          data = {
            user_name: user["fullname"],
            user_email: user["email"]
          }

          if !!activity_data
            data[:project_name] = get_project_name(activity_data["project_id"])
            data[:description] = activity_data["description"]
            data[:duration] = activity_data["duration"]
            data[:stop] = activity_data["stop"]
          end

          UserTimeEntry.new(data)
        end
      end

      private

      def get_user_activity_data(user_id)
        platanus_dashboard["activity"].find { |v| v["user_id"] == user_id }
      end

      def get_project_name(project_id)
        project = projects.find { |v| v["id"] == project_id }
        return unless project
        project["name"]
      end

      def projects
        @projects ||= api.projects(platanus_workspace_id)
      end

      def platanus_dashboard
        @platanus_dashboard ||= api.dashboard(platanus_workspace_id)
      end

      def platanus_users
        api.users(platanus_workspace_id)
      end

      def platanus_workspace_id
        @platanus_workspace_id ||= api.workspaces.first["id"]
      end

      def api
        @api ||= TogglV8::API.new(api_token)
      end
    end
  end
end
