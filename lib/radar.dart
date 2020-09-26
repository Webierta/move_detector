import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:move_detector/utils/preferencias.dart';
import 'package:sensors/sensors.dart';
import 'grafico.dart';
//import 'package:flutter/services.dart' show HapticFeedback;

class Radar extends StatefulWidget {
  Radar({Key key}) : super(key: key);

  @override
  _RadarState createState() => _RadarState();
}

class _RadarState extends State<Radar> {
  // estados
  bool _onAlarma = false;
  bool _parada = false;
  bool _sensor = true;
  // sensor
  UserAccelerometerEvent event;
  Timer timer;
  StreamSubscription accel;
  int count = 0;
  // preferencias
  bool _alarmaStop;
  bool _sonido;
  String _file;
  //sonido
  bool _isPlaying = false;
  AudioPlayer audioPlayer;

  @override
  initState() {
    super.initState();
    _getPreferencias();
    audioPlayer = AudioPlayer();
  }

  _getPreferencias() async {
    var alarmaStop = await Pref.getPref(Pref.stopping.titulo);
    var sonidoValor = await Pref.getPref(Pref.sonido.titulo);
    var file = await Pref.getFile();
    setState(() {
      _alarmaStop = alarmaStop;
      _sonido = sonidoValor;
      _file = file;
    });
  }

  // START AUDIO
  playAudio() async {
    int response = await audioPlayer.play(_file, isLocal: true);
    if (response == 1) {
      setState(() => _isPlaying = true);
    } else {
      print('Some error occured in playing from storage!');
    }
  }

  pauseAudio() async {
    if (_isPlaying) {
      int response = await audioPlayer.pause();
      if (response == 1) {
        setState(() => _isPlaying = false);
      } else {
        print('Some error occured in pausing');
      }
    }
  }

  stopAudio() async {
    if (_isPlaying) {
      int response = await audioPlayer.stop();
      if (response == 1) {
        setState(() => _isPlaying = false);
      } else {
        print('Some error occured in stopping');
      }
    }
  }

  resumeAudio() async {
    if (!_isPlaying) {
      int response = await audioPlayer.resume();
      if (response == 1) {
        setState(() => _isPlaying = true);
      } else {
        print('Some error occured in resuming');
      }
    }
  }
  // END AUDIO

  appOn() {
    accel ??= userAccelerometerEvents.listen((UserAccelerometerEvent ev) {
      setState(() => event = ev);
    }); //accel.resume(); // ??
    if ((timer == null || !timer.isActive)) {
      timer = Timer.periodic(Duration(milliseconds: 200), (_) {
        if (event == null) {
          setState(() => _sensor = false);
        } else {
          setState(() => _sensor = true);
        }
        if (_sensor) {
          if (event.x.abs() < 0.01 && event.y.abs() < 0.01 && event.z.abs() < 0.01) {
            count++;
            if (count > 3) {
              if (_sonido && !_alarmaStop) {
                pauseAudio();
              }
              if (_sonido && _alarmaStop) {
                playAudio();
              }
              setState(() => _parada = true);
            }
          } else {
            count = 0;
            if (_sonido && _alarmaStop) {
              pauseAudio();
            }
            if (_sonido && !_alarmaStop) {
              playAudio();
            }
            setState(() => _parada = false);
          }
        }
      });
    }
  }

  appOff() {
    stopAudio(); //audioPlayer = null;
    //sonido?.stopAudio();
    timer?.cancel();
    accel?.pause();
    accel?.cancel();
    setState(() {
      _onAlarma = false;
      _parada = false;
      count = 0;
      event = null;
      accel = null;
      timer = null;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    accel?.cancel();
    stopAudio(); //audioPlayer = null;
    //sonido.stopAudio();

    _sensor = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Text mensajeText() {
      if (_onAlarma == false) {
        return Text('Off', style: Theme.of(context).textTheme.headline3);
      }
      if (_sensor == false) {
        return Text('Disabled!', style: Theme.of(context).textTheme.headline3);
      }
      if (_onAlarma && _parada) {
        return Text('Stopped!', style: Theme.of(context).textTheme.headline4);
      }
      if (_onAlarma && !_parada) {
        return Text('Motion detected!', style: Theme.of(context).textTheme.headline4);
      }
      return Text('Unexpected result');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Stop Detector'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              appOff();
              Navigator.pushReplacementNamed(context, '/ajustes');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
              child: FractionallySizedBox(
                widthFactor: 0.9,
                heightFactor: 0.5,
                child: Container(
                  child: Opacity(
                    opacity: _onAlarma && _sensor ? 1.0 : 0.0,
                    child: Image.asset(
                        _parada ? 'assets/images/imgStop.png' : 'assets/images/compass.gif'),
                  ),
                ),
              ),
            ),
            mensajeText(),
            graficoPaint(),
            //controlPref(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _getPreferencias();
          setState(() => _onAlarma = !_onAlarma);
          _onAlarma ? appOn() : appOff();
        },
        child: Icon(
          _onAlarma ? Icons.power_settings_new : Icons.explore,
          size: 48.0,
        ),
      ),
    );
  }

  Widget graficoPaint() {
    if (_onAlarma == false) return Text('Motion Sensors Reading Disabled');
    if (_sensor == false) return Text('Motion sensors not detected!');

    var x = event?.x ?? 0.0;
    var y = event?.y ?? 0.0;
    var z = event?.z ?? 0.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Text('Motion Sensors Reading Enabled'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: CustomPaint(
                  painter: Grafico(valorX: x, valorY: y, valorZ: z),
                  //child: Text('Motion Sensors'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'X: ${event?.x?.toStringAsFixed(4)}',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      Text(
                        'Y: ${event?.y?.toStringAsFixed(4)}',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                      Text(
                        'Z: ${event?.z?.toStringAsFixed(4)}',
                        style: TextStyle(color: Colors.green[600]),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
