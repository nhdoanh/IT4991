import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ListVideoPage extends StatefulWidget {
  const ListVideoPage({Key? key}) : super(key: key);

  @override
  State<ListVideoPage> createState() => _ListVideoPageState();
}

class _ListVideoPageState extends State<ListVideoPage> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();

    getSavedDirectory();
  }

  Future<void> getSavedDirectory() async {
    Directory savedDirectory = await getApplicationDocumentsDirectory();

    files = savedDirectory.listSync();
    setState(() {
      files = files
          .whereType<File>()
          .where((element) => element.path.contains("_result.mp4"))
          .toList();
    });
    print(files);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("List Video")),
      body: SafeArea(
        child: ListView.separated(
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) =>
              VideoItem(files[index] as File),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        ),
      ),
    );
  }
}

class VideoItem extends StatefulWidget {
  const VideoItem(this.file, {Key? key}) : super(key: key);
  final File file;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    try {
      controller = VideoPlayerController.file(widget.file);
      controller.initialize().then((value) {
        setState(() {});
      });

      _chewieController = ChewieController(videoPlayerController: controller);
    } catch (err) {
      initState();
    }
  }

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _chewieController.enterFullScreen();
      },
      child: Column(
        children: [
          controller.value.isInitialized
              ? SizedBox(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: Chewie(controller: _chewieController),
                  ),
                )
              : const CircularProgressIndicator(),
          Text(widget.file.path.split('/').last),
        ],
      ),
    );
  }
}
