//
//  Dream.swift
//  CAFE
//
//  Created by Sung Mun on 23/05/2019.
//  Copyright © 2019 Sung Mun. All rights reserved.
//

import UIKit

class crowd_label : UILabel{
    
}

class Dream: UIViewController {
    @IBOutlet weak var chattable: UITableView!
    
    @IBOutlet weak var SendText: UITextField!
    @IBOutlet weak var SendButton: UIButton!
    @IBOutlet weak var air_label: UILabel!
    @IBOutlet weak var crowd_label: UILabel!
    
    @IBAction func Send_Pressed(_ sender: Any) {
        var Str_send:String = SendText.text as! String;
        
        let Url = URL(string : "http://18.223.102.79:9000/chat")
        var request = URLRequest(url : Url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json_temp:[String: String] = ["comments":"\(Str_send)"];
        let jsonData = try? JSONSerialization.data(withJSONObject: json_temp);
        request.httpBody = jsonData;
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data : Data?, response: URLResponse?, error:Error?) -> Void in
            if error != nil{
                print(error)
                return
            }
            print("Msg Sended Success!\n");
            
        }).resume()
        //update_chat();
    }
    func update_chat(){
        
        let Url = URL(string : "http://18.223.102.79:9000/chat_table")
        var request = URLRequest(url : Url!)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data : Data?, response: URLResponse?, error:Error?) -> Void in
            if error != nil{
                print(error)
                return
            }
            print(data!);
            do{
                let parseJson = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                //print(parseJson)
                let instance:Singleton=Singleton.sharedInstance;
                
                var comments:[String] = parseJson.object(forKey:"comments") as! [String];
                instance.all_chat=comments;
                var i:Int = 0;
                for comment in comments{
                    print(comment);
                    //self.tableView(self.chattable, cellForRowAt: <#T##IndexPath#>)
                    i+=1;
                }
                
                
                
                
                
                //print(parseJson.object(forKey: "connect"))
                //var connect:Int = parseJson.object(forKey:"connect") as! Int
                
            }catch{
                print("연결 오류! 다시 한번 클릭해주세요 :)\n")
            }
            
        }).resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let instance:Singleton=Singleton.sharedInstance
        let temp1:Float = Float(instance.people_num);
        let temp2:Float = Float(instance.total_num);
        let crowd:Float = temp1/temp2;
        
        
        crowd_label.text="혼잡도 : \(crowd)";
        crowd_label.textAlignment=NSTextAlignment.center
        
        air_label.text="공기질 : \(instance.PVOC_num)"
        air_label.textAlignment=NSTextAlignment.center

        update_chat();

        
        // Do any additional setup after loading the view.
    }


}

extension Dream : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let instance:Singleton=Singleton.sharedInstance;
        return instance.all_chat.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let instance:Singleton=Singleton.sharedInstance;
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath);
        cell.textLabel?.text = instance.all_chat[indexPath.row];
        return cell;
    }
    
}
