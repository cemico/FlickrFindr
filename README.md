# Bleacher Report Notes

## Environment
• Friday, Jully 26, 2019
• Xcode 10.3 (dropped 4 days back) / Swift 5 (compiles fine under 4.2)

## Effort
Began Saturday night, 10pm, today is Friday day noon'ish, did the day job during the week,
worked when during the slots withing the days.  I left off on unit tests - setup an entire 
framework, ran out of time, leaving town soon for weekend in Oregon.  There is full mocking
in place, somewhat tested, but no actual unit nor ui tests written.
Note: I wrote all the code from scratch, minus a few extensions which I had previously 
written - pretty sure I notated that within code as well.  No 3rd party libraries were included,
which would not be the case if I was doing it under non-exam environment, for example,
the image cache I rolled would be much better served by one of the many libraries out there.
I've used Haneke before, and it worked great.
Note: overall the app is pretty simple, touches on a number of areas, was done quicly with
decisions made to highlight various techniques and such.  lots of comments were added
inline to describe some decision points, logic, etc.  I also went w/ the approach of showing
more foundational things, like all the testing / mocking paths, versus writing a bunch of 
actual simple unit tests, say to test a model ... these are important, but very basic versus
more design level adds.
Note: the app should give a *lot* of material for reviewers to ask questions ;)  

## Highlights
Highlights on what was done, as best I can remember ;)

### API / Network Layer
• APIProtocol defines the interface for the API, which includes a "recent" api, fully functional and used
• Two concrete implementations conform to the protocol, live and mock.
• Mock is driven off command line arguments
• Live is the default and pulls it's API Key via the project user defines being pulled into info.plist at build time, stored in "company" folder w/ extesion for easy access.  This is pretty common, either this way or via xcconfig files allowing different values or different build types / schemes.
• Mock further defines a data source protocol with two derivations, bundle/file based json text, and other is the ability to direcctly inject in valid model class objects.  The latter is very convenient for unit testing ... which I ran out of time to complete an example.
• Every call has a model "class" (i.e. a struct in this case) using the swift 4 style of class serialization.  Most models contain other sub-models.  customer descriptions are added for easier output reading.
• I handle errors gracefully - if an image has an issue downloading, I remove it from the list.  you can see the collection reorder every now and then, and a message in the log when flickr returns their 1003 message.
• when data is returned and modelled, I update the local storage in a thread-safe manner, so you'll see a few spots with locking techiques around them.
• There are a handful of test files bundled, for rapid testing of known results.  each screen has a pass and fail variant. 

### Storage
• I used the user defaults for live local storage, but like the API service, I extrapolated a protocol at the base, and the app uses the user defaults as it's derived implemetation.  This was done so an injected replacement could be used during testing, if so desired.

### UI
• Two screens, main collection grid and a details page.  I wanted to demonstrate both storyboard and nib files, so main screen is storyboard, and details is nib (with injected depencencies for encapsulation).  Technically there's the launch storyboard, not much there.   
• Nav + home -> details structure
• Search / home page has the search bar at top, customized in both color, text, and options, collection, and a "current status" type bar separating the two showing what you are currently viewing.
• I pull the recently uploaded photos on first launch to give user something to view
• Refresh button on top/right will restart the last operation, i.e. if viewing recent photos, will do a clean pull of first uploads again, and if looking at a search results page, will re-submit the same tags on a clean pull of 25 first results
• The status area tracks which "page" you're on by a physical count of images shown vs the total reported
• I went with the infinite scroll style versus present the user with an action item / button to pull more.  when the user hits the last cell, minus optional buffer value, it'll fire off the next page request.  when this happens, there is a custom view / status bar which appears at the bottom letting the user know what is going on, which also contains simple animation on the text.  when the load is done, the bar fades out.  the collection is live during this time, so depending on your connection, results can pop in pretty quickly.
• I use two caches, one for the thumbnails (which contain the image and text at bottom overlayed) and one for the bigger detail images.  the latter is constrained by  size, and the thumbnails is constrained by count.  it works pretty well with similar searches and up/dn scrolling.  the log window puts an "o" if it is fetched online, and a "c" if fetched from cache ... in case you were wondering what all those weird letters were ;)  
• I emplore another simple cache on the url requests to manage the cell reuse states when returning async data.  this queue only grows to the size of the number of cells the system reuses, and you'll find that in the logs too.
• when I fetch a new page, there is always the possibility that more images were added since the previous, and some of the items on the previous page are pushed down and returned on the next page.  I added some logic to detect and remove dups - you'll see that in the logs as well.
• the cell has a "loading" state image, then the actual image or an error image when completed.  the error images are hard to see, as I remove them from the list on error...
• I extended UIImageView to do the async image download, outside of the assignment, would handle the caching better versus the localized files above the class extesion.
• I went w/ the dark theme, as that typically accentuates images.  I also added a used partial alpha views in places, such as the light border around each cell and in some of the text overlays.
• Note: added image ID on details page bottom for validation of unique image if you see dups ... as valid cases exist for dups, such as same or different user(s) posting same image

### Bugs
• Only one known bug ... see if you can spot it ;)  

