# AUTHENTICATE FIRST found in examples/authenticate.rb

# client is a LinkedIn::Client

# find details about a company; Defaults: start=0, count=10
client.company({:id => 60283, :start => 0, :count => 10})

# get company updates: 
# event_type=job-posting|new-hire|position-change|profile-change|new-product|status-update
client.company({:id => 60283, :event_type => 'status-update', :start => 0, :count => 10})

# search for companies by keywords
client.company_search({:keywords => 'Neev'})

# get list of suggested companies to follow
client.suggested_companies

# follow a company
client.follow_company(60283)

# unfollow a company
client.unfollow_company(60283)

# get company products and recommendations; Defaults: start=0, count=10
client.company_products({:id => 60283, :start => 0, :count => 10})
