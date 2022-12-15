import Foundation

class WeatherDataConversion{
    var temp: Int
    var humidity: Int
    var pressure: Int
    
    init?(data: NSDictionary){
        guard let temp = data["temp"] as? Double, let humidity = data["humidity"] as? Int, let pressure = data["pressure"] as? Int else {
            return nil
        }
        let tempC = temp - 273.15
        let numberOfPlaces = 0.0
        let multiplier = pow(10.0, numberOfPlaces)
        let rounded = round(tempC * multiplier) / multiplier
        
//        self.dt_txt = dt_txt
//        print("Полученная температура - \(temp)K, \(Int(rounded))°C")
//        self.sunrise = sunrise
        self.temp = Int(rounded)
        self.humidity = humidity
        self.pressure = pressure
//        print("Давление - \(pressure)мм.рт")
//        print("Влажность - \(humidity)%")
    }
}
