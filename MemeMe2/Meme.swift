//
//  Meme.swift
//  MemeMe2
//
//  Created by Imane BOUAMAMA on 2021/10/17.
//

import UIKit

class Meme {
  private var top : String!
  private var bottom : String!
  private var originalImage : UIImageView!
  var memedImage : UIImage!
  
  public init( top: String, bottom: String, originalImage: UIImageView, memedImage: UIImage ){
    self.top = top
    self.bottom = bottom
    self.originalImage = originalImage
    self.memedImage = memedImage
  }
}
