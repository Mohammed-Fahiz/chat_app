import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CustomImagePopUpBox extends StatelessWidget {
  final String imageUrl;

  const CustomImagePopUpBox({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Dialog(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ZoomableImage(imageUrl),
                ),
              );
            },
            child: Image.network(
              imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(5),
                child: Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: Colors.white,
                  size: h * .04,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZoomableImage extends StatelessWidget {
  final String imageUrl;

  const ZoomableImage(this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Zoom View',
          style: TextStyle(fontFamily: 'Urbanist', fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: PhotoView(
            imageProvider: NetworkImage(imageUrl),
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
            minScale: PhotoViewComputedScale.contained * 1.0),
      ),
    );
  }
}
