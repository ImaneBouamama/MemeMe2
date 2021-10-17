//
//  MemeCollectionVC.swift
//  MemeMe2
//
//  Created by Imane BOUAMAMA on 2021/10/17.
//

import UIKit

class MemeCollectionVC : UICollectionViewController {
  
  var meme : Meme!
  
  var memes: [Meme]! {
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    return appDelegate.memes
  }
  
  @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let space: CGFloat = 3.0
    let dimension = ( view.frame.size.width - ( 2 * space ) )
    
    flowLayout.minimumInteritemSpacing = space
    flowLayout.minimumLineSpacing = space
    flowLayout.itemSize = CGSize ( width: dimension, height: dimension )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear( animated )
    self.tabBarController?.tabBar.isHidden = false
  }
  
  override func viewWillDisappear( _ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
  }
  
  // MARK: Collection View Data Source
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return self.memes.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemesCollectionViewCell", for: indexPath) as! MemesCollectionViewCell
      let meme = self.memes[(indexPath as NSIndexPath).row]
     
    cell.memeImageView?.image = meme.memedImage
      return cell
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
      let detailController = self.storyboard!.instantiateViewController( withIdentifier: "MemeCollectionVC") as! MemeCollectionVC
      detailController.meme = self.memes[(indexPath as NSIndexPath).row]
      self.navigationController!.pushViewController(detailController, animated: true)
  }
  
  @IBAction func AddNewMeme(_ sender: Any) {
    let editorViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemesEditorVC") as! MemesEditorVC
    self.navigationController!.pushViewController( editorViewController, animated: true )
  }
  
}
