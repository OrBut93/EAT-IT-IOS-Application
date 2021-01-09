//
//  RecInfoViewController.swift
//  EAT-IT-Project
//
//  Created by admin on 07/06/2020.
//  Copyright © 2020 Or. All rights reserved.
//

import UIKit
import Kingfisher


class RecInfoViewController: UIViewController {

    @IBOutlet weak var userNameInfo: UILabel!
    @IBOutlet weak var titleInfo: UILabel!
    @IBOutlet weak var locationInfo: UILabel!
    @IBOutlet weak var avatarInfo: UIImageView!
    @IBOutlet weak var descriptionInfo: UILabel!
    @IBOutlet weak var editbtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
        
    var recommend: Recommend?
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUserId = Model.instance.getCurrentUserId()
        editbtn.isHidden = currentUserId != recommend?.ownerId
        deletebtn.isHidden = currentUserId != recommend?.ownerId
        titleInfo.text = recommend?.title
        userNameInfo.text = recommend?.ownerName
        locationInfo.text = recommend?.location
        descriptionInfo.text = recommend?.description
        avatarInfo.image = UIImage(named: "avatar")
        if(recommend?.image != "")
        {
            avatarInfo.kf.setImage(with: URL(string: recommend!.image))
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        if (recommend != nil) {
            performSegue(withIdentifier: "editRecommendSegue", sender: self)
        }
    }
    
    @IBAction func deletepost(_ sender: Any) {
        if (recommend != nil) {
            Model.instance.deleteRecommend(recommend: recommend!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "editRecommendSegue"){
            let vc:AddRecViewController = segue.destination as! AddRecViewController
            vc.recommend = recommend!
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
