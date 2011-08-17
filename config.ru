$LOAD_PATH.unshift(Dir.getwd)
require 'app'
set :run, false
set :environment, :production
run Sinatra::Application