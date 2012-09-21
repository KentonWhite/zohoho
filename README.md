# Zohoho [![Build Status](https://secure.travis-ci.org/KentonWhite/zohoho.png)](http://travis-ci.org/nolastan/zohoho)
## Usage

For new users, retrieve a token:
	
	@auth_token = Zohoho::Crm.generate_token("username", "password")
	
This token will be used for all future calls for this user.  The token has no expiration date.

Then to access Zoho:

	@crm = Zohoho::Crm.new(@auth_token_) 
	record = @crm.add_contact "Stephen Colbert"
	
Current only the CRM is added to this gem.  Other API endpoints should be easy to add and are welcomed!

## Contributing to zohoho
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 KentonWhite. See LICENSE.txt for
further details.

