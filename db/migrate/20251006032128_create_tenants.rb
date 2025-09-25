class CreateTenants < ActiveRecord::Migration[8.1]
  def change
    create_table :tenants do |t|
      t.string :name, null: false
      t.string :slug, null: false, index: { unique: true }
      t.string :subdomain, index: { unique: true }
      t.string :database_host, null: false
      t.string :database_port, null: false
      t.string :database_name, null: false
      t.string :database_username, null: false
      t.string :database_password, null: false
      t.integer :tenancy_type, null: false, default: 0, index: true
      t.string :schema_name, index: true

      t.timestamps
    end
  end
end
