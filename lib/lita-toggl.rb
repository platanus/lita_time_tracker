require "lita"
require "redis"
require "lita/handlers/toggl"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

Lita::Handlers::Toggl.template_root File.expand_path(
  File.join("..", "..", "templates"),
  __FILE__
)
