//
//  Networkhandler.swift
//  CAFE
//
//  Created by Sung Mun on 24/05/2019.
//  Copyright © 2019 Sung Mun. All rights reserved.
//

import UIKit

class Networkhandler{
    class func getData(resource:String)
    {
        let defaultSession = URLSession(configuration: .default)
        guard let url = URL(string: resource) else {
            print("URL is not valid")
            return
        }
        
        // Request
        let request = URLRequest(url: url)
        
        // dataTask
        let dataTask = defaultSession.dataTask(with: request) { data, response, error in
            // getting Data Error
            guard error == nil else {
                print("Error occur: \(String(describing: error))")
                return
            }
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                // 통신에 성공한 경우 data에 Data 객체가 전달됩니다.
                
                // 받아오는 데이터가 json 형태일 경우,
                // json을 serialize하여 json 데이터를 swift 데이터 타입으로 변환
                // json serialize란 json 데이터를 String 형태로 변환하여 Swift에서 사용할 수 있도록 하는 것을 말합니다.
                guard let jsonToArray = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    print("json to Any Error")
                    return
                }
 
                // 원하는 작업
                print(data)
            }
            
        }
        
        dataTask.resume()
    }


}
