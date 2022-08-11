import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

Future<String> uploadImage({
  required File file,
  required String userId,
}) async {
  final path = '$userId/${const Uuid().v4()}';

  final ref = FirebaseStorage.instance.ref().child(path);
  var uploadTask = ref.putFile(file);

  final snapshot = await uploadTask.whenComplete(() => {});

  final urlDownload = await snapshot.ref.getDownloadURL();

  print('testing that we have downloadURL : $urlDownload');

  return urlDownload;

  // FirebaseStorage.instance
  //     .ref(userId)
  //     .child(const Uuid().v4())
  //     .putFile(file)
  //     .then((_) => true)
  //     .catchError((_) => false);
  // return true;
}
