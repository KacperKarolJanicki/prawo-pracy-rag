import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

List<dynamic> saved = [];

class Memory {

  Future<String> _initialize() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (!await file.exists()) {
      await file.create();
      await file.writeAsString(jsonEncode([]));
    }

    return await file.readAsString();
  }

  Future<List<dynamic>> loadData() async {
    List<dynamic> data = jsonDecode(await _initialize());
    return data;
  }

  void saveData(List<dynamic> data, {Object? newData}) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (newData != null) {
      data.add(newData);
    }
    file.writeAsString(jsonEncode(data));
  }
}