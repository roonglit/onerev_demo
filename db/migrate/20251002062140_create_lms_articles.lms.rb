# This migration comes from lms (originally 20251001094501)
class CreateLmsArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_articles do |t|
      t.timestamps
    end
  end
end
