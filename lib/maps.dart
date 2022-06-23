import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController? _controller;
  GlobalKey stickyKey = GlobalKey();
  var widgetKey = GlobalKey();

  static const CameraPosition _kMoskowKremlin = CameraPosition(
    target: LatLng(55.75212565337628, 37.61797171474234),
    zoom: 14.4746,
  );

  Future<LatLng> movePosition(String move) async {
    var context = widgetKey.currentContext;

    double middleY = Platform.isAndroid ? context!.size!.height : context!.size!.height / 2;
    double middleX = Platform.isAndroid ? context.size!.width : context.size!.width / 2;
    ScreenCoordinate screenCoordinate = ScreenCoordinate(x: middleX.round(), y: middleY.round());

    LatLng middlePoint = await _controller!.getLatLng(screenCoordinate);
    final c = middlePoint.toJson();

    if (move == 'up') {
      return LatLng(
        jsonDecode(c.toString())[0] + 0.01,
        jsonDecode(c.toString())[1],
      );
    } else if (move == 'right') {
      return LatLng(
        jsonDecode(c.toString())[0],
        jsonDecode(c.toString())[1] + 0.01,
      );
    } else if (move == 'left') {
      return LatLng(
        jsonDecode(c.toString())[0],
        jsonDecode(c.toString())[1] - 0.01,
      );
    } else {
      return LatLng(
        jsonDecode(c.toString())[0] - 0.01,
        jsonDecode(c.toString())[1],
      );
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            key: widgetKey,
            initialCameraPosition: _kMoskowKremlin,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      iconSize: 40,
                      icon: const Text(
                        '+',
                        style: TextStyle(fontSize: 50),
                      ),
                      onPressed: () {
                        _controller?.animateCamera(CameraUpdate.zoomIn());
                      },
                    ),
                    IconButton(
                      iconSize: 70,
                      icon: const Text(
                        '-',
                        style: TextStyle(fontSize: 70),
                      ),
                      onPressed: () {
                        _controller?.animateCamera(CameraUpdate.zoomOut());
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: () async {
                        LatLng position = await movePosition('up');
                        _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: position,
                          zoom: await _controller!.getZoomLevel(),
                        )));
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            LatLng position = await movePosition('left');
                            _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              target: position,
                              zoom: await _controller!.getZoomLevel(),
                            )));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            LatLng position = await movePosition('right');
                            _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              target: position,
                              zoom: await _controller!.getZoomLevel(),
                            )));
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: () async {
                        LatLng position = await movePosition('down');
                        _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target: position,
                          zoom: await _controller!.getZoomLevel(),
                        )));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          _controller?.animateCamera(CameraUpdate.newCameraPosition(_kMoskowKremlin));
        },
      ),
    );
  }
}
