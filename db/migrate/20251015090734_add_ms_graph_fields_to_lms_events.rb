class AddMsGraphFieldsToLmsEvents < ActiveRecord::Migration[7.1]
  def change
    change_table :lms_events do |t|
      t.string  :external_provider         
      t.string  :external_event_id         
      t.string  :external_ical_uid
      t.string  :external_web_link         
      t.string  :online_meeting_url       
      t.string  :external_etag
      t.datetime :synced_at
    end
  end
end
