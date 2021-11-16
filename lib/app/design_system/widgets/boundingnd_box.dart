import 'package:flutter/material.dart';
import 'dart:math' as math;

class Boxdetect extends StatelessWidget {
  final List<dynamic>? results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const Boxdetect(
      this.results, this.previewH, this.previewW, this.screenH, this.screenW,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scaleW;
    double scaleH;
    double x, y, w, h;
    List<Widget> _renderBoxes() {
      return results!.map(
        (re) {
          var _x = re["rect"]["x"];
          var _w = re["rect"]["w"];
          var _y = re["rect"]["y"];
          var _h = re["rect"]["h"];

          if (screenH / screenW > previewH / previewW) {
            scaleW = screenH / previewH * previewW;
            scaleH = screenH;
            var difW = (scaleW - screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            w = _w * scaleW;
            if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
            y = _y * scaleH;
            h = _h * scaleH;
          } else {
            scaleH = screenW / previewW * previewH;
            scaleW = screenW;
            var difH = (scaleH - screenH) / scaleH;
            x = _x * scaleW;
            w = _w * scaleW;
            y = (_y - difH / 2) * scaleH;
            h = _h * scaleH;
            if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
          }

          return Positioned(
            left: math.max(0, x),
            top: math.max(0, y),
            width: w,
            height: h,
            child: Container(
              padding: const EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: const Color.fromRGBO(37, 213, 253, 1.0),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                      color: Color.fromRGBO(37, 213, 253, 1.0),
                      fontSize: MediaQuery.of(context).textScaleFactor * 13,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ).toList();
    }

    return Stack(
      children: _renderBoxes(),
    );
  }
}