## Direction
Where I left off: as mentioned above, wanted to finish off a handful of test cases demonstrating
the framework.  I was also thinking of a settings page to drive a few configurable items, such
as number of items per page, or number of imagess across a device, etc.  Everything is
encapsulated for this.  The history is also saved in this LocalStorage area, and the search
bar was expanded to allow a History display, but didn't get to writing up a table to display
and track / push a selection through.  Some of the photos out there are pretty nice - thought
it might also be nice to add a Share button ... 
Two bigger hit items which would be nice are on the details page.  first, setting it up to support
pinch and zoom on the image, and secondly, to support left/right swiping via a page control or 
another single image collection. 


## The Ask
Create an iOS app that displays photos returned from the Flickr search API. This can be written
in either Objective-C or Swift. Code should be stored in online accessible version control (such
as GitHub). On completion, email a link to the online version control project to
exercise@bleacherreport.com. The project should compile in the latest version of Xcode.

## Funcional Requirements
Provide an interface for inputting search terms
• Display 25 results for the given search term, including a thumbnail of the image and the title
• Selecting a thumbnail or title displays the full photo
• Provide a way to return to the search results
• Provide a way to search for another term

## [API browser runs]
• [reference]: Flickr API Docs: https://www.flickr.com/services/api/
• [search]: https://www.flickr.com/services/api/flickr.photos.search.html
• [details]: https://www.flickr.com/services/api/flickr.photos.getInfo.html
• [recent]: https://www.flickr.com/services/api/flickr.photos.getRecent.html
• [popular]: https://www.flickr.com/services/api/flickr.photos.getPopular.html

## Search
• https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&tags=flower
•  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&tags=flower+green
•  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&per_page=25&tags=flower+green
•  results (few lines rest chopped): {"photos":{"page":1,"pages":2,"perpage":25,"total":"50","photo":[{"id":"31193961378","owner":"76645795@N05","secret":"64a3cbe9f8","server":"1943","farm":2,"title":"Simply white flower in green...","ispublic":1,"isfriend":0,"isfamily":0},{"id":"27068539368","owner":"65053702@N00","secret":"75bcd7b6bf","server":"4779","farm":5,"title":"Pansy","ispublic":1,"isfriend":0,"isfamily":0},{"id":"29792250665","owner":"139259445@N07","secret":"ca5ec80d0b","server":"8543","farm":9,"title":"20160918-122410-P1380556.jpg","ispublic":1,"isfriend":0,"isfamily":0}, … to end … ]},"stat":"ok"}

## Details
•  https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=1508443e49213ff84d566777dc211f2a&photo_id=24379963431&secret=027546fe5d&format=json
•  results: {"photo":{"id":"24379963431","secret":"027546fe5d","server":"1516","farm":2,"dateuploaded":"1453135407","isfavorite":0,"license":"0","safety_level":"0","rotation":0,"originalsecret":"2e20c21fd2","originalformat":"jpg","owner":{"nsid":"139259445@N07","username":"kenichi.fukuma","realname":"Kenichi Fukuma","location":"","iconserver":"4377","iconfarm":5,"path_alias":null},"title":{"_content":"P1650469.jpg"},"description":{"_content":""},"visibility":{"ispublic":1,"isfriend":0,"isfamily":0},"dates":{"posted":"1453135407","taken":"2015-12-16 10:18:54","takengranularity":"0","takenunknown":"0","lastupdate":"1454217191"},"views":"15","editability":{"cancomment":0,"canaddmeta":0},"publiceditability":{"cancomment":1,"canaddmeta":1},"usage":{"candownload":1,"canblog":0,"canprint":0,"canshare":1},"comments":{"_content":"0"},"notes":{"note":[]},"people":{"haspeople":0},"tags":{"tag":[{"id":"139238115-24379963431-63835889","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"\u98a8\u666f\u30fb\u30b9\u30ca\u30c3\u30d7","_content":"\u98a8\u666f\u30fb\u30b9\u30ca\u30c3\u30d7","machine_tag":0},{"id":"139238115-24379963431-280003176","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"\u4e3b\u306a\u30ad\u30fc\u30ef\u30fc\u30c9","_content":"\u4e3b\u306a\u30ad\u30fc\u30ef\u30fc\u30c9","machine_tag":0},{"id":"139238115-24379963431-990604","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"Flower\/Green","_content":"flowergreen","machine_tag":0}]},"urls":{"url":[{"type":"photopage","_content":"https:\/\/www.flickr.com\/photos\/139259445@N07\/24379963431\/"}]},"media":"photo"},"stat":"ok"}
> url: https://www.flickr.com/photos/139259445@N07/24379963431/

## Error(cut off some of api key)
•  https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=1508443e49213ff84d566777dc211f2&photo_id=24379963431&secret=027546fe5d&format=json
•  results: jsonFlickrApi({"stat":"fail","code":100,"message":"Invalid API Key (Key has invalid format)"})

## Valid w/ no results
•  results: jsonFlickrApi({"photos":{"page":1,"pages":0,"perpage":100,"total":"0","photo":[]},"stat":"ok"})
