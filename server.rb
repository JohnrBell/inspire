require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require 'date'

require "./lib/category.rb"
require "./lib/post.rb"
require "./lib/reply.rb"
require "./lib/subscription.rb"
require "./lib/connection.rb"

require './manage.rb' #all the gets/post to manage the database
require './tests.rb'

after do
  ActiveRecord::Base.connection.close
end

get '/' do 
	File.read('views/index.html')
	category = Category.all.entries
	# category.sort_by! { |k| k["score"] }
	# category.reverse!
	Mustache.render(File.read('views/index.html'), {
		category: category
	})
end


get '/cat/:post_id' do 
	posts = Post.where(parent_category_id: params[:post_id]).entries
	Mustache.render(File.read('views/posts.html'), {posts: posts})
end


# get '/post/:post_id/' do 
	posts = Post.find_by(id: params[:post_id])
# 	replies = Reply.find_by(parent_post_id: params[:post_id])
# 	# binding.pry
# 	Mustache.render(File.read('views/replies.html'), {posts: posts, replies: replies})
# end
