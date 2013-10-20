require 'bundler/setup'
load 'deploy'
# Uncomment if you are using Rails' asset pipeline
    # load 'deploy/assets'
Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
require "capistrano-resque"
load 'config/deploy' # remove this line to skip loading any of the default tasks
