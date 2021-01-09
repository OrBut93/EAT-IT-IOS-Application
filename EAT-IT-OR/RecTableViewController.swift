//
//  RecTableViewController.swift
//  EAT-IT-Project
//
//  Created by admin on 07/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit
import Kingfisher

class RecTableViewController: UITableViewController {

    var data = [Recommend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Model.instance.getAllRecommend{ (_data:[Recommend]?) in
        if (_data != nil){
            self.data = _data!
            self.tableView.reloadData()
        }
    }
    }

    @objc func reloadData (){

            Model.instance.getAllRecommend{ (_data:[Recommend]?) in
                if (_data != nil){
                    self.data = _data!
                    self.tableView.reloadData()
                }
                self.refreshControl?.endRefreshing()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RecViewCell = tableView.dequeueReusableCell(withIdentifier: "RecCell", for: indexPath) as! RecViewCell
        
        let rc = data[indexPath.row]
        cell.title.text = rc.title
        cell.userName.text = rc.ownerName
        cell.location.text = rc.location
        cell.avatarImg.image = UIImage(named: "avatar")
        if (rc.image != ""){
            cell.avatarImg.kf.setImage(with: URL(string: rc.image))
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "RecInfoSegue")
        {
            let rec:RecInfoViewController = segue.destination as! RecInfoViewController
            rec.recommend = selected
        }
    }
   
    var selected:Recommend?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        selected = data[indexPath.row]
        performSegue(withIdentifier: "RecInfoSegue", sender: self)
        
    }

}
