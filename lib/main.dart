import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env safely
  await dotenv.load(fileName: "assets/.env");
  print("TMDB key loaded: ${dotenv.env['TMDB_API_KEY']}");

  // Delay GetStorage init until first frame to ensure platform channels are ready
  runApp(const MyAppWithStorage());
}

class MyAppWithStorage extends StatefulWidget {
  const MyAppWithStorage({super.key});

  @override
  State<MyAppWithStorage> createState() => _MyAppWithStorageState();
}

class _MyAppWithStorageState extends State<MyAppWithStorage> {
  bool storageReady = false;

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    try {
      await GetStorage.init();
      print("GetStorage initialized successfully");
      setState(() => storageReady = true);
    } catch (e) {
      print("GetStorage initialization failed: $e");
      setState(() => storageReady = true); // still continue
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!storageReady) {
      // Show a splash/loading until GetStorage is ready
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Vortax Mobile App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: AppRoutes.home,
      initialBinding: InitialBinding(),
      getPages: AppPages.pages,
    );
  }
}
