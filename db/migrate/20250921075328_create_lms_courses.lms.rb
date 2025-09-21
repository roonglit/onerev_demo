# This migration comes from lms (originally 20250921070837)
class CreateLmsCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_courses do |t|
      t.string :title
      t.string :subtitle
      t.text :description

      t.timestamps
    end
  end
end
