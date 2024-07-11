import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../database/database_helper.dart';
import '../../models/lessons/lesson_model.dart';

class LessonDetailsPage extends StatefulWidget {
  final int lessonId;

  const LessonDetailsPage({required this.lessonId, Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LessonDetailsPageState createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  late Future<Lesson> _lessonFuture;
  int _currentStep = 0;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    _lessonFuture = fetchLesson();
  }

  Future<Lesson> fetchLesson() async {
    final dbHelper = DatabaseHelper();
    Map<String, dynamic>? lessonMap =
        await dbHelper.getLessonById(widget.lessonId);
    return Lesson.fromJson(lessonMap!);
  }

  @override
  void dispose() {
    _youtubePlayerController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الدرس'),
      ),
      body: FutureBuilder<Lesson>(
        future: _lessonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('لا يوجد بيانات للدرس'));
          } else {
            Lesson lesson = snapshot.data!;
            List<Widget> steps = [
              _buildStep(lesson.lessonFirstTitle, lesson.lessonFirstContent),
              _buildStep(lesson.lessonSecondTitle, lesson.lessonSecondContent),
              _buildStep(lesson.lessonThirdTitle, lesson.lessonThirdContent),
              _buildVideoPlayer(lesson.lessonLink),
            ];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: steps[_currentStep]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: const Text('السابق'),
                      ),
                    const Spacer(), // Adds space between the buttons to push the next button to the right
                    if (_currentStep < steps.length - 1)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentStep++;
                          });
                        },
                        child: const Text('التالي'),
                      ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStep(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Text(
            content,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    final videoId = convertUrlToId(videoUrl);
    if (videoId == null) {
      return const Center(child: Text('رابط الفيديو غير صالح'));
    }

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );

    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9, // Normal video size aspect ratio
        child: YoutubePlayer(
          controller: controller,
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }

  String? convertUrlToId(String url) {
    final uri = Uri.parse(url);
    if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
      if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'];
      } else if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.first;
      }
    }
    return null;
  }
}
