import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prawo_pracy/views/notebook.dart';

class ViewPhoto extends StatelessWidget {
  const ViewPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Image.file(File(currentPath)));
  }
}
