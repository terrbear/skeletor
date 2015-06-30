#rails new kapow -m skeletor.rb --database=mysql

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

rakefile("auto_annotate_models.rake") do
  <<-TASK
# NOTE: only doing this in development as some production environments (Heroku)
# NOTE: are sensitive to local FS writes, and besides -- it's just not proper
# NOTE: to have a dev-mode tool do its thing in production.
if Rails.env.development?
  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the
    # same name.
    Annotate.set_defaults({
      'position_in_routes'   => "before",
      'position_in_class'    => "after",
      'position_in_test'     => "before",
      'position_in_fixture'  => "before",
      'position_in_factory'  => "before",
      'show_indexes'         => "true",
      'simple_indexes'       => "false",
      'model_dir'            => "app/models",
      'include_version'      => "false",
      'require'              => "",
      'exclude_tests'        => "false",
      'exclude_fixtures'     => "false",
      'exclude_factories'    => "false",
      'ignore_model_sub_dir' => "false",
      'skip_on_db_migrate'   => "false",
      'format_bare'          => "true",
      'format_rdoc'          => "false",
      'format_markdown'      => "false",
      'sort'                 => "false",
      'force'                => "false",
      'trace'                => "false",
    })
  end

  Annotate.load_tasks
end
  TASK
end

after_bundle do
  generate 'devise'
  generate 'devise:views'
  generate 'active_admin:install', 'User'
  generate 'rspec:install'
  generate :controller, "static"

  file("app/views/static/index.html.haml") do
    <<-HAML
Skeletor engaged.
    HAML
  end

  rake "db:create:all"
  rake "db:migrate"
  rake "db:setup"

  run("rm .rspec")
  run("rm app/views/layouts/application.html.erb")

  file(".rspec") do
    <<-RSPEC
--color
--require spec_helper
--format documentation
    RSPEC
  end

  generate "bootstrap:install", "less"
  generate "bootstrap:layout", "application"

  run("rm app/assets/stylesheets/application.css")
  file("app/assets/stylesheets/application.css") do
    <<-CSS
    /*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or any plugin's vendor/assets/stylesheets directory can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require bootstrap_and_overrides
 *= require_self
 */
    CSS
  end

  run("rm db/seeds.rb")
  file("db/seeds.rb") do
    <<-SEED
User.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
    SEED
  end
    
  rake "db:seed"

  run "ln -s `pwd` ~/.pow/"

  git :init
  git add: "."
  git commit: "-a -m 'Initial commit'"
end


