# This migration comes from lms (originally 20251002072842)
class CreateLmsVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_videos do |t|
      t.timestamps
    end
  end
end
