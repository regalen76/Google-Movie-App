//
//  ViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Userdata")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            let res = results
            if res.count == 0{  //jika baru download app dan tidak ada user maka create admin
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Userdata", in: context)
                let newUserdata = Userdata(entity: entity!, insertInto: context)
                newUserdata.username = "thisisadmin"
                newUserdata.password = "adminpassword"
                newUserdata.isadmin = 1
                do{
                    try context.save()
                }catch{
                    print("context save error")
                }
            }
        }catch{
            print("Fetch failed")
        }
    }
    
    @IBAction func moveToRegister(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @IBAction func moveToHome(_ sender: Any) {  //login
        var flag = false
        var flag2 = false
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Userdata")
        do{
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let userdata = result as! Userdata
                if(usernameTextField.text! == userdata.username && passwordTextField.text! == userdata.password){
                    let defaults = UserDefaults.standard
                    defaults.set(userdata.username, forKey: "userKey")
                    
                    flag = true
                    if userdata.isadmin == 1{
                        flag2 = true
                    }
                }
            }
        }catch{
            print("Fetch failed")
        }
        
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty{
            let alertVC = UIAlertController(title: "Warning", message: "Fields cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default)
            alertVC.addAction(action)
            present(alertVC, animated: true)
        }else if flag == false{
            let alertVC = UIAlertController(title: "Warning", message: "Username or Password is not correct", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default)
            alertVC.addAction(action)
            present(alertVC, animated: true)
        }else if flag == true{
            if(flag2 == false){
                performSegue(withIdentifier: "userHomeSegue", sender: self)
            }else if(flag2 == true){
                
                performSegue(withIdentifier: "adminHomeSegue", sender: self)
            }
        }
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
//        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
}

