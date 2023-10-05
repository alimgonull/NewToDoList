//
//  ViewController.swift
//  NewToDoList
//
//  Created by Alim Gönül on 23.05.2023.
//

import UIKit
import CoreData
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var headerArray = [String]()
    var commentArray = [String]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        getData()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector:#selector(getData), name: NSNotification.Name("newData"), object: nil)
    }
   @objc func getData() {
        headerArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        commentArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                if let headerName = result.value(forKey: "header") as? String {
                    headerArray.append(headerName)
                }
                if let commentName = result.value(forKey: "comment") as? String {
                    commentArray.append(commentName)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    idArray.append(id)
                }
                self.tableView.reloadData()
                   
            }
        }catch { 
            print("Error")
        }
        
    }
    @objc func addButton(){
        performSegue(withIdentifier: "toSecondVc", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.headerLabel.text = headerArray[indexPath.row]
        cell.commentLabel.text = commentArray[indexPath.row]
        return cell
    }
    
    
   // SİLME İŞLEMİ İÇİN
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
            
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        
                        if let id = result.value(forKey: "id") as? UUID {
                            
                            if id == idArray[indexPath.row] {
                                
                                context.delete(result)
                                idArray.remove(at: indexPath.row)
                                headerArray.remove(at: indexPath.row)
                                commentArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                    
                                } catch {
                                    
                                }
                                break
                            }
                        }
                    }
                }
            }catch {
                
            }
            
            
        }
    }

}

