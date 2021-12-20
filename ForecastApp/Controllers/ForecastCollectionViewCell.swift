//
//  fullDayWeatherViewCell.swift
//  ForecastApp
//
//  Created by Tatsiana Marchanka on 8.12.21.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var temperature: UILabel!
    
    @IBOutlet weak var dateLable: UILabel!
    
    @IBOutlet weak var mintempLab: UILabel!
    
    static let identifier = "ForecastCollectionViewCell"
    
    static func nub() -> UINib {
        return UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }
    
  public  func configure(model: Model) {
      self.temperature.text = String(model.weatherMax)
      self.dateLable.text = String(model.weatherdate)
      self.mintempLab.text = String(model.weatherMin)
      
      print(model.weatherdate)
  }
      
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
