import 'package:flutter/material.dart';
import 'package:prawo_pracy/functions/memory.dart';

class Notebook extends StatefulWidget {
  const Notebook({super.key});

  @override
  State<Notebook> createState() => _NotebookState();
}

class _NotebookState extends State<Notebook> {

  void loadNotes() async {
    saved = await Memory().loadData();
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Twoje notatki'),
          centerTitle: true),
      body: ListView(children: [
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
                onPressed: (){
                  setState(() {
                    row['read_more'] = !row['read_more'];
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
                      style: TextStyle(color: Colors.white), maxLines: row['read_more']? null : 7),
                )),
            row['deleting'] ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    saved.remove(row);
                  });
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
                child: Icon(Icons.delete)) : SizedBox.shrink(),
            SizedBox.shrink()
          ])
      ]),
    );
  }
}
