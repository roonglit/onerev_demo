# This migration comes from lms (originally 20251003024541)
class CreateLmsCategoryContents < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_category_contents do |t|
      t.references :category, null: false, foreign_key: { to_table: :lms_categories }
      t.references :content, null: false, foreign_key: { to_table: :lms_contents } 

      t.timestamps
    end
  end
end
