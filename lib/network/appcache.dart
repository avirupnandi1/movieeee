import 'package:flutter/foundation.dart';
import 'package:json_store/json_store.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/network/constant.dart';
class AppCacheService {
  static final AppCacheService _singleton = AppCacheService._internal();

  factory AppCacheService() {
    return _singleton;
  }

  final JsonStore _jsonStore = JsonStore(dbName: CACHED_DB);
  List<MovieModel> nowPlayingMovies = [];
  List<MovieModel> topRatedMovies = [];
  int topPages = 0;
  int nowPlayingPages = 0;

  AppCacheService._internal();

  Future<List<MovieModel>> getCachedNowMovies() async {
    if (nowPlayingMovies.isNotEmpty) return nowPlayingMovies;
    // fetch from db
    Map<String, dynamic>? nowMoviesDb =
        await _jsonStore.getItem(NOW_PLAYING_DB_KEY);
    if (nowMoviesDb != null) {
      // data is present in db
      try {
        List<dynamic> tempMovies = (nowMoviesDb['data']);
        int totalPages = (nowMoviesDb['totalPages']);
        List<MovieModel> movies =
            tempMovies.map((e) => MovieModel.fromJson(e)).toList();
        nowPlayingMovies = movies;
        nowPlayingPages = totalPages;
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }
    return nowPlayingMovies;
  }

  Future<List<MovieModel>> getCachedTopMovies() async {
    if (topRatedMovies.isNotEmpty) return topRatedMovies;
    // fetch from db
    Map<String, dynamic>? nowMoviesDb =
        await _jsonStore.getItem(TOP_RATED_DB_KEY);
    if (nowMoviesDb != null) {
      // data is present in db
      try {
        List<dynamic> tempMovies = (nowMoviesDb['data']);
        int totalPages = (nowMoviesDb['totalPages']);
        List<MovieModel> movies =
            tempMovies.map((e) => MovieModel.fromJson(e)).toList();
        topRatedMovies = movies;
        topPages = totalPages;
      } catch (ex) {
        if (kDebugMode) {
          print(ex);
        }
      }
    }
    return topRatedMovies;
  }

  Future setCachedMovies(String key, List<MovieModel> movies, int totalPages,
      {bool updateDb = true}) async {
    Map<String, dynamic> cachedData = {
      // 'totalCuunt': totalCount,
      'totalPages': totalPages,
      'data': movies
    };
    if (key == TOP_RATED_DB_KEY) {
      topRatedMovies = movies;
      topPages = totalPages;
    } else {
      nowPlayingMovies = movies;
      nowPlayingPages = totalPages;
    }
    if (updateDb) {
      await _jsonStore.setItem(key, cachedData);
    }
  }

  Map<String, List<MovieModel>> searchMovies(String searchQuery) {
    Map<String, List<MovieModel>> result = {'now': [], 'top': []};
    if (searchQuery.isEmpty) return result;
    // searching in now playing
    List<MovieModel> nowPlayingSearch = nowPlayingMovies
        .where((element) => ((element.title ?? '')
            .toLowerCase()
            .contains(searchQuery.toLowerCase())))
        .toList();
    List<MovieModel> topPlayingSearch = topRatedMovies
        .where((element) => ((element.title ?? '').contains(searchQuery)))
        .toList();
    // searching in topRated
    result = {'now': nowPlayingSearch, 'top': topPlayingSearch};
    return result;
  }
}