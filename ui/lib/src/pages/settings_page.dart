import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertex_ui/src/models/settings_model.dart';

/// Passing settings in from main.dart
/// Stateful widget receives data
/// It hands off data to Stateless widget
/// Stateless widget creates the widget from the data
/// It then passes it back to Stateful, who return the built widget
class SettingsPage extends StatefulWidget {
  // Immutable data -- Sort of.. this is the hand over, essentially just a temp ?
  final String title;
  final Settings settings;

  // Constructor
  SettingsPage({this.title, this.settings});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  String _audioInput;
  String _audioOutput;
  double _audioInputSensitivity;
  String _videoInput;
  bool _audioInputIsMute;
  bool _audioOutputIsMute;

  List<bool> _audioInputIsSelected = [true, false];
  List<bool> _audioOutputIsSelected = [true, false];

  /// -- Init State --
  @override
  void initState() {
    super.initState();
    restore();
  }

  /// -- Dispose --
  @override
  void dispose() {
    super.dispose();
  }

  // https://codingwithjoe.com/flutter-saving-and-restoring-with-sharedpreferences/
  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  // https://codingwithjoe.com/flutter-saving-and-restoring-with-sharedpreferences/
  restore() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      _audioInput = (sharedPrefs.getString('audioInput') ?? 'None Selected');
      _audioOutput = (sharedPrefs.getString('audioOutput') ?? 'None Selected');
      _audioInputSensitivity = (sharedPrefs.getDouble('audioInputSensitivity') ?? 0.0);
      _videoInput = (sharedPrefs.getString('videoInput') ?? 'None Selected');
      _audioInputIsMute = (sharedPrefs.getBool('audioInputIsMute') ?? false);
      _audioOutputIsMute = (sharedPrefs.getBool('audioOutputIsMute') ?? false);
    });
  }

  /// -- Audio Input--
  /// Text Display
  Widget get audioInputText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Audio In: " + _audioInput,
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- Audio Input --
  /// DropBox Display
  ///
  /// TODO: Manipulate for systems hardware
  Widget get audioInputDropBox {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _audioInput,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.lightGreen[800]),
                    underline: Container(
                      height: 2,
                      color: Colors.lightGreen,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _audioInput = value;
                      });
                      save('audioInput', value);
                    },
                    // TODO: Look at getting audio options here
                    items: <String>[
                      'None Selected',
                      'Integrated Microphone',
                      'External Microphone'
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  /// -- Audio Output --
  /// Text Display
  Widget get audioOutputText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Audio Out: " + _audioOutput,
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- Audio Output --
  /// DropBox Display
  Widget get audioOutputDropBox {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _audioOutput,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.lightGreen[800]),
                    underline: Container(
                      height: 2,
                      color: Colors.lightGreen,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _audioOutput = value;
                      });
                      save('audioOutput', value);
                    },

                    // TODO: Look at getting audio options here
                    items: <String>['None Selected', 'Speakers', 'Headphones']
                        .map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  /// -- Audio Input Sensitivity --
  /// Text Display
  Widget get audioInputSensitivityText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                    "Audio Input Sensitivity: " +
                        _audioInputSensitivity.floor().toString(),
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- Audio Input Sensitivity --
  /// Slider Display
  Widget get audioInputSensitivitySlider {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Slider(
                    activeColor: Colors.lightGreen,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (value) {
                     setState(() {
                       _audioInputSensitivity = value;
                     });
                     save('audioInputSensitivity', value);
                    },
                    value: _audioInputSensitivity,
                  ),
                ),

                // This displays the slider value
                Container(
                  width: 50.0,
                  alignment: Alignment.center,
                  child: Text(
                    '${_audioInputSensitivity.toInt()}',
                    style: Theme.of(context).textTheme.display1,
                  ),
                )
              ],
            )),
      ],
    );
  }

  /// -- WebCam Input --
  /// Text Widget
  Widget get videoInputText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Webcam In: " + _videoInput,
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- WebCam Input --
  /// DropBox Widget
  Widget get videoInputDropBox {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: DropdownButton<String>(
                    value: _videoInput,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.lightGreen[800]),
                    underline: Container(
                      height: 2,
                      color: Colors.lightGreen,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _videoInput = value;
                      });
                      save('videoInput', value);
                    },
                    items: <String>[
                      'None Selected',
                      'Webcam',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  /// -- Mute Microphone --
  /// Text Widget
  Widget get audioInputIsMuteText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Mute Audio Input: " + _audioInputIsMute.toString(),
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- Mute Microphone --
  /// ToggleButton Widget
  Widget get audioInputIsMuteToggle {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.do_not_disturb_alt),
                    Icon(Icons.check),
                  ],
//                  // Need mutually exclusive check
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _audioInputIsSelected.length; i++) {
                        if (i == index) {
                          _audioInputIsSelected[i] = true;
                        } else {
                          _audioInputIsSelected[i] = false;
                        }
                        _audioInputIsMute = _audioInputIsSelected[i];
                        save('audioInputIsMute', _audioInputIsSelected[i]);
                      }
                    });
                  },
                  isSelected: _audioInputIsSelected,
                ),
              ],
            )),
      ],
    );
  }

  /// -- Mute Headphone --
  /// Text Widget
  Widget get audioOutputIsMuteText {
    return Container(
      child: Card(
          color: Colors.lightGreen[800],
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
              bottom: 8.0,
              left: 20.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Mute Audio Output: " + _audioOutputIsMute.toString(),
                    style: Theme.of(context).textTheme.headline),
              ],
            ),
          )),
    );
  }

  /// -- Mute Headphone --
  /// ToggleButton Widget
  Widget get audioOutputIsMuteToggle {
    return Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.do_not_disturb_alt),
                    Icon(Icons.check),
                  ],
//                  // Need mutually exclusive check
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _audioOutputIsSelected.length; i++) {
                        if (i == index) {
                          _audioOutputIsSelected[i] = true;
                        } else {
                          _audioOutputIsSelected[i] = false;
                        }
                        _audioOutputIsMute = _audioOutputIsSelected[i];
                        save('audioOutputIsMute', _audioOutputIsSelected[i]);

                      }
                    });
                  },
                  isSelected: _audioOutputIsSelected,
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            audioInputText,
            audioInputDropBox,
            audioOutputText,
            audioOutputDropBox,
            audioInputSensitivityText,
            audioInputSensitivitySlider,
            videoInputText,
            videoInputDropBox,
            audioInputIsMuteText,
            audioInputIsMuteToggle,
            audioOutputIsMuteText,
            audioOutputIsMuteToggle,
          ],
        ),
      ),
    );
  }
}