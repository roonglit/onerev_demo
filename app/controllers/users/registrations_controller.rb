# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # POST /users
  def create
    super do |user|
      # Set encrypted cookie for Hotwire Native authentication
      cookies.encrypted[:user_id] = user.id if user.persisted?
    end
  end
end
