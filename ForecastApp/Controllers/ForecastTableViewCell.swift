//
//  ForecastTableViewCell.swift
//  ForecastApp
//
//  Created by Tatsiana Marchanka on 8.12.21.
//

import UIKit

class ForecastTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    static let identifier = "ForecastTableViewCell"
    
    static func nub() -> UINib {
        return UINib(nibName: "ForecastTableViewCell", bundle: nil)
    }
    var model = [Model]()
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(ForecastCollectionViewCell.nub(), forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    public func configure (with models: [Model]) {
        self.model = models
        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as! ForecastCollectionViewCell
        cell.configure(model: model[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 200)
    }
    
}
