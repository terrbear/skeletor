# skeletor
Boilerplate for apps

Right now it's just a Rails template. Invoke like so:

    rails new <appname> -m skeletor.rb

# assumptions
This is for libraries that I use in almost every project I work on. For Rails, this means:

* RSpec for testing, with fixtures and shoulda matchers
* Devise for authentication
* ActiveAdmin for backend scaffolding
* Bootstrap for front end styling
* Mail safe so you never, ever, email everyone after getting a production database
* Annotate for schema comments in your everything
* HAML
* Mina for deploying (if installed)
