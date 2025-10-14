# frozen_string_literal: true
require "net/http"
require "json"
require "uri"

class MsGraphEventsService
  GRAPH_BASE = "https://graph.microsoft.com/v1.0"

  def initialize(access_token:)
    @access_token = access_token # token ของ Microsoft Graph (ได้จาก Keycloak broker/microsoft)
  end

  # สร้างอีเวนต์ (ออนไลน์ Teams) ล่วงหน้า
  # start_at/end_at = "YYYY-MM-DDTHH:mm:ss" ตามโซนที่ส่งใน timezone
  def create_event(subject:, start_at:, end_at:, timezone: "Asia/Bangkok", html: " ")
    payload = {
      subject: subject,
      body: { contentType: "HTML", content: html },
      start: { dateTime: start_at, timeZone: timezone },
      end:   { dateTime: end_at,   timeZone: timezone },
      isOnlineMeeting: true,
      onlineMeetingProvider: "teamsForBusiness"
    }

    request_json(:post, "/me/events", payload)
  end

  # เพิ่มผู้ที่กด “เข้าร่วม” เข้า attendees (Graph จะส่งเชิญให้เฉพาะคนที่เพิ่มใหม่)
  def rsvp_attend(event_id:, email:, name: nil, type: "required")
    payload = {
      attendees: [
        {
          emailAddress: { address: email, name: name || email },
          type: type
        }
      ]
    }
    request_json(:patch, "/me/events/#{event_id}", payload)
  end

  private

  def request_json(method, path, body_hash = nil)
    uri = URI.join(GRAPH_BASE, path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 15
    http.open_timeout = 5

    req =
      case method
      when :get   then Net::HTTP::Get.new(uri)
      when :post  then Net::HTTP::Post.new(uri)
      when :patch then Net::HTTP::Patch.new(uri)
      else
        raise ArgumentError, "Unsupported method: #{method}"
      end

    req["Authorization"] = "Bearer #{@access_token}"
    req["Content-Type"]  = "application/json"
    req.body = body_hash.to_json if body_hash

    res = http.request(req)

    unless res.is_a?(Net::HTTPSuccess)
      raise StandardError, "Graph error #{res.code}: #{res.body}"
    end

    JSON.parse(res.body)
  end
end
