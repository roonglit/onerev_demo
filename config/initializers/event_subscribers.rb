# frozen_string_literal: true

# Subscribe to application events
Rails.application.config.to_prepare do
  LmsArticleSubscriber.subscribe
end
