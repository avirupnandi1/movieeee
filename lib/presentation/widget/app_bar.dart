import 'package:flutter/material.dart';
import 'package:myapp/models/user_address_model.dart';


class WeAppBar extends PreferredSize {
  final double bottomHeight;
  final double titleHeight;
  final UserAddressModel? userAddress;
  final VoidCallback? onTap;
  final String title;

  WeAppBar(
    BuildContext context, {
    Key? key,
    required this.titleHeight,
    required this.bottomHeight,
    required this.userAddress,
    this.onTap,
    this.title = '',
  }) : super(
          key: key,
          preferredSize: Size.fromHeight(titleHeight + (bottomHeight)),
          child: Container(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined),
                          Text(
                            userAddress?.mainAdress ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Text(
                          userAddress?.secondaryAdress ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                CircleAvatar(
  radius: 19,
  backgroundImage: AssetImage("assets/we.png"),
)
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(bottomHeight),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(96),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.20),
                        spreadRadius: 4,
                        blurRadius: 16,
                        offset:
                            const Offset(0, 0), // changes position of shadow
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Material(
                      child: InkWell(
                        onTap: onTap,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .dividerColor
                                                .withOpacity(0.56)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
}