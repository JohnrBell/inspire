require "./category.rb"
require "./post.rb"
require "./reply.rb"
require "./subscription.rb"
require "./connection.rb"
require "active_record"

		CREATE TABLE categories(
		id serial primary key,
		name varchar (255),
		descrip text,
		score integer
		);

# Category.create(
# 	name: "Battlestations",
# 	descrip: "Photos of computer workstations, pc or mac, home, work or mobile.",
# 	score: '0')

# Category.create(
# 	name: "EDC",
# 	descrip: "Everyday Carry - What's in your pockets?",
# 	score: '0')

# Category.create(
# 	name: "BagDump",
# 	descrip: "What cool stuff do you carry around with you everyday?",
# 	score: '0')

		CREATE TABLE posts(
		id serial primary key,
		parent_category_id integer,
		title varchar(255),
		msg text,
		author varchar(255),
		score integer,
		birth varchar(255),
		death varchar(255),
		url text
		);

# Post.create(
# 	parent_category_id: '1',
# 	title: "Jim Bob's ",
# 	msg: "Jim Bob's Portfolio",
# 	author: "Mr Awesome",
# 	score: '0',
# 	birth: "2014-12-19T07:15:00+00:00",
# 	death: "",
# 	url: ""
# 	)

# Post.create(
# 	parent_category_id: '2',
# 	title: "Example JSON",
# 	msg: "Examples of JSON Code Chunks",
# 	author: "The Stig",
# 	score: '0',
# 	birth: "2014-12-19T07:15:00+00:00",
# 	death: "",
# 	url: ""
# 	)
# Post.create(
# 	parent_category_id: '1',
# 	title: "KultHouse",
# 	msg: "Jim Bob's Portfolio",
# 	author: "http://www.kult.house",
# 	score: '0',
# 	birth: "2014-12-19T07:15:00+00:00",
# 	death: "",
# 	url: ""
# 	)
# Post.create(
# 	parent_category_id: '1',
# 	title: "My workstation v2",
# 	msg: "This is my computer setup since swapping my desk",
# 	author: "StuTheHacker",
# 	score: '0',
# 	birth: "2014-12-18T07:15:00+00:00",
# 	death: ""
# 	)

# Post.create(
# 	parent_category_id: '2',
# 	title: "My Everday Items",
# 	msg: "Wallet gets swapped out pretty commonly...",
# 	author: "StuTheHacker",
# 	score: '0',
# 	birth: "2014-12-18T07:15:00+00:00",
# 	death: ""
# 	)

# Post.create(
# 	parent_category_id: '3',
# 	title: "My batered bag...",
# 	msg: "I could use a new bag itself, but the contents I can't be without...",
# 	author: "StuTheHacker",
# 	score: '0',
# 	birth: "2014-12-18T07:15:00+00:00",
# 	death: ""
# 	)

		CREATE TABLE replies(
		id serial primary key,
		parent_post_id integer,
		author varchar(255),
		msg text, 
		score integer,
		birth varchar(255)
		);

# Reply.create(
# 	parent_post_id: '1',
# 	author: "Alan Smith",
# 	msg: "Wow, what speakers are those?",
# 	score: '0',
# 	birth: "2014-12-18T09:35:00+00:00"
# 	)

# Reply.create(
# 	parent_post_id: '2',
# 	author: "Alan Smith",
# 	msg: "I like that knife!",
# 	score: '0',
# 	birth: "2014-12-18T09:35:00+00:00"
# )

# Reply.create(
# 	parent_post_id: '3',
# 	author: "Alan Smith",
# 	msg: "You should look at a Goruck bag!",
# 	score: '0',
# 	birth: "2014-12-18T09:35:00+00:00"
# )


		CREATE TABLE subscriptions(
		id serial primary key,
		parent_post_id integer,
		parent_category_id integer,
		contact_info varchar(255)
		);

# Subscription.create(
# 	parent_post_id: '',
# 	parent_category_id: '1',
# 	contact_info: "johnrbell@gmail.com"
# )
# Subscription.create(
# 	parent_post_id: '1',
# 	parent_category_id: '',
# 	contact_info: "+18484591420"
# )
# Subscription.create(
# 	parent_post_id: '2',
# 	parent_category_id: '',
# 	contact_info: "johnrbell@gmail.com"
# )

