::ActiveRecord::Base.clear_all_connections!


get '/manage' do #renders out the add page with input boxes
	category = Category.all.entries
	post = Post.all.entries
	reply = Reply.all.entries
	subscription = Subscription.all.entries

	category.sort_by! { |k| k["id"] }
	post.sort_by! { |k| k["id"] }
	reply.sort_by! { |k| k["id"] }
	subscription.sort_by! { |k| k["id"] }

	Mustache.render(File.read('views/manage.html'), {
		category: category, 
		post: post, 
		reply: reply, 
		subscription: subscription})
end

post "/manage/category/:id" do #doese the actual edit for category 
	to_edit = Category.find_by(id: params[:id])
	to_edit.name = params[:name]
	to_edit.descrip = params[:descrip]
	to_edit.score = params[:score]
	to_edit.save
	redirect "/manage"
end

post "/manage/post/:id" do #doese the actual edit for posts 
	to_edit = Post.find_by(id: params[:id])
	to_edit.parent_category_id = params[:parent_cat_id]
	to_edit.title = params[:title]
	to_edit.msg = params[:msg]
	to_edit.author = params[:author]
	to_edit.score = params[:score]
	to_edit.birth = params[:birth]	
	to_edit.death = params[:death]
	to_edit.url = params[:urladd]

	to_edit.save
	redirect "/manage"
end

post "/manage/reply/:id" do #doese the actual edit for replies 
	to_edit = Reply.find_by(id: params[:id])
	to_edit.parent_post_id = params[:parent_post_id]
	to_edit.author = params[:author]
	to_edit.msg = params[:msg]
	to_edit.score = params[:score]
	to_edit.birth = params[:birth]
	to_edit.save
	redirect "/manage"
end

post "/manage/sub/:id" do #doese the actual edit for subs 
	to_edit = Subscription.find_by(id: params[:id])
	to_edit.parent_post_id = params[:parent_post_id]
	to_edit.parent_category_id = params[:parent_cat_id]
	to_edit.contact_info = params[:contact_info]
	to_edit.save
	redirect "/manage"
end