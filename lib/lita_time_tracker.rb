require "lita"
require "redis"
require "awesome_print"
require "togglv8"
require "httparty"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require_rel "lita"

Lita::Handlers::TimeTracker.template_root File.expand_path(
  File.join("..", "..", "templates"),
  __FILE__
)
