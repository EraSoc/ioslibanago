//
//  ViewController.swift
//  bwigowv
//
//  Created by Armando Cervantes on 28/01/21.
//
import Foundation
import UIKit
import WebKit
import CoreLocation
//import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var wView: WKWebView!
    
    var manager: CLLocationManager?
    var startTime: Date?
    var latx: String?
    var lonx: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
              
        //print("getting location....")
        
        
    }
    func doLogin(usr: String,psw: String){
        let params = "usr="+usr+"&psw="+psw+"&idf=0&cli=0&asis=1821&url=http://www.link2loyalty.com/AsistenciasL2L/api/ValidaAnaGo"
        /*hssttp://www.link2loyalty.com/AsistenciasL2L/api/_LoginAsis*/
        let urli = "https://bwigo.com/anago/class.service.php"
        
        ///login service
        guard let url = URL(string: urli) else{
            fatalError("errorxxx")
        }
        let payload = params
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let data = data {
                        
                    do{
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let status = json["err"] as? Int {
                                if status == 1 {
                                    print("error")
                                }else{
                                    if let jsonx = json["Valor"] as? [String: Any]{
                                        let ses = jsonx["ses"] as? String
                                        
                                        /**/
                                            print("dologin")
                                        self.launchResponse(ses: ses!)
                                        /**/

                                    }
                                    
                                }
                            }else{
                                //print("xxx...\(json)")
                            }
                        }else{
                            print("no existe")
                        }
                    }catch{
                        print(error)
                    }
                    
            }else {
                print(error ?? "Error xxxx")
            }
        }.resume()
        ///end loginservice
        
    }
    
    
    
    //////getpromos
    func getPromos(lat: String,lon: String){
        
        let defaults=UserDefaults.standard
        if let ses = defaults.string(forKey:"ses") {

        let params = "lat="+lat+"&lon="+lon+"&ses="+ses+"&url=http://www.link2loyalty.com/BwMobile/api/PushCupon"
        let urli = "https://bwigo.com/anago/class.service.php"
        print("lat="+lat+"&lon="+lon+"&ses="+ses+"&url=http://www.link2loyalty.com/BwMobile/api/PushCupon")
        ///login service
        guard let url = URL(string: urli) else{
            fatalError("errorxxx")
        }
        let payload = params
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let data = data {
                        
                    do{
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let status = json["err"] as? Int {
                                if status == 1 {
                                    print("error")
                                }else{
                                    if let jsonx = json["Lov"] as? [[String: Any]]{
                                        let ali = jsonx[0]["ali"] as? String
                                        let descor = jsonx[0]["descor"] as? String
                                        let clvpro = jsonx[0]["clvpro"] as? Int
                                        print("launch...push...\(jsonx)")
                                        
                                        self.launchNotification(ttl: ali!,bdy: descor!,idx: clvpro!)
                                        
                                    }
                                    
                                }
                            }else{
                                print("xxx...\(json)")
                            }
                        }else{
                            print("no existe")
                        }
                    }catch{
                        print(error)
                    }
                    
            }else {
                print(error ?? "Error xxxx")
            }
        }.resume()
        ///end loginservice
        }
    }
    ////endgetpromos
    func launchNotification(ttl: String,bdy: String,idx: Int){
        let userNotificationCenter = UNUserNotificationCenter.current()
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = ttl
        notificationContent.body = bdy
        notificationContent.userInfo = ["gcm.message_id":idx]
        //notificationContent.badge = NSNumber(value: 1)
        
        

        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
 
        let request = UNNotificationRequest(identifier: "AnaGo", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request){ (error) in
            if let error = error {
                print("Notification Error: \(error)")
            }
            
        }
    }
    func launchResponse(ses: String) {
        let defaults = UserDefaults.standard
        if !ses.isEmpty {
            print("exist ses...https://pwa.bwigo.com?key=1&keycode=afk&ses="+ses)
            /*wView.load(URLRequest(url: URL(string: "https://pwa.bwigo.com?key=1&keycode=afk&ses="+ses)!))*/

            UserDefaults.standard.removeObject(forKey: "ses")
            defaults.set(ses,forKey: "ses")
            
            if let detl: String = defaults.string(forKey:"detailcupon"){
           print("detalle cupon...")
           //self.launchDetailC(mcupon: detl)
                wView.load(URLRequest(url: URL(string: "https://pwa.bwigo.com?key=1&keycode=afk&ses="+ses+"&mcupon="+detl)!))
                print("catch cupon...https://pwa.bwigo.com?key=1&keycode=afk&ses="+ses+"&mcupon="+detl)
            } else {
                if let latp: String = self.latx{
                    if let lonp: String = self.lonx{
                wView.load(URLRequest(url: URL(string: "https://pwa.bwigo.com?key=1&keycode=afk&ses="+ses+"&lat="+latp+"&long="+lonp)!))
                    }
                }
            }
        
        }
        
    }
    func launchDetailC(mcupon: String) {
        if mcupon.isEmpty {
         print("no existe cuponId")
        }else {
            print(":::::https://pwa.bwigo.com/mcupon/"+mcupon)
            wView.load(URLRequest(url: URL(string: "https://pwa.bwigo.com/mcupon/"+mcupon)!))
            UserDefaults.standard.removeObject(forKey: "detailcupon")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.allowsBackgroundLocationUpdates=true
        manager?.distanceFilter=0;
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("authorization ok")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let first=locations.first else{
            return
        }
        let time=first.timestamp
        guard let startTime=startTime else{
            self.startTime=time
            return
        }
        
        let elapsed=time.timeIntervalSince(startTime)
        
        if elapsed > 10{
            self.getPromos(lat: "\(first.coordinate.latitude)",lon: "\(first.coordinate.longitude)")
            self.latx="\(first.coordinate.latitude)"
            self.lonx="\(first.coordinate.longitude)"
            
            /**/
            let defaults = UserDefaults.standard
            
            if let userx = defaults.string(forKey: "username") {
                if let pswx = defaults.string(forKey: "password") {
                    let usx = userx
                    let psx = pswx
                    
                    self.doLogin(usr: usx, psw: psx)
                    
                    UserDefaults.standard.removeObject(forKey: "username")
                    
                    UserDefaults.standard.removeObject(forKey: "password")
                }
            } else {
              print("Usuario y contraseña no encontrados")
            }
            /**/
            
            self.startTime=time
            
        }
        
    }
    
    
    
    func postReq(urli: String,params: String) -> Void {
        guard let url = URL(string: urli) else{
            fatalError("errorxxx")
        }
        let payload = params
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = payload.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        session.dataTask(with: request){(data, response, error) in
            if let data = data {
                        
                    do{
                        
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let status = json["message"] {
                                print(status)
                            }else{
                                print("xxx...\(json)")
                            }
                        }else{
                            print("no existe")
                        }
                    }catch{
                        print(error)
                    }
                    
//                }
            }else {
                print(error ?? "Error xxxx")
            }
        }.resume()
    }
    func getReq(){
        guard let url = URL(string:"https://bwigo.com/anago/class.api.php?key=123/*test") else{
            fatalError("Error generated....XXX")
            
        }
        let session = URLSession.shared
        session.dataTask(with: url) {(data,response,error) in
            if let data = data {
                do{
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let status = json["message"] {
                            print(status)
                        }else{
                            print("xxx...\(json)")
                        }
                    }
                   /* if let dict = json as? [String : Any] {
                        ////FOR SINGLE VALUES
                        if let value = dict["status"] as? String{
                                print("json::::\(value)")
                            
                        }else{
                            print("no hay datos\(json)")
                        }
                        
                    }*/
                }catch{
                    print(error)
                }

            }
        }.resume()
        
    }
    
    
}
