class ApisController < ApplicationController
  require "net/http"
  require "uri"
  require "json"

  def call_api_get_keycloak_token
    uri = URI("http://localhost:8080/realms/lms/broker/microsoft/token")

    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{current_user.token}"

    res = Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }

    if res.is_a?(Net::HTTPSuccess)
      create_teams_event(token_data: JSON.parse(res.body))
    else
      redirect_to root_path
    end
  end

  def create_teams_event(token_data: String)

    if token_data.nil?
      return render json: { error: "No token in session, please re-authenticate" }, status: :unauthorized
    end

    access_token = token_data["access_token"]
    uri = URI("https://graph.microsoft.com/v1.0/me/events")
    req = Net::HTTP::Post.new(uri)
    req["Authorization"] = "Bearer #{access_token}"
    req["Content-Type"] = "application/json"
    req.body = {
      subject: "Test meeting",
      start: { dateTime: "2025-10-14T09:00:00", timeZone: "UTC" },
      end:   { dateTime: "2025-10-14T10:00:00", timeZone: "UTC" },
      isOnlineMeeting: true,
      onlineMeetingProvider: "teamsForBusiness"
    }.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }

    if res.is_a?(Net::HTTPSuccess)
      render json: { success: true, event: JSON.parse(res.body) }
    else
      render json: { success: false, code: res.code, body: res.body }, status: :bad_request
    end
  end

end
