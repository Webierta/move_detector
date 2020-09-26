import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:move_detector/utils/files.dart' as Asset;
import 'package:move_detector/utils/preferencias.dart';

class Ajustes extends StatefulWidget {
  Ajustes({Key key}) : super(key: key);

  @override
  _AjustesState createState() => _AjustesState();
}

class _AjustesState extends State<Ajustes> {
  //bool stop;
  String _fileItem;
  String _fileExplorer = '';

  @override
  void initState() {
    super.initState();
    _cargarPreferencias();
  }

  _cargarPreferencias() async {
    var stopping = await Pref.getPref(Pref.stopping.titulo);
    var sonidoValor = await Pref.getPref(Pref.sonido.titulo);
    var file = await Pref.getFile();
    setState(() {
      Pref.stopping.valor = stopping;
      Pref.sonido.valor = sonidoValor;
      Pref.file = file;
      _fileItem = Pref.fileName;
      _fileExplorer = Pref.fileExplorer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      body: Column(
        children: [
          //Flexible(child: FractionallySizedBox(heightFactor: 0.2)),
          SizedBox(height: 20.0),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: SwitchListTile(
              title: Pref.stopping.valor == true ? Text('Stopping') : Text('Moving'),
              subtitle: Text('Alarm when'),
              value: Pref.stopping.valor,
              inactiveThumbColor: Colors.blue,
              inactiveTrackColor: Colors.blue[200],
              onChanged: (bool value) async {
                Pref.setPref(Pref.stopping.titulo, value);
                await _cargarPreferencias();
              },
              secondary: Pref.stopping.valor == true ? Icon(Icons.stop) : Icon(Icons.play_arrow),
            ),
          ),
          Divider(indent: 50.0, endIndent: 50.0),
          checkbox(Pref.sonido),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text('Select audio:'),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    //color: Colors.blue[50],
                    border: Border.all(),
                  ),
                  child: Stack(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _fileItem,
                          onChanged: (String newValue) async {
                            setState(() => _fileItem = newValue);
                            String path = (newValue == 'beep.mp3' || newValue == 'ambulance.mp3')
                                ? await Asset.getAsset(file: newValue)
                                : await FilePicker.getFilePath(type: FileType.audio);
                            Pref.setFile(path);
                            await _cargarPreferencias();
                          },
                          items: <String>['beep.mp3', 'ambulance.mp3', 'File explorer']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Positioned(bottom: 0.0, child: Text(_fileExplorer)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(indent: 50.0, endIndent: 50.0),
          //checkbox(Pref.vibrate),
        ],
      ),
    );
  }

  Widget checkbox(Pref pref) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: CheckboxListTile(
        title: Text(
          pref.titulo,
          //style: Theme.of(context).textTheme.headline5,
        ),
        secondary: Icon(pref.icono),
        value: pref.valor,
        onChanged: (value) async {
          Pref.setPref(pref.titulo, value);
          await _cargarPreferencias();
        },
      ),
    );
  }
}
