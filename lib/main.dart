import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio foreground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Audio foreground'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _player = AudioPlayer();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AlbumArtwork(imagePath: 'assets/images/image.png'),
            SizedBox(height: 20),
            PlayStopButton(player: _player),
          ],
        ),
      ),
    );
  }
}

class AlbumArtwork extends StatelessWidget {
  final String imagePath;

  const AlbumArtwork({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PlayStopButton extends StatelessWidget {
  final AudioPlayer player;

  const PlayStopButton({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ControlButton(
            onPressed: () => toggleAudio(player),
            icon: Icons.play_arrow,
            iconSize: 48,
          ),
          SizedBox(width: 20),
          ControlButton(
            onPressed: () => stopAudio(player),
            icon: Icons.stop,
            iconSize: 48,
          ),
        ],
      ),
    );
  }

  void toggleAudio(AudioPlayer player) async {
    try {
      if (player.playing) {
        await player.stop();
      } else {
        await startAudio(player);
      }
    } catch (e) {
      // Handle errors, e.g., show an error message to the user
      print("Error: $e");
    }
  }

  Future<void> startAudio(AudioPlayer player) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await initializeService();

      final audioSource = AudioSource.uri(
        Uri.parse('asset:assets/music/music.mp3'),
      );
      await player.setAudioSource(audioSource);
      await player.play();
    } catch (e) {
      // Handle errors, e.g., show an error message to the user
      print("Error: $e");
    }
  }

  Future<void> stopAudio(AudioPlayer player) async {
    try {
      await player.stop();
    } catch (e) {
      // Handle errors, e.g., show an error message to the user
      print("Error: $e");
    }
  }

  Future<void> initializeService() async {
    // Your background service initialization code
    // ...
  }
}

class ControlButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final double iconSize;

  const ControlButton({
    required this.onPressed,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: iconSize,
      color: Colors.blue, // Customize the button color
    );
  }
}
