//
//  TitleTableViewCell.swift
//  Movies
//
//  Created by Vitaly on 10.01.2024.
//

import SnapKit
import UIKit

class TitleTableViewCell: UITableViewCell {
    
    //MARK: - GUI Variables
    static let identifier = "TitleTableViewCell"
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private var titlePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    //MARK: - Initialisation
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //MARK: - Privat methods
    private func setupUI() {
        contentView.addSubview(titlePosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titlePosterUIImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.top.equalTo(contentView.snp.top).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titlePosterUIImageView.snp.trailing).offset(20)
            make.center.equalTo(contentView.snp.center)
        }
        
        playTitleButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.centerY.equalTo(contentView.snp.centerY)
            
        }
    }
    
    //MARK: - Methods
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\( model.posterURL)") else { return }
        
        titlePosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
}
