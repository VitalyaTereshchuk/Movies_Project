//
//  HeroHeaderUIView.swift
//  Movies
//
//  Created by Vitaly on 05.01.2024.
//

import SnapKit
import UIKit

protocol HomeHeaderUIViewDelegate: AnyObject {
    func homeHeaderUIViewDidTapCell(_ viewModel: TitlePreviewViewModel)
}

class HeroHeaderUIView: UIView {
    weak var delegate: HomeHeaderUIViewDelegate?
    private var titlesElement: Title?
    
    static let identifier = "HeroHeaderUIView"
    
    //MARK: - GUI Variables
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        
        return imageView
    }()
    
    private var playButton: UIButton = {
        var button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    private var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    //MARK: - Methods
    public func config(with model: Title){
        titlesElement = model
        guard let posterURL = model.poster_path else {return}
        guard let url=URL(string: "\(Constants.imageBaseURL)\(posterURL)") else {
            return
        }
        heroImageView.sd_setImage(with: url)
    }
    
    //MARK: - Initialisation
    override init(frame: CGRect) {
        super.init(frame: frame)
        playButton.addTarget(self, action: #selector(playButtonTap), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonTap), for: .touchUpInside)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    @objc
    private func playButtonTap() {
        guard let title = titlesElement else { return }
        guard let titleName = titlesElement?.original_name ?? title.title else { return }
        guard let overview = titlesElement?.overview else { return }
        
        MoviesAPI.shared.getMovie(with: titleName + "trailer") { [ weak self ] result in
            switch result {
            case.success(let data):
                guard let strongSelf = self else {return}
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: data, titleOverview: overview)
                self?.delegate?.homeHeaderUIViewDidTapCell(viewModel)
            case.failure(let error):
                guard let strongSelf = self else { return }
                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: VideoElement(id: IdVideoElement(kind: "", videoId: "uYPbbksJxIg")), titleOverview: overview)
                self?.delegate?.homeHeaderUIViewDidTapCell(viewModel)
                print(error.localizedDescription)
            }
        }
    }
    
    @objc
    private func downloadButtonTap() {
        print("downloadButtonTap")
        guard let title = titlesElement else { return }
        DataPersistenceManager.shared.downloadTitleWith(with: title) { result in
            switch result {
            case.success():
                NotificationCenter.default.post(name: Notification.Name("download"), object: nil)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    private func setupUI() {
        heroImageView.frame = bounds
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        
        setupConstraints()
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame=bounds
    }
    
    private func setupConstraints() {
        heroImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(500)
        }
        playButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.leading.equalTo(heroImageView.snp.leading).offset(60)
            make.bottom.equalTo(heroImageView.snp.bottom).offset(-50)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.trailing.equalTo(heroImageView.snp.trailing).offset(-60)
            make.bottom.equalTo(heroImageView.snp.bottom).offset(-50)
        }
    }
}
