import 'dart:io';
class ImagePickerState {
  final File? imageFile;
  const ImagePickerState({this.imageFile});
  ImagePickerState copyWith({File? imageFile}) {
    return ImagePickerState(
      imageFile: imageFile ?? this.imageFile,
    );
  }
}