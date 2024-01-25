//
//  TitlePreviewViewController.swift
//  Movies
//
//  Created by Vitaly on 11.01.2024.
//
import WebKit
import SnapKit
import UIKit

class TitlePreviewViewController: UIViewController {
    
    private var youtubePreviewViewModel: TitlePreviewViewModel?
    
    //MARK: - GUI Variables
    private let webView: WKWebView = {
        var webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        
        return label
    }()
    
    private let overViewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "This is the best movie ever to watch as a kid!"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        return button
    }()
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Privat methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        
//        downloadButton.addTarget(TitlePreviewViewController.self, action: #selector(didTapButton), for: .touchUpInside)
        
        setupConstraints()
    }
    
//    @objc
//    private func didTapButton() {
//        
//    }
    
    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overViewLabel.text = model.titleOverview
        youtubePreviewViewModel = model
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(350)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        overViewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(overViewLabel.snp.bottom).offset(25)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
}
