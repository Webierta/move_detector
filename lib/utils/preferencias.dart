import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:move_detector/utils/files.dart' as Asset;
import 'package:path/path.dart';

class Pref {
  String titulo;
  bool valor;
  IconData icono;

  static String file;
  static String fileName;
  static String fileExplorer = '';

  Pref({this.titulo, this.icono, this.valor = true});

  static Pref stopping = Pref(titulo: 'Stopping');

  static Pref sonido = Pref(
    titulo: 'Sound',
    icono: Icons.volume_up,
  );

  /* static Pref vibrate = Pref(
    titulo: 'Vibrate',
    icono: Icons.vibration,
  ); */

  static Future<bool> getPref(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  static setPref(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static getFile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /* var file = prefs.getString('File');
    if (file == null) {
      var asset = await Asset.getAsset();
      return asset;
    }
    return file; */
    var file = prefs.getString('File') ?? await Asset.getAsset();
    setFileName(file);
    return file;
    //return prefs.getString('File') ?? await Asset.getAsset();
  }

  static setFile(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('File', value);
    fileExplorer = '';
  }

  static setFileName(String file) {
    if (basename(file) == 'beep.mp3' || basename(file) == 'ambulance.mp3') {
      fileName = basename(file);
    } else {
      fileName = 'File explorer';
      fileExplorer = basename(file);
    }
  }
}
