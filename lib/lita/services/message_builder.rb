module Lita
  module Services
    class MessageBuilder
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def general_activity
        current_entries.map { |entry| entry_to_s(entry) }.join("\n")
      end

      def active_users
        owners(current_entries.select(&:active?))
      end

      def inactive_users
        owners(current_entries.select(&:inactive?))
      end

      def user_activity(term)
        entry = current_entries.find { |e| e.owned_by?(term) }
        return I18n.t("user_time_entry.entry_not_found") if term.to_s.empty? || !entry
        entry_to_s(entry)
      end

      private

      def owners(entries)
        entries.map { |entry| "• #{entry.owner}" }.join("\n")
      end

      def current_entries
        @current_entries ||= client.users_current_entries
      end

      def entry_to_s(entry)
        if entry.active?
          locals = {
            owner: entry.owner,
            project_name: format_string(entry.project_name),
            description: format_string(entry.description),
            time_elapsed: entry.time_elapsed
          }

          I18n.t("user_time_entry.active_msg.main", locals)
        else
          I18n.t("user_time_entry.inactive_msg", owner: entry.owner)
        end
      end

      def format_string(str)
        fstr = str.to_s.strip
        return I18n.t("user_time_entry.unkwnown") if fstr == ""
        fstr
      end
    end
  end
end
