
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/network/appcache.dart';
import 'package:myapp/repository/movie_repo.dart';

part 'nowPlayingState.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingLoadingState()) {
    fetchNowPlayingMovies();
  }
  MovieRepository movieRepository = MovieRepository();

  void fetchNowPlayingMovies(
      {bool retry = false, bool getCached = true, int page = 1}) async {
    try {
      if (retry) {
        emit(NowPlayingLoadingState());
      }
      List<MovieModel> movies = await movieRepository.fetchNowPlayingMovies(
          getCached: getCached, page: page);
      emit(NowPlayingLoadedState(
          movies, AppCacheService().nowPlayingPages, page));
    } catch (ex) {
      emit(NowPlayingErrorState(""));
    }
  }
}