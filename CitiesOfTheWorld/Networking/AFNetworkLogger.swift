//
//  AFNetworkLogger.swift
//  CitiesOfTheWorld
//
//  Created by One Bank Ltd on 7/12/21.
//

import Foundation
import Alamofire
class AFNetworkLogger : EventMonitor{
    let queue = DispatchQueue(label: "com.raywenderlich.gitonfire.networklogger")

    func requestDidFinish(_ request: Request) {
      print(request.description)
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
      guard let data = response.data else {
        return
      }
      if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
        print(json)
      }
    }
}
