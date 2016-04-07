//
//  Constants.swift
//  weather-app
//
//  Created by Abha Chandel on 4/5/16.
//  Copyright © 2016 Abha Chandel. All rights reserved.
//

import Foundation


let API_KEY = "82c68cdaa61862a6edf6606481f7bb09"

let URL_BASE = "http://api.openweathermap.org/data/2.5/weather?zip="

let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat="

let LON = "&lon="

let SEP = ","

let URL_UNITS = "&APPID="

let URL_METRIC = "&units=metric"

typealias DownloadComplete = () -> ()

typealias ForecastCompleted = () -> ()