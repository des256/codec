import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:typed_data';

typedef Usize = Uint64;

class VecU8 extends Struct {
  external Pointer<Uint8> ptr;
  @Usize()
  external int cap;
  @Usize()
  external int len;
  Uint8List asTypedList() {
    return ptr.asTypedList(len);
  }
}

class VecU32 extends Struct {
  external Pointer<Uint32> ptr;
  @Usize()
  external int cap;
  @Usize()
  external int len;
  Uint8List asUint8List() {
    return ptr.asTypedList(len).buffer.asUint8List();
  }
}

class ImageStruct extends Struct {
  @Usize()
  external int width;
  @Usize()
  external int height;
  external VecU32 pixels;
}

typedef Image = Pointer<ImageStruct>;

Future<ui.Image> makeUiImage(Image image) async {
  final buffer =
      await ui.ImmutableBuffer.fromUint8List(image[0].pixels.asUint8List());
  final descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: image[0].width,
    height: image[0].height,
    pixelFormat: ui.PixelFormat.bgra8888,
  );
  final codec = await descriptor.instantiateCodec();
  final frameInfo = await codec.getNextFrame();
  final result = frameInfo.image;
  codec.dispose();
  buffer.dispose();
  return result;
}

class EncoderStruct extends Struct {
  @Usize()
  external int width;
  @Usize()
  external int height;
  external Pointer<Void> encoder;
}

typedef Encoder = Pointer<EncoderStruct>;

late DynamicLibrary _lib;
late Image Function(int width, int height) imageNew;
late void Function(Image image) imageDrop;
late Encoder Function(int width, int height) encoderNew;
late void Function(Encoder encoder) encoderDrop;
late Pointer<VecU8> Function(Encoder encoder, Image image) _encoderEncode;

load(String path) {
  _lib = DynamicLibrary.open('../target/debug/libcodec.so');
  imageNew = _lib
      .lookup<NativeFunction<Image Function(Usize, Usize)>>('image_new')
      .asFunction();
  imageDrop = _lib
      .lookup<NativeFunction<Void Function(Image)>>('image_drop')
      .asFunction();
  encoderNew = _lib
      .lookup<NativeFunction<Encoder Function(Usize, Usize)>>('encoder_new')
      .asFunction();
  encoderDrop = _lib
      .lookup<NativeFunction<Void Function(Encoder)>>('encoder_drop')
      .asFunction();
  _encoderEncode = _lib
      .lookup<NativeFunction<Pointer<VecU8> Function(Encoder, Image)>>(
          'encoder_encode')
      .asFunction();
}

Uint8List encoderEncode(Encoder encoder, Image image) {
  final vec = _encoderEncode(encoder, image)[0];
  return vec.ptr.asTypedList(vec.len);
}
