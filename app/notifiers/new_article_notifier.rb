# To deliver this notification:
#
# NewArticleNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewArticleNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end
  deliver_by :fcm do |config|
    config.credentials = Rails.application.credentials.fcm.to_h.deep_stringify_keys

    config.device_tokens = -> {
      recipient.notification_tokens.where(platform: :FCM).pluck(:token)
    }

    config.json = ->(device_token) {
      {
        message: {
          token: device_token,
          notification: {
            title: "New Article Published",
            body: "Someone created a new content. Check it out!"
          }
        }
      }
    }

    config.error_handler = ->(response) {
      Rails.logger.error("FCM Error: #{response.code} - #{response.body}")
    }

    config.invalid_token = ->(device_token) {
      Rails.logger.warn("Invalid FCM token: #{device_token}")
    }
  end

  # Add required params
  #
  # required_param :message

  # Compute recipients without having to pass them in
  #
  # recipients do
  #   params[:record].thread.all_authors
  # end
end
