//
//  WeatherFC.swift
//  weather-app
//
//  Created by Abha Chandel on 4/7/16.
//  Copyright © 2016 Abha Chandel. All rights reserved.
//

import Foundation

class WeatherFC{
    
    private var _day:String!
    
    private var _dayIcon:String!
    
    private var _dayTemp:String!
    
    init() {
        
    }
    
    var day: String {
        get { return self._day}
        set { self._day = newValue }
    }
    
    var dayIcon: String {
        get { return self._dayIcon}
        set { self._dayIcon = newValue }
    }
    
    var dayTemp: String {
        get { return self._dayTemp}
        set { self._dayTemp = newValue }
    }
}