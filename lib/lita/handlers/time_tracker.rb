# rubocop:disable Metrics/LineLength
module Lita
  module Handlers
    class TimeTracker < Handler
      def self.help_msg(route)
        { "time_tracker: #{t("help.#{route}.usage")}" => t("help.#{route}.description") }
      end

      route(/me muestras la actividad en (toggl|harvest)\?$/i, help: help_msg(:general_activity)) do |r|
        r.reply(message_builder.general_activity)
      end

      route(/en qué?e? wea andan\?$/i, help: help_msg(:general_activity)) do |r|
        r.reply(message_builder.general_activity)
      end

      route(/quié?e?nes togglean\?$/i, help: help_msg(:active_users)) do |r|
        r.reply(message_builder.active_users)
      end

      route(/quié?e?nes no togglean\?$/i, help: help_msg(:inactive_users)) do |r|
        r.reply(message_builder.inactive_users)
      end

      route(/me muestras el (toggl|harvest) de ([^\s]+)\?$/i, help: help_msg(:user_activity)) do |r|
        r.reply(message_builder.user_activity(r.matches[0][1]))
      end

      private

      def message_builder
        @message_builder ||= Lita::Services::MessageBuilder.new(client)
      end

      def client
        @client ||= Lita::Client.new
      end
    end
  end
end
