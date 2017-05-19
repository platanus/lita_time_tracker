require "require_all"
require "lita"
require "redis"
require "awesome_print"
require "togglv8"

require_rel "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

Lita::Handlers::Toggl.template_root File.expand_path(
  File.join("..", "..", "templates"),
  __FILE__
)

I18n.locale = "es-CL"
