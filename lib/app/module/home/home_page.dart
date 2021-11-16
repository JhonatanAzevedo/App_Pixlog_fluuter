import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import '../../design_system/widgets/camera.dart';
import '../../design_system/widgets/boundingnd_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CameraDescription>? cameras;
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String? res;
  bool _model = false;
  bool click = true;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    camAvailable();
  }

  loadModel() async {
    res = await Tflite.loadModel(
      model: "assets/pinus.tflite",
      labels: "assets/label.txt",
    );
  }

  Future camAvailable() async {
    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      debugPrint('Error: $e.code\nError Message: $e.message');
    }
  }

  onSelect(model) {
    setState(
      () {
        loading = !loading;
        _model = model;
      },
    );

    loadModel();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(
          () {
            loading = !loading;
          },
        );
      },
    );
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(
      () {
        _recognitions = recognitions;
        _imageHeight = imageHeight;
        _imageWidth = imageWidth;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    final height = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      backgroundColor: const Color(0xff132533),
      body: loading
          ? Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/background_imagem.png'),
                    fit: BoxFit.cover),
              ),
              child: _model == false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(height: height * 20),
                        Container(
                          padding: EdgeInsets.only(bottom: height * 13),
                          alignment: Alignment.bottomCenter,
                          child: FloatingActionButton(
                            backgroundColor: const Color(0xff3d709e),
                            child: const Icon(
                              Icons.camera_outlined,
                              size: 40,
                            ),
                            onPressed: () => onSelect(click),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        Camera(
                          cameras,
                          setRecognitions,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(height: height * 20),
                            Container(
                              padding: EdgeInsets.only(bottom: height * 13),
                              alignment: Alignment.bottomCenter,
                              child: FloatingActionButton(
                                backgroundColor: const Color(0xff3d709e),
                                child: const Icon(
                                  Icons.cancel_outlined,
                                  size: 40,
                                ),
                                onPressed: () =>
                                    Modular.to.popAndPushNamed('/home/'),
                              ),
                            ),
                          ],
                        ),
                        Boxdetect(
                          _recognitions ?? [],
                          math.max(_imageHeight, _imageWidth),
                          math.min(_imageHeight, _imageWidth),
                          screen.height,
                          screen.width,
                        ),
                      ],
                    ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
