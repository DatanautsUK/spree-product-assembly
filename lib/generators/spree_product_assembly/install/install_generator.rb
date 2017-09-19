module SpreeProductAssembly
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_migrations
        run 'rake railties:install:migrations FROM=spree_product_assembly'
      end

      def add_javascripts
        append_file "#{js_path}/backend/all.js", "//= require spree/backend/spree_product_assembly\n"
        append_file "#{js_path}/frontend/all.js", "//= require spree/frontend/spree_product_assembly\n"
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
           run 'rake db:migrate'
         else
           puts "Skiping rake db:migrate, don't forget to run it!"
         end
      end

      private

      def js_path
        return 'vendor/assets/javascripts/spree' if Dir.exist?('vendor/assets/javascripts/spree')
        'app/assets/javascripts/spree'
      end
    end
  end
end
