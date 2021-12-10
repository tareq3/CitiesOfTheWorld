//
//  CitiesApiManager.swift
//  CitiesOfTheWorld
//
//  Created by One Bank Ltd on 7/12/21.
//

import Foundation
import Alamofire
import AlamofireURLCache5

enum DataResponseError : Error{
    case responseError
}
class CitiesApiManager{
    static let shared = CitiesApiManager()
    let sessionManager: Session = {
      let configuration = URLSessionConfiguration.af.default
      configuration.requestCachePolicy = .returnCacheDataElseLoad
      let responseCacher = ResponseCacher(behavior: .modify { _, response in
          let userInfo = ["date": Date().timeIntervalSince1970]
        return CachedURLResponse(
          response: response.response,
          data: response.data,
          userInfo: userInfo,
          storagePolicy: .allowed)
      })

      let networkLogger = AFNetworkLogger()
      let interceptor = AFRequestInterceptor()

      return Session(
        configuration: configuration,
        interceptor: interceptor,
        cachedResponseHandler: responseCacher,
        eventMonitors: [networkLogger])
    }()
    
    
    func fetchCities(page:Int, completion: @escaping (Result<Data,DataResponseError>) -> Void) {
        searchCities(page : page, include: "country", query: "ka", completion: completion)
    }
    
    
    func searchCities( page: Int,include :  String, query: String, completion: @escaping (Result<Data,DataResponseError>) -> Void) {
        sessionManager.request(CitiesRouter.searchCities(String(page), include, query))
        .responseDecodable(of: CitiesResponse.self) { response in
          guard let cities = response.value else {
              return completion(Result.failure(DataResponseError.responseError))
          }
            completion(Result.success((cities.data)!))
        }
    }
}
