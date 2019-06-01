//
//  Index.swift
//  CAFE
//
//  Created by Sung Mun on 10/05/2019.
//  Copyright © 2019 Sung Mun. All rights reserved.
//

import UIKit

class Index: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let instance:Singleton = Singleton.sharedInstance
        instance.reinit()
        
        
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
