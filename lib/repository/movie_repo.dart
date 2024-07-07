
import 'package:dio/dio.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/network/appcache.dart';
import 'package:myapp/network/constant.dart';
import 'package:myapp/network/httpclient.dart';

class MovieRepository {
  HttpClient httpCLient = HttpClient();

  Future<List<MovieModel>> fetchNowPlayingMovies(
      {bool getCached = true, int page = 1}) async {
    try {
      if (getCached) {
        List<MovieModel> cachedMovies =
            await AppCacheService().getCachedNowMovies();
        if (cachedMovies.isNotEmpty) return cachedMovies;
      }
      Response response = await httpCLient.sendRequest
          .get("movie/now_playing?language=en-US&page=$page");
      List<dynamic> postMaps = response.data['results'];
      // int totalMovieCount = response.data['total_results'];
      int totalPages = response.data['total_pages'];
      List<MovieModel> finalMovies =
          postMaps.map((postMap) => MovieModel.fromJson(postMap)).toList();
      await AppCacheService().setCachedMovies(
          NOW_PLAYING_DB_KEY, finalMovies, totalPages,
          updateDb: page == 1);
      return finalMovies;
    } catch (ex) {
      rethrow;
    }
  }

  Future<List<MovieModel>> fetchTopRatedMovies(
      {bool getCached = true, int page = 1}) async {
    try {
      if (getCached) {
        List<MovieModel> cachedMovies =
            await AppCacheService().getCachedTopMovies();
        if (cachedMovies.isNotEmpty) return cachedMovies;
      }
      Response response = await httpCLient.sendRequest
          .get("movie/top_rated?language=en-US&page=$page");
      List<dynamic> postMaps = response.data['results'];
      int totalPages = response.data['total_pages'];
      // int totalMovieCount = response.data['total_results'];
      List<MovieModel> finalMovies =
          postMaps.map((postMap) => MovieModel.fromJson(postMap)).toList();
      await AppCacheService().setCachedMovies(
          TOP_RATED_DB_KEY, finalMovies, totalPages,
          updateDb: page == 1);
      return finalMovies;
    } catch (ex) {
      rethrow;
    }
  }
}