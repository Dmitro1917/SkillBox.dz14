import Foundation

class WeatherLoader{
    
    func loadWeather(complition: @escaping ([WeatherDataConversion]) -> Void){
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?id=524901&APPID=b6e0eee32bb0424c918f6175ff399463")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments), let jsonDict = json as? NSDictionary{
                let jsoon = jsonDict["list"] as? NSArray
                let jsn = jsoon![1] as? NSDictionary
                let jsn2 = jsoon![2] as? NSDictionary
                let jsn3 = jsoon![3] as? NSDictionary
                let jsn4 = jsoon![4] as? NSDictionary
                let jsn5 = jsoon![5] as? NSDictionary
                let jsn6 = jsoon![6] as? NSDictionary
                let jsn7 = jsoon![7] as? NSDictionary
                var weather: [WeatherDataConversion] = []
                for (_, data) in jsn! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn2! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn3! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn4! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn5! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn6! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                for (_, data) in jsn7! where data is NSDictionary{
                    if let weathery = WeatherDataConversion(data: data as! NSDictionary) { weather.append(weathery) }
                }
                DispatchQueue.main.async {
                    complition(weather)
                }
            }
        }
task.resume()
    }
}
