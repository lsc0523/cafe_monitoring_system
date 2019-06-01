//
//  Singleton.swift
//  CAFE
//
//  Created by Sung Mun on 24/05/2019.
//  Copyright © 2019 Sung Mun. All rights reserved.
//

import UIKit

final class Singleton {
    static let sharedInstance = Singleton()
    public var people_num:Int
    public var total_num:Int
    public var noise_num:Int
    public var CO2_num:Int
    public var PVOC_num:Int
    
    public var all_chat:[String]
    
    private init() {
        self.people_num=0
        self.total_num=0
        self.noise_num=0
        self.CO2_num=0
        self.PVOC_num=0
        self.all_chat=[]
    }
    public func reinit() {
        self.people_num=0
        self.total_num=0
        self.noise_num=0
        self.CO2_num=0
        self.PVOC_num=0
    }
}
