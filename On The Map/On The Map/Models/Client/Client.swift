//
//  Client.swift
//  On The Map
//
//  Created by RhaXiel on 10/7/22.
//

import Foundation

class APIClient {
    static let apiKey = "58d2d637cbe360499625978f4930b693"//"YOUR_TMDB_API_KEY"
    
    struct Auth {
        //static var accountId = 0
        //static var requestToken = ""
        static var sessionId = ""
    }
    
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        //static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getStudentLocation(GetStudentLocationParams)
        case postStudentLocation
        case putStudentLocation(String)
        case postSession
        case deleteSession
        case getUser(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocation(let params): return Endpoints.base + "/StudentLocation/?" + ((params.limit != nil) ?  "&"  + params.limit! : "") + ((params.skip != nil) ?  "&"  + params.skip! : "") + ((params.order != nil) ?  "&-"  + params.order! : "") + ((params.uniqueKey != nil) ?  "&"  + params.uniqueKey! : "")
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation/"
            case .putStudentLocation(let objectId):
                return Endpoints.base + "/StudentLocation/" + objectId
            case .postSession:
                return Endpoints.base + "/session"
            case .deleteSession:
                return Endpoints.base + "/session"
            case .getUser(let userId):
                return Endpoints.base + "/users/" + userId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTSessionRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data */
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForDELETERequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForGETSkipRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let range = (5..<data.count)
                let newData = data.subdata(in: range)
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    
    class func getStudentLocation(limit: String?, skip: String?, order: String?, uniqueKey: String? , completion: @escaping ([StudentLocation], Error?) -> Void) {
        
        let params = GetStudentLocationParams(limit: limit, skip: skip, order: order, uniqueKey: uniqueKey)
        
        taskForGETRequest(url: Endpoints.getStudentLocation(params).url, responseType: StudentLocationResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudenLocation(firstName: String, lastName: String, latitude: Float, longitude: Float, mapString: String, mediaURL: String, uniqueKey: String, completion: @escaping (CreatedStudentLocationResponse?, Error?) -> Void) {
        
        let body = PostStudentLocationRequests(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: uniqueKey)
        
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: CreatedStudentLocationResponse.self, body: body) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func putStudentLocation(firstName: String, lastName: String, latitude: Float, longitude: Float, mapString: String, mediaURL: String, uniqueKey: String , objectId: String, completion: @escaping (UpdatedStudentLocationResponse?, Error?) -> Void) {
        let body = UpdateLocationRequest(firstName: firstName, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: uniqueKey)
        taskForPUTRequest(url: Endpoints.putStudentLocation(objectId).url, responseType: UpdatedStudentLocationResponse.self, body: body) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func postSession(username: String, password: String, completion: @escaping (PostSessionResponse?, Error?) -> Void) {
        let body = PostSessionRequest(udacity: Udacity(username: username, password: password))
        taskForPOSTSessionRequest(url: Endpoints.postSession.url, responseType: PostSessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func deleteSession(username: String, password: String, completion: @escaping (DeleteSessionResponse?, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.deleteSession.url, responseType: DeleteSessionResponse.self) { response, error in
            if let response = response {
                Auth.sessionId = ""
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUser(userId: String, completion: @escaping (GetUserReponse?, Error?) -> Void) {
        taskForGETSkipRequest(url: Endpoints.getUser(userId).url, responseType: GetUserReponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    /*
     class func createSessionId(completion: @escaping (Bool, Error?) -> Void) {
     let body = PostSession(requestToken: Auth.requestToken)
     taskForPOSTRequest(url: Endpoints.createSessionId.url, responseType: SessionResponse.self, body: body) { response, error in
     if let response = response {
     Auth.sessionId = response.sessionId
     completion(true, nil)
     } else {
     completion(false, nil)
     }
     }
     }
     
     class func logout(completion: @escaping () -> Void) {
     var request = URLRequest(url: Endpoints.logout.url)
     request.httpMethod = "DELETE"
     let body = LogoutRequest(sessionId: Auth.sessionId)
     request.httpBody = try! JSONEncoder().encode(body)
     request.addValue("application/json", forHTTPHeaderField: "Content-Type")
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
     Auth.requestToken = ""
     Auth.sessionId = ""
     completion()
     }
     task.resume()
     }
     
     class func search(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionDataTask {
     let task = taskForGETRequest(url: Endpoints.search(query).url, responseType: MovieResults.self) { response, error in
     if let response = response {
     completion(response.results, nil)
     } else {
     completion([], error)
     }
     }
     return task
     }
     
     class func markWatchlist(movieId: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
     let body = MarkWatchlist(mediaType: "movie", mediaId: movieId, watchlist: watchlist)
     taskForPOSTRequest(url: Endpoints.markWatchlist.url, responseType: TMDBResponse.self, body: body) { response, error in
     if let response = response {
     // separate codes are used for posting, deleting, and updating a response
     // all are considered "successful"
     completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
     } else {
     completion(false, nil)
     }
     }
     }
     
     class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
     let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
     taskForPOSTRequest(url: Endpoints.markFavorite.url, responseType: TMDBResponse.self, body: body) { response, error in
     if let response = response {
     completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
     } else {
     completion(false, nil)
     }
     }
     }
     
     class func downloadPosterImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
     let task = URLSession.shared.dataTask(with: Endpoints.posterImage(path).url) { data, response, error in
     DispatchQueue.main.async {
     completion(data, error)
     }
     }
     task.resume()
     }
     
     */
}
