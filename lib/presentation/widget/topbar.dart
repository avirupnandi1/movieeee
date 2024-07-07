
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:myapp/cubit/nowPlayingCubit.dart';
import 'package:myapp/presentation/widget/cardClipper.dart';

class topWidget extends StatelessWidget {
  const topWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Stack(
        children: [
          ClipPath(
            clipper: Cardclipper(cornerRadius: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFFB6A0A4),
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width - 32,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      "We Movies",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    BlocBuilder<NowPlayingCubit, NowPlayingState>(
                      builder: (context, state) {
                        String movieCount = (state is NowPlayingLoadedState)
                            ? (state.moviesList.length.toString())
                            : "--";
                        return Text(
                            "$movieCount movies are loaded in now playing");
                      },
                    )
                  ]),
            ),
          ),
          Positioned(
            top: 4,
            left: 16,
            child: Text(
              DateFormat('dd MMM yyyy').format(DateTime.now()).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}