# Bleacher Report Notes

## General
* I've added detailed comments to help the review w/ my thought process - comments inline
* top level process
> [begin saturday]: late at night
> read assignment, read flickr docs
> test flickr api via browser
> create this accounting
> create github repo, base xcode app
> create icon :)
> add mock, add model classes first pass, test api
> [end saturday]
> [begin sunday]:

## Log (general accounting of time and progress to help reviewer)
[Saturday July 20]
* @start / afternoon, opened task, read scope of exercise
* @late night, set down at desk, started to think / early design formulations 
> read flickr docs, did some test api calls via browser to get a feel for the scope of the assignment
- search
- details
- error
> created git repo
> note: wife sick, time intermixed w/ her
> had fun w/ icon composite of companies
> began thinking of testability
- created shell app w/ hooks for unit testing w/ only path for testing
- created model classes for results from above flickr browser runs
- created simple add fail scenarios (add)
- added offline datasets from above browser data, validated tests
- added network layer to code w/ hooks to run live or mock
- ran live through same mock offline tests, same results
: early validation of model classes
: early validation of network mockability
> setup app to use network layer and model classes to display one fixed image
- validate url content
* @end / good stopping point, work on UI Sunday.

[Sunday July 21]
* 

## [API browser runs]
* [search]: https://www.flickr.com/services/api/flickr.photos.search.html
* [details]: https://www.flickr.com/services/api/flickr.photos.getInfo.html
* [recent]: https://www.flickr.com/services/api/flickr.photos.getRecent.html
* [popular]: https://www.flickr.com/services/api/flickr.photos.getPopular.html

## search
* https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&tags=flower
* https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&tags=flower+green
* https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=1508443e49213ff84d566777dc211f2a&format=json&per_page=25&tags=flower+green
* results (few lines rest chopped): {"photos":{"page":1,"pages":2,"perpage":25,"total":"50","photo":[{"id":"31193961378","owner":"76645795@N05","secret":"64a3cbe9f8","server":"1943","farm":2,"title":"Simply white flower in green...","ispublic":1,"isfriend":0,"isfamily":0},{"id":"27068539368","owner":"65053702@N00","secret":"75bcd7b6bf","server":"4779","farm":5,"title":"Pansy","ispublic":1,"isfriend":0,"isfamily":0},{"id":"29792250665","owner":"139259445@N07","secret":"ca5ec80d0b","server":"8543","farm":9,"title":"20160918-122410-P1380556.jpg","ispublic":1,"isfriend":0,"isfamily":0}, … to end … ]},"stat":"ok"}

## details
* https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=1508443e49213ff84d566777dc211f2a&photo_id=24379963431&secret=027546fe5d&format=json
* results: {"photo":{"id":"24379963431","secret":"027546fe5d","server":"1516","farm":2,"dateuploaded":"1453135407","isfavorite":0,"license":"0","safety_level":"0","rotation":0,"originalsecret":"2e20c21fd2","originalformat":"jpg","owner":{"nsid":"139259445@N07","username":"kenichi.fukuma","realname":"Kenichi Fukuma","location":"","iconserver":"4377","iconfarm":5,"path_alias":null},"title":{"_content":"P1650469.jpg"},"description":{"_content":""},"visibility":{"ispublic":1,"isfriend":0,"isfamily":0},"dates":{"posted":"1453135407","taken":"2015-12-16 10:18:54","takengranularity":"0","takenunknown":"0","lastupdate":"1454217191"},"views":"15","editability":{"cancomment":0,"canaddmeta":0},"publiceditability":{"cancomment":1,"canaddmeta":1},"usage":{"candownload":1,"canblog":0,"canprint":0,"canshare":1},"comments":{"_content":"0"},"notes":{"note":[]},"people":{"haspeople":0},"tags":{"tag":[{"id":"139238115-24379963431-63835889","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"\u98a8\u666f\u30fb\u30b9\u30ca\u30c3\u30d7","_content":"\u98a8\u666f\u30fb\u30b9\u30ca\u30c3\u30d7","machine_tag":0},{"id":"139238115-24379963431-280003176","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"\u4e3b\u306a\u30ad\u30fc\u30ef\u30fc\u30c9","_content":"\u4e3b\u306a\u30ad\u30fc\u30ef\u30fc\u30c9","machine_tag":0},{"id":"139238115-24379963431-990604","author":"139259445@N07","authorname":"kenichi.fukuma","raw":"Flower\/Green","_content":"flowergreen","machine_tag":0}]},"urls":{"url":[{"type":"photopage","_content":"https:\/\/www.flickr.com\/photos\/139259445@N07\/24379963431\/"}]},"media":"photo"},"stat":"ok"}
> url: https://www.flickr.com/photos/139259445@N07/24379963431/

## error(cut off some of api key)
* https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=1508443e49213ff84d566777dc211f2&photo_id=24379963431&secret=027546fe5d&format=json
* results: jsonFlickrApi({"stat":"fail","code":100,"message":"Invalid API Key (Key has invalid format)"})

## valid w/ no results
* results: jsonFlickrApi({"photos":{"page":1,"pages":0,"perpage":100,"total":"0","photo":[]},"stat":"ok"})
