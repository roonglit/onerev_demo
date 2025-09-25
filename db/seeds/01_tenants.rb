Tenant.find_or_create_by(name: 'krungthai') do |tenant|
  tenant.slug = "krungthai"
  tenant.subdomain = "onerev"
  tenant.database_host = "localhost"
  tenant.database_port = "5432"
  tenant.database_name = "krungthai"
  tenant.database_username = "postgres"
  tenant.database_password = "postgres"
end

Tenant.find_or_create_by(name: 'arise') do |tenant|
  tenant.slug = "arise"
  tenant.subdomain = "arise"
  tenant.database_host = "localhost"
  tenant.database_port = "5432"
  tenant.database_name = "arise"
  tenant.database_username = "postgres"
  tenant.database_password = "postgres"
end