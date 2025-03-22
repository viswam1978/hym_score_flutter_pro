import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'graph_screen.dart';
import 'help_screen.dart';
import '../widgets/joint_marker.dart';
import '../utils/joint_positions.dart';
import '../models/joint_strength.dart';
import 'package:hym_score_flutter_pro/views/three_d/three_d_model_viewer.dart';

class HYMScoreHome extends StatefulWidget {
  final String name;

  const HYMScoreHome({super.key, required this.name});

  @override
  _HYMScoreHomeState createState() => _HYMScoreHomeState();
}

class _HYMScoreHomeState extends State<HYMScoreHome> {
  int _selectedIndex = 0;
  bool _showNameEntryPopup = false;
  late TextEditingController _nameController;
  String _enteredName = 'Test Subject';

  final Map<String, JointStrength> _jointStrengths = {
    'Neck': JointStrength(5, 5),
    'Left Shoulder': JointStrength(5, 5),
    'Right Shoulder': JointStrength(5, 5),
    'Left Elbow': JointStrength(5, 5),
    'Right Elbow': JointStrength(5, 5),
    'Left Wrist': JointStrength(5, 5),
    'Right Wrist': JointStrength(5, 5),
    'Left Hip': JointStrength(5, 5),
    'Right Hip': JointStrength(5, 5),
    'Left Knee': JointStrength(5, 5),
    'Right Knee': JointStrength(5, 5),
    'Left Ankle': JointStrength(5, 5),
    'Right Ankle': JointStrength(5, 5),
  };

  double _hymScore = 100.0;
  Map<String, Offset> draggablePositions = Map.from(jointPositionsMap);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _enteredName);
    _hymScore = _calculateHYMScore();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  double _calculateHYMScore() {
    const int maxStrengthPerMovement = 5;
    const int movementsPerJoint = 2;
    int totalJoints = _jointStrengths.length;
    int recordedStrength = _jointStrengths.values.fold(0, (sum, strength) => sum + strength.movement1 + strength.movement2);
    int totalPossibleStrength = totalJoints * movementsPerJoint * maxStrengthPerMovement;
    return double.parse(((recordedStrength / totalPossibleStrength) * 100).toStringAsFixed(1));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      setState(() {
        _showNameEntryPopup = true;
      });
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  GraphScreen(jointStrengths: _jointStrengths)));
    } else if (index == 2) {
      _exportToCSV();
    } else if (index == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HelpScreen()));
    }
  }

  void _onMarkerSelected(String jointKey) {
    String topLabel = (jointKey.contains('Shoulder')) ? 'Abduction' : 'Flexion';
    String bottomLabel = (jointKey.contains('Shoulder')) ? 'Adduction' : 'Extension';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    topLabel,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setModalState(() {
                            _jointStrengths[jointKey]!.movement1 = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          backgroundColor: (_jointStrengths[jointKey]!.movement1 == index)
                            ? Colors.blueAccent
                            : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(index.toString()),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bottomLabel,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setModalState(() {
                            _jointStrengths[jointKey]!.movement2 = index;
                          });
                          setState(() {
                            _hymScore = _calculateHYMScore();
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          backgroundColor: (_jointStrengths[jointKey]!.movement2 == index)
                            ? Colors.green
                            : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(index.toString()),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HYM Score: ${_hymScore.toStringAsFixed(1)}%'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double scaleFactor = 1.3;
          final double imageWidth = 400 * scaleFactor;
          final double imageHeight = 800 * scaleFactor;
          final imageLeftOffset = (constraints.maxWidth - imageWidth) / 2;
          final imageTopOffset = (constraints.maxHeight - imageHeight) / 2;

          return Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Transform.scale(
                  scale: 1.3,
                  child: Image.asset(
                    'assets/body_memoji.png',
                    width: 400,
                    height: 800,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              ...draggablePositions.entries.map((entry) {
                final dx = entry.value.dx * imageWidth;
                final dy = entry.value.dy * imageHeight;

                return Positioned(
                  left: imageLeftOffset + dx - 15,
                  top: imageTopOffset + dy - 70,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_jointStrengths[entry.key]?.movement1}/${_jointStrengths[entry.key]?.movement2}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(color: Colors.black, blurRadius: 2)],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onMarkerSelected(entry.key);
                          },
                          child: JointMarker(
                            absolutePosition: entry.value,
                            size: 20,
                            onTap: () {
                              _onMarkerSelected(entry.key);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    _enteredName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      shadows: [Shadow(color: Colors.white, blurRadius: 4)],
                    ),
                  ),
                ),
              ),
              if (_showNameEntryPopup) _nameEntryPopup(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Name'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Graph'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Export'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Help'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ThreeDModelViewer()),
          );
        },
        child: const Icon(Icons.threed_rotation),
      ),
    );
  }

  Widget _nameEntryPopup() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showNameEntryPopup = false;
          });
        },
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Center(
            child: AlertDialog(
              title: const Text("Enter Name"),
              content: TextField(
                controller: _nameController,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(hintText: "Test Subject"),
                onSubmitted: (value) {
                  setState(() {
                    _enteredName = value;
                    _showNameEntryPopup = false;
                  });
                },
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _enteredName = _nameController.text;
                      _showNameEntryPopup = false;
                    });
                  },
                  child: const Text("Done"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _exportToCSV() async {
    final List<List<String>> csvData = [
      ['Joint', 'Movement 1', 'Movement 2'],
      ..._jointStrengths.entries.map((entry) => [
            entry.key,
            entry.value.movement1.toString(),
            entry.value.movement2.toString(),
          ]),
    ];

    final String csvString =
        csvData.map((row) => row.join(',')).join('\n');

    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/hym_score_export.csv');
    await file.writeAsString(csvString);

    Share.shareXFiles([XFile(file.path)], text: 'HYM Score Data Export');
  }
}