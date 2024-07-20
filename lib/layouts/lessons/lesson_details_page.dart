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
  YoutubePlayerController? _youtubePlayerController;
  var _currentStep = 0;
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
              _buildStep(
                lesson.lessonFirstTitle,
                lesson.lessonFirstContent,
                lesson.lessonFirstImage,
              ),
              _buildStep(
                lesson.lessonSecondTitle,
                lesson.lessonSecondContent,
                lesson.lessonSecondImage,
              ),
              _buildStep(
                lesson.lessonThirdTitle,
                lesson.lessonThirdContent,
                lesson.lessonThirdImage,
              ),
              _buildStep(
                lesson.lessonFourthTitle,
                lesson.lessonFourthContent,
                lesson.lessonFourthImage,
              ),
              _buildVideoPlayer(lesson.lessonLink),
            ];
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: steps[_currentStep],
                    ),
                  ),
                ),
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
                    const Spacer(),
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

  Widget _buildStep(String title, String content, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.right, // Align text to the right
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
              textAlign: TextAlign.right, // Align text to the right
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Image.asset(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ],
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
