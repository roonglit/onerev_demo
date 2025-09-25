# app/services/tenants/database_manager.rb
module Tenants
  class DatabaseManager
    def self.create_database(tenant)
      begin
        if tenant.database?
          create_database_tenant(tenant)
        else
          create_schema_tenant(tenant)
        end

        puts "✓ #{tenant.tenancy_type.humanize} for '#{tenant.slug}' created successfully"

      rescue ActiveRecord::Tasks::DatabaseAlreadyExists
        puts "Database '#{tenant.database_name}' already exists"
      rescue => e
        puts "✗ Failed to create #{tenant.tenancy_type} for '#{tenant.slug}': #{e.message}"
        raise e
      end
    end

    def self.drop_database(tenant)
      begin
        if tenant.database?
          drop_database_tenant(tenant)
        else
          drop_schema_tenant(tenant)
        end

        puts "✓ #{tenant.tenancy_type.humanize} for '#{tenant.slug}' dropped successfully"
      rescue => e
        puts "✗ Failed to drop #{tenant.tenancy_type} for '#{tenant.slug}': #{e.message}"
        raise e
      end
    end

    def self.create_all_databases
      failed_tenants = []

      ::Tenant.find_each do |tenant|
        begin
          create_database(tenant)
          puts "✓ Created #{tenant.tenancy_type} for #{tenant.slug}"
        rescue => e
          failed_tenants << { tenant: tenant.slug, error: e.message }
          puts "✗ Failed to create #{tenant.tenancy_type} for #{tenant.slug}: #{e.message}"
        end
      end

      if failed_tenants.empty?
        puts "\n🎉 All tenant resources created successfully!"
      else
        puts "\n❌ #{failed_tenants.size} tenants failed:"
        failed_tenants.each do |failure|
          puts "  - #{failure[:tenant]}: #{failure[:error]}"
        end
      end
    end

    def self.grant_all_permissions
      failed_tenants = []

      ::Tenant.find_each do |tenant|
        begin
          grant_tenant_permissions(tenant)
          puts "✓ Granted permissions for #{tenant.name}"
        rescue => e
          failed_tenants << { tenant: tenant.name, error: e.message }
          puts "✗ Failed to grant permissions for #{tenant.name}: #{e.message}"
        end
      end

      if failed_tenants.empty?
        puts "\n🎉 All tenant permissions granted successfully!"
      else
        puts "\n❌ #{failed_tenants.size} tenants failed:"
        failed_tenants.each do |failure|
          puts "  - #{failure[:tenant]}: #{failure[:error]}"
        end
      end
    end

    private

    def self.create_database_tenant(tenant)
      # Use Rails' built-in database tasks for separate database
      db_config = tenant_db_config(tenant)
      ActiveRecord::Tasks::DatabaseTasks.create(db_config)
    end

    def self.create_schema_tenant(tenant)
      # Create schema within existing database
      ActiveRecord::Base.establish_connection(tenant_db_config(tenant))
      ActiveRecord::Base.connection.execute("CREATE SCHEMA IF NOT EXISTS #{tenant.schema_name}")
    end

    def self.drop_database_tenant(tenant)
      db_config = tenant_db_config(tenant)
      ActiveRecord::Tasks::DatabaseTasks.drop(db_config)
    end

    def self.drop_schema_tenant(tenant)
      ActiveRecord::Base.establish_connection(tenant_db_config(tenant))
      ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS #{tenant.schema_name} CASCADE")
    end

    def self.tenant_db_config(tenant)
      {
        "adapter" => "postgresql",
        "host" => tenant.database_host,
        "port" => tenant.database_port.to_i,
        "database" => tenant.database_name,
        "username" => tenant.database_username,
        "password" => tenant.database_password,
        "encoding" => "unicode"
      }
    end

    def self.grant_tenant_permissions(tenant)
      # Store original connection for restoration
      original_connection = ActiveRecord::Base.connection_db_config

      # Connect as a superuser or database owner to grant permissions
      admin_config = tenant_db_config(tenant)

      # You might need to use a different user with GRANT privileges
      # admin_config['username'] = 'postgres'  # or your admin user

      ActiveRecord::Base.establish_connection(admin_config)

      # Grant necessary permissions to the tenant user
      username = tenant.database_username

      if tenant.schema?
        ActiveRecord::Base.connection.execute("GRANT ALL PRIVILEGES ON SCHEMA #{tenant.schema_name} TO #{username}")
      else
        ActiveRecord::Base.connection.execute("GRANT ALL PRIVILEGES ON SCHEMA public TO #{username}")
      end

    rescue ActiveRecord::RecordNotFound
      raise "Failed to grant permissions for tenant #{tenant.name}"
    ensure
      # Restore the original connection properly
      ActiveRecord::Base.establish_connection(original_connection) if original_connection
    end
  end
end
