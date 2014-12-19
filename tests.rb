get '/test/category_manip' do
	posts = Post.all.entries
	msg_array=[]
	posts.each do |post|
		msg_array.push(post.msg)
	end
	url_to_gsub = msg_array[2].scan(/(http.*(jpg|gif|png|jpeg)\Z)/)
	url_to_gsub = url_to_gsub[0][0]
	url_to_gsub = "<img src=#{url_to_gsub} width=250px>"
	"#{url_to_gsub}"
end