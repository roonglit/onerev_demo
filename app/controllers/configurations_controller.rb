class ConfigurationsController < ApplicationController
  skip_before_action :authenticate_user! 

  def android_v1
    render json: {
      settings: {},
      rules: [
        {
          patterns: [
            ".*",
          ],
          properties: {
            uri: "hotwire://fragment/web",
            pull_to_refresh_enabled: true
          }
        },
        {
          patterns: [
            "/new$",
            "/edit$"
          ],
          properties: {
            context: "modal",
            pull_to_refresh_enabled: false
          }
        }
      ]
    }
  end
end
