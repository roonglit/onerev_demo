# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /users/sign_in
  def create
    super do |user|
      # Set encrypted cookie for Hotwire Native authentication
      cookies.encrypted[:user_id] = user.id
    end
  end

  # DELETE /users/sign_out
  def destroy
    # Clear the encrypted cookie on sign out
    cookies.delete(:user_id)
    super
  end
end
