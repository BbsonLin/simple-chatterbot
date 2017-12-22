require "capistrano/setup"
require "capistrano/deploy"
require "capistrano/scm/git"
require "slackistrano/capistrano"
require_relative 'config/custom_message'
install_plugin Capistrano::SCM::Git

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
