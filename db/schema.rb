# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_10_21_122335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "campfire_memberships", force: :cascade do |t|
    t.datetime "connected_at"
    t.integer "connections", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "involvement", default: "mentions"
    t.bigint "room_id", null: false
    t.datetime "unread_at"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["room_id", "created_at"], name: "index_campfire_memberships_on_room_id_and_created_at"
    t.index ["room_id", "user_id"], name: "index_campfire_memberships_on_room_id_and_user_id", unique: true
    t.index ["room_id"], name: "index_campfire_memberships_on_room_id"
    t.index ["user_id"], name: "index_campfire_memberships_on_user_id"
  end

  create_table "campfire_messages", force: :cascade do |t|
    t.string "client_message_id", null: false
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.bigint "room_id", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_campfire_messages_on_creator_id"
    t.index ["room_id"], name: "index_campfire_messages_on_room_id"
  end

  create_table "campfire_rooms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "creator_id", null: false
    t.string "name"
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_campfire_rooms_on_creator_id"
  end

  create_table "campfire_users", force: :cascade do |t|
    t.boolean "active", default: true
    t.text "bio"
    t.string "bot_token"
    t.datetime "created_at", null: false
    t.string "name", default: "", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["bot_token"], name: "index_campfire_users_on_bot_token", unique: true
    t.index ["user_id"], name: "index_campfire_users_on_user_id"
  end

  create_table "lms_articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lms_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "lms_category_contents", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.bigint "content_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_lms_category_contents_on_category_id"
    t.index ["content_id"], name: "index_lms_category_contents_on_content_id"
  end

  create_table "lms_contents", force: :cascade do |t|
    t.bigint "contentable_id", null: false
    t.string "contentable_type", null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["contentable_type", "contentable_id"], name: "index_lms_contents_on_contentable"
    t.index ["user_id"], name: "index_lms_contents_on_user_id"
  end

  create_table "lms_courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lms_curriculum_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "section_id", null: false
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_lms_curriculum_items_on_section_id"
  end

  create_table "lms_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "event_date"
    t.datetime "updated_at", null: false
  end

  create_table "lms_sections", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lms_sections_on_course_id"
  end

  create_table "lms_videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "noticed_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "notifications_count"
    t.jsonb "params"
    t.bigint "record_id"
    t.string "record_type"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_noticed_events_on_record"
  end

  create_table "noticed_notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "event_id", null: false
    t.datetime "read_at", precision: nil
    t.bigint "recipient_id", null: false
    t.string "recipient_type", null: false
    t.datetime "seen_at", precision: nil
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_noticed_notifications_on_event_id"
    t.index ["recipient_type", "recipient_id"], name: "index_noticed_notifications_on_recipient"
  end

  create_table "notification_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "platform", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_notification_tokens_on_user_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "database_host", null: false
    t.string "database_name", null: false
    t.string "database_password", null: false
    t.string "database_port", null: false
    t.string "database_username", null: false
    t.string "name", null: false
    t.string "schema_name"
    t.string "slug", null: false
    t.string "subdomain"
    t.integer "tenancy_type", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["schema_name"], name: "index_tenants_on_schema_name"
    t.index ["slug"], name: "index_tenants_on_slug", unique: true
    t.index ["subdomain"], name: "index_tenants_on_subdomain", unique: true
    t.index ["tenancy_type"], name: "index_tenants_on_tenancy_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campfire_memberships", "campfire_rooms", column: "room_id"
  add_foreign_key "campfire_memberships", "campfire_users", column: "user_id"
  add_foreign_key "campfire_messages", "campfire_rooms", column: "room_id"
  add_foreign_key "campfire_messages", "campfire_users", column: "creator_id"
  add_foreign_key "campfire_rooms", "campfire_users", column: "creator_id"
  add_foreign_key "campfire_users", "users"
  add_foreign_key "lms_category_contents", "lms_categories", column: "category_id"
  add_foreign_key "lms_category_contents", "lms_contents", column: "content_id"
  add_foreign_key "lms_contents", "users"
  add_foreign_key "lms_curriculum_items", "lms_sections", column: "section_id"
  add_foreign_key "lms_sections", "lms_courses", column: "course_id"
  add_foreign_key "notification_tokens", "users"
end
