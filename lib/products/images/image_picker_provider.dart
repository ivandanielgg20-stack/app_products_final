import 'dart:io';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

final imagePickerProvider =
    StateNotifierProvider<ImagePickerNotifier, ImagePickerState>(
  (ref) => ImagePickerNotifier(),
);

class ImagePickerNotifier extends StateNotifier<ImagePickerState> {
  ImagePickerNotifier() : super(const ImagePickerState());

  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (pickedFile != null) {
      state = state.copyWith(imageFile: File(pickedFile.path));
    }
  }

  Future<void> pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (pickedFile != null) {
      state = state.copyWith(imageFile: File(pickedFile.path));
    }
  }

  void clearImage() {
    state = state.copyWith(imageFile: null);
  }
}

class ImagePickerState {
  final File? imageFile;
  const ImagePickerState({this.imageFile});
  ImagePickerState copyWith({File? imageFile}) {
    return ImagePickerState(imageFile: imageFile ?? this.imageFile);
  }
}