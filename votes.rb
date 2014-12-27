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
	redirect "/post/#{postid}"
end

get '/:categoryid/replydown/:replyid' do 														#request for reply downvote
	score = Reply.where(id: params[:replyid]).entries
	score[0].score = score[0].score - 1
	score[0].save
	postid = score[0].parent_post_id
	redirect "/post/#{postid}"
end

get '/catup/:catid' do 																						#request for category upvote
	score = Category.where(id: params[:catid]).entries
	score[0].score = score[0].score + 1
	score[0].save
	redirect "/"
end
get '/catdown/:catid' do 																						#request for category upvote
	score = Category.where(id: params[:catid]).entries
	score[0].score = score[0].score - 1
	score[0].save
	redirect "/"
end