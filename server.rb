require 'pry'
require 'sinatra'
require 'mustache'
require 'sinatra/reloader'
require 'date'
require 'sendgrid-ruby'
require 'twilio-ruby'


require "./lib/category.rb"
require "./lib/post.rb"
require "./lib/reply.rb"
require "./lib/subscription.rb"
require "./lib/connection.rb"


require './manage.rb'  #all the gets/post to manage the database
require './votes.rb' 	 #all the voting logic
require './methods.rb' #all the methods

after do
  ActiveRecord::Base.connection.close																						#hack to keep sql from disconnecting
end


get '/' do 																																			#request to get categories/homepage
	category = Category.all.entries
	category.sort_by! { |k| k["score"] }.reverse!																	#sorts by popularity
	# binding.pry
	category.each do |cat|																												#gsubs the format tags
		cat.descrip = cat.descrip.gsub('[b]','<b>').gsub('[/b]','</b>')
	end

	Mustache.render(File.read('views/index.html'),{category: category})						#displays all categories
end


get '/cat/:post_id' do 																													#request to get posts page
	posts = Post.where(parent_category_id: params[:post_id]).entries

	posts.sort_by! { |k| k["score"] }.reverse!																		#sorts by popularity
	birth_to_s(posts) 																														#converts birthdate into a logical string			

	if posts.count == 0 																													#checks if there are posts in the category
		deletebutton = File.read('views/deletebutton.html')													#grabs html for delete button
		category = params[:post_id]																									#sets params for the delete button
	else																																					#if there are posts, do this....
		category = Category.where(id: posts[0].parent_category_id).entries					#grabs the category to get data from it
		category = category[0].id
		deletebutton	= ""																													#presents no delete button
	end

	posts.each do |post|																													#runs through posts
		if post.death != ""																													#if there is a death date...
			if DateTime.now.new_offset(0) > DateTime.parse(post.death)															#check if death date is in past
				post.birth = "Post is dead"																							#changes string
	end end end 																																	#ends

	posts.each do |post|																													#gsubs the format tags
		post.msg = post.msg.gsub('[b]','<b>').gsub('[/b]','</b>')
	end																																

	Mustache.render(File.read('views/posts.html'), 
		{posts: posts, category: category, deletebutton: deletebutton})							#displays all posts in category
end


get '/cat/:cat_id/post/:post_id' do 																						#request to replies page
	posts = Post.where(id: params[:post_id]).entries
	replies = Reply.where(parent_post_id: params[:post_id]).entries		
	replies.sort_by! { |k| k["score"]}.reverse!																		#sorts by popularity
	birth_to_s(replies) 																													#converts birthdate into a logical string
	
	deathstatus = Post.where(id: params[:post_id]).entries												#pulls the .death data from selected post
	deathstatus = deathstatus[0].death 																						#pulls the .death data from the array from above line
	
	if deathstatus != ""																													#if there is a deathstatus set
		deathstatus = DateTime.parse(deathstatus)																		#parse deathstatus into a datetime object
		deathstatus = DateTime.now.new_offset(0) - deathstatus											#subtract that from current time to get age
		if deathstatus > 0 																													#if (now-deathdate) is over zero.. (dead)
			deathstatus = "<center>This post is dead.<br>															
										Sorry, you can not add a reply.<br><br></center>"						#sets post is dead message
		else																																				#if (now-deathdate) is under zero.. (alive)
			deathstatus	= File.read('views/addareply.html')														#reads in the form to add reply/post
		end
	else																																					#if no death date at all....
		deathstatus	= File.read('views/addareply.html')															#add in form also
	end

	replies.each do |reply|																												#gsubs the format tags
		reply.msg = reply.msg.gsub('[b]','<b>').gsub('[/b]','</b>')
	end		
	output = Mustache.render(File.read('views/replies.html'), 
		{posts: posts, replies: replies, deadoralive: deathstatus})									#displays all replies in post
end


get "/delcat/:id" do 																														#deletes a blank category
	to_del = Category.find_by(id: params[:id])
	to_del.destroy
	redirect "/"
end


post '/addcat' do 																															#adds a category 
	name = params[:name]
	descrip = params[:descrip]
	Category.create(
		name: name,
		descrip: descrip,
		score: '0')
	redirect back
end


post '/addreply/:idofpost' do 																									#add a reply
	msg = params[:msg]
	birth = DateTime.now.new_offset(0)
	author = params[:author]
	check_for_sub(nil,params[:idofpost])		
	Reply.create(
		parent_post_id: params[:idofpost],
		author: author,
		msg: msg,
		score: '0',
		birth: birth)	
	redirect back
end


post '/addpost/:idofcat' do 																										#add a post 
	parent_category_id = params[:idofcat]
	title = params[:title]
	msg = params[:msg]
	author = params[:author]
	url = params[:urladd]
	score = '0'
	birth = DateTime.now.new_offset(0).to_s

	#checks to see if you set a death date or left that part of the form alone..
	if  params[:year]!=""&&params[:month]!=""&&params[:day]!=""&&params[:hour]!=""&&params[:minute]!=""	
		death =	"#{params[:year]}-#{params[:month]}-#{params[:day]}T#{params[:hour]}:#{params[:minute]}:00+00:00"
	else
		death = ""
	end

	check_for_sub(params[:idofcat], nil)																					#runs: look for category subscibers	
	Post.create(																																	
		parent_category_id: parent_category_id,
		title: title,
		msg: msg,
		author: author,
		url: url,
		score: score,
		birth: birth,
		death: death)
	redirect back	
end


get '/as' do 																																		#get activity stream of posts&replies
	activitystream = []
	post = Post.all.entries
	reply = Reply.all.entries
	post.each do |x| activitystream.push(x) end
	reply.each do |x| activitystream.push(x) end
	activitystream.sort_by! { |k| k["birth"] }.reverse!

	Mustache.render(File.read('views/as.html'), 
		{activitystream: activitystream})																						#displays activity stream
end


