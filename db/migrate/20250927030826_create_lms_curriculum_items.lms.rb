# This migration comes from lms (originally 20250922072322)
class CreateLmsCurriculumItems < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_curriculum_items do |t|
      t.string :name
      t.belongs_to :section, null: false, foreign_key: { to_table: :lms_sections }

      t.timestamps
    end
  end
end
