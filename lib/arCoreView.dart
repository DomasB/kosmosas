import 'dart:convert';

import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart';

class AugmentedPage extends StatefulWidget {
  @override
  _AugmentedPageState createState() => _AugmentedPageState();
}

class _AugmentedPageState extends State<AugmentedPage> {
  ArCoreController? arCoreController;
  Map<int, ArCoreAugmentedImage> augmentedImagesMap = Map();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AugmentedPage'),
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          type: ArCoreViewType.AUGMENTEDIMAGES,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) async {
    arCoreController = controller;
    arCoreController?.onTrackingImage = _handleOnTrackingImage;
    loadSingleImage();
  }

  loadSingleImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/images/Target_birutes.jpg');
    arCoreController?.loadSingleAugmentedImage(
        bytes: bytes.buffer.asUint8List());
  }

  // loadImagesDatabase() async {
  //   final ByteData bytes = await rootBundle.load('assets/myimages.imgdb');
  //   arCoreController?.loadAugmentedImagesDatabase(
  //       bytes: bytes.buffer.asUint8List());
  // }

  _handleOnTrackingImage(ArCoreAugmentedImage augmentedImage) {
    if (!augmentedImagesMap.containsKey(augmentedImage.index)) {
      augmentedImagesMap[augmentedImage.index] = augmentedImage;
      _addSphere(augmentedImage);
    }
  }

  Future _addSphere(ArCoreAugmentedImage augmentedImage) async {
    var node2 = ArCoreNode(image: ArCoreImage());
    var node = ArCoreReferenceNode(
        objectUrl:
            "https://raw.githubusercontent.com/DomasB/kosmosas/master/assets/model.gltf",
        name: 'Tower',
        // object3DFileName: 'model.gltf',
        scale: Vector3(0.1, 0.1, 0.1),
        position: Vector3(0.0, 0.0, 0.0),
        rotation: Vector4(0.0, 0.0, 0.0, 0.0));
    arCoreController?.addArCoreNodeToAugmentedImage(node, augmentedImage.index,
        parentNodeName: 'None');
  }

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }
}
