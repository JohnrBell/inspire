require 'active_record'

if ENV["DB_INFO"] 
	ActiveRecord::Base.establish_connection('postgresql://' + ENV["DB_INFO"]  + '@127.0.0.1/oohfancy')
	ActiveRecord::Base.logger = Logger.new(STDOUT)  
else
	ActiveRecord::Base.establish_connection({
	  :adapter => "postgresql",
	  :host => "localhost",
	  :username => "john",
	  :database => "inspire"
	  })
	  ActiveRecord::Base.logger = Logger.new(STDOUT)
end