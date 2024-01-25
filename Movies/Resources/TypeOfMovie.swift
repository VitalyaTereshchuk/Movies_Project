//
//  TypeOfMovie.swift
//  Movies
//
//  Created by Vitaly on 22.01.2024.
//

import Foundation

enum SectionsName {
    case trending_movie,
         trending_tv,
         popular_movie,
         upcoming_movie,
         top_rated_movie,
         Discover
}

enum SectionsNameRawValue: Int {
    case trending_movie = 0
    case trending_tv = 1
    case popular_movie = 2
    case upcoming_movie = 3
    case top_rated_movie = 4
}
