# Multi-tenant database migration tasks
#
# Available commands:
# rails db:tenant:create                           # Create databases for all tenants
# rails db:tenant:migrate                          # Run migrations on all tenant databases
# rails db:tenant:migrate:down VERSION=<version>   # Roll back a specific migration on all tenants
# rails db:tenant:migrate:rollback [STEP=n]        # Roll back the last n migrations (default: 1)
# rails db:tenant:migrate:status                   # Show migration status for all tenants
#
# Examples:
# rails db:tenant:migrate:down VERSION=20250711135140
# rails db:tenant:migrate:rollback STEP=2
#
namespace :db do
  namespace :tenant do
    desc "Create databases for all tenants"
    task create: :environment do
      Tenants::DatabaseManager.create_all_databases
    end

    desc "Run migrations on all tenant databases"
    task migrate: :environment do
      Tenants::Migrator.migrate_all_tenants
    end

    namespace :migrate do
      desc "Roll back a specific migration version on all tenant databases"
      task down: :environment do
        version = ENV["VERSION"]

        if version.blank?
          puts "❌ VERSION is required. Usage: rails db:tenant:migrate:down VERSION=20250711135140"
          exit 1
        end

        Tenants::Migrator.migrate_down_all_tenants(version)
      end

      desc "Roll back the last migration(s) on all tenant databases"
      task rollback: :environment do
        step = ENV["STEP"] ? ENV["STEP"].to_i : 1
        Tenants::Migrator.rollback_all_tenants(step)
      end

      desc "Show migration status for all tenant databases"
      task status: :environment do
        Tenants::Migrator.migration_status_all_tenants
      end
    end

    desc "Grant permissions to tenant databases"
    task grant_permissions: :environment do
      Tenants::DatabaseManager.grant_all_permissions
    end
  end

  # Test-specific tenant database tasks
  namespace :test do
    namespace :tenant do
      desc "Prepare tenant test database (create + migrate)"
      task prepare: :environment do
        # Use the same credentials as the main test database
        test_config = Rails.application.config.database_configuration["test"]

        begin
          # Connect to the main test database
          ActiveRecord::Base.establish_connection(test_config)

          # Create the "test" schema for tenant data
          ActiveRecord::Base.connection.execute("CREATE SCHEMA IF NOT EXISTS test;")
          puts "✓ Created tenant test schema: test"

          # Set the search path to use the test schema
          ActiveRecord::Base.connection.execute("SET search_path TO test, public;")

          # Run tenant-specific migrations from db/tenant_migrate
          tenant_migrations_path = Rails.root.join("db", "tenant_migrate")
          if Dir.exist?(tenant_migrations_path)
            ActiveRecord::MigrationContext.new(tenant_migrations_path).migrate
            puts "✓ Migrated tenant test schema with tenant-specific migrations"
          else
            puts "⚠️  No tenant migrations found at db/tenant_migrate"
          end
        rescue => e
          puts "✗ Failed to prepare tenant test schema: #{e.message}"
          raise e
        ensure
          # Reset search path to default
          ActiveRecord::Base.connection.execute("SET search_path TO public;")
        end

        puts "🎉 Tenant test schema prepared successfully!"
      end

      desc "Drop tenant test database"
      task drop: :environment do
        # Use the same credentials as the main test database
        test_config = Rails.application.config.database_configuration["test"]
        db_config = test_config.dup
        db_config["database"] = "rexx_tenant_test"

        begin
          ActiveRecord::Tasks::DatabaseTasks.drop(db_config)
          puts "✓ Dropped tenant test database: rexx_tenant_test"
        rescue => e
          puts "✓ Tenant test database was already gone or couldn't be dropped"
        end
      end

      desc "Reset tenant test database (drop + prepare)"
      task reset: [ :drop, :prepare ]
    end
  end
end
