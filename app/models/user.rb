class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:keycloak]

  def self.from_omniauth(auth)
    email = auth.info.email.presence || "#{auth.uid}@change.me"
    user  = find_or_initialize_by(email: email)
    user.password ||= Devise.friendly_token.first(20)
    user.name = auth.info.name if user.respond_to?(:name)
    user.provider = auth.provider
    user.uid = auth.uid
    user.token = auth.credentials.token
    user.save!
    user
  end
end