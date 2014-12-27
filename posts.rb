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