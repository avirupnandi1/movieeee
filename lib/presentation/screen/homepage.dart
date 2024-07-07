import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/cubit/nowPlayingCubit.dart';
import 'package:myapp/cubit/topRatedCubit.dart';
import 'package:myapp/presentation/widget/now_playing.dart';
import 'package:myapp/presentation/widget/topbar.dart';
import 'package:myapp/presentation/widget/toprated.dart';

class WeMoviesPage extends StatefulWidget {
  const WeMoviesPage({super.key});

  @override
  State<WeMoviesPage> createState() => _WeMoviesPageState();
}

class _WeMoviesPageState extends State<WeMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<NowPlayingCubit>(context)
            .fetchNowPlayingMovies(getCached: false);
        BlocProvider.of<TopRatedCubit>(context)
            .fetchTopRatedMovies(getCached: false);
        return;
      },
      child: const SingleChildScrollView(
        child: Column(
          children: [topWidget(),NowPlayingWidget(), TopRatedWidget()],
        ),
      ),
    );
  }
}
