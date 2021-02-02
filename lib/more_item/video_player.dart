
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class VideoTutorial extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoTutorialState();
  }
}

class _VideoTutorialState extends State<VideoTutorial> {

  /*TargetPlatform _platform;
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;*/

  @override
  void initState() {
    super.initState();
    //initializePlayer();
  }

  @override
  void dispose() {
   /* _videoPlayerController1.dispose();
    _chewieController.dispose();*/
    super.dispose();
  }

 /* Future<void> initializePlayer() async {
    _videoPlayerController1 = VideoPlayerController.network('https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4');
    await _videoPlayerController1.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      autoPlay: true,
      looping: false,
      showControls: false,
      aspectRatio: _videoPlayerController1.value.aspectRatio
    );

    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              /* child: Center(
                 child: _chewieController != null && _chewieController.videoPlayerController.value.initialized
                      ? Chewie(controller: _chewieController) : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text('Loading...'),
                    ],
                  ),
                ),*/
              ),
            ),
          ],
        ),
      );
  }
}