#!/usr/bin/env ruby
$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'sinatra'
require 'data_mapper'


require 'models'

# use Rack::ShowExceptions

configure do
  enable :sessions
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/tinyfora.db")
  # DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/tinyfora.db")
  #DataMapper.setup(:default, 'postgres://postgres:postgres@localhost/tinyfora')
  DataMapper::Logger.new(STDOUT, :debug)
  

end

before do
  redirect '/login' unless authenticated? unless env['REQUEST_PATH'] =~ /^\/login|users|style|favicon/
end

get '/' do
  redirect '/forums' if authenticated?
  'Welcome to TinyFora'
end

get %r{^/style\d+?.css} do
  content_type 'text/css', :charset => 'utf-8'
  sass :style
end

get %r{^/images/(.+)$} do
  content_type 'image/gif'
  open(File.join(Dir.pwd, "views", "images", params[:captures][0]), "r").read
end

%w(helpers.rb user_routes.rb forum_routes.rb topic_routes.rb post_routes.rb).each { |f| load f }


