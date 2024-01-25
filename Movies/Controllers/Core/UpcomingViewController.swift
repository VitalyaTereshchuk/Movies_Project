//
//  UpcomingViewController.swift
//  Movies
//
//  Created by Vitaly on 05.01.2024.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    //MARK: - GUI Variables
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return table
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        upcomingTable.frame = view.bounds
        
        view.addSubview(upcomingTable)
        
        fetchUpcoming()
    }
    
    private func fetchUpcoming() {
        MoviesAPI.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case.success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - UITableVieDataSource, UITableViewDelegate
extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title =  titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Upcoming title name",
                                            posterURL: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else {
            return
        }
        MoviesAPI.shared.getMovie(with: titleName) { [ weak self ]result in
            switch result {
            case.success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName,
                                                             youtubeView: videoElement,
                                                             titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
