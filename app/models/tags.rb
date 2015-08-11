require 'data_mapper'
require 'sinatra'

class Tag
  include DataMapper::Resource

  property :id, Serial
  property :name, String

  has n, :links, through: Resource

end