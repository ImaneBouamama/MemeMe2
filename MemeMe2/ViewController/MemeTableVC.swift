//
//  MemeTableVC.swift
//  MemeMe2
//
//  Created by Imane BOUAMAMA on 2021/10/17.
//

import UIKit

class MemeTableVC : UITableViewController {
  
  var memes: [Meme]! {
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    return appDelegate.memes
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.memes.count
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear( animated )
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func viewWillDisappear( _ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MemesTableViewCell", for: indexPath) as! MemesTableViewCell
      let meme = self.memes[(indexPath as NSIndexPath).row]
    cell.memeImageView?.image = meme.memedImage
    return cell
  }
  
  
  @IBAction func AddNewMeme( _ sender: UIButton ) {
    let editorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemesEditorVC") as! MemesEditorVC
    self.navigationController!.pushViewController( editorViewController, animated: true )
  }
}
