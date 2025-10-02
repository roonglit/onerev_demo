# This migration comes from lms (originally 20251002055507)
class AddUserIdToLmsContents < ActiveRecord::Migration[8.1]
  def change
    add_reference :lms_contents, :user, foreign_key: true
  end
end
