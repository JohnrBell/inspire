require 'pry'
require 'sinatra'
require 'mustache'
# require 'sinatra/reloader'
require 'date'
require 'sendgrid-ruby'
require 'twilio-ruby'

require "./lib/category.rb"
require "./lib/post.rb"
require "./lib/reply.rb"
require "./lib/subscription.rb"
require "./lib/connection.rb"

require './manage.rb'  																													#all the gets/post to manage the database
require './votes.rb' 																														#all the voting logic
require './posts.rb'																														#all the post routes
require './methods.rb' 																													#all the methods

after do
  ActiveRecord::Base.connection.close																						#hack to keep sql from disconnecting
end


get '/' do 																																			#show categories/homepage
	"Hello World"
end
