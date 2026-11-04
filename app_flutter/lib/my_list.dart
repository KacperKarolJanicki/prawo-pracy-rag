import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prawo_pracy/functions/memory.dart';

String returnedText = '';
List<dynamic> messages = [];
bool requestWaiting = false;

class Conversation extends StatefulWidget {
  final ScrollController? controller;
  const Conversation({super.key, this.controller});

  @override
  State<Conversation> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
        children: [
      SizedBox(height: 20),
      for(var row in messages)
        if(row["type"] == "request")
          Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                width: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: SelectableText(row["message"], style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 10)
            ]),
            SizedBox(height: 30)
          ]).animate().fadeIn(duration: 1.seconds)
        else if(row["type"] == "response")
          Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.start, children: [
                  MaterialButton(
                      onPressed: () {
                        setState(() {
                          row["saving"] = !row["saving"];
                        });
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        width: 250,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(150),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                            row["message"],
                            style: TextStyle(color: Colors.white)),
                      ))
                ]),
                SizedBox(height: 15),
                row['saving']
                    ? Row(
                    mainAxisAlignment: .start,
                    spacing: 15,
                    children: [
                      SizedBox.shrink(),
                      ElevatedButton(
                          onPressed: row['saved'] ? null : () {
                            Memory().saveData(saved,
                                newData: {
                                  "message": row['message'],
                                  "deleting": false,
                                  "read_more": false
                                });
                            setState(() {
                              row['saved'] = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.withAlpha(150),
                            elevation: 10,
                            minimumSize: Size(50, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(Icons.note_add)),
                    ])
                    : SizedBox.shrink(),
                SizedBox(height: 30)
          ])
              .animate()
              .fadeIn(duration: 1.5.seconds),
      requestWaiting
          ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10),
            Container(
              width: 100,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(150),
                  borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text(
                  '...', style: TextStyle(color: Colors.white))),
            )
      ]).animate().fadeIn(duration: 1.seconds)
          : SizedBox.shrink()
    ]);
  }
}
