//
//  TitleCollectionViewCell.swift
//  Movies
//
//  Created by Vitaly on 10.01.2024.
//

import SDWebImage
import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    //MARK: - GUI Variables
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    //MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupUI() {
        contentView.addSubview(posterImageView)
        posterImageView.frame = bounds
    }
    
    //MARK: - Methods
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
