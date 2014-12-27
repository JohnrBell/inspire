def birth_to_s(entry)																														#converts age to a logical string 
	entry.each  do |x|																														#runs through each entry
			age = DateTime.now.new_offset(0)-DateTime.parse(x.birth)									#calculates age (now-birth)
			age = (age*1.day)/60/60/24																								#converts age from seconds to days
			age = age.round(1)																												#rounds days to x.x
			age = "This post is #{age} days old."																			#builds string 
			x.birth = age																															#sets attribute .birth to age
end	end																																					#ends 

def suboutmsg(what)																															#subs out the [b] and [/b] tags
	what.each do |reply|		
		reply.msg = reply.msg.gsub('[b]','<b>').gsub('[/b]','</b>')
	end	
end

def check_for_sub(category_id, post_id)																					#checks for subscriptions
	if post_id == nil																															#code to run if you pass a category_id
		subscriptions = Subscription.where(parent_category_id: category_id).entries	
		category = Category.where(id: category_id).entries
		message = "A new post was made in #{category[0].name}!"
		send_noif(subscriptions, message)																						#calls send notification

	elsif category_id == nil																											#code to run if you pass a post_id
		subscriptions = Subscription.where(parent_post_id: post_id).entries	
		post = Post.where(id: post_id).entries
		message = "A new reply was made in #{post[0].title}!"
		send_noif(subscriptions, message)																						#calls send notification 
	end
end


def send_noif(subscriptions, message)
	subscriptions.each do |sub|																										
		if sub.contact_info.match /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/								#checks if the contact info is an email
			client = SendGrid::Client.new(api_user: 'johnrbell', 											#api validation 
				api_key: 'ralsup85')																										#api validation
			mail = SendGrid::Mail.new do |m|																					#email to email address
			  m.to = sub.contact_info
			  m.from = 'oohfancy@oohfancy.com'
			  m.subject = message
			  m.text = message
			end
			puts client.send(mail)
		else																																				#does if contact info is not an email address
			account_sid = 'ACed0ac6ff890dcdda1589958af82b5104'												#api validation
			auth_token = '68aa46cb4b6b61173745e0602909df0c'														#api validation
			@client = Twilio::REST::Client.new account_sid, auth_token								#sms to phone number
			@client.messages.create(
		  	from: '+17323336096',
			  to: sub.contact_info,
			  body: message)
		end
	end	
end




 