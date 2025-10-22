# frozen_string_literal: true

class LmsArticleSubscriber
  def self.subscribe
    ActiveSupport::Notifications.subscribe("lms.article.created") do |_name, _start, _finish, _id, payload|
      new.article_created(payload)
    end
  end

  def article_created(payload)
    article_id = payload[:article_id]

    # Send push notifications to all users with FCM tokens
    User.find_each do |user|
      NewArticleNotifier.with({}).deliver(user)
    end

    Rails.logger.info "Push notifications sent for article #{article_id}"
  rescue StandardError => e
    Rails.logger.error "Failed to send notifications for article #{article_id}: #{e.message}"
  end
end
