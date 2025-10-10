# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def keycloak
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)
    sign_in_and_redirect @user, event: :authentication
  end

  def failure
    redirect_to root_path
  end
end
