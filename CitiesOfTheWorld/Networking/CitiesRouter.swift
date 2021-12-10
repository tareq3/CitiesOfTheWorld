//
//  CitiesRouter.swift
//  CitiesOfTheWorld
//
//  Created by One Bank Ltd on 7/12/21.
//

import Foundation
import Alamofire

enum CitiesRouter{
    case fetchCities(String)
    
    case searchCities(String ,String, String )
    
    
    var baseURL : String{
        switch self {
        case . fetchCities, .searchCities :
            return "http://connect-demo.mobile1.io/square1/connect"
        }
    }
    
    var path: String {
        switch self {
        case .fetchCities, .searchCities:
            return "/v1/city"
        
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCities:
            return    .get
        case .searchCities:
            return    .get
        }
    }
    

    var parameters : [String : String]? {
        switch self {
        case .fetchCities(let page):
            return ["page" :   page]
        case .searchCities(let page, let include, let q):
            return ["page" :   page, "include" : include, "filter[0][name][contains]" : q]
        }
    }
        
        
}

extension CitiesRouter : URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL().appendingPathComponent(path)
        var request  = URLRequest(url: url)
        request.method = method
        if method == .get {
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }else if method == .post {
            request = try JSONParameterEncoder().encode(parameters, into: request)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        return request
    }
}
