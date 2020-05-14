//
//  ConnectWithUsernameView.swift
//  findMyBanana
//
//  Created by Maja Drinovac on 01.04.20.
//  Copyright © 2020 Laura Riener. All rights reserved.
//

import UIKit

class ConnectWithUsernameView: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
    var jsonModel = GameModel(anz: 3, timeInSec: 5)
    var admin:Bool = false
    var token:String = ""
    
    @IBAction func gestureNext(_ sender: UIScreenEdgePanGestureRecognizer) {
        if(sender.state == .began){
            nextView()
        }
    }
    
    @IBAction func nextBtn(_ sender: UIBarButtonItem) {
        nextView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //addShadow(tf: usernameTF)
        // Do any additional setup after loading the view.
        
    }
    fileprivate func nextView() {
        let queue = DispatchQueue(label:"myQueue", attributes: .concurrent)
        if(self.admin){
            performSegue(withIdentifier: "PartyRoomAdmin", sender: self)
        }else{
            
            performSegue(withIdentifier: "PartyRoom", sender: self)
        }
    }
    
    
    func addShadow(tf: UITextField){
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("username: \(usernameTF.text!)")
        if(segue.identifier == "PartyRoom") {
            let vc = segue.destination as! PartyRoomView
            vc.username = usernameTF.text!
            vc.token = token
        }
        
        if(segue.identifier == "PartyRoomAdmin"){
            let vc = segue.destination as! CreateGameGamecodeView
            vc.username = usernameTF.text!
        }
    }

}

