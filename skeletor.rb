#rails new kapow -m skeletor.rb --database=mysql

def template_file(filename)
  File.read(File.join(File.dirname(__FILE__), "templates", filename))
end

gem_group :development, :test do
  gem 'annotate', '~> 2.6.6'
  
  gem 'rspec-rails', '~> 3.0.0'
  gem 'rspec-mocks'
  gem 'shoulda-matchers', require: false
  gem "mail_safe"
end

gem 'devise', :git => 'https://github.com/plataformatec/devise.git'
gem 'activeadmin', github: 'activeadmin'

gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"

gem "haml-rails", "~> 0.9"

environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }", env: :development

route "root to: 'static#index'"

after_bundle do
  generate 'devise:views'
  generate 'active_admin:install', 'User'
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
