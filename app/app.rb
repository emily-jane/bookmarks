require 'sinatra/base'
require_relative 'models/link.rb'
require_relative '../data_mapper_setup'


class Bookmarks < Sinatra::Base

  get '/' do
  redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    Link.new(url: params[:url], title: params[:title]).save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new'
  end

end