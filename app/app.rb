require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/partial'
require_relative 'models/link.rb'
require_relative '../data_mapper_setup'

class Bookmarks < Sinatra::Base

enable :sessions
register Sinatra::Flash
register Sinatra::Partial
set :session_secret, 'super secret'
use Rack::MethodOverride

helpers do
  def current_user
    current_user ||= User.get(session[:user_id])
  end
end

  get '/' do
  erb :welcome
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    params[:tags].split(" ").each do |tag|
      tag = Tag.create(name: tag)
      link.tags << tag
    end
    link.save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new'
  end
 
  get '/tags/:name' do
    tag = Tag.all(name: params[:name])
    @links = tag ? tag.links : [] 
    erb :'links/index'
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email], password: params[:password], password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions/new' do
    flash.now[:notice] = 'Check your emails'
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.now[:notice] = 'goodbye!'
    erb :'sessions/new'
  end

  get '/users/password_reset' do
    erb :'users/password_reset'
  end

  run! if app_file == $0
end