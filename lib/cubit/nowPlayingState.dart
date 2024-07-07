

part of 'nowPlayingCubit.dart';



@immutable
sealed class NowPlayingState {}

final class NowPlayingLoadingState extends NowPlayingState {}

final class NowPlayingEmptyState extends NowPlayingState {}

class NowPlayingLoadedState extends NowPlayingState {
  final List<MovieModel> moviesList;
  final int totalPages;
  final int currentPage;
  NowPlayingLoadedState(this.moviesList, this.totalPages, this.currentPage);
}

class NowPlayingErrorState extends NowPlayingState {
  final String error;
  NowPlayingErrorState(this.error);
}