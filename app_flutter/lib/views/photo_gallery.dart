import 'dart:io';
import 'package:flutter/material.dart';
import 'notebook.dart';

String currentPath = '';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});
  @override
  State<PhotoGallery> createState() => PhotoGalleryState();
}

class PhotoGalleryState extends State<PhotoGallery> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsetsGeometry.directional(top: MediaQuery
            .of(context)
            .size
            .height / 17),
        child: SingleChildScrollView(
            child: Wrap(children: [
              for(var path in paths)
                MaterialButton(
                    materialTapTargetSize: .shrinkWrap,
                    padding: EdgeInsets.zero,
                    splashColor: Colors.transparent,
                    highlightColor: Colors
                        .transparent,
                    onPressed: () {
                      currentPath = path;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewPhoto()));
                    },
                    child: Image.file(
                        File(path), width: MediaQuery
                        .of(context)
                        .size
                        .width / 4)
                )
            ])));
  }
}

class ViewPhoto extends StatelessWidget {
  const ViewPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Image.file(File(currentPath)));
  }
}