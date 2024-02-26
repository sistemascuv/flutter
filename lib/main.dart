import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';
import '../clases/theme_provider.dart'; // Importa tu ThemeProvider

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => ThemeProvider(), // Crea una instancia del ThemeProvider aquí
    child: MyApp(),
  ),
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeProvider.themeData, // Usa el tema proporcionado por ThemeProvider

          home: VideoScreen(),
        );
      },
    );
  }
}

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _initializeVideoPlayer() async {
    _controller = VideoPlayerController.asset('assets/introwebsis.mp4');
    await _controller.initialize();
    await _controller.play();

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        _onVideoComplete();
      }
    });
  }

  Future<void> _onVideoComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('videoPlayed', true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
