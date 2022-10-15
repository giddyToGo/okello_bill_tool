import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hive/hive.dart';
import 'package:okello_bill_tool/firebase_options.dart';
import 'package:okello_bill_tool/logic/cubits/internet/internet_cubit.dart';
import 'package:okello_bill_tool/screens/source.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'app.dart';
import 'logic/cubits/auth/auth_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.init((await path_provider.getApplicationDocumentsDirectory()).path);
  await Hive.openBox("users_box");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
        appId: "1184501812387266", cookie: true, xfbml: true, version: "v13.0");
  }

  final internetCubit = InternetCubit(connectivity: Connectivity());

  final app = MultiBlocProvider(providers: [
    BlocProvider(create: (_) => AuthCubit(internetCubit)),
    BlocProvider(create: (context) => internetCubit),
  ], child: MyApp(connectivity: Connectivity()));

  runApp(app);
}
