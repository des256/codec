import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:split_view/split_view.dart';
import 'design.dart';
import 'rust.dart';

late Rust rust;

void main() {
  rust = Rust('../target/debug/libcodec.so');
  var encoder = rust.createEncoder();
  runApp(Application(encoder: encoder));
}

class Application extends StatelessWidget {
  final Encoder encoder;
  const Application({required this.encoder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codec Project Debug Tool',
      theme: ThemeData(
        backgroundColor: Colors.black,
        primarySwatch: Colors.grey,
      ),
      home: Main(encoder: encoder),
    );
  }
}

class Main extends StatefulWidget {
  final Encoder encoder;
  const Main({required this.encoder, Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  SplitViewController? _splitViewController1;
  SplitViewController? _splitViewController2;
  ui.Image? _image;

  @override
  initState() {
    super.initState();
    _splitViewController1 = SplitViewController(weights: [0.8, 0.2]);
    _splitViewController2 = SplitViewController(weights: [0.2, 0.4, 0.4]);
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
        child: Center(
          child: (_image != null)
              ? RawImage(
                  image: _image,
                  fit: BoxFit.contain,
                )
              : null,
        ),
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
              onPressed: () async {
                final image = await rust.encoderGetImage(widget.encoder);
                setState(() {
                  _image = image;
                });
              }),
        ),
        color: Colors.grey.shade800,
      ),
    );
  }

  Widget _buildTimeline() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          child: const Center(child: Text('timeline')),
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
                  onPressed: () {},
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
