//
//  ViewController.swift
//  NoteTaking
//
//  Created by Md Ashraful Islam on 19/7/18.
//  Copyright © 2018 Md Ashraful Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    var data:[String] = [ /* empty item variable it will be named as "Item 1:" */ ]
    var fileURL:URL!
    var selectedRow:Int = -1
    var newRowString:String = ""
    
    // datasoruce handles the data
    // delegrts handles the interectevity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        table.delegate = self
        self.title = "My Notes"
       self.navigationController?.navigationBar.prefersLargeTitles = true
        // add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem = addButton
        //Edit button
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        // file url
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        fileURL = baseURL.appendingPathComponent("notes.text")
       
        load()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        data[selectedRow] = newRowString
        if newRowString == "" {
            data.remove(at: selectedRow)
        }
        table.reloadData()
        save()
    }
    
    // add new note and placing on top of others...
    @objc func addNote(){
        
        if table.isEditing{
            /*if the table is in editing mode it will no t add any more items */
            return
        }
        let name:String = "Item \(data.count+1):"
        data.insert(name, at: 0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        table.insertRows(at: [indexPath], with: .left)
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
        // save()
    }
    
    
    // how many tables do the tableView has...
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // returns the data in cells pre row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell;
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
    
    
    //selecting a row in table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("\(data[indexPath.row])")
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView: detailViewController = segue.destination as! detailViewController
        selectedRow = table.indexPathForSelectedRow!.row
        detailView.masterView = self
        detailView.setText(userText: data[selectedRow])
    }
    
    func save(){
     //   UserDefaults.standard.set(data, forKey: "notes")
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURL)
        } catch {
            print("Error writting file")
        }
        
    }
    func load(){
     //   if let loadedData:[String] = UserDefaults.standard.value(forKey: "notes") as? [String]{
        if let loadedData:[String] = NSArray(contentsOf: fileURL) as? [String]{
        data = loadedData
            table.reloadData()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

