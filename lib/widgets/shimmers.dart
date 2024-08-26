import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class SingleBoxShimmer extends StatelessWidget {
  const SingleBoxShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 250.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SingleLineShimmer extends StatelessWidget {
  const SingleLineShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 12,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20.0,
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 5.0),
            ),
          ),
        ),
      ],
    );
  }
}
