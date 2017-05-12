require 'rufus-scheduler'
require 'date'

module Lita
  module Handlers
    class WateringReminder < Handler
      on :loaded, :load_on_start

      def self.help_msg(route)
        { "toggl: #{t("help.#{route}.usage")}" => t("help.#{route}.description") }
      end

      def load_on_start(_payload)
        create_schedule
      end

      route(/el que riega los ([^\s]+) en la ([^\s]+) es ([^\s]+)/i, help: help_msg(:add_to_waterers)) do |response|
        add_to_waterers(response.matches[0][2], response.matches[0][0], response.matches[0][1])
        response.reply("perfecto, entonces #{response.matches[0][2]} regará cada #{response.matches[0][0]} en la #{response.matches[0][1]}")
      end

      route(/quié?e?nes riegan\?$/i, help: help_msg(:waterers_list)) do |response|
        message = "Veamos:"
        waterers_list.each do |waterer|
          waterer = JSON.parse(waterer)
          message += "\n#{waterer['mention_name']} riega los #{waterer['day']} en la #{waterer['moment']}"
        end
        response.reply(message)
      end

      route(/([^\s]+) ya no quiere regar más/i, help: help_msg(:remove_from_waterers)) do |response|
        remove_from_waterers(response.matches[0][0])
        response.reply("ok!")
      end

      route(/voy a regar los ([^\s]+) en la ([^\s]+)/, help: help_msg(:add_me_to_waterers)) do |response|
        add_to_waterers(response.user.mention_name, response.matches[0][0], response.matches[0][1])
        response.reply("Perfecto @#{response.user.mention_name}, te recordaré regar cada #{response.matches[0][0]} en la #{response.matches[0][1]}.")
      end
      
      route(/refresh/, help: help_msg(:refresh)) do |response|
        refresh
      end

      def refresh
        days = [:lunes, :martes, :miercoles, :jueves, :viernes, :sabado, :domingo]
        today = days[Time.now.wday - 1]
        now = Time.now.hour < 14 ? 'mañana' : 'tarde'
        waterers_list.each do |waterer|
          waterer = JSON.parse(waterer)
          if waterer['day'] == today.to_s && waterer['moment'] == now
            message = "@#{waterer['mention_name']} acuérdate que hoy día en la #{now} te toca regar."
            robot.send_message(Source.new(room: "#coffeebar"), message)
          end
        end
      end

      def notify(list, message)
        list.shuffle.each do |luncher|
          user = Lita::User.find_by_mention_name(luncher)
          robot.send_message(Source.new(user: user), message)
        end
      end

      def add_to_waterers(mention_name, day, moment)
        data = {
          day: day,
          moment: moment,
          mention_name: mention_name
        }
        redis.sadd("waterers", data.to_json)
      end

      def remove_from_waterers(mention_name)
        waterers_list.each do |waterer|
          w = JSON.parse(waterer)
          if w['mention_name'] == mention_name
            redis.srem("waterers", waterer)
          end
        end
      end

      def waterers_list
        redis.smembers("waterers") || []
      end

      def create_schedule
        scheduler = Rufus::Scheduler.new
        scheduler.cron("0 11,21 * * 1-5") do
          refresh
        end
      end

      Lita.register_handler(self)
    end
  end
end
