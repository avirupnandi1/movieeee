part of 'topRatedCubit.dart';

@immutable
sealed class TopRatedState {}

final class TopRatedLoadingState extends TopRatedState {}

final class TopRatedEmptyState extends TopRatedState {}

class TopRatedLoadedState extends TopRatedState {
  final List<MovieModel> moviesList;
  final int totalPages;
  final int currentPage;
  TopRatedLoadedState(this.moviesList, this.totalPages, this.currentPage);
}

class TopRatedErrorState extends TopRatedState {
  final String error;
  TopRatedErrorState(this.error);
}