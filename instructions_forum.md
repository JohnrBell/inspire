## Forum

---

A forum is an application that allows users to both post information and to comment on other's posts, or tag the other posts with metadata. One of the most important functions of forums is to allow "voting" on content to determine it's popularity.

###***MVP***

- **Data Model**:
  - `category`
  - `post`
  - `comment`
  - `subscriber`
  - A `category` can have many `posts`, but a `post` belongs to only one `category`
  - Similiarly, A `post` can have many `comments`, but a `comment` belong to only one `post`
- **Required technologies or features**:
  - [Twilio](https://www.twilio.com/docs/api)
    - Allows an application to send text messages to any phone number
  - [SendGrid](https://sendgrid.com/docs/index.html)
    - Allows an application to send emails
- **Example Ideas**:
  - schedule student get-togethers and topics, vote on them
  - create a reddit like site for wdi life
- **User Stories (MVP)**:
  - A user can create a new *category* and add a description to it (think subreddits on reddit)
  - A user can create a new forum post in a given category (`/categories/category-name/posts/new`)
  - A user can delete a category if there are no posts associated with it
  - A user can show (ie, see) a given forum post
  - A user can see all of the forum's posts as a *feed*, up to a maximum of ten (`/posts`)
  - A user can browse successive pages of ten posts each, until the beginning of the feed (`/posts?id=id-of-first-post`)
  - A user can write a forum post as markdown and have it rendered as HTML
  - A user can browse forum posts by category
  - A user can "upvote" a forum post
  - A user can "upvote" a category
  - A user can see the "vote totals" of a given forum post or category
  - A user can "downvote" a forum post or category
  - A user can add a time-to-live to a forum post, so that it expires after a given period
  - A user can see, but not interact with, an expired post
  - A user can subscribe to a category or post and receive updates to it via text or email (using Twilio/Sendgrid)

###***Bonus***

- **Additional Data Models**
  - `author`
- **Further User Stories**:
  - A user can browse categories ordered by votes or ordered by number of posts
  - A user can browse posts ordered by votes or ordered by number of comments
  - A user can "upvote" a comment
  - A user can see the "vote totals" of a given comment
  - A user can "downvote" a comment
  - A user can browse comments as ordered by votes
  - A user can specify an author when creating a post by creating a new author or choosing a pre-existing one from a drop-down menu
  - A user can view posts by author (`authors/authorhandle/posts`)
  - A user can view posts by tag (`tag/tagname/posts`)
  - A user can reference an existing post in a new post by using the syntax [[post-title]]. This will automatically create a hyperlink for that referenced post.
  - A user can write a post that is "sticky" (stays at the top of the feed, or after a previously stuck post) and has a "life" (in seconds, the time until it becomes "unstuck") of up to two weeks
- **JSON Activity Streams and/or Request Response**
  - [Activity Streams](http://en.wikipedia.org/wiki/Activity_Streams_(format)) are complex feeds that explain what is happening on your site. Your AS feed would be served from the endpoint `/as` and would record all the posting activity on the forum. This sort of feed could be generated using a gem, [for example](https://github.com/nov/activitystreams)
  - Alternatively, you can offer up a JSON representation of a single post at the endpoint `/as/post-id` -- a much simpler option.
  - Or you can do both!
  - To get Sinatra to form responses in JSON format rather than HTML, check out this [tutorial](http://nathanhoad.net/how-to-return-json-from-sinatra)
- **Implement responsive web design to your application**
  - [What the heck is responsive web design?](http://johnpolacek.github.io/scrolldeck.js/decks/responsive/)
