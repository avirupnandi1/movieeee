import 'package:flutter/material.dart';

class ShimmerWidget extends StatefulWidget {
  final double width;
  final double height;
  final double curveRadius;

  const ShimmerWidget(
      {super.key,
      required this.width,
      required this.height,
      this.curveRadius = 0});

  @override
  // ignore: library_private_types_in_public_api
  _ShimmerWidgetState createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation? gradientPosition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    )..addListener(_gradientChangeListener);

    _controller.repeat();
  }

  _gradientChangeListener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.curveRadius),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(gradientPosition?.value, 0),
              end: const Alignment(-1, 0),
              colors: [
                Theme.of(context).unselectedWidgetColor.withOpacity(0.08),
                Theme.of(context).unselectedWidgetColor.withOpacity(0.16),
                Theme.of(context).unselectedWidgetColor.withOpacity(0.08),
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    gradientPosition?.removeListener(_gradientChangeListener);
    super.dispose();
  }
}

class ShimmerList extends StatelessWidget {
  final double height;
  final int itemsCount;
  final double itemsGap;
  const ShimmerList(
      {Key? key, this.height = 80, this.itemsCount = 4, this.itemsGap = 16})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemsCount + (itemsCount - 1),
        (index) => index % 2 == 0
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: height,
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ShimmerWidget(
                              width: height - 32,
                              height: height - 32,
                              curveRadius: 8),
                          const Flexible(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                children: [
                                  ShimmerWidget(
                                    width: double.infinity,
                                    height: 24,
                                    curveRadius: 4,
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: ShimmerWidget(
                                          width: double.infinity,
                                          height: 16,
                                          curveRadius: 4,
                                        ),
                                      ),
                                      SizedBox(width: 48)
                                    ],
                                  ),
                                  Spacer(flex: 1)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16)
                        ],
                      )),
                ),
              )
            : SizedBox(height: itemsGap),
      ),
    );
  }
}