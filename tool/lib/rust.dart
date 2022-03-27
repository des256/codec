import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

Future<ui.Image> createOrangeImage() async {
  Uint8List data = Uint8List(320 * 240 * 4);
  for (var y = 0; y < 240; y++) {
    for (var x = 0; x < 320; x++) {
      final j = (y * 320 + x) * 4;
      data[j] = 0x00; // b
      data[j + 1] = 0x7F; // g
      data[j + 2] = 0xFF; // r
      data[j + 3] = 0xFF; // a
    }
  }
  final buffer = await ui.ImmutableBuffer.fromUint8List(data);
  final descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: 320,
    height: 240,
    pixelFormat: ui.PixelFormat.bgra8888,
  );
  final codec = await descriptor.instantiateCodec();
  final frameInfo = await codec.getNextFrame();
  codec.dispose();
  buffer.dispose();
  return frameInfo.image;
}

typedef Encoder = Pointer<Void>;

class Rust {
  late DynamicLibrary _lib;

  // create rust encoder
  late Pointer<Void> Function() _createEncoder;

  // destroy rust encoder
  late void Function(Pointer<Void> encoder) _destroyEncoder;

  // get width, height and pixel data from 'the' image from the encoder
  late int Function(Pointer<Void> encoder) _encoderGetImageWidth;
  late int Function(Pointer<Void> encoder) _encoderGetImageHeight;
  late Pointer<Uint8> Function(Pointer<Void> encoder)
      _encoderGetImagePixelsMutRef;

  Encoder createEncoder() {
    return _createEncoder();
  }

  destroyEncoder(Encoder encoder) {
    _destroyEncoder(encoder);
  }

  Future<ui.Image> encoderGetImage(Encoder encoder) async {
    final width = _encoderGetImageWidth(encoder);
    final height = _encoderGetImageHeight(encoder);
    final pixels = _encoderGetImagePixelsMutRef(encoder);
    final buffer = await ui.ImmutableBuffer.fromUint8List(
        pixels.asTypedList(width * height * 4));
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.bgra8888,
    );
    final codec = await descriptor.instantiateCodec();
    final frameInfo = await codec.getNextFrame();
    codec.dispose();
    buffer.dispose();
    return frameInfo.image;
  }

  Rust(String path) {
    _lib = DynamicLibrary.open('../target/debug/libcodec.so');
    _createEncoder = _lib
        .lookup<NativeFunction<Pointer<Void> Function()>>('create_encoder')
        .asFunction();
    _destroyEncoder = _lib
        .lookup<NativeFunction<Void Function(Pointer<Void>)>>('destroy_encoder')
        .asFunction();
    _encoderGetImageWidth = _lib
        .lookup<NativeFunction<Uint32 Function(Pointer<Void>)>>(
            'encoder_get_image_width')
        .asFunction();
    _encoderGetImageHeight = _lib
        .lookup<NativeFunction<Uint32 Function(Pointer<Void>)>>(
            'encoder_get_image_height')
        .asFunction();
    _encoderGetImagePixelsMutRef = _lib
        .lookup<NativeFunction<Pointer<Uint8> Function(Pointer<Void>)>>(
            'encoder_get_image_pixels_mut_ref')
        .asFunction();
  }
}
