import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:myapp/cubit/nowPlayingCubit.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/presentation/widget/cardClipper.dart';
import 'package:myapp/presentation/widget/section_head.dart';
import 'package:myapp/presentation/widget/shimmer.dart';
import 'package:myapp/presentation/widget/starrating.dart';

class NowPlayingWidget extends StatelessWidget {
  const NowPlayingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 8,
        ),
        SectionHeadingWidget(
          title: "Now Playing",
        ),
        NowPlayingList(),
        // TwoCardPageView(),
      ],
    );
  }
}

class NowPlayingList extends StatefulWidget {
  const NowPlayingList({super.key});

  @override
  State<NowPlayingList> createState() => _NowPlayingListState();
}

class _NowPlayingListState extends State<NowPlayingList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        if (state is NowPlayingLoadedState) {
          return Column(
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: 336,
                child: ListView.builder(
                    itemCount: state.moviesList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return NowPlayingCard(movie: state.moviesList[index]);
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  state.currentPage > 1
                      ? IconButton(
                          onPressed: () {
                            context
                                .read<NowPlayingCubit>()
                                .fetchNowPlayingMovies(
                                    getCached: false,
                                    page: state.currentPage - 1);
                          },
                          icon: const Icon(Icons.chevron_left))
                      : Container(),
                  Text("Page: ${state.currentPage} of ${state.totalPages}"),
                  state.currentPage != state.totalPages
                      ? IconButton(
                          onPressed: () {
                            context
                                .read<NowPlayingCubit>()
                                .fetchNowPlayingMovies(
                                    getCached: false,
                                    page: state.currentPage + 1);
                          },
                          icon: const Icon(Icons.chevron_right))
                      : Container(),
                ],
              )
            ],
          );
        }

        if (state is NowPlayingErrorState) {
          return SizedBox(
            // width: MediaQuery.of(context).size.width,
            height: 336,
            child: Column(
              children: [
                const Text("Unable to fetch Data"),
                TextButton(
                    onPressed: () {
                      context
                          .read<NowPlayingCubit>()
                          .fetchNowPlayingMovies(retry: true);
                    },
                    child: const Text("Retry"))
              ],
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 16,
                ),
                ShimmerWidget(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 336),
                const SizedBox(
                  width: 16,
                ),
                ShimmerWidget(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 336),
                const SizedBox(
                  width: 16,
                ),
                ShimmerWidget(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 336),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class NowPlayingCard extends StatelessWidget {
  final MovieModel movie;
  const NowPlayingCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double minWidth = (MediaQuery.of(context).size.width < 480
        ? MediaQuery.of(context).size.width - 64
        : 320);
    double cornerRadius = 16;
    double iconSize = 20;
    String posterPath =
        "https://image.tmdb.org/t/p/w500/${movie.posterPath ?? ""}";
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          ClipPath(
            clipper: Cardclipper(cornerRadius: cornerRadius),
            child: SizedBox(
              height: 336,
              width: minWidth,
              child: CachedNetworkImage(
                  imageUrl: posterPath,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => const ShimmerWidget(
                      width: 56, height: 336, curveRadius: 8),
                  errorWidget: (context, _, __) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 3 * cornerRadius,
                          ),
                          Icon(
                            Icons.error,
                            size: 56,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const Text("Unable to fetch image")
                        ],
                      )),
            ),
          ),
          Positioned(
              top: 4,
              left: 64,
              child: StarRating(
                  rating: (movie.voteAverage ?? 0).toStringAsFixed(2))),
          // const Positioned(
          //     top: 4, right: 16, child: StarRatingWidget(rating: "6.67")),
          Positioned(
              bottom: 0,
              left: 0,
              child: ClipPath(
                clipper: Cardclipper(cornerRadius: cornerRadius),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    height: 120,
                    width: minWidth,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(color: Colors.white),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 2 * cornerRadius,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white),
                                  Text(LocaleNames.of(context)!.nameOf(
                                          movie.originalLanguage ?? '') ??
                                      ''),
                                  SizedBox(
                                    width: 2 * cornerRadius,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              movie.title ?? movie.originalTitle ?? '',
                              maxLines: 1,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: minWidth -
                                          iconSize -
                                          2 * cornerRadius -
                                          8,
                                      child: Text(
                                        movie.overview ?? '',
                                        maxLines: 2,
                                        style: const TextStyle(fontSize: 10),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text("${movie.voteCount ?? 0} votes")
                          ]),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}