# Tailwind CSS content paths configuration
# This initializer sets up the content paths that Tailwind CSS will scan for utility classes.
# Rails engines can register their own paths via their engine initializers.
#
# Example engine initializer:
#   module Lms
#     class Engine < ::Rails::Engine
#       initializer "lms.tailwind_content_paths" do |app|
#         app.config.tailwind_content_paths ||= []
#         app.config.tailwind_content_paths += [
#           root.join("app/views/**/*.{erb,slim}").to_s,
#           root.join("app/components/**/*.rb").to_s,
#           root.join("app/helpers/**/*.rb").to_s,
#           root.join("app/javascript/**/*.js").to_s
#         ]
#       end
#     end
#   end

Rails.application.config.tap do |config|
  # Initialize the tailwind_content_paths array if not already set by engines
  unless config.respond_to?(:tailwind_content_paths)
    config.class.attr_accessor :tailwind_content_paths
    config.tailwind_content_paths = []
  end

  config.tailwind_content_paths ||= []

  # Register main application paths
  config.tailwind_content_paths += [
    Rails.root.join("app/views/**/*.{erb,slim}").to_s,
    Rails.root.join("app/helpers/**/*.rb").to_s,
    Rails.root.join("app/components/**/*.rb").to_s,
    Rails.root.join("app/javascript/**/*.js").to_s
  ]
end
