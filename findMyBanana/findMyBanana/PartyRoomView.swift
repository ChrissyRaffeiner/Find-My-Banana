//
//  PartyRoomView.swift
//  findMyBanana
//
//  Created by Maja Drinovac on 01.04.20.
//  Copyright © 2020 Laura Riener. All rights reserved.
//

import UIKit

class PartyRoomView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    var username = ""
    var counter = 0
    var token = ""
    //@IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arr:Array<String> = []
    var users:Array<String> = []
    var parameter = ["":""]
    var emojis = ["\u{1F973}", "\u{1F36A}","\u{1F480}","\u{1F47E}","\u{1F98A}","\u{1F42C}","\u{1F41D}","\u{1F354}",]
   // let localServer = "http://192.168.1.175:8080"
    let serverURL = "http://172.17.214.100:3000"
    //let serverURL = "http://vm112.htl-leonding.ac.at:8080"
    //let serverURL = "http://192.168.0.105:3000"
    //let serverURL = "http://31.214.245.100:3000"
    var user:Array<Dictionary<String,Any>> = []
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self

      super.viewDidLoad()
        //usernameLabel.text = username
        print("hello, \(username)")
        let queue = DispatchQueue(label: "myQueue", attributes: .concurrent)
        // Do any additional setup after loading the view.
        self.parameter = ["token": self.token, "username": self.username, "emoji": self.emojis[Int.random(in: 0...7)]]
        queue.async{
            self.poll()
            self.joinGame(parameter: self.parameter)
            print(self.token)
        }
//        joinGame()
  //      poll()
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.user.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "partyCell", for: indexPath) as! CollectionPartyViewCell
        let cellIndex = indexPath.item
        cell.text.text = user[cellIndex]["emoji"]! as! String
        cell.username.text = user[cellIndex]["username"]! as! String
        print(user[cellIndex])
        return cell
    }
    
    func joinGame(parameter:[String:String]){
        let urlString =  "\(serverURL)/joinGame"
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let username = parameter["username"]
            let token = parameter["token"]
            let emoji = parameter["emoji"]
            //let jsondata = try? JSONEncoder().encode(model)
            let poststring = "token=\(token!)&username=\(username!)&emoji=\(emoji!)"

            request.httpBody = poststring.data(using: String.Encoding.utf8)
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    
                    print(dataString)
                    
                    DispatchQueue.main.async {
                        self.arr.append("new")
                        print(dataString)
                    }//DispatchQueue
                }
                if let error = err {
                    print("Error took place \(error)")
                }
            }.resume()
        }else{
            print("URL ist flasch")
        }
    }
    
    func poll(){
        if let url = URL(string: "\(serverURL)/poll?counter=\(self.counter)&token=\(self.token)"){

            var request = URLRequest(url:url)
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                    
                    DispatchQueue.main.async {
                       print("datastring: \(dataString)")
                        if(dataString == "Try again"){
                            print("nixx neues")
                            self.poll()
                        }else{
                            if(dataString == "Game started"){
                                print("game started")
                                //perform segue
                                self.performSegue(withIdentifier: "partyJoin", sender: self)
                            }else{
                                print("kein try again kein game started")
                                if let x = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
                                     print(Int(x["count"] as! String))
                                     self.counter = Int(x["count"] as! String)!
                                     //String(data: x["new"] as! Data, encoding: .utf8)
                                    // print(x["new"] as! String)
                                      //self.users = x["users"] as! Array<String>
                                     //let values​ = x["new"] as! NSArray
                                     //self.arr.append((values​[0] as! NSString) as String)
                                     //self.users.append((values​[0] as! NSString) as String)
                                     //self.users.append(x["new"] as! String)
                                     //self.arr = x["emojis"] as! Array<String>
                                  self.user = x["users"] as! Array<Dictionary<String,Any>>
                                      print("emojis \(self.arr)")
                                      print("users: \(self.users)")
                                     self.collectionView.reloadData()
                                 }else{
                                     print("failed parse")
                                 }
                                print("poll...")
                                self.poll()
                            }
                        }
                    }//DispatchQueue
                }
                if let error = err {
                    print("Error took place \(error)")
                }
            }.resume()
        }else{
            print("URL ist flasch")
        }
    }
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
         if(segue.identifier == "partyJoin") {
           let vc = segue.destination as! CameraView
         }
     }
     
    
}
