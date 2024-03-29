//
//  Client.swift
//  On The Map
//
//  Created by RhaXiel on 10/7/22.
//

import Foundation

class APIClient {
    static let apiKey = "YOUR_API_KEY"
    
    struct Auth {
        static var sessionId = ""
        static var userKey = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocation(GetStudentLocationParams)
        case postStudentLocation
        case putStudentLocation(String)
        case postSession
        case deleteSession
        case getUser(String)
        
        var stringValue: String {
            switch self {
            case .getStudentLocation(let params): return Endpoints.base + "/StudentLocation" + paramBuilder(params: params)
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
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
        
        func paramBuilder(params: GetStudentLocationParams) -> String {
            if (params.uniqueKey == nil && params.limit == nil && params.order == nil && params.skip == nil ){
                return ""
            }
            var paramResult = "?" + ((params.limit != nil) ?  "limit="  + params.limit! + "&" : "") + ((params.skip != nil) ?  "skip="  + params.skip! + "&" : "") + ((params.order != nil) ?  "order="  + params.order! + "&" : "") + ((params.uniqueKey != nil) ?  "uniqueKey="  + params.uniqueKey! : "")
            
            return paramResult.hasSuffix("&") ? String(paramResult.dropLast()) : paramResult
        }
        
    }
    
    ///TODO: Make TaskForRequest a single method that receives customizations via parameters.
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
                let responseObject = try decoder.decode(ResponseType.self, from: fixData(data: data))
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                ///Account not found or invalid credentials
                do{
                    //{
                    //"status": 403,
                    //"error": "Account not found or invalid credentials."
                    //}
                    let errorObject : ErrorReponse = try decoder.decode(ErrorReponse.self, from: fixData(data: data))
                    let loginError: Error = LoginError.invalidCredentials(errorObject.error)
                    DispatchQueue.main.async {
                        completion(nil, loginError)
                    }
                } catch{
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
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
                let responseObject = try decoder.decode(ResponseType.self, from: fixData(data: data))
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
                let responseObject = try decoder.decode(ResponseType.self, from: fixData(data: data))
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
    
    class func fixData(data: Data) -> Data{
        let range = 5..<data.count
        let newData = data.subdata(in: range)
        return newData
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
                StudentsData.currentLocationId = response.objectId
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
                Auth.userKey = response.account.key
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func deleteSession(completion: @escaping (DeleteSessionResponse?, Error?) -> Void) {
        taskForDELETERequest(url: Endpoints.deleteSession.url, responseType: DeleteSessionResponse.self) { response, error in
            if let response = response {
                Auth.sessionId = ""
                Auth.userKey = ""
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getUser(userId: String, completion: @escaping (GetUserResponse?, Error?) -> Void) {
        taskForGETSkipRequest(url: Endpoints.getUser(userId).url, responseType: GetUserResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
