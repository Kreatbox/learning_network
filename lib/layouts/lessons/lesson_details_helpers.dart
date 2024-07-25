import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// يبني عنصر يمثل خطوة في الدرس
Widget buildStep(String title, String content, String imageUrl) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start, // يجعل العناصر تبدأ من اليسار
    children: [
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0), // يضيف مسافة أفقية
        child: Directionality(
          textDirection:
              TextDirection.rtl, // يحدد اتجاه النص من اليمين إلى اليسار
          child: Text(
            title, // عنوان الخطوة
            style: const TextStyle(
              fontSize: 20.0, // حجم الخط
              fontWeight: FontWeight.bold, // وزن الخط غامق
              color: Colors.blue, // لون الخط أزرق
            ),
            textAlign: TextAlign.right, // محاذاة النص إلى اليمين
          ),
        ),
      ),
      const SizedBox(height: 10.0), // مسافة رأسية
      Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16.0), // يضيف مسافة أفقية
        child: buildRichTextStep(content, imageUrl), // يبني محتوى النص والصورة
      ),
    ],
  );
}

/// يبني محتوى النص مع إمكانية إدراج الصور في النص
Widget buildRichTextStep(String content, String imageUrl) {
  List<InlineSpan> children = []; // قائمة لحفظ النصوص والصور
  List<String> parts =
      content.split('<image>'); // يقسم النص حسب العلامة <image>

  for (int i = 0; i < parts.length; i++) {
    children.add(TextSpan(
      text: parts[i], // النص العادي
      style: const TextStyle(
        fontSize: 16.0, // حجم الخط
        color: Colors.black54, // لون النص
      ),
    ));

    if (i < parts.length - 1) {
      // إذا كان هناك صورة يجب إدراجها
      children.add(WidgetSpan(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 10.0), // يضيف مسافة رأسية
          child: Image.asset(
            imageUrl, // مسار الصورة
            fit: BoxFit.cover, // يجعل الصورة تغطي المساحة المحددة
            width: double.infinity, // يجعل عرض الصورة يأخذ عرض الشاشة كاملاً
          ),
        ),
      ));
    }
  }

  return RichText(
    textDirection: TextDirection.rtl, // يحدد اتجاه النص من اليمين إلى اليسار
    text: TextSpan(children: children), // يجمع النصوص والصور في نص واحد
  );
}

/// يبني مشغل فيديو YouTube
Widget buildVideoPlayer(String videoUrl) {
  final videoId = convertUrlToId(videoUrl); // يحصل على معرّف الفيديو من الرابط
  if (videoId == null) {
    return const Center(
        child: Text(
            'رابط الفيديو غير صالح')); // يعرض رسالة خطأ إذا كان الرابط غير صالح
  }

  final controller = YoutubePlayerController.fromVideoId(
    videoId: videoId, // يستخدم معرّف الفيديو لإنشاء المتحكم
    autoPlay: false, // يحدد أن الفيديو لا يشغل تلقائيًا
    params: const YoutubePlayerParams(
      showControls: true, // يعرض أزرار التحكم في الفيديو
      showFullscreenButton: true, // يعرض زر ملء الشاشة
    ),
  );

  return Center(
    child: AspectRatio(
      aspectRatio: 16 / 9, // يحدد نسبة العرض إلى الارتفاع للفيديو
      child: YoutubePlayer(
        controller: controller, // يستخدم المتحكم لإنشاء مشغل الفيديو
        aspectRatio: 16 / 9, // يحدد نسبة العرض إلى الارتفاع للمشغل
      ),
    ),
  );
}

/// يحول رابط YouTube إلى معرّف الفيديو
String? convertUrlToId(String url) {
  final uri = Uri.parse(url); // يحول الرابط إلى كائن URI
  if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
    // يتحقق من أن الرابط ينتمي إلى YouTube
    if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v']; // يحصل على معرّف الفيديو من الرابط
    } else if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.first; // يحصل على معرّف الفيديو من الرابط المختصر
    }
  }
  return null; // يعيد null إذا لم يكن الرابط صالحًا
}
