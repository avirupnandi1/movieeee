


import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/cubit/topRatedCubit.dart';
import 'package:myapp/models/movieModel.dart';
import 'package:myapp/presentation/widget/section_head.dart';
import 'package:myapp/presentation/widget/shimmer.dart';
import 'package:myapp/presentation/widget/starrating.dart';

class TopRatedWidget extends StatelessWidget {
  const TopRatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 8,
        ),
        SectionHeadingWidget(
          title: "Top Rated",
        ),
        TopRatedList(),
      ],
    );
  }
}

class TopRatedList extends StatefulWidget {
  const TopRatedList({super.key});

  @override
  State<TopRatedList> createState() => _TopRatedListState();
}

class _TopRatedListState extends State<TopRatedList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopRatedCubit, TopRatedState>(
      builder: (context, state) {
        if (state is TopRatedLoadedState) {
          // return SizedBox(
          //   // width: MediaQuery.of(context).size.width,
          //   height: 336,
          //   child: ListView.builder(
          //       itemCount: state.moviesList.length,
          //       scrollDirection: Axis.horizontal,
          //       itemBuilder: (context, index) {
          //         return Text(state.moviesList[index].originalTitle ?? "");
          //       }),
          // );
          return Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.moviesList.length,
                  itemBuilder: (context, index) {
                    return TopRatedCard(movie: state.moviesList[index]);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  state.currentPage > 1
                      ? IconButton(
                          onPressed: () {
                            context.read<TopRatedCubit>().fetchTopRatedMovies(
                                getCached: false, page: state.currentPage - 1);
                          },
                          icon: const Icon(Icons.chevron_left))
                      : Container(),
                  Text("Page: ${state.currentPage} of ${state.totalPages}"),
                  state.currentPage != state.totalPages
                      ? IconButton(
                          onPressed: () {
                            context.read<TopRatedCubit>().fetchTopRatedMovies(
                                getCached: false, page: state.currentPage + 1);
                          },
                          icon: const Icon(Icons.chevron_right))
                      : Container(),
                ],
              ),
            ],
          );
        }

        if (state is TopRatedErrorState) {
          return Column(
            children: [
              SizedBox(
                // width: MediaQuery.of(context).size.width,
                height: 336,
                child: Column(
                  children: [
                    const Text("Unable to fetch Data"),
                    TextButton(
                        onPressed: () {
                          context
                              .read<TopRatedCubit>()
                              .fetchTopRatedMovies(retry: true);
                        },
                        child: const Text("Retry"))
                  ],
                ),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                ShimmerWidget(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 336),
                const SizedBox(
                  height: 16,
                ),
                ShimmerWidget(
                    width: (MediaQuery.of(context).size.width * 0.75),
                    height: 336),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TopRatedCard extends StatelessWidget {
  final MovieModel movie;
  const TopRatedCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    double minWidth = min(MediaQuery.of(context).size.width - 40, 540);
    double iconSize = 20;
    String posterPath =
        "https://image.tmdb.org/t/p/w500/${movie.backdropPath ?? ""}";
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(32))),
      // height: 360,
      width: minWidth,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
            child: CachedNetworkImage(
                imageUrl: posterPath,
                height: MediaQuery.of(context).size.height / 3,
                // width: 320,
                fit: BoxFit.cover,
                placeholder: (context, url) => ShimmerWidget(
                    width: minWidth,
                    height: MediaQuery.of(context).size.height / 3,
                    curveRadius: 8),
                errorWidget: (context, _, __) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 56,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const Text("Unable to fetch image")
                      ],
                    )),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            // height: 120,
            // width: minWidth,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                movie.title ?? movie.originalTitle ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: iconSize,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: minWidth - 56,
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
              IntrinsicHeight(
                child: Row(
                  children: [
                    Text("${movie.voteCount ?? 0} votes"),
                    const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: VerticalDivider(),
                    ),
                    StarRating(
                        rating: (movie.voteAverage ?? 0).toStringAsFixed(2))
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}