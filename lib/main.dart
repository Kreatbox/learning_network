import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'layouts/info_page.dart';
import 'layouts/lessons/lessons_page.dart';
import 'layouts/tests/tests_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "تبسيط تعليم برمجة التطبيقات الشبكية",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/info': (context) => const InfoPage(),
        '/lessons': (context) => const LessonsPage(),
        '/tests': (context) => const TestsPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تطبيق تبسيط تعليم برمجة التطبيقات الشبكية"),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
            onPressed: () {
              SystemNavigator.pop(); // This closes the app
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.blue[200],
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // هون بدلت الخلفية بتقدر ترجعها بس بشيل هدول اللي عجنب
          Container(
            height: 1000,
            color: Colors.blue,
          ),
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/images/network.jpg'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      " مرحباً بك في تطبيق تبسيط تعليم برمجة التطبيقات الشبكية",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'HSI',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'HSI',
                          color: Colors.black,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/info');
                      },
                      child: const Text(" الطلاب المشاركة ")),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'HSI',
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/lessons');
                    },
                    child: const Text("المحتوى"),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'HSI',
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tests');
                    },
                    child: const Text("الاختبارات"),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
