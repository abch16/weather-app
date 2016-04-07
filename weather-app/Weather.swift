//
//  Weather.swift
//  weather-app
//
//  Created by Abha Chandel on 4/5/16.
//  Copyright © 2016 Abha Chandel. All rights reserved.
//

import Foundation

import Alamofire

class Weather {

    private var _zipCode:String!
    
    private var _countryCode:String!
    
    private var _weatherUrl:String!
    
    private var _temparature:String!
    
    private var _humidity:String!
    
    private var _windSpeed:String!
    
    private var _weatherIcon:String!
    
    private var _description:String!
    
    private var _latitude : Double!
    
    private var _longitude : Double!
    
    private var _forecastUrl:String!
    
    
    private var _weatherFc = [WeatherFC]()
    
    

    var waetherFc : [WeatherFC] {
        
        return self._weatherFc
    }
    
    var latitude : Double  {
        
      get  {
            return _latitude
        }
    }
    
    
    
    var temparature : String {
        
        get {
            return _temparature
        }
    }
    
    
    var humidity : String {
        
        get {
            return _humidity + "%"
        }
    }
    var windSpeed : String {
        
        get {
            return _windSpeed
        }
    }
    
    var weatherIcon:String {
        
        get {
            
            return _weatherIcon
        }
    }
    
    
    init(zipCode:String ,countryCode : String,latitude:Double,longitude:Double) {
        
        self._zipCode = zipCode
        
        self._countryCode = countryCode
        
        self._latitude = latitude
        
        self._longitude = longitude
        
        self._weatherUrl = "\(URL_BASE)\(self._zipCode)\(SEP)\(self._countryCode)\(URL_UNITS)\(API_KEY)\(URL_METRIC)"
        
        self._forecastUrl = "\(FORECAST_URL)\(self.latitude)\(LON)\(self._longitude)\(URL_UNITS)\(API_KEY)\(URL_METRIC)"

    
    }
    
    func downloadWeatherData(completed:DownloadComplete){
    
        print(self._weatherUrl);
        
        let url = NSURL(string:self._weatherUrl)
        
        
        Alamofire.request(.GET, url!).responseJSON { (response:Response<AnyObject, NSError>) in
            
            print(response.result.value.debugDescription)
            
         if let dict = response.result.value as? Dictionary<String,AnyObject> {
            
            if let weatherDetl =  dict["weather"] as? [Dictionary<String, AnyObject>] where weatherDetl.count > 0 {
            
                if let icon = weatherDetl[0]["icon"] as? String {
                    self._weatherIcon = icon + ".png"
                }
                if let desc = weatherDetl[0]["description"] as? String {
                    self._description = desc
                }
            }
            else {
                
                self._weatherIcon = ""
                self._description = ""
            }
            
            if let weatherMain = dict["main"]  as? Dictionary<String,AnyObject> {
                
                if let tmp = weatherMain["temp"] as? Double {
                    self._temparature = NSString(format: "%.0f", tmp) as String
                }
                
                
                if let hum = weatherMain["humidity"] as? Double {
                    self._humidity = NSString(format: "%.0f", hum) as String
                    
                }
                
                
            } else {
                self._temparature = ""
                self._humidity = ""
            }
            
            if let wind = dict["wind"] as? Dictionary<String,AnyObject> {
                
                if let speed = wind["speed"] as? Double {
                    self._windSpeed = NSString(format: "%.0f", speed) as String
                    
                }
                
            }
            else{
                self._windSpeed = ""
            }
            
            
        
         }
            completed()
        }
        
    }

    func getNextForecastWeather(completed:ForecastCompleted) {
        
     print(self._forecastUrl);
        
        let url = NSURL(string:self._forecastUrl)
        
        Alamofire.request(.GET, url!).responseJSON { (response:Response<AnyObject, NSError>) in
    
            
        if let dict = response.result.value as? Dictionary<String,AnyObject> {
            
            if let lists = dict["list"] as? [Dictionary<String,AnyObject>] where lists.count > 0 {
                
                var x = 1
                
                repeat{
                    
                    
                    
                    let weatherfc = WeatherFC()
                    
                    if let dt = lists[x]["dt"] as? Double	 {
                        
                        let date = NSDate(timeIntervalSince1970: dt)
                        let dayFormatter = NSDateFormatter()
                        dayFormatter.dateFormat = "EE"
                        print(dayFormatter.stringFromDate(date))
                        weatherfc.day = dayFormatter.stringFromDate(date)
                        
                    }
                    
                    
                    
                    if let weatherMain = lists[x]["temp"]  as? Dictionary<String,AnyObject> {
                        
                        if let tmp = weatherMain["day"] as? Double {
                            weatherfc.dayTemp = NSString(format: "%.0f", tmp) as String
                        }
                        
                    }
                    
                    if let weatherDetl =  lists[x]["weather"] as? [Dictionary<String, AnyObject>] where weatherDetl.count > 0 {
                        
                        if let icon = weatherDetl[0]["icon"] as? String {
                            print(icon)
                            weatherfc.dayIcon = icon + ".png"
                            
                        }
                        
                    }
                    else {
                        
                        
                    }
                    
                    self._weatherFc.append(weatherfc);
                    x+=1

                
                } while x < 5
                
            }
            completed()
         }
                
    
        }
        
    /*    if let path = NSBundle.mainBundle().pathForResource("respose", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    
                    print(jsonResult.allValues.debugDescription)
                    if let lists = jsonResult["list"] as? [Dictionary<String,AnyObject>] where lists.count > 0 {
                        
                        var x=0
                        let prevDate :NSDate = NSDate()
                        
                        repeat{
                            
                            
                            if let dt = lists[x]["dt"] as? Double	 {
                                
                                let date = NSDate(timeIntervalSince1970: dt)
                                let dayFormatter = NSDateFormatter()
                                let dateFormatter = NSDateFormatter()
                                let timeFormatter = NSDateFormatter()
                                dayFormatter.dateFormat = "EEEE"
                                dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
                                timeFormatter.dateFormat = "h:mm a"
                                print(dayFormatter.stringFromDate(date))
                                print(dateFormatter.stringFromDate(date))
                                print(timeFormatter.stringFromDate(date))
                                
                                let dateComparisionResult: NSComparisonResult = NSCalendar.currentCalendar().compareDate(date, toDate: prevDate,toUnitGranularity:.Day)
                                
                                /* if dateComparisionResult == NSComparisonResult.OrderedSame
                                 {
                                 continue
                                 }*/
                                
                                
                                // prevDate = date
                                
                                
                            }
                            x=x+1

                        }while x < lists.count
                    }
                } catch {}
            } catch {}
        }*/

   /*     let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("respose", ofType: "json")
   
        do {
            let content = try String(contentsOfFile:path!, encoding: NSUTF8StringEncoding)
            
            
        let data = content.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String: AnyObject]
            
            if let lists = json["list"] as? [Dictionary<String,AnyObject>] where lists.count > 0 {

                
                
                
                
                var x=1
              //  var prevDate :NSDate
    
                repeat{
                    
                    let weatherfc = WeatherFC()
                
                    if let dt = lists[x]["dt"] as? Double	 {
                        
                        let date = NSDate(timeIntervalSince1970: dt)
                        let dayFormatter = NSDateFormatter()
                        dayFormatter.dateFormat = "EE"
                        print(dayFormatter.stringFromDate(date))
                        weatherfc.day = dayFormatter.stringFromDate(date)
  
                    }
                    
                    
                    
                    if let weatherMain = lists[x]["temp"]  as? Dictionary<String,AnyObject> {
                        
                        if let tmp = weatherMain["day"] as? Double {
                           weatherfc.dayTemp = NSString(format: "%.0f", tmp) as String
                        }
                        
                    }
                    
                    if let weatherDetl =  lists[x]["weather"] as? [Dictionary<String, AnyObject>] where weatherDetl.count > 0 {
                        
                        if let icon = weatherDetl[0]["icon"] as? String {
                            print(icon)
                           weatherfc.dayIcon = icon + ".png"
                        
                        }
                     
                    }
                    else {
                        
                        
                    }
                    
                    self._weatherFc.append(weatherfc);
                    x+=1
                    
                } while x < 5
                
              
            }
            completed()
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
        } catch _ as NSError {
            
        }*/
    
    }

}
