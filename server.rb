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


require './manage.rb' #all the gets/post to manage the database
require './votes.rb' 	#all the voting logic

after do
  ActiveRecord::Base.connection.close																						#hack to keep sql from disconnecting
end


get '/' do 																																			#request to get categories/homepage
	category = Category.all.entries
	category.sort_by! { |k| k["score"] }.reverse!																	#sorts by popularity

	Mustache.render(File.read('views/index.html'), 
		{category: category})
end


get '/cat/:post_id' do 																													#request to get posts page
	posts = Post.where(parent_category_id: params[:post_id]).entries
	category = Category.where(id: posts[0].parent_category_id).entries
	posts.sort_by! { |k| k["score"] }.reverse!																		#sorts by popularity
	birth_to_s(posts) 																														#converts birthdate into a logical string			

	posts.each do |post|																													#runs through posts
		if post.death != ""																													#if there is a death date...
			if DateTime.now > DateTime.parse(post.death)															#check if death date is in past
				post.birth = "Post is dead"																							#changes string
	end end end 																																	#ends	

	output = Mustache.render(File.read('views/posts.html'), 
		{posts: posts, category: category})
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
										Sorry, you can not add a reply.</center>"										#sets post is dead message
		else																																				#if (now-deathdate) is under zero.. (alive)
			deathstatus	= File.read('views/addareply.html')														#reads in the form to add reply/post
		end
	else																																					#if no death date at all....
		deathstatus	= File.read('views/addareply.html')															#add in form also
	end
	
	output = Mustache.render(File.read('views/replies.html'), 
		{posts: posts, replies: replies, deadoralive: deathstatus})
end


post '/addreply/:idofpost' do 																									#does the logic to add reply
	msg = params[:msg]
	birth = DateTime.now.new_offset(0)
	author = params[:author]
	Reply.create(
		parent_post_id: params[:idofpost],
		author: author,
		msg: msg,
		score: '0',
		birth: birth)	
	check_for_sub(nil,params[:idofpost])		
	redirect back
end


post '/addpost/:idofcat' do 																										#does the logic to add a new post
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

	check_for_sub(params[:idofcat], nil)																	#runs: look for category subscibers

	# Post.create(
	# 	parent_category_id: parent_category_id,
	# 	title: title,
	# 	msg: msg,
	# 	author: author,
	# 	url: url,
	# 	score: score,
	# 	birth: birth,
	# 	death: death
	# 	)
	redirect back	
end





def birth_to_s(entry)																														#converts age to a logical string 
	entry.each  do |x|																														#runs through each entry
			age = DateTime.now.new_offset(0)-DateTime.parse(x.birth)									#calculates age (now-birth)
			age = (age*1.day)/60/60/24																								#converts age from seconds to days
			age = age.round(1)																												#rounds days to x.x
			age = "This post is #{age} days old."																			#builds string 
			x.birth = age																															#sets attribute .birth to age
end	end																																					#ends 





