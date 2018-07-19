//
//  DetailSectionImage.swift
//  StoreApp
//
//  Created by yuaming on 18/07/2018.
//  Copyright © 2018 yuaming. All rights reserved.
//

import Foundation
import UIKit

class DetailSectionImage {
  var index: Int?
  var image: UIImage?
  
  init(_ imageUrl: String?, index: Int?) {
    self.index = index
    loadImageData(imageUrl)
  }
}

extension DetailSectionImage: ImageLoaderable { }