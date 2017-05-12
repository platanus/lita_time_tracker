require "lita"
require "redis"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/watering_reminder"
require "lita/services/spreadsheet_writer"

Lita::Handlers::WateringReminder.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