def check_for_sub(category_id, post_id)																					#checks category for subscriptions
	if post_id == nil																															#code to run if you pass a category_id
		subscriptions = Subscription.where(parent_category_id: category_id).entries	
		category = Category.where(id: category_id).entries
		message = "A new post was made in #{category[0].name}!"

		subscriptions.each do |sub|																										
			if sub.contact_info.match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/							#checks if the contact info is an email
				client = SendGrid::Client.new(api_user: 'johnrbell', 										#api validation 
					api_key: 'ralsup85')																									#api validation
				mail = SendGrid::Mail.new do |m|																				#email to email address
				  m.to = sub.contact_info
				  m.from = 'oohfancy@oohfancy.com'
				  m.subject = message
				  m.text = message
				end
				puts client.send(mail)
			else																																			#does if contact info is not an email address
				account_sid = 'ACed0ac6ff890dcdda1589958af82b5104'											#api validation
				auth_token = '68aa46cb4b6b61173745e0602909df0c'													#api validation
				@client = Twilio::REST::Client.new account_sid, auth_token							#sms to phone number
				@client.messages.create(
			  	from: '+17323336096',
				  to: sub.contact_info,
				  body: message)
			end
		end	
	elsif category_id == nil																											#code to run if you pass a post_id
		subscriptions = Subscription.where(parent_category_id: category_id).entries	
		post = Post.where(id: post_id).entries
		message = "A new reply was made in #{post[0].title}!"

		subscriptions.each do |sub|																										
			if sub.contact_info.match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/							#checks if the contact info is an email
				client = SendGrid::Client.new(api_user: 'johnrbell', 										#api validation 
					api_key: 'ralsup85')																									#api validation
				mail = SendGrid::Mail.new do |m|																				#email to email address
				  m.to = sub.contact_info
				  m.from = 'oohfancy@oohfancy.com'
				  m.subject = message
				  m.text = message
				end
				puts client.send(mail)
			else																																			#does if contact info is not an email address
				account_sid = 'ACed0ac6ff890dcdda1589958af82b5104'											#api validation
				auth_token = '68aa46cb4b6b61173745e0602909df0c'													#api validation
				@client = Twilio::REST::Client.new account_sid, auth_token							#sms to phone number
				@client.messages.create(
			  	from: '+17323336096',
				  to: sub.contact_info,
				  body: message)
			end
		end	
	end
end


# def check_for_sub(category_id, post_id)																					#checks category for subscriptions
# 	if post_id == nil																															#code to run if you pass a category_id
# 		subscriptions = Subscription.where(parent_category_id: category_id).entries	
# 		category = Category.where(id: category_id).entries
# 		message = "A new post was made in #{category[0].name}!"

# 		subscriptions.each do |sub|																										
# 			if sub.contact_info.match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/							#checks if the contact info is an email
# 				client = SendGrid::Client.new(api_user: 'johnrbell', 										#api validation 
# 					api_key: 'ralsup85')																									#api validation
# 				mail = SendGrid::Mail.new do |m|																				#email to email address
# 				  m.to = sub.contact_info
# 				  m.from = 'oohfancy@oohfancy.com'
# 				  m.subject = message
# 				  m.text = message
# 				end
# 				puts client.send(mail)
# 			else																																			#does if contact info is not an email address
# 				account_sid = 'ACed0ac6ff890dcdda1589958af82b5104'											#api validation
# 				auth_token = '68aa46cb4b6b61173745e0602909df0c'													#api validation
# 				@client = Twilio::REST::Client.new account_sid, auth_token							#sms to phone number
# 				@client.messages.create(
# 			  	from: '+17323336096',
# 				  to: sub.contact_info,
# 				  body: message)
# 			end
# 		end	
# 	elsif category_id == nil																											#code to run if you pass a post_id
# 		subscriptions = Subscription.where(parent_category_id: category_id).entries	
# 		post = Post.where(id: post_id).entries
# 		message = "A new reply was made in #{post[0].title}!"

# 		subscriptions.each do |sub|																										
# 			if sub.contact_info.match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/							#checks if the contact info is an email
# 				client = SendGrid::Client.new(api_user: 'johnrbell', 										#api validation 
# 					api_key: 'ralsup85')																									#api validation
# 				mail = SendGrid::Mail.new do |m|																				#email to email address
# 				  m.to = sub.contact_info
# 				  m.from = 'oohfancy@oohfancy.com'
# 				  m.subject = message
# 				  m.text = message
# 				end
# 				puts client.send(mail)
# 			else																																			#does if contact info is not an email address
# 				account_sid = 'ACed0ac6ff890dcdda1589958af82b5104'											#api validation
# 				auth_token = '68aa46cb4b6b61173745e0602909df0c'													#api validation
# 				@client = Twilio::REST::Client.new account_sid, auth_token							#sms to phone number
# 				@client.messages.create(
# 			  	from: '+17323336096',
# 				  to: sub.contact_info,
# 				  body: message)
# 			end
# 		end	
# 	end
# end






 