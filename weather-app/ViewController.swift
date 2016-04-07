//
//  ViewController.swift
//  weather-app
//
//  Created by Abha Chandel on 4/4/16.
//  Copyright © 2016 Abha Chandel. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{
    
    
    
    @IBOutlet weak var locationLbl: UILabel!
    
    @IBOutlet weak var tempLbl: UILabel!
    
    
    @IBOutlet weak var windSpeed: UILabel!
    
    @IBOutlet weak var humiditylbl: UILabel!
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var dayOne : UILabel!
    
    @IBOutlet weak var dayOneIcon : UIImageView!
    
    @IBOutlet weak var dayOneTemp : UILabel!
    
    
    @IBOutlet weak var dayTwoLbl: UILabel!

    @IBOutlet weak var dayTwoIcon: UIImageView!
    
    
    @IBOutlet weak var dayTwoTemp: UILabel!
    
    
    @IBOutlet weak var dayThreeLbl: UILabel!
    
    
    @IBOutlet weak var dayThreeIcon: UIImageView!
    
    
    @IBOutlet weak var dayThreeTemp: UILabel!
    
    
    @IBOutlet weak var dayFourLbl: UILabel!
    
    
    @IBOutlet weak var dayFourIcon: UIImageView!
    
    
    @IBOutlet weak var dayFourTemp: UILabel!
    
    
    var weather:Weather!
    
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
 
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationAuthStatus()
        
        super.viewDidLoad()
        
    }


    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            
            locationManager.requestLocation()
            
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // get current location andd weather
            let geoCoder = CLGeocoder()
        
            
             geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error)  in
                
                // Place details
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                
                // Address dictionary
               // print(placeMark.addressDictionary)
                
         
                let city = placeMark.addressDictionary!["City"] as? String //{

                let zip = placeMark.addressDictionary!["ZIP"] as? String //{
           

                let countryCode = placeMark.addressDictionary!["CountryCode"] as? String //{
            
          
          
                self.locationLbl.text = city! + "," + countryCode!
                
                let latitude = location.coordinate.latitude as Double
                
                let longitude = location.coordinate.longitude as Double
                
                self.weather = Weather(zipCode:zip!,countryCode:countryCode!,latitude: latitude,longitude:longitude)
                
            
             
                
               self.weather.downloadWeatherData()  { () -> () in
                 
                  self.updadeUI()
                } 
                
                
                   // get next days forecast
                
                
                self.weather.getNextForecastWeather(){ () -> () in
                
                   print("get next days data")
                   self.updateNextFiveDayWeather()
                }
                
                
                
            })
            
         
            
           
        }
        
    }
    

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    

    func updadeUI() {
     
        print("UI update called")
        
        tempLbl.text = weather.temparature + "°"
        
        windSpeed.text = weather.windSpeed
        
        humiditylbl.text = weather.humidity
        
        weatherIcon.image =  UIImage(named: weather.weatherIcon)

        
    }
    
    func updateNextFiveDayWeather() {
        
        print("UI update called")
        if  !weather.waetherFc.isEmpty{
            
        var weatherfc = weather.waetherFc[0]
        
        dayOne.text = weatherfc.day
        
        dayOneIcon.image =  UIImage(named: weatherfc.dayIcon)
        
        dayOneTemp.text = weatherfc.dayTemp + "°"
        
         weatherfc = weather.waetherFc[1]
        
        dayTwoLbl.text = weatherfc.day
        
        dayTwoIcon.image =  UIImage(named: weatherfc.dayIcon)
        
        dayTwoTemp.text = weatherfc.dayTemp + "°"
        
        weatherfc = weather.waetherFc[2]
        dayThreeLbl.text = weatherfc.day
        
        dayThreeIcon.image =  UIImage(named: weatherfc.dayIcon)
        
        dayThreeTemp.text = weatherfc.dayTemp + "°"
        
        weatherfc = weather.waetherFc[3]
        dayFourLbl.text = weatherfc.day
        
        dayFourIcon.image =  UIImage(named: weatherfc.dayIcon)
        
        dayFourTemp.text = weatherfc.dayTemp + "°"
        
        }
        
        
    } 
}

