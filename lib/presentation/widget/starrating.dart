import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StarRating extends StatelessWidget {
  final String rating;
  const StarRating({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          rating,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          width: 4,
        ),
        SvgPicture.asset('assets/images/star.svg',
            height: 12,
            colorFilter:
                const ColorFilter.mode(Colors.yellowAccent, BlendMode.srcIn))
      ],
    );
  }
}