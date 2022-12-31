//
//  RegisterViewController.swift
//  MulmedFinalLab
//
//  Created by Reonaldo Galen Maliode on 29/12/22.
//

import UIKit
import CoreData

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || password2TextField.text!.isEmpty{
            let alertVC = UIAlertController(title: "Warning", message: "Fields cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default)
            alertVC.addAction(action)
            present(alertVC, animated: true)
        }else{
            var flag = false
            var message = ""
            
            if usernameTextField.text!.count <= 6 {
                message = "Username must contains more than 6 characters"
                flag = true
            }else if passwordTextField.text!.count <= 8 {
                message = "Password must contains more than 8 characters"
                flag = true
            }else if
                password2TextField.text! != passwordTextField.text {
                message = "Password you re-enter did not match"
                flag = true
            }
            let alertVC = UIAlertController (title: "Warning",message: message, preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default)
            alertVC.addAction(action)
            if flag {
                present(alertVC, animated: true)
            }else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Userdata", in: context)
                let newUserdata = Userdata(entity: entity!, insertInto: context)
                newUserdata.username = usernameTextField.text
                newUserdata.password = passwordTextField.text
                newUserdata.isadmin = 0
                do{
                    try context.save()
                    performSegue(withIdentifier: "unwindToLogin", sender: self)
                }catch{
                    print("context save error")
                }
            }
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLogin", sender: self)
    }
    
}
