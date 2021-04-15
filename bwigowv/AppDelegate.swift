//
//  AppDelegate.swift
//  bwigowv
//
//  Created by Armando Cervantes on 28/01/21.
//
import UIKit
import UserNotifications
/*import FirebaseMessaging
import FirebaseCore
*/
@main
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey="gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        ///firebase
       /* FirebaseApp.configure()
        
        Messaging.messaging().delegate=self
        
        Messaging.messaging().token{token,error in
            if let error = error{
                print("error fetting fcm: \(error)")
            }else if let token = token{
                print("FCM registration token: \(token)")
            }
        }
        */
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions=[.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in})
        }else{
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        
      /*  application.registerForRemoteNotifications()
        if let option = launchOptions {
            let info = option[UIApplication.LaunchOptionsKey.remoteNotification]
            if (info != nil) {
                 let sb = UIStoryboard(name: "Main", bundle: nil)
                
        }}
        */
        
        
        return true
    }
    
    /*// [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletetionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }*/
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID \(messageID)")
            let defaults=UserDefaults.standard
            let idmss = messageID
            defaults.set(idmss,forKey: "detailcupon")
           
            (window?.rootViewController as? ViewController)?.viewDidLoad()
        } else {
            print("not message ID \(userInfo)")
        }
    }
    
    

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


