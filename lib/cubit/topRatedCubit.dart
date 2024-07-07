import 'package:bloc/bloc.dart';
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3463638548.
import 'package:meta/meta.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/network/appcache.dart';
import 'package:myapp/repository/movie_repo.dart';

part 'topRatedState.dart';

class TopRatedCubit extends Cubit<TopRatedState> {
  TopRatedCubit() : super(TopRatedLoadingState()) {
    fetchTopRatedMovies();
  }
  MovieRepository movieRepository = MovieRepository();

  void fetchTopRatedMovies(
      {bool retry = false, bool getCached = true, int page = 1}) async {
    try {
      if (retry) {
        emit(TopRatedLoadingState());
      }
      List<MovieModel> movies = await movieRepository.fetchTopRatedMovies(
          getCached: getCached, page: page);
      emit(TopRatedLoadedState(movies, AppCacheService().topPages, page));
    } catch (ex) {
      emit(TopRatedErrorState(""));
    }
  }
}