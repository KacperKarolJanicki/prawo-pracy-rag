import 'dart:io';
import 'package:adaptive_ad_banner/adaptive_ad_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prawo_pracy/functions/memory.dart';
import '../main.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Twoje notatki'),
          centerTitle: true),
      body: ListView(children: [
        AdaptiveAdBanner(adUnitId: adUnitId),
        SizedBox(height: 10),
        for(var row in saved)
          Column(
              spacing: 10,
              children: [
                MaterialButton(
                    onLongPress: () {
                      setState(() {
                        row["deleting"] = !row["deleting"];
                      });
                    },
                    onPressed: () {
                      setState(() {
                        row['read_more'] = !row['read_more'];
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(150),
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                          row["message"],
                          style: TextStyle(color: Colors.white),
                          maxLines: row['read_more'] ? null : 7),
                    )),
                row['deleting']
                    ? Row(
                  spacing: 10,
                    mainAxisAlignment: .center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              saved.remove(row);
                            });
                            if(row['path']!=null) {File(row['path']).delete();}
                            Memory().saveData(saved);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withAlpha(150),
                            elevation: 10,
                            minimumSize: Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.delete)),
                      ElevatedButton(
                          onPressed: row['path']==null
                              ? () async {
                            try {
                              row['path'] = await Memory()
                                  .savePhoto(Photo.fromCamera)
                                  .whenComplete(() {
                                setState(() {
                                  Memory().saveData(saved);
                                });
                              });
                            } catch (e) {
                              return;
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withAlpha(150),
                            elevation: 10,
                            minimumSize: Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.camera_alt)),
                      ElevatedButton(
                          onPressed: row['path']==null
                              ? () async {
                            try {
                              row['path'] = await Memory()
                                  .savePhoto(Photo.fromGallery)
                                  .whenComplete(() {
                                setState(() {
                                  Memory().saveData(saved);
                                });
                              });
                            } catch (e) {
                              return;
                            }
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withAlpha(150),
                            elevation: 10,
                            minimumSize: Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.add_photo_alternate)),
                      ElevatedButton(
                          onPressed: row['path']!=null ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.blue.withAlpha(100),
                                    duration: 20.seconds,
                                    elevation: 10,
                                    behavior: SnackBarBehavior.floating,
                                    content: Center(child: Image.file(
                                        File(row['path']), width: 200))));
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withAlpha(150),
                            elevation: 10,
                            minimumSize: Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.attachment)),
                ])
                    : SizedBox.shrink(),
          ])
      ]),
    );
  }
}
