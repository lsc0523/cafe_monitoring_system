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

class Dream: UIViewController{
    @IBOutlet weak var Sound_label: UIImageView!
    @IBOutlet weak var Temperatrue: UILabel!
    @IBOutlet weak var Total_seat: UILabel!
    @IBOutlet weak var Left_seat: UILabel!
    @IBOutlet weak var air_quality: UIImageView!
    @IBOutlet weak var chattable: UITableView!
    
    @IBOutlet weak var SendText: UITextField!
    @IBOutlet weak var SendButton: UIButton!
    //@IBOutlet weak var air_label: UILabel!
    //@IBOutlet weak var crowd_label: UILabel!
    
    @IBAction func Send_Pressed(_ sender: Any) {
        if(SendText.text=="")
        {
            return;
        }
        let Str_send:String = SendText.text as! String;
        SendText.text="";
        
        let Url = URL(string : "http://35.247.50.186:3000/chat")
        var request = URLRequest(url : Url!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json_temp:[String: String] = ["comments":"\(Str_send)"];
        print("보낼 메세지 : \(json_temp)")
        let jsonData = try? JSONSerialization.data(withJSONObject: json_temp);
        request.httpBody = jsonData;
        URLSession.shared.dataTask(with: request, completionHandler: {(data : Data?, response: URLResponse?, error:Error?) -> Void in
            if error != nil{
                print(error)
                return
            }
            print("Msg Sended Success!\n");
            self.update_chat();
            
        }).resume()
       // update_chat();
    }
    func update_chat(){
        
        let Url = URL(string : "http://35.247.50.186:3000/chat_table")
        var request = URLRequest(url : Url!)
     
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request, completionHandler: {(data : Data?, response: URLResponse?, error:Error?) -> Void in
            if error != nil{
                print(error)
                return
            }
            //print(data!);
            do{
                let parseJson = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                print(parseJson)
                let instance:Singleton=Singleton.sharedInstance;
                
                let comments:[String] = parseJson.object(forKey:"comments") as! [String];
                let dates:[String] = parseJson.object(forKey: "date") as! [String];
                instance.all_chat=comments;
                instance.all_date=dates;
                instance.comment_num=comments.count;
                print("COMMENTS COUNT is \(comments.count)")
                
                DispatchQueue.main.async{
            
                    self.chattable.reloadData();
                    
                }
                
            }catch{
                print("연결 오류! 다시 한번 클릭해주세요 :)\n")
            }
            
        }).resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update_chat();
        
        let instance:Singleton=Singleton.sharedInstance
        let temp1:String = String(instance.total_num - instance.people_num);
        let temp2:String = String(instance.total_num );
        var temp3:String = String(instance.temper)
        temp3 = temp3 + "℃"
        //let crowd:Float = temp1/temp2;
        let air:Int = instance.PVOC_num
        
        let sound:Int = instance.noise_num
        
        DispatchQueue.main.async {
            /*------AIR POLLUTION------*/
            if air < 300{
                self.air_quality.image = #imageLiteral(resourceName: "good")
            }
            else if air>=300 && air <= 450{
                self.air_quality.image = #imageLiteral(resourceName: "middle")
            }
            else{
                self.air_quality.image = #imageLiteral(resourceName: "bad")
            }
            
            self.Left_seat.text = temp1
            self.Left_seat.textAlignment = NSTextAlignment.center
            self.Left_seat.layer.borderColor = UIColor.green.cgColor
            self.Left_seat.layer.borderWidth = 3.0
            
            self.Total_seat.text = temp2
            self.Total_seat.textAlignment = NSTextAlignment.center
            self.Total_seat.layer.borderColor = UIColor.green.cgColor
            self.Total_seat.layer.borderWidth = 3.0
            
            self.Temperatrue.text = temp3
            self.Temperatrue.textAlignment = NSTextAlignment.center
            self.Temperatrue.layer.borderColor = UIColor.green.cgColor
            self.Temperatrue.layer.borderWidth = 3.0
            
            if sound < 70{
                self.Sound_label.image = #imageLiteral(resourceName: "low-sound")
            }
            else if sound >= 70 && sound < 100{
                self.Sound_label.image = #imageLiteral(resourceName: "middle-sound")
            }
            else{
                self.Sound_label.image = #imageLiteral(resourceName: "loud")
            }
            //소음 크기 기준 : 70, 100
            
            self.SendButton.layer.borderColor = UIColor.green.cgColor
            self.SendButton.layer.borderWidth = 1.0
            
        }
        

        
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
        let cell  = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath);
    
  
        let size = instance.all_chat.count
        cell.textLabel?.text = instance.all_chat[size - 1 - indexPath.row];
        cell.textLabel?.font  = UIFont.init(name:"Helvetica",size: 14.0)
        cell.detailTextLabel?.text = instance.all_date[size - 1 - indexPath.row];
        cell.detailTextLabel?.font = UIFont.init(name:"Helvetica", size: 8.0)
        cell.backgroundColor = UIColor(red:0.7,green: 1.0,blue: 0.5,alpha: 1.0)
    
        return cell;
        
    }
    
}
