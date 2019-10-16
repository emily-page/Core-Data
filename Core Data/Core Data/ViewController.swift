//
//  ViewController.swift
//  Core Data
//
//  Created by apcs2 on 9/13/17.
//  Copyright © 2017 apcs2. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var myTableView: UITableView!
    var grocery:[NSManagedObject] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "List")
        do
        {
            grocery = try fetchFunction(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [NSManagedObject]
        }
        catch
        {
            print("error viewdidload")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return grocery.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = grocery[indexPath.row].value(forKeyPath: "item") as? String
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            grocery.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func barButtonAdd(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Add an Item", message: "Enter Info", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Item" })
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            let nameTextField = alert.textFields![0]
            let newItem = Food(n: nameTextField.text!)
            self.grocery.append(NSManagedObject(context: newItem.name))
            self.myTableView.reloadData()
            print("Text field: \(String(describing: newItem))")
        }))
        self.present(alert, animated: true, completion: nil)
        myTableView.reloadData()
    }
    
    func save(item: String, name: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
        else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: item, in: managedContext)
        let newObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        newObject.setValue(item, forKey: "item")
        newObject.setValue(name, forKey: "name")
        do
        {
            try managedContext.save()
        }
        catch
        {
            print("error2")
        }
    }
    
    func fetchFunction(_ request: NSFetchRequest<NSFetchRequestResult>) throws -> [Any]
    {
        var array : [Any]! = []
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        do
        {
            array = try managedContext?.fetch(request)
        }
        catch
        {
            print("error fetch")
        }
        return array
    }
}
