Hello hello. 

This is a small Sinatra web app to count word frequencies in a text. 

### Installation:
* clone the repository
* make sure to have the main stack components installed
  * ruby 2.2.0
  * postgresql
* create two databases, one for the web app, and the other for the tests
* navigate to the path of the repo
* run `bundle install`
* run `ruby startup.rb` and follow along

When the console wizard concludes, you'd have the web app running locally at 
`http://0.0.0.0:9292` 

### Endpoints:
* /words/count : parses the text and determines each word's frequency
  - POST
  - Parameter Name: **text** 
  - Parameter Value: **any string of english words only**
* /words/top : gets a list of most frequent words so far, default list length is 10
	- GET
	- Parameter Name: **limit** (optional)
	- Parameter Value: **number that denotes how many top words needed**
	- Returns: **JSON list of words and frequencies**
* /words/clear : resets all frequencies to zero
	- GET
	- No Parameters
	
### Tests:

To run tests, simply navigate to the directory of the repo and run `rspec` 


### TO-DO List:

* Account for special characters in the text
* Provide a simple view so text files could be uploaded
* Use caching
