#rails new kapow -m skeletor.rb --database=mysql

def template_file(filename)
  File.read(File.join(File.dirname(__FILE__), "templates", filename))
end

skip_devise = ENV['skip_devise']
skip_aa = ENV['skip_aa']

gem_group :development, :test do
  gem 'annotate', '~> 2.6.6'
  
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-mocks'
  gem 'shoulda-matchers', require: false
  gem "mail_safe"
end

gem 'devise', :git => 'https://github.com/plataformatec/devise.git' unless skip_devise
gem 'activeadmin', github: 'activeadmin' unless skip_aa

gem "therubyracer", platform: :ruby
gem "less-rails"
gem "twitter-bootstrap-rails"

gem "haml-rails", "~> 0.9"

environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: :development

route "root to: 'static#index'"

after_bundle do
  generate 'devise:views' unless skip_devise
  generate 'active_admin:install', 'User' unless skip_aa
  generate 'rspec:install'
  generate :controller, "static"

  Dir[File.join(File.dirname(__FILE__), "templates").to_s + "/**/*"].each do |file|
    next if File.directory?(file)

    /templates\/(?<filename>.*)/ =~ file
    run "rm #{filename}"
    file(filename){ template_file filename }
  end

  rake "db:create:all"
  rake "db:migrate"
  rake "db:setup"

  run("rm app/views/layouts/application.html.erb")

  generate "bootstrap:install", "less"
  generate "bootstrap:layout", "application"

  rake "db:seed"

  run "ln -s `pwd` ~/.pow/"

  run "which mina && mina init"

  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"
end
