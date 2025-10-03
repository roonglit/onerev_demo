# This migration comes from lms (originally 20251003024144)
class CreateLmsCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
