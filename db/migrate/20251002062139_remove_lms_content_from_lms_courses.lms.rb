# This migration comes from lms (originally 20251001065544)
class RemoveLmsContentFromLmsCourses < ActiveRecord::Migration[8.1]
  def change
    remove_column :lms_courses, :title, :string
    remove_column :lms_courses, :subtitle, :string
    remove_column :lms_courses, :description, :text
  end
end
