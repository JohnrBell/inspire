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
	category = Category.all.entries
	category.sort_by! { |k| k["score"] }.reverse!																	#sorts by popularity

	category.each do |cat|																												#gsubs the format tags
		cat.descrip = cat.descrip.gsub('[b]','<b>').gsub('[/b]','</b>')
	end
	Mustache.render(File.read('views/index.html'),{category: category})						#displays all categories
end


get '/cat/:cat_id' do 																													#show posts page
	category = Category.where(id: params[:cat_id]).entries				
	posts = Post.where(parent_category_id: params[:cat_id]).entries
	posts.sort_by! { |k| k["score"] }.reverse!																		#sorts by popularity
	birth_to_s(posts) 																														#converts birthdate into a logical string			

	if posts.count == 0 																													#checks if there are posts in the category
		deletebutton = File.read('views/deletebutton.html')													#grabs html for delete button
	else																																					#if there are posts, do this....
		deletebutton	= ""																													#shows no delete button
	end
	posts.each do |post|																													#runs through posts
		if post.death != ""																													#if there is a death date...
			if DateTime.now.new_offset(0) > DateTime.parse(post.death)								#check if death date is in past
				post.birth = "Post is dead"																							#changes string
	end end end 																																	#ends

	suboutmsg(posts)																															#gsubs the format tags																														
	Mustache.render(File.read('views/posts.html'), 
		{posts: posts, category: category, deletebutton: deletebutton})							#displays all posts in category
end


get "/delcat/:id" do 																														#deletes a blank category
	to_del = Category.find_by(id: params[:id])
	to_del.destroy
	redirect "/"
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


get '/pagedpost/:post_id/:id_of_first_reply' do 																#shows paginated replies
	posts = Post.where(id: params[:post_id]).entries
	replies = Reply.where(parent_post_id: params[:post_id]).entries		
	replies.sort_by! { |k| k["score"]}.reverse!																		#sorts by popularity
	birth_to_s(replies) 																													#converts birthdate into a logical string
	
	if params[:id_of_first_reply].to_i == replies.count	&& 												#prevents you from seeing blank page by going to far
	params[:id_of_first_reply].to_i > 0																						#if you ask for replies to start at final post, it 
		lessone = params[:id_of_first_reply].to_i - 1																#puts you back a post
		newurl = "/pagedpost/#{params[:post_id]}/#{lessone}"												#generates url for that new url
		redirect newurl																															#and sends you there
	end

	replies.shift(params[:id_of_first_reply].to_i)																#deletes all replies before first reply asked for
	while replies.count > 3																										
		replies.pop 																																#remove end replies until 3 are left.
	end

	backnum = params[:id_of_first_reply].to_i - 3																	#creates the number of steps back link
	if backnum < 0 then backnum = 0 end
 	backlink = "<a href='/pagedpost/#{params[:post_id]}/#{backnum}'>
 	View Higher Rated Comments</a>"

	nextnum = params[:id_of_first_reply].to_i + 3																	#creates the number of steps forward link
	nextlink =  "<a href='/pagedpost/#{params[:post_id]}/#{nextnum}'>
	View Lower Rated Comments</a>"
	
	if replies.count < 3																													#if you have less than 3 replies, no next link.
		nextlink = "No More Comments available"
	end
	if params[:id_of_first_reply].to_i == 0 																			#if seeing first link, no back link. 
	 	backlink = "No Previous available"
 	end	

	deathdate = Post.where(id: params[:post_id]).entries													#pulls the .death data from selected post
	deathdate = deathdate[0].death 																								#pulls the .death data from the array from above line
	if deathdate =="" 																														#if no death date set...
		deathdate	= File.read('views/addareply.html')																#add in form to add a reply
	elsif deathdate != ""																													#if there is a deathdate set
		deathdate = DateTime.parse(deathdate)																				#parse deathdate into a datetime object
		deathdate = DateTime.now.new_offset(0) - deathdate													#subtract that from current time to get age
		if deathdate > 0 																														#if (now-deathdate) is over zero.. (dead)
			deathdate = "<center>This post is dead.<br>															
			Sorry, you can not add a reply.<br><br></center>"													#sets post is dead message
		else																																				#if (now-deathdate) is under zero.. (alive)
			deathdate	= File.read('views/addareply.html')															#reads in the form to add reply/post
		end
	end
	
	suboutmsg(replies)																														#gsubs the format tags

	Mustache.render(File.read('views/paged.html'), 
		{posts: posts, 
		replies: replies, 
		deadoralive: deathdate, 
		backlink: backlink, 
		nextlink: nextlink})										
end

