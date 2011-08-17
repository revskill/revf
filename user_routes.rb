require 'digest/sha1'

get '/login' do
  redirect '/forums' if authenticated?
  haml :login
end

post '/login' do
  redirect '/forums' if auth(params[:login], params[:password]) if params[:password] && params[:login]
  status 400 and return "Login failed"
end

get '/logout' do
  unauth and redirect '/login'
end

get '/users/new' do
  redirect '/forums' if authenticated?
  haml :new_user
end

get '/users' do
	@users = User.all
	haml :users
end

get %r{^/users/(\d+)$} do
  @user = User.first(:id => params[:captures][0])
  status 404 and return "User not found" unless @user  
  haml :user
end

post '/users' do
  unless params[:password] && params[:login] && (params[:password].empty? || params[:login].empty?)
    unless User.first(:login => params[:login])
      create_user(params[:login], params[:password])
      redirect '/login'
    else
      status 403 and return "User exists"
    end
  else
    status 400 and return "Please provide complete information"
  end
end















