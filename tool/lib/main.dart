import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'package:file_picker/file_picker.dart';
import 'design.dart';
import 'rust.dart' as rust;

void main() {
  rust.load('../target/debug/libcodec.so');
  runApp(Application());
}

class Application extends StatelessWidget {
  const Application({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codec Project Debug Tool',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.grey,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    Key? key,
  }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  SplitViewController? _splitViewController1;
  SplitViewController? _splitViewController2;
  List<ui.Image> _frames = [];

  @override
  initState() {
    super.initState();
    _splitViewController1 = SplitViewController(weights: [0.8, 0.2]);
    _splitViewController2 = SplitViewController(weights: [0.2, 0.4, 0.4]);
    /*
    _rustImage = rust.imageNew(320, 240);
    () async {
      final image = await rust.makeUiImage(_rustImage!);
      setState(() {
        _image = image;
      });
    }();
    */
  }

  Widget _buildStream() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          child: const Center(child: Text('stream')),
          color: Colors.grey.shade800,
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Row(
            children: [
              Tooltip(
                message: 'load coded stream',
                child: ElevatedButton(
                  child: const Icon(Icons.folder_open),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(codeColor)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'save coded stream',
                child: ElevatedButton(
                  child: const Icon(Icons.save),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(codeColor)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFrame() {
    return Scaffold(
      body: Container(
        child: Center(),
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildBlock() {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.power),
            label: const Text('current action'),
            onPressed: null,
          ),
        ),
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTimeline() {
    List<Widget> timelineImages = [];
    for (var frame in _frames) {
      timelineImages.add(
        TextButton(
          child: RawImage(
            image: frame,
          ),
          onPressed: () {},
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: timelineImages,
          ),
          color: Colors.grey.shade800,
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Row(
            children: [
              Tooltip(
                message: 'load video',
                child: ElevatedButton(
                  child: const Icon(Icons.folder_open),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(videoColor)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'save as MP4',
                child: ElevatedButton(
                  child: const Icon(Icons.save),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(videoColor)),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'load individual frames',
                child: ElevatedButton(
                  child: const Icon(Icons.folder_open),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(frameColor)),
                  onPressed: () async {
                    final FilePickerResult? result = await FilePicker.platform
                        .pickFiles(allowMultiple: true);
                    if (result != null) {
                      List<File> files =
                          result.paths.map((path) => File(path!)).toList();
                      List<ui.Image> frames = [];
                      for (var file in files) {
                        final bytes = await file.readAsBytes();
                        final frame = await decodeImageFromList(bytes);
                        frames.add(frame);
                      }
                      setState(() {
                        _frames = frames;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'save as individual frames',
                child: ElevatedButton(
                  child: const Icon(Icons.save),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(frameColor)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplitView(
        viewMode: SplitViewMode.Vertical,
        controller: _splitViewController1,
        gripSize: 5,
        gripColor: Colors.grey.shade900,
        gripColorActive: Colors.grey.shade700,
        children: [
          SplitView(
            viewMode: SplitViewMode.Horizontal,
            controller: _splitViewController2,
            gripSize: 5,
            gripColor: Colors.grey.shade900,
            gripColorActive: Colors.grey.shade700,
            children: [
              _buildStream(),
              _buildFrame(),
              _buildBlock(),
            ],
          ),
          _buildTimeline(),
        ],
      ),
    );
  }
}
