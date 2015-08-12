require 'sinatra/base'
require 'sinatra/flash'

require_relative 'models/link.rb'
require_relative '../data_mapper_setup'


class Bookmarks < Sinatra::Base

enable :sessions
register Sinatra::Flash
set :session_secret, 'super secret'

helpers do
  def current_user
    current_user ||= User.get(session[:user_id])
  end 
end

  get '/' do
  redirect '/links/new'
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

    tag = Tag.first(name: params[:name])
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
      flash.now[:notice] = "Password and confirmation password do not match"
      erb :'users/new'
    end
  end

end