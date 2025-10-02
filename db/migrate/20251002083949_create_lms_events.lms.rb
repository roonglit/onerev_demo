# This migration comes from lms (originally 20251002075754)
class CreateLmsEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_events do |t|
      t.date :event_date

      t.timestamps
    end
  end
end
