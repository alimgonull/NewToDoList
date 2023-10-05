//
//  SecondViewController.swift
//  NewToDoList
//
//  Created by Alim Gönül on 23.05.2023.
//

import UIKit
import CoreData
class SecondViewController: UIViewController {
    
    @IBOutlet weak var headerText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    var selectedHeader = ""
    var selectedHeaderId : UUID?
    
    var chosenHeader = ""
    var chosenComment = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedHeader != "" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
            // id'yi stringe çeviriyoruz
            let idString = selectedHeaderId!.uuidString
            request.predicate = NSPredicate(format: "id = %@", idString)
            request.returnsObjectsAsFaults = false
        
            do{
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let header = result.value(forKey: "header") as? String{
                            chosenHeader = header
                        }
                        if let comment = result.value(forKey: "comment") as? String{
                            chosenComment = comment
                        }
                    }
                }
            }
            catch {
                print("Error")
            }
        }
        else {
            
        }
    }
    
    // Verileri Core Data'ya kaydediyoruz
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let painting = NSEntityDescription.insertNewObject(forEntityName: "Todolist", into: context)
        
        painting.setValue(headerText.text, forKey: "header")
        painting.setValue(commentText.text, forKey: "comment")
        
        painting.setValue(UUID(), forKey: "id")
        do {
            try context.save()
            print("success")
        }catch {
            print("Error")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object:nil)
        self.navigationController?.popViewController(animated: true)
        
            }

}
