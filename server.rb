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
# require './tests.rb'

after do
  ActiveRecord::Base.connection.close
end

get '/' do 
	File.read('views/index.html')
	category = Category.all.entries
	category.sort_by! { |k| k["score"] }.reverse!

	Mustache.render(File.read('views/index.html'), {category: category})
end

get '/cat/:post_id' do 
	posts = Post.where(parent_category_id: params[:post_id]).entries
	posts.sort_by! { |k| k["score"] }.reverse!
	category = Category.where(id: posts[0].parent_category_id).entries

	Mustache.render(File.read('views/posts.html'), {posts: posts, category: category})
end

get '/postup/:postid' do 																						#request for post upvote
	score = Post.where(id: params[:postid]).entries
	score[0].score = score[0].score + 1
	score[0].save
	categoryid = score[0].parent_category_id
	redirect "/cat/#{categoryid}"
end

get '/postdown/:postid' do 																					#request for post downvote
	score = Post.where(id: params[:postid]).entries
	score[0].score = score[0].score - 1
	score[0].save
	categoryid = score[0].parent_category_id
	redirect "/cat/#{categoryid}"
end

get '/:categoryid/replyup/:replyid' do 															#request for reply upvote
	score = Reply.where(id: params[:replyid]).entries
	score[0].score = score[0].score + 1
	score[0].save
	postid = score[0].parent_post_id
	redirect "/cat/#{params[:categoryid]}/post/#{postid}"
end

get '/:categoryid/replydown/:replyid' do 														#request for reply downvote
	score = Reply.where(id: params[:replyid]).entries
	score[0].score = score[0].score - 1
	score[0].save
	postid = score[0].parent_post_id
	redirect "/cat/#{params[:categoryid]}/post/#{postid}"
end

get '/cat/:cat_id/post/:post_id' do 
	posts = Post.where(id: params[:post_id]).entries
	replies = Reply.where(parent_post_id: params[:post_id]).entries

	replies.each do |reply|																						#runs through replies
		age = DateTime.now.new_offset(0)-DateTime.parse(reply.birth)		#calculates age
		age = (age*1.day)/60/60/24																			#converts seconds to days
		age = age.round(1)																							#rounds days to x.x
		age = "This post is #{age} days old."														#builds string
		reply.birth = age																								#sets variable to age
	end																																#ends 

	replies.sort_by! { |k| k["score"]}.reverse!

	Mustache.render(File.read('views/replies.html'), {posts: posts, replies: replies})
end