require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module KanbanApp
  class Application < Rails::Application
    config.load_defaults 8.0

    config.time_zone = "Brasilia"

    config.active_job.queue_adapter = :sidekiq

    config.autoload_lib(ignore: %w[assets tasks])
  end
end
