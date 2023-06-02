import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  final String image;
  const FullImage({super.key,required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Full Image",
        ),
        centerTitle: true,
      ),
      body: Image.network(image),
    );
  }
}
