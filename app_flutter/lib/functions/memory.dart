import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:prawo_pracy/functions/attachments.dart';

List<dynamic> saved = [];
enum Photo {fromCamera, fromGallery}

class Memory extends Attachments {

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
    await file.writeAsString(jsonEncode(data));
  }

  Future<String> savePhoto(Photo location) async {

    late File photo;
    final directory = await getApplicationDocumentsDirectory();

    if (location == Photo.fromCamera) {
      photo = await fromCamera();
    } else if (location == Photo.fromGallery) {
      photo = await fromGallery();
    }

    File insideAppPhoto = await photo.copy('${directory.path}/photo${DateTime.now().millisecondsSinceEpoch}.jpg');
    return insideAppPhoto.path;
  }
}