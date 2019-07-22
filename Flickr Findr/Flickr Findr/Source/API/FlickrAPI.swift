//
//  FlickrAPI.swift
//  Flickr Findr
//
//  Created by Dave Rogers on 7/21/19.
//  Copyright © 2019 Cemico Inc. All rights reserved.
//

import Foundation

protocol APIRequirements {

    // tags: comma delineated, default empty
    // exclusive: tags OR or AND, default OR
    // page to view, default 1
    func search(with tags: String,
                exclusive: Bool,
                page: Int,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void)

    // info on specific photo
    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void)

    // toying w/ idea of showing this at first launch
    // note: fully implemented
    func recent(completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void)
}

// add live implementation to be used as default
class APIService: APIRequirements {

    // search via tags
    func search(with tags: String = "",
                exclusive: Bool = false,
                page: Int = 1,
                completionHandler: @escaping (FlickrResults<FlickrSearch>) -> Void) {

        let isExclusive = exclusive ? APIEndpoints.ExclusiveValues.and.value : APIEndpoints.ExclusiveValues.or.value
        let page = "\(page)"
        APIEndpoints.search(tags, isExclusive, page).getData(value: FlickrSearch.self) { results in

            switch results {

            case .success(let model):
                print("success model \(type(of: model.self)):", model)

            case .failure(let error):
                print(error)
            }
        }
    }

    // specific photo info
    func photoInfo(id: String,
                   secret: String,
                   completionHandler: @escaping (FlickrResults<FlickrPhoto>) -> Void) {

    }

    // recently added
    func recent(completionHandler: @escaping (FlickrResults<FlickrRecent>) -> Void) {

    }
}

enum APIEndpoints {

    enum ExclusiveValues: String {

        // Note: not that these enums actually needed it, you can define values
        //       or funcs as reserved keyworks with the back-tick ... not the best
        //       practice in general, here okay, but done as exam demonstration item.
        case `or` = "any"
        case `and` = "all"

        // readablity accessor
        var value: String {

            return rawValue
        }
    }

    // could easily just use full string, below sets up for more flexibility
    private enum QueryParams {

        // nested enums and structs help categorize things
        private enum Keys: String {

            case method, format, tags, nojsoncallback, secret, page
            case apiKey = "api_key"
            case perPage = "per_page"
            case photoId = "photo_id"

            // per docs: "any" = OR, "all" = AND
            case exclusive = "tag_mode"
        }

        private enum Values: String {

            case format = "json"
            case perPage = "25"
            case nojsoncallback = "1"
            case searchMethod = "flickr.photos.search"
            case recentMethod = "flickr.photos.getRecent"
            case photoInfoMethod = "flickr.photos.getInfo"
        }

        // all non-user specific
        case search(String, String, String)
        case recent
        case photoInfo(String, String)

        var queryParams: [URLQueryItem] {

            // common items
            let apiKey = Bundle.InfoPlistKeys.CompanyChildKeys.flickrApiKey.value
            var params: [URLQueryItem] = [
                URLQueryItem(name: Keys.apiKey.rawValue, value: apiKey),
                URLQueryItem(name: Keys.format.rawValue, value: Values.format.rawValue),
                URLQueryItem(name: Keys.perPage.rawValue, value: Values.perPage.rawValue),
                URLQueryItem(name: Keys.nojsoncallback.rawValue, value: Values.nojsoncallback.rawValue)
            ]

            // specifics
            switch self {

            case .search(let tags, let exclusive, let page):
                params.append(URLQueryItem(name: Keys.method.rawValue, value: Values.searchMethod.rawValue))
                if !tags.isEmpty {

                    // per docs: comma-delimited list of tags
                    params.append(URLQueryItem(name: Keys.tags.rawValue, value: tags))
                }
                params.append(URLQueryItem(name: Keys.exclusive.rawValue, value: exclusive))
                params.append(URLQueryItem(name: Keys.page.rawValue, value: page))

            case .recent:
                params.append(URLQueryItem(name: Keys.method.rawValue, value: Values.recentMethod.rawValue))

            case .photoInfo(let photoId, let secret):
                params.append(URLQueryItem(name: Keys.method.rawValue, value: Values.photoInfoMethod.rawValue))
                params.append(URLQueryItem(name: Keys.photoId.rawValue, value: photoId))
                if !secret.isEmpty {

                    // per docs: optional
                    params.append(URLQueryItem(name: Keys.secret.rawValue, value: secret))
                }
            }

            return params
        }
    }

    // associated values enum
    case search(String, String, String)
    case recent
    case photoInfo(String, String)

    var url: URL? {

        // yes, a less common used "guard var" syntax
        let apiUrl = Bundle.InfoPlistKeys.CompanyChildKeys.flickrApiUrl.value
        guard var components = URLComponents(string: apiUrl) else { return nil }

        switch self {

        case .search(let tags, let exclusive, let page):
            components.queryItems = QueryParams.search(tags, exclusive, page).queryParams

        case .recent:
            components.queryItems = QueryParams.recent.queryParams

        case .photoInfo(let photoId, let secret):
            components.queryItems = QueryParams.photoInfo(photoId, secret).queryParams
        }
        
        return components.url
    }

    // common routine since all request have similar format, just vary by url
    //
    // compiler needs help to determine type, thus need for "value" property
    // ref: https://stackoverflow.com/questions/27965439/cannot-explicitly-specialize-a-generic-function
    func getData<T: Decodable>(value: T.Type, completionHandler: @escaping (FlickrResults<T>) -> Void) {

        typealias ResultType = T

        // setup url with comma delimited search tags
        guard let url = self.url else {

            completionHandler(FlickrResults<ResultType>.failure(from: .badURL))
            return
        }

        // common server call
        dataRequest(value: value, url: url, completionHandler: completionHandler)
    }

    private func dataRequest<T: Decodable>(value: T.Type, url: URL, completionHandler: @escaping (FlickrResults<T>) -> Void) {

        typealias ResultType = T
        print("url:", url.absoluteString)

        // get data
        URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in

            // 1 - check for request failed, i.e. internet or server issue / outside of server response error
            if let error = error {

                // response error
                completionHandler(FlickrResults<ResultType>.failure(from: error))
                return
            }

            // 2 - make sure data exists
            guard let data = data, data.count > 0 else {

                // no data
                completionHandler(FlickrResults<ResultType>.failure(from: .noData))
                return
            }

            // 3 - go for gusto and serialize data into working model
            do {

                let model = try JSONDecoder().decode(ResultType.self, from: data)

                // success - done
                completionHandler(FlickrResults<ResultType>.success(model))
                return
            }
            catch {

                print("Target online serialization failed:", error)

                // 4 - check for server response error, i.e. data contains error
                do {

                    let flickrError = try JSONDecoder().decode(FlickrError.self, from: data)

                    // "success" - serialized server resonse error
                    completionHandler(FlickrResults<ResultType>.failure(from: flickrError))
                    return
                }
                catch {

                    // as an aid for developers, take a stab at a typical server response, i.e. dictionary
                    // note: Any does not conform to Decodable, so have to go old school
                    // let json = try JSONDecoder().decode([String: Any], from: data)
                    do {

                        // old school, pre-swift 4 way to serialize response data
                        let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                        guard let results = json else { return }

                        // example of multiple prints on same line
                        print("Likely server data types have changed - update to match, ", terminator: "")
                        print("Physical results:", results)
                    }
                    catch { }
                }

                // catch-all
                completionHandler(FlickrResults<ResultType>.failure(from: .unknown))
            }
        }.resume()
    }
}
