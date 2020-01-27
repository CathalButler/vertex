import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vertex_ui/src/models/settings_model.dart';
import 'package:vertex_ui/src/widgets/text_widget.dart';

// TODO: Verify if this is correct
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

class _SettingsPageState extends State<SettingsPage> {
  String _audioInput;
  String _audioOutput;
  double _audioInputSensitivity;
  String _videoInput;
  bool _audioInputIsMute;
  bool _audioOutputIsMute;
  bool _theme; // Light --> true /  Dark --> false

  List<String> _defaultAudioInput = [
    'None Selected',
    'Integrated Microphone',
    'External Microphone'
  ];

  List<String> _defaultAudioOutput = [
    'None Selected',
    'Integrated Speakers',
    'External Headphones'
  ];

  List<String> _defaultVideoInput = [
    'None Selected',
    'Internal Webcam',
    'External Webcam'
  ];

  List<bool> _audioInputIsSelected = [true, false];
  List<bool> _audioOutputIsSelected = [true, false];
  List<bool> _themeIsSelected = [true, false];

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
      _audioInputSensitivity =
          (sharedPrefs.getDouble('audioInputSensitivity') ?? 50.0);
      _videoInput = (sharedPrefs.getString('videoInput') ?? 'None Selected');
      _audioInputIsMute = (sharedPrefs.getBool('audioInputIsMute') ?? false);
      _audioOutputIsMute = (sharedPrefs.getBool('audioOutputIsMute') ?? false);
    });
  }

  /// -- Audio Input Card--
  /// Displays Text
  /// Displays Dropdown
  Widget get audioInCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Audio in", _audioInput),
            audioInputDropBox,
          ],
        ),
      ),
    );
  }

  /// -- Audio Input --
  /// DropBox Display
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
                    style: TextStyle(color: Colors.white),
                    underline: Container(
                      height: 2,
                      color: Colors.white30,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _audioInput = value;
                      });
                      // Save as key value pair
                      save('audioInput', value);
                    },
                    items: _defaultAudioInput.map((String value) {
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

  /// -- Audio Card--
  /// Text Display
  Widget get audioOutCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Audio Out", _audioOutput),
            audioOutputDropBox,
          ],
        ),
      ),
    );
  }

  /// -- Audio Output --
  /// DropBox Display
  Widget get audioOutputDropBox {
    return Column(
      children: <Widget>[
        Container(
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
                  style: TextStyle(color: Colors.white),
                  underline: Container(
                    height: 2,
                    color: Colors.white30,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _audioOutput = value;
                    });
                    save('audioOutput', value);
                  },
                  // TODO: Look at getting audio options here
                  items: _defaultAudioOutput.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// -- Audio Sensitivity Card--
  Widget get audioInputSensitivityCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Audio Input Sensitivity",
                _audioInputSensitivity.floor().toString()),
            audioInputSensitivitySlider,
          ],
        ),
      ),
    );
  }

  /// -- Audio Input Sensitivity --
  /// Slider Display
  Widget get audioInputSensitivitySlider {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  activeColor: Colors.white,
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
            ],
          ),
        ),
      ],
    );
  }

  /// -- Audio Card--
  /// Text Display
  Widget get videoInputCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Webcam Input", _videoInput),
            videoInputDropBox,
          ],
        ),
      ),
    );
  }

  /// -- WebCam Input --
  /// DropBox Widget
  Widget get videoInputDropBox {
    return Column(
      children: <Widget>[
        Container(
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
                  style: TextStyle(color: Colors.white),
                  underline: Container(
                    height: 2,
                    color: Colors.white30,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _videoInput = value;
                    });
                    save('videoInput', value);
                  },
                  // TODO: Look at getting audio options here
                  items: _defaultVideoInput.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// -- Audio Card--
  /// Text Display
  Widget get audioInputIsMuteCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Mute Audio Input", _audioInputIsMute.toString()),
            audioInputIsMuteToggle,
          ],
        ),
      ),
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
                        save('audioInputIsSelected', _audioInputIsSelected[i]);
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

  /// -- Audio Card--
  /// Text Display
  Widget get audioOutputIsMuteCard {
    return Container(
      child: Card(
//        color: Colors.lightGreen[800],
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextWidget("Mute Audio Input", _audioOutputIsMute.toString()),
            audioOutputIsMuteToggle,
          ],
        ),
      ),
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
//                          brightness: Brightness.dark,
                        } else {
                          _audioOutputIsSelected[i] = false;
                        }
                        _audioOutputIsMute = _audioOutputIsSelected[i];
                        save('audioOutputIsMute', _audioOutputIsSelected[i]);
                        save('audioOutputIsSelected', _audioOutputIsSelected[i]);
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
//
//  /// -- Theme Card--
//  /// Text Display
//  Widget get themeCard {
//    return Container(
//      child: Card(
//        color: Colors.lightGreen[800],
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            TextWidget("", _audioOutputIsMute.toString()),
//            audioOutputIsMuteToggle,
//          ],
//        ),
//      ),
//    );
//  }
//
//  /// -- Theme Input --
//  /// Text Widget
//  Widget get themeText {
//    return Container(
//      child: Card(
////          color: Colors.lightGreen[800],
//          child: Padding(
//            padding: const EdgeInsets.only(
//              top: 10.0,
//              bottom: 8.0,
//              left: 20.0,
//            ),
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                Text("Current Theme: " + _theme.toString(),
//                    style: Theme.of(context).textTheme.headline),
//              ],
//            ),
//          )),
//    );
//  }
//
//  /// -- Mute Headphone --
//  /// ToggleButton Widget
//  Widget get themeToggle {
//    return Column(
//      children: <Widget>[
//        Container(
//            padding: EdgeInsets.symmetric(
//              vertical: 16.0,
//              horizontal: 16.0,
//            ),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              children: <Widget>[
//                ToggleButtons(
//                  children: <Widget>[
//                    Icon(Icons.do_not_disturb_alt),
//                    Icon(Icons.check),
//                  ],
////                  // Need mutually exclusive check
//                  onPressed: (int index) {
//                    setState(() {
//                      for (int i = 0; i < _themeIsSelected.length; i++) {
//                        if (i == index) {
//                          _themeIsSelected[i] = true;
//                        } else {
//                          _themeIsSelected[i] = false;
//                        }
//                        _theme = _themeIsSelected[i];
//                        save('theme', _themeIsSelected[i]);
//                      }
//                    });
//                  },
//                  isSelected: _themeIsSelected,
//                ),
//              ],
//            )),
//      ],
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.1, 0.3, 0.5, 0.7, 0.9],
            colors: [
              Colors.lightGreen[900],
              Colors.lightGreen[800],
              Colors.lightGreen[700],
              Colors.lightGreen[500],
              Colors.lightGreen[300],
            ],
          ),
        ),
        child: Center(
          child: ListView(
            children: <Widget>[
              audioInCard,
              audioOutCard,
              audioInputSensitivityCard,
              videoInputCard,
              audioInputIsMuteCard,
              audioOutputIsMuteCard,
//            audioInputDropBox,
//            audioOutputText,
//            audioOutputDropBox,
//            audioInputSensitivityText,
//            audioInputSensitivitySlider,
//            videoInputText,
//            videoInputDropBox,
//            audioInputIsMuteText,
//            audioInputIsMuteToggle,
//            audioOutputIsMuteText,
//            audioOutputIsMuteToggle,
//            themeText,
//            themeToggle,
            ],
          ),
        ),
      ),
    );
  }
}
