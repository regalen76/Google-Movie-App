//
//  ViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

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
            for result in results {
                let userdata = result as! Userdata
                print("username: \(userdata.username)")
                print("password: \(userdata.password)")
                print("isAdmin: \(userdata.isadmin)")
            }
        }catch{
            print("Fetch failed")
        }
    }
    
    @IBAction func moveToRegister(_ sender: Any) {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @IBAction func moveToHome(_ sender: Any) {
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

