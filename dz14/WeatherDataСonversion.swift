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
        
        self.temp = Int(rounded)
        self.humidity = humidity
        self.pressure = pressure
    }
}
