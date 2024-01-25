//
//  SearchResultsViewController.swift
//  Movies
//
//  Created by Vitaly on 11.01.2024.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    //MARK: - GUI Variable
    public var titles: [Title] = [Title]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let searchResultsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        setupUI()
    }
    //MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        searchResultsCollectionView.frame = view.bounds
        view.addSubview(searchResultsCollectionView)
    }
}

//MARK: - UITableVieDataSource, UITableViewDelegate
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier,
                                                            for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        MoviesAPI.shared.getMovie(with: titleName) { [ weak self ]result in
            switch result {
            case.success(let videoElement):
                self?.delegate?.searchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: title.original_title ?? "",
                                                                                            youtubeView: videoElement,
                                                                                            titleOverview: title.overview ?? ""))            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
