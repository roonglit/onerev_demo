class Tenant < ApplicationRecord
  enum :tenancy_type, { database: 0, schema: 1 }
end
