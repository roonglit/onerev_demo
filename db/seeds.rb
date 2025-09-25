# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Script to read and execute all seed files in the seeds/ folder
puts "🌱 Starting seed process..."

seeds_dir = File.join(File.dirname(__FILE__), 'seeds')

if Dir.exist?(seeds_dir)
  # Get all Ruby files in the seeds directory and sort them alphabetically
  seed_files = Dir.glob(File.join(seeds_dir, '*.rb')).sort
  
  if seed_files.any?
    puts "📁 Found #{seed_files.length} seed file(s) in #{seeds_dir}"
    
    seed_files.each do |seed_file|
      filename = File.basename(seed_file)
      puts "🔄 Executing: #{filename}"
      
      begin
        # Load and execute the seed file
        load seed_file
        puts "✅ Successfully executed: #{filename}"
      rescue => e
        puts "❌ Error executing #{filename}: #{e.message}"
        puts "   #{e.backtrace.first}" if e.backtrace
        # Continue with other files even if one fails
      end
    end
    
    puts "🌱 Seed process completed!"
  else
    puts "📂 No seed files found in #{seeds_dir}"
  end
else
  puts "📂 Seeds directory not found: #{seeds_dir}"
  puts "💡 Create the directory and add .rb files to it for automatic execution"
end

