//
//  HomeViewController.swift
//  Movies
//
//  Created by Vitaly on 05.01.2024.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionsTitles: [String] = ["Trending Movies", "Trending tv", "Popular", "Upcoming Movies", "Top rated"]
    
    //MARK: - GUI Variables
    private var randomTrendingMovie: Title?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self,
                       forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        
        return table
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureHeroHeaderView()
        configureNavbar()
    }
    
    //MARK: - Privat methods
    private func configureHeroHeaderView() {
        let homeHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 510))
        homeHeaderView.delegate = self
        
        MoviesAPI.shared.getTrendingMovies { [ weak self ] result in
            switch result{
            case.success(let data):
                guard let random = data.randomElement() else { return }
                guard let posterPath = random.poster_path else { return }
                DispatchQueue.main.async {
                    homeHeaderView.config(with: random)
                    self?.homeFeedTable.tableHeaderView = homeHeaderView
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavbar() {
        var image = UIImage(named: "movieLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(pushMovieLogo))
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    //MARK: - Methods
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    @objc func pushMovieLogo() {
        let homeViewController = HomeViewController()
        navigationController?.pushViewController(homeViewController, animated: false)
    }
}

//MARK: - UITableVieDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            MoviesAPI.shared.getTrendingMovies { result in
                switch result {
                case.success(let titles):
                    cell.configure(with: titles)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTV.rawValue:
            MoviesAPI.shared.getTrendingTVs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            MoviesAPI.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            MoviesAPI.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            MoviesAPI.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: HomeHeaderUIViewDelegate {
    func homeHeaderUIViewDidTapCell(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            print(viewModel.youtubeView)
            let vc=TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
