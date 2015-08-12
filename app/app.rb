require 'sinatra/base'
require_relative 'models/link.rb'
require_relative '../data_mapper_setup'


class Bookmarks < Sinatra::Base

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
    @links = tag ? tag.links : [] # brilliant refactoring
    erb :'links/index'
  end

end