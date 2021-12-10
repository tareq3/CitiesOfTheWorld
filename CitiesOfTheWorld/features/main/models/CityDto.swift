//
//  CityDto.swift
//  CitiesOfTheWorld
//
//  Created by Tareq on 10/12/21.
//

import Foundation
import RealmSwift

class CityDto : Object{
    @Persisted  var id : Int = 0
    @Persisted  var cityName : String
    @Persisted var countryName : String
    @Persisted  var lat : Double
    @Persisted  var lon : Double
    
    convenience init( _ cityName: String, _ countryName : String, _ lat : Double, _ lon : Double) {
      self.init()
      self.cityName = cityName
        self.countryName = countryName
        self.lat = lat
        self.lon = lon
    }
}

extension CityDto {
    static func all(in realm: Realm = try! Realm()) -> Results<CityDto> {
        return realm.objects(CityDto.self)
    }

    @discardableResult
    static func add(cityName: String, countryName : String, lat : Double, lon : Double, in realm: Realm = try! Realm())
      -> CityDto {
          let item = CityDto(cityName, countryName, lat, lon)
        try! realm.write {
          realm.add(item)
        }
        return item
    }

   

    func delete() {
      guard let realm = realm else { return }
      try! realm.write {
        realm.delete(self)
      }
    }
    
   

    func update(cityName: String, countryName : String,_ lat : Double, _ lon : Double) {
      guard let realm = realm else { return }
      try! realm.write {
        self.cityName = cityName
          self.countryName = countryName
          self.lon = lon
          self.lat = lat
      }
    }
}
