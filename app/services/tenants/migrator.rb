module Tenants
  class Migrator
    def self.migrate_all_tenants
      failed_tenants = []

      ::Tenant.find_each do |tenant|
        begin
          migrate_tenant(tenant)
        rescue => e
          failed_tenants << { tenant: tenant.name, error: e.message }
        end
      end

      report_results(failed_tenants, "migrated")
    end

    def self.migrate_tenant(tenant)
      original_connection = ActiveRecord::Base.connection_db_config

      begin
        ActiveRecord::Base.establish_connection(config(tenant))
        ActiveRecord::Migration.verbose = true

        # Use Rails 6+ migration API
        tenant_migrations_path = Rails.root.join("db", "tenant_migrate")
        ActiveRecord::MigrationContext.new(tenant_migrations_path).migrate
      ensure
        ActiveRecord::Base.establish_connection(original_connection)
      end
    end

    def self.migrate_down_all_tenants(version)
      failed_tenants = []
      version_number = version.to_i

      puts "🔄 Rolling back migration #{version} on all tenant databases..."

      ::Tenant.find_each do |tenant|
        begin
          migrate_down_tenant(tenant, version_number)
        rescue => e
          failed_tenants << { tenant: tenant.name, error: e.message }
        end
      end

      report_results(failed_tenants, "rolled back")
    end

    def self.migrate_down_tenant(tenant, version)
      original_connection = ActiveRecord::Base.connection_db_config

      begin
        ActiveRecord::Base.establish_connection(config(tenant))
        ActiveRecord::Migration.verbose = true

        tenant_migrations_path = Rails.root.join("db", "tenant_migrate")
        migration_context = ActiveRecord::MigrationContext.new(tenant_migrations_path)

        # Check if migration is currently up
        executed_migrations = migration_context.get_all_versions
        unless executed_migrations.include?(version)
          puts "⚠️  Migration #{version} is not executed on #{tenant.name}, skipping..."
          return
        end

        puts "🔄 Rolling back migration #{version} on #{tenant.name}..."

        # Use migrate with target version - 1 to rollback to previous version
        previous_version = executed_migrations.select { |v| v < version }.max || 0
        migration_context.migrate(previous_version)

        puts "✅ Successfully rolled back migration #{version} on #{tenant.name}"
      ensure
        ActiveRecord::Base.establish_connection(original_connection)
      end
    end

    def self.rollback_all_tenants(step = 1)
      failed_tenants = []

      puts "🔄 Rolling back #{step} step(s) on all tenant databases..."

      ::Tenant.find_each do |tenant|
        begin
          rollback_tenant(tenant, step)
        rescue => e
          failed_tenants << { tenant: tenant.name, error: e.message }
        end
      end

      report_results(failed_tenants, "rolled back")
    end

    def self.rollback_tenant(tenant, step)
      original_connection = ActiveRecord::Base.connection_db_config

      begin
        ActiveRecord::Base.establish_connection(config(tenant))
        ActiveRecord::Migration.verbose = true

        tenant_migrations_path = Rails.root.join("db", "tenant_migrate")
        migration_context = ActiveRecord::MigrationContext.new(tenant_migrations_path)

        # Rollback the specified number of steps
        migration_context.rollback(step)
      ensure
        ActiveRecord::Base.establish_connection(original_connection)
      end
    end

    def self.migration_status_all_tenants
      puts "📊 Migration Status for All Tenants:"
      puts "=" * 50

      ::Tenant.find_each do |tenant|
        begin
          status = get_migration_status(tenant)
          tenancy_info = tenant.database? ? tenant.database_name : "#{tenant.database_name}/#{tenant.schema_name}"
          puts "\n🏥 #{tenant.name} (#{tenant.tenancy_type}: #{tenancy_info}):"

          if status.empty?
            puts "  No migrations found"
          else
            status.each do |migration|
              status_icon = migration[:status] == "up" ? "✅" : "❌"
              puts "  #{status_icon} #{migration[:version]} #{migration[:name]} (#{migration[:status]})"
            end
          end
        rescue => e
          puts "\n❌ #{tenant.name}: Error getting status - #{e.message}"
        end
      end
    end

    def self.get_migration_status(tenant)
      original_connection = ActiveRecord::Base.connection_db_config

      begin
        ActiveRecord::Base.establish_connection(config(tenant))

        tenant_migrations_path = Rails.root.join("db", "tenant_migrate")
        migration_context = ActiveRecord::MigrationContext.new(tenant_migrations_path)

        # Get all migration files
        migration_files = migration_context.migrations
        executed_migrations = migration_context.get_all_versions

        migration_files.map do |migration|
          {
            version: migration.version.to_s,
            name: migration.name,
            status: executed_migrations.include?(migration.version) ? "up" : "down"
          }
        end
      ensure
        ActiveRecord::Base.establish_connection(original_connection)
      end
    end

    private

    def self.config(tenant)
      base_config = {
        adapter: "postgresql",
        host: tenant.database_host,
        port: tenant.database_port || 5432,
        database: tenant.database_name,
        username: tenant.database_username,
        password: tenant.database_password,
        encoding: "unicode",
        pool: 5,
        timeout: 5000
      }

      # Add schema search path for schema-based tenancy
      if tenant.schema?
        base_config[:schema_search_path] = tenant.schema_name
      end

      base_config
    end

    def self.report_results(failed_tenants, action = "migrated")
      if failed_tenants.empty?
        puts "\n🎉 All tenants #{action} successfully!"
      else
        puts "\n❌ #{failed_tenants.size} tenants failed:"
        failed_tenants.each do |failure|
          puts "  - #{failure[:tenant]}: #{failure[:error]}"
        end
      end
    end
  end
end
