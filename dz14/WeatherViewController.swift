import UIKit
import RealmSwift

class NowWeatherLabel: Object{
    @objc dynamic var nowText = ""
}

class WeatherDataRealm: Object {
    @objc dynamic var temp = ""
    @objc dynamic var humidity = ""
    @objc dynamic var pressure = ""
}

class WeatherViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nowTempLabel: UILabel!
    var cellNames: [String] = []
    var temp: [String] = []
    var humidity: [String] = []
    var pressure: [String] = []
    
    override func viewDidLoad() {
        tableView.reloadData()
        let nowWeatherData = realm.objects(NowWeatherLabel.self)
        
//        грузим текущую погодку
        switch nowWeatherData.count {
        case 0:
            WeatherLoader().loadWeather { weathery in
                self.loadLabelData(data: weathery)
            }
        default:
            for text in nowWeatherData.self{
            nowTempLabel.text = "\(text.nowText)"
            WeatherLoader().loadWeather { weathery in
                self.loadLabelData(data: weathery)
            }
            }
            try! realm.write{
                realm.delete(nowWeatherData)
            }
        }
//        if nowWeatherData.count == 0{
//            WeatherLoader().loadWeather { weathery in
//                self.loadLabelData(data: weathery)
//            }
//        } else {
//            for text in nowWeatherData.self{
//            nowTempLabel.text = "\(text.nowText)"
//            WeatherLoader().loadWeather { weathery in
//                self.loadLabelData(data: weathery)
//            }
//            }
//        }
//
//        for data in weatherData{
//            if data.temp == ""{
//                WeatherLoader().loadWeather { weathery in
//                    self.loaded(data: weathery)
//                    self.tableView.reloadData()
//                }
//            } else {
////                выгрузи из реалма в массивы
//                WeatherLoader().loadWeather { weathery in
//                    self.loaded(data: weathery)
//                    self.tableView.reloadData()
//                }
//            }
//        }
        
        WeatherLoader().loadWeather { weathery in
            self.loaded(data: weathery)
            self.tableView.reloadData()
        }
        
        cellNames.append("Через 3 часа:")
        cellNames.append("Завтра:")
        
        // ставим даты
        for i in 1...4 {
            let date = NSDate().addingTimeInterval(TimeInterval(86400 + (i * 86400)))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.YYYY"
            let formatteddate = formatter.string(from: date as Date)
            cellNames.append("\(formatteddate)")
        }
        
        super.viewDidLoad()
    }
    
    func loaded(data: [WeatherDataConversion]){
        
        self.temp.removeAll()
        self.humidity.removeAll()
        self.pressure.removeAll()
        
        for i in 1...data.count - 1{
            self.temp.append(String(data[i].temp))
            self.humidity.append(String(data[i].humidity))
            self.pressure.append(String(data[i].pressure))
            let weatherData = WeatherDataRealm()
            if weatherData.temp == ""{
            weatherData.temp = String(data[i].temp)
            weatherData.humidity = String(data[i].humidity)
            weatherData.pressure = String(data[i].pressure)
            try! realm.write{
                realm.add(weatherData)
            }
            } else {
            try! realm.write{
                realm.delete(weatherData)
            }
            }
        }
    }
    
    func loadLabelData(data: [WeatherDataConversion]){
        let nowLabelText = NowWeatherLabel()
        
        let date = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM HH:mm:ss"
        let formatteddate = formatter.string(from: date as Date)
            
        nowLabelText.nowText = """
            Сейчас:
            Температура: \(data[0].temp) °C
            Влажность: \(data[0].humidity) %
            Давление: \(data[0].pressure) мм рт. ст.
            Обновлено: \(formatteddate)
            """
        
        nowTempLabel.text = nowLabelText.nowText
        
        try! realm.write{
            realm.add(nowLabelText)
        }
        }
    }


extension WeatherViewController: UITableViewDataSource{
    
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cellNames.count
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        cell.nameLabel.text = cellNames[indexPath.row]
            let weatherData = realm.objects(WeatherDataRealm.self)
            switch weatherData.count {
            case 0:
                if self.temp.count == cellNames.count{
                cell.tempLabel.text = "\(self.temp[indexPath.row]) °C"
                cell.humidityLabel.text = "\(self.humidity[indexPath.row]) %"
                cell.pressureLabel.text = "\(self.pressure[indexPath.row]) мм рт. ст."
                }
            default:
                cell.tempLabel.text = "\(weatherData[indexPath.row].temp) °C"
                cell.humidityLabel.text = "\(weatherData[indexPath.row].humidity) %"
                cell.pressureLabel.text = "\(weatherData[indexPath.row].pressure) мм рт. ст."
                if self.temp.count == cellNames.count{
                cell.tempLabel.text = "\(self.temp[indexPath.row]) °C"
                cell.humidityLabel.text = "\(self.humidity[indexPath.row]) %"
                cell.pressureLabel.text = "\(self.pressure[indexPath.row]) мм рт. ст."
                }
                }
        return cell
}
}
