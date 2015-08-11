require 'data_mapper'
require 'sinatra'

class Link

  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :url, String

end
