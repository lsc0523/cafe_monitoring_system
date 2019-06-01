//
//  Load.swift
//  CAFE
//
//  Created by Sung Mun on 23/05/2019.
//  Copyright © 2019 Sung Mun. All rights reserved.
//

import UIKit

class Load: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Networkhandler.getData(resource: "http://18.223.102.79:9000/")
        
        let Url = URL(string : "http://18.223.102.79:9000/req")
        var request = URLRequest(url : Url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data : Data?, response: URLResponse?, error:Error?) -> Void in
            if error != nil{
                print(error)
                return
            }
            
            do{
                let parseJson = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                print(parseJson)
                //print(parseJson.object(forKey: "connect"))
                var connect:Int = parseJson.object(forKey:"connect") as! Int
                if connect == 100{//연결되었을 때
                    
                    let instance:Singleton = Singleton.sharedInstance
                    instance.people_num=parseJson.object(forKey:"person_num") as! Int
                    instance.total_num=parseJson.object(forKey:"total_seat") as! Int
                    instance.PVOC_num=parseJson.object(forKey:"gas") as! Int
                    
                    if let nextScreen = self.storyboard?.instantiateViewController(withIdentifier: "Dream")
                    {
                        nextScreen.modalTransitionStyle = .coverVertical
                        self.present(nextScreen, animated: true /*completion: nil*/)
                    }
                }
                else{
                    print("connect != 100\n")
                    print("connect is \(connect)\n")
                }
            }catch{
                print("연결 오류! 다시 한번 클릭해주세요 :)\n")
            }

        }).resume()
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
