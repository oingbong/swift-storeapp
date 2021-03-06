//
//  PriceView.swift
//  StoreApp
//
//  Created by oingbong on 08/12/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import UIKit

class PriceView: UIStackView, Decorating {
    @IBOutlet weak var nPriceLabel: UILabel!
    @IBOutlet weak var sPriceLabel: UILabel!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(from item: StoreItem) {
        self.addSubview(nPriceLabel)
        self.addSubview(sPriceLabel)
        
        hiddenViewItem()

        // MARK: nPrice
        if let price = item.nPrice, let firstLabel = self.arrangedSubviews[0] as? UILabel {
            firstLabel.isHidden = false
            firstLabel.attributedText = decorateString(option: PriceAttribute.nPrice, string: price)
        }

        // MARK: sPrice
        guard let secondLabel = self.arrangedSubviews[1] as? UILabel else { return }
        secondLabel.isHidden = false
        secondLabel.attributedText = decorateString(option: PriceAttribute.sPrice, string: item.sPrice)
    }
    
    private func hiddenViewItem() {
        for subview in self.arrangedSubviews {
            subview.isHidden = true
        }
    }
    
    func decorateString(option: Attributable, string: String) -> NSMutableAttributedString {
        let attributedOption = option.style
        let attributedString = NSMutableAttributedString(string: string, attributes: attributedOption)
        return attributedString
    }
}
