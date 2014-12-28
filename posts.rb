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
	# check_for_sub(nil,params[:idofpost])																				#runs: look for post subscibers	
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
	death = ""
	#checks to see if you set a death date or left that part of the form alone..
	if  params[:year]!=""&&params[:month]!=""&&params[:day]!=""&&params[:hour]!=""&&params[:minute]!=""	
		death =	"#{params[:year]}-#{params[:month]}-#{params[:day]}T#{params[:hour]}:#{params[:minute]}:00+00:00"
	end
	# check_for_sub(params[:idofcat], nil)																				#runs: look for category subscibers	
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

post '/sub_cat/:cat_id' do																											#adds a category subscription
	parent_category_id = params[:cat_id].to_i
	contact_info = params[:contact_info]
	Subscription.create(
		parent_post_id: 0,
		parent_category_id: parent_category_id,
		contact_info: contact_info)
	redirect back
end

post '/sub_post/:post_id' do																										#adds a post subscription
	parent_post_id = params[:post_id].to_i
	contact_info = params[:contact_info]
	Subscription.create(
		parent_post_id: parent_post_id,
		parent_category_id: 0,
		contact_info: contact_info)
	redirect back
end