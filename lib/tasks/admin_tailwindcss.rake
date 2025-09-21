namespace :admin do
  namespace :tailwindcss do
    desc "Watch and build admin Tailwind CSS on file changes"
    task :watch do
      input_file, output_file = setup_admin_tailwind_files
      
      puts "Watching admin Tailwind CSS: #{input_file} -> #{output_file}"
      puts "Press Ctrl+C to stop watching..."
      
      exec_tailwind_command(input_file, output_file, "--watch")
    rescue Interrupt
      puts "\nStopping admin Tailwind CSS watcher..."
    end
    
    desc "Build admin Tailwind CSS"
    task :build do
      input_file, output_file = setup_admin_tailwind_files
      
      puts "Building: #{input_file} -> #{output_file}"
      
      if exec_tailwind_command(input_file, output_file, "--minify")
        puts "Admin Tailwind CSS built successfully!"
      else
        puts "Error building admin Tailwind CSS"
        exit 1
      end
    end
    
    private
    
    def setup_admin_tailwind_files
      input_file = Rails.root.join("app/assets/tailwind/admin.css")
      output_file = Rails.root.join("app/assets/builds/admin/tailwind.css")
      
      # Ensure directories exist
      FileUtils.mkdir_p(File.dirname(input_file))
      FileUtils.mkdir_p(File.dirname(output_file))
      
      # Create input file if it doesn't exist
      unless File.exist?(input_file)
        File.write(input_file, <<~CSS)
          @import "tailwindcss";
          
          /* Admin-specific styles */
        CSS
        puts "Created #{input_file}"
      end
      
      [input_file, output_file]
    end
    
    def exec_tailwind_command(input_file, output_file, *options)
      # Main app uses Tailwind's default content scanning behavior
      # Engine files should be within the scanning scope or use @source directives in CSS
      cmd = [
        "tailwindcss",
        "-i", input_file.to_s,
        "-o", output_file.to_s,
        *options
      ]
      
      puts "Building with Tailwind CSS v4 default content scanning" if ENV['DEBUG']
      
      if options.include?("--watch")
        exec(*cmd)
      else
        system(*cmd)
      end
    end
  end
end