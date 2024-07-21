import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  // دالة للحصول على قاعدة البيانات
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // دالة لتهيئة قاعدة البيانات
  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      var factory = databaseFactoryFfiWeb;
      var db = await factory.openDatabase('networking.db');
      await _checkAndCreateTables(db);
      return db;
    } else {
      String path = join(await getDatabasesPath(), 'networking.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    }
  }

  // دالة للتحقق من وجود الجداول وإنشائها إذا لم تكن موجودة
  Future<void> _checkAndCreateTables(Database db) async {
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tests'");
    if (result.isEmpty) {
      await _onCreate(db, 1);
    }
  }

  // دالة لإنشاء الجداول عند تهيئة قاعدة البيانات
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE lessons (
        lesson_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_name TEXT,
        lesson_first_title TEXT,
        lesson_first_content TEXT,
        lesson_first_image TEXT,
        lesson_second_title TEXT,
        lesson_second_content TEXT,
        lesson_second_image TEXT,
        lesson_third_title TEXT,
        lesson_third_content TEXT,
        lesson_third_image TEXT,
        lesson_fourth_title TEXT,
        lesson_fourth_content TEXT,
        lesson_fourth_image TEXT,
        lesson_link TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE tests (
        test_id INTEGER PRIMARY KEY AUTOINCREMENT,
        lesson_id INTEGER,
        test_name TEXT,
        FOREIGN KEY (lesson_id) REFERENCES lessons (lesson_id)
    )
    ''');
    await db.execute('''
    CREATE TABLE questions (
        question_id INTEGER PRIMARY KEY AUTOINCREMENT,
        test_id INTEGER,
        question_text TEXT,
        choice1 TEXT,
        choice2 TEXT,
        choice3 TEXT,
        choice4 TEXT,
        correct_choice INTEGER,
        state INTEGER DEFAULT 0,
        FOREIGN KEY (test_id) REFERENCES tests (test_id)
    )
    ''');

    // إدراج بيانات عينة للدروس، الاختبارات، والأسئلة
    await db.insert('lessons', {
      'lesson_name': 'الدرس الأول: النياسب 1',
      'lesson_first_title': 'المقدمة',
      'lesson_first_content':
          'إذا أمعن النظر في طبيعة جسم الإنسان، فسوف نلاحظ أنه ينجز الكثير من العمليات مع وبنفس الوقت، فمثلا جميع العمليات الأساسية مثل التنفس والهضم والدورة الدموية هي عمليات لابد لها من أن تتم بنفس الوقت وعلى التوازي. لأنه من غير الممكن أن تنتظر إحدى هـذه العمليـات انتهاء عملية أخرى.\nكذلك، تعمل الحواس الخمس للإنسان في وقت واحد، حيث يمكن له أن يسـمع ويشـاهد، مثلا، في نفس الوقت.\nوعلى غرار ذلك، فإننا إذا أمعنا النظر في الحاسـب وكيفية قيامه عملياته الأسـاسـية، سـنلاحظ أنه قادر على تنفيذ برنامج ما واستبيان بريد الكتروني من شبكة وتنفيذ أمر دخل خرج طباعة مثلا بنفس الوقت وبشكل متوازي\nيستخدم الحاسب يشكل عام عند إنجازه لعدد من العمليات يشكل متوازي ميزة تعددية النيسب Multithreading. فإذا افترضـنا مثلا، وجود ثلاث عمليات مختلفة تتطلب التنفيذ من قبل الحاسـب بنفس الوقت، يشكل الحاسب ثلاثة نياسب Thread، بحيث يكون النيسب مسؤولا عـن تنفيذ عملية معينة، ويتم تنفيذ النياسب الثلاثة في نفس الوقت.\nإذ أنه من غير المنطقي أن تقتصر معالجة الحاسب على عملية واحدة فقط في وقت معين وبقاء جميع العمليات الأخرى معلقة حتى انتهاء هذه العملية.\nولإيضاح أهمية تعددية النياسب لنناقش المثال التالي: عندما يقوم المستخدم بتحميل برنـامج أو ملف معين من الإنترنت ليكن مقطع صوتي أو مقطع فيديو مثلا. يطلب المستخدم تشغيل المقطع قبل انتهاء التحميل كاملا. يحل الحاسـب هذه المشـكلة بتوزيع ميزة تعددية النياسـب، حيث يقوم نيسـب بتحميل المقطع بينما يقوم نيسب آخر بتشغيل المقطع.\nوهنا سيطرح السؤال التالي\nماذا سيحدث إذا وصل نيسب التشغيل إلى جزء لم يحمله نيسب التحميل بعد؟ \nيكمن الحل هنا ما سنرىThreads Synchronization.\n	\nبمزامنة النيسبين\nومن المثير للدهشة أنه رغم الفوائد الواضحة لتعددية النياسب، فقد ان توظيف هـذه الميـزة وبنائها في الماضي لأن الات البرمجة القديمة لم تقدم الأدوات اللازمـة للتعامـل مـع النياسب، وةانت هذه الميزة محصورة على متخصصي برمجة النظم فقط أدرة وازرة الدفاع الأمريكية أهمية تعددية النياسب، فطورت لغه البرمجة Ada التي اسـتخدمتها لخدمة مصـالحها، إلا أنها كانت غير بـائعة الاسـتخدام في المجال التعليمي أو المجال التجاري.\nبعد ذلك ومنذ فترة قريبة قامت بيئة العمل NET بتزويد جميع الات البرمجة الموجودة ضـمنها يالأدوات التي تمكن المبرمجين من بناء النياسب والتعامل معها، ووضعت هذه الأدوات في المكتبة System Thread.\nسـنتحدث في هذا الفصـل عن النياسـب وكيف يتم بنابها والتعامل معها برمجيا وكيف توظف ميزة تعددية النياسب.',
      'lesson_first_image': 'assets/images/empty.jpg',
      'lesson_second_title': 'دورة حياة النياسب',
      'lesson_second_content':
          'بعد أن تحدثنا يشـكل عام عن مفهوم النيسـب، سـوف نتحدث بالتفصـيل عن النياسـب ودورة حياتها في.NET. وسوف نتعرف على حالات النياسب Threads States وكيفية الانتقال فيمـا بينها. ومن الجدير بالذكر هنا أن المكتبـة Threading System تحـوي الـصفين Thread وMonitor اللذان يحويان الطرق اللازمة للتحكم في النياسب والتعامل معها.\nتبدأ دورة حياة النيسب من حالة عدم الانطلاق Unstarted وذلك عندما يتم بناؤه بعد تمريـر المفوض Start Thread لباني النيسب Constructor.\nيحدد هذا المفوض Delegate المهام التي يجب أن يقوم بها النيسب خلا فترة حياته. ويكـون عبارة عن طريقة تعيد لا شيء void وليس لها معاملات parameters.\nيبقى النيسـب في الحالة الابتدائية Unstarted حتى يقوم البرنامج باستدعاء الطريقـة Start التي تقوم بتغيير حالة النيسب إلى حالة التشغيل Running. ثم بعد ذلك، يعاد التحكم مباشـرة إلى التعليمة التالية في البرنامج بعدالتعليمة التي استدعت الطريقة Start.\nيمكن في هذه المرحلة، أن تنفذ النياسب الموجودة في حالة التشغيل المتزامن في نظام المعالجات المتعددة أو تتشـارك هذه النياسـب التنفيذ في نظام المعالج الوحيد. مع ملاحظة أنه ليس بالضرورة أن ينفذ النيسـب باستمرار إلا عندما يسند إلى المعالج.\nيدخل النيسـب في حالة الإيقاف أو الإحباط Stopped or Aborted عندما ينهي النيسـب المهمة التي كانت موكلة إليه يشـكل طبيعي، أو عندما يجبر البرنامج النيسـب على ذلك باستدعاء طريقة الإحبا ط أو الإنهاء المفاجئ Abort، والتـي تدخل النيـسب في حالـة طلب الإحبـاط Requested Abort حي لا يتم إنهـاء النيـسب فعليا إلا بعد استقبال لاسـتثناء إحباط النيسب\n Exception Abort Thread. ثم يقوم جامع النفايات Garbage Collector بإزالة النيسب من الذاكرة مالم تسند إليه مهمة أخرى.\nومن الجدير بالذكر أنه عندما يكون النيسـب في حالة أخرى غير حالة التشغيل، سـوف يبقى فـي حالته الحالية ويدخل في حالة طلب الإحباط Requested Abort في نفس الوقت ولكنـه لـن يسـتجيب للاستثناء Exception Abort Thread إلا بعد أن يخرج من حالته الحالية.\nيعتبر النيسـب مجمدا Blocked عندما يكون عاجزا عن اسـتخدام أي معالج حتى إذا وجد. فعلى سـبيل المثال: يصـبح النيسـب مجمدا عندما تكون مهمته طلب دخل خرج، حيث يقوم نظام التشـغيل يحجبه ومنعه من متابعة التنفيذ حتى يتمكن نظام التشغيل من إنجاز طلب الدخل الخرج الذي ينتظره النيسب.\nبعد ذلك يعود النيسب إلى حالة التشغيل ويمكن أن يعاود التنفيذ.\nكذلك، فمن الأمثلة على تجميد النيسـب في مزامنة النيسب: عندما يبدأ النيسبب المزامنة يجب أن يكون قفل معين كما سـنرى لاحقا باستدعاء الطريقة Enter الموجودة في الصـف Monitor. فإذا لم يكن القفل موجودا، سيصب النيسب مجمدا إلى أن يتاح القفل المطلوبة. يجب الملاحظة هنا أن حالة التجميد ليس حالة حبيبية فعلية في بيئة العمل NET إلا أنه مفهـوم أو تعبير يطلق على النيسب عندما لا يكون في حالة التشغيل.\nأما حالة انتظار استضم Join Sleep Wait يمكن أن يصل النيسب لها بثلاثة طرق:\nالطريقة الأولى: عندما يواجه النيسب تعليمة لا يمكن تنفيذها حاليا كأن تتطلب التعليمة حالة لم تتحقق بعد مثلا يتم استدعاء الطريقة Wait من الصف Monitor، وبالتالي يدخل النيسب في حالة الانتظار Wait. بعدها، يعود النيسب إلى حالة التشغيل عندما يستدعي نيسب آخر طريقة الإنعاش النبضة Pulse أو إنعاش الكل All Pulse من الصف Monitor. لاحظ أن طريقة الإنعاش Pulse تقوم بتغيير حالة النيسب المنتظر التالي إلى حالة التش يل بينما تقوم طريقة All Pulse بتغيير حالات جميع النياسب المنتظرة إلى حالة التشغيل.\nالطريقة الثانية: يمكن للنيسب الموجود في حالة التشغيل أن يستدعي طريقة السبات Sleep ليصب في حالة انتظارساتضم Join Sleep Wait لفترة زمنية محددة تكون الوحدة الميلي ثانية ﹸتعرف تدخل في الطريقة Sleep. ويعود النيسب من حالة السبات إلى حالة التش يل عندما ينتهي وقت السبات. لاحظ أن النيسب الذي يكون في حالة السبات لا يمكن أن يستخدم المعالج حتى وإن كان متاحا.\nالطريقة الثالثة: من الممكن أن يعتمد تنفيذ نيسب على نيسب آخر. وفي هذه الحالة يدخل النيسب حالة انتظارساتضم Join Sleep Wait حتى يستدعى النيسب المعتمد على نيسب آخر الطريقة Join والتي تقوم بربط وضم النيسبين وبعدها يخرج النيسب من تلك الحالة.\nتعود النيسب الموجودة في حالة الانتظار Wait أو في حالة الـسبات Sleep إلى حالـة التشغيل عندما تسـتدعى طريقة المقاطعة Interrupt من قبل نيسـب آخر في البرنامج. تقوم هذه الطريقة إرسال اسـتثناء مقاطعة النيسـب Exception Interruption Thread إلى النيسـب الأول. عندما يتم اسـتدعاء طريقة الإيقاف المؤقت Suspend، سـوف تنتقل حالة النيسـب من التشغيل إلى الإيقاف المؤقت.\nويمكن إعادة النيسـب إلى حالة التشغيل مرة أخرى عندما يسـتدعى البرنامج طريقة الاسـتئناف أو المتابعة\nوفي الواقع، فإنه عندما تستدعى طريقة الإيقاف المؤقت Suspend يدخل النيسب فعلي ا فـي حالة طلـب الإيقـاف المؤقـت Requested Suspend. فـإذا كان النيسب في حالـة Join Sleep Wait أو في حالة التجميد عند استدعاء طلب الإيقاف المؤقت، فسـوف يبقى النيسـب في حالته السـابقة وفي حالة انتظـار الإيقـاف المؤقـت Requested Suspend ولا يمكنه الاستجابة لطلب الإيقاف المؤقت تماما إلا بعد أن يغادر حالته الحالية. سوف نتكلم لاحقا عن كيفية التحويل لهذه الحالة يالتفصيل في مزامنة النياسب.\nوبشكل مختصر يبقى النيسب في حالة التشغيل إلا إذا صادفته أحد الحالات التالية:\nA. أن يصل إلى النهاية ويفنى.\nB. أن يجمد يسبب عمليات دخل خرج أو أي سبب آخر.\nC. أن يحو ل إلى حالة السبات أو يستدعي من الصف Monitor الطرائق الانتظار Wait أو الضم Join أو السبات Sleep.\nD. أن يتسبب نيسب آخر ذو أفضلية في إيقاف عمله مؤقتا.\nE. انتهاء الكمة الزمنية Quantum المخصصة له.\nF. كذلك يمكن أن يعمل نيسـب ويحول إلى حالة التشغيل، على الرغم من وجود نيسب آخر في حالة التشغيل. وذلك بتأجيل عمل النيسب اخر في الحالات التالية:\nإذا تم إعادة نيسب إلى حالة التشغيل بعد أن كان في حالة السبات.\nإذا انتهت معالجة عمليات دخل خرج النيسب كان قد جمد يسببها.\nإذا تم استدعاء الطرق النبضة Pulse أو All Pulse النيسب كان في حالة الانتظار.\nعندما يعود نيسب للعمل بعد خروجه من حالة الإيقاف المؤقت.\nأو بعد انتهاء تنفيذ نيسب ذو أولوية أكبر من النيسب الحالي.',
      'lesson_second_image': 'assets/images/lesson_1_second_image.jpg',
      'lesson_third_title': 'أفضليات تنظيم النياسب',
      'lesson_third_content':
          'يملك النيسب درجة أفضلية Priority معينة من بـين الأفـضليات المتـوفرة فـي التعـداد Thread Priority enumeration وتتراوح درجة هذه الأفضليات بين:\nأفضلية دنيا Lowest\n أقل من الطبيعي Below Normal. \nطبيعي Normal، وهو الوضع الافتراضي للنياسب. \nAbove Normal فوق الطبيعي. \nأفضلية العليا Highest. \nيدعم نظام التشغيل Windows ميزة اقتسام الوقت Times licing، والذي يمكن النياسـب ذات الأولوية المتساوية الفرصة في مشاركة المعالج. لاحظ أنه بدون هذه الميزة سيعمل النيـسب حتى انتهاء عمله إلا إذا تغيرت حالة النيسـب عن حالة التشـغيل دون أن يمن فرصـة للنيسب الأخرى التي تملك نفس الأولوية بالتنفيذ. أما مع ميزة تجزئة الوقت، فسيخصص لكـل نيـسب وقت معين من وقت المعالج يطلق عليه اسـم الكمة Quantum يمكن أن ينفـذ خلالهـا النيـسـب جزءا من عمله. وعند انتهاء الكمة المخصصة لنيسب، يمنع هذا النيسب من استخدام المعـالج، لتنتقل الفرصة أو الكمة إلى نيسب آخر إذا وجد وحتى لو لم ينتهي عمل النيسب الأول. \nيتلخص عمل مجدو النياسب Thread Scheduler في أنه يحرص على أن تكـون النياسـب الأكثر أولوية في حالة التشـغيل دائما. وإذا وجد أكثر من نيسـب له الأولوية الكبرى يعمل مجددا النياسـب على ضمان عملها في طريقة تسمى طريقة روبـن الدائريـة Round-Robin Fashion. \nيبين الشكل التالي تعدد مستويات الأولوية للنياسب يفرض أنها تعالج في حاسب ذو معالج وحيد. \n تتم معالجة النيسب A والنيسب B بطريق روبن الدائرية وذلك حتى تنتهي مهمة كل منهما. أي أن النيسـب A سـيأخذ من الوقت ليعمل ثم يأخذ النيسـب B مهمة ثم يعود النيـسـب A ليأخذ مهمة أخرى وهكذا حتى ينتهي عملها منهما. \nيخصص المعالج بعد ذلك كل طاقاته للنياسب المتببية في الأولويات الأدنى إلا إذا بدأ عمل نيسب آخر في نفس الأولوية الأعلى. حي يعمل النيسـب C حتى ينتهي ثم تعمل النياسـب D وE وF بنفس الطريقة الدائرية حتى تنتهي من التنفيذ. \nوهنا يجب أن نلاحظ أن الاعتماد على نظام التشغيل في جدولة النياسـب وتنفيذها حسـب أولويتها سـوف يمن النياسب الجديدة ذات الأولوية الكبرى القدرة على تأجيل تنفيذ النياسب ذات الأولوية الدنيا. مما قد يؤدي هذا التأجيل غير المحدود في بعض الأحيان إلـى تحطيم حـظ وفرصـة النياسب ذات الأولوية الدنيا من التنفيذ. \nيمكن ضبط وتعيير أولوية النياسب من الخاصية Priority والتي تأخذ قيمها من مجموعـة التعداد Priority Thread. وفي حال تم تعري هيمه غير معرفة تحت هذا التعداد سـوف يظهر اسـتثناء أو خطأ في القيمة التي تم تمريرها Exception Argument.',
      'lesson_third_image': 'assets/images/lesson_1_third_image.jpg',
      'lesson_fourth_title': 'بناء تنفيذ النياسب',
      'lesson_fourth_content':
          'لنبدأ بالرنامج البسيط التالي والذي يقوم بتطبيق الطريقة Sleep على النياسـب. يقـوم هذا البرنامج ببناء ثلاثة نياسب مختلفة، لكل منها درجة الأولوية الافتراضية الأولوية العاديـة.\nيظهر النيسـب في البداية رسـالة تشـير إلى أن النيسـب سـوف يتحول إلى حالة السـبات Sleep وذلك لفترة زمنية عشوائية ضـمن المجال 0-5000 ميللي ثانية. ثم يذهب فعليا إلى حالة السـبات. وعند انتهاء الفترة الزمنية، سوف يظهر رسالة أخر ى تبين اسم النيسب وأنه قد خرج من حال \nـة السبات، ثم ينتقل النيسـب إلى حالة الإيقاف، سـوف نلاحظ هنا أن تنفيذ البرنامج الفعلي ينتهي قبل انتهاء النياسـب من تنفيذ مهماتها. \n\nيتكون البرنامج من صفين: \nالصف Tester Thread في السطور 7-35، والذي مهمته بناء النياسب الثلاثة. \nالصـف Printer Message في السـطور 38-64، والذي مهمته تعريف الطريقة Print التي تحتوي المهمات التي ستنجزها وتعالجها النياسب. \nيقوم الباني constructor للصف Printer Message بتهيئـة متغيـر زمن الـسبات Time Sleep بإعطائه قيمة عشوائية ضمن المجال 0 - 5000. \nتبدأ الطريقة Print للصـف Printer Message بالوصول إلى النيسـب الحالي النيـسـب الذي استدعى تنفيذ الطريقة Print عن طريق الطريقة Thread Current Thread السطر 54، ثم تظهر رسالة تحتوي اسم النيسب الحالي المنفذ وأنه سوف يقوم بتنفيذ الطريقة Sleep لمدة زمنية معينة السطور 57-58 لاحظ أن التعليمة فـي الـسطر 58 تقوم ياستخدام الخاصية Name للنيسب المنفذ تحدد هذه الخاصية عند بناء النيسب. \nتتغير حالة النيسبب السـطر 59 إلى حالة انتظارسـاتضم Joint Sleep Wait، وفي هذه المرحلة سوف يفقد النيسب المعالج الذي كان يستخدمه للتنفيذ نفس نظام التـشغيل المجال لنيسب آخر إن وجد. وبعد أن يعود النيسب إلى حالة التشغيل ويخرج من حالة السبات، ينتظر حتى يتم إسناده إلى معالج معين عن طريق مجـدو النياسـب، وبعـدها سوف يظهر رسالة جديدة السـطر 62 تتضـمن اسـم النيسـب وإلى أنه قد أتم حالة الـسـبات للفترة الزمنية التي حددت له وخرج منها. \nتكون الطريقة Main المسؤولة عن تنفيذ البرنامج فعليا السـطور 9-34، حيث تبني أولا ثلاثة أغراض من الصف Printer Message السطور 13,71,21. ثم تخلق ثلاثة نياسب السطور 14,81,22 تكون مهمة كل منها تنفيذ الطريقة Print للغرض الموافق. \nيقوم المفوض Start Thread في السـطر14 يإسـناد النيسـب thread1 إلى الطريقـة\nPrint، يدخل بعد ذلك هذا النيسب في حالة التشغيل، مما يجبر الغرض printer1 على تنفيذ المهمة المعرفة في محتوى الطريقة Print، وهكذا سـوف يظهر النيسـب thread1 اسـمه والفترة الزمنية التي سوف يبقى فيها في حالة السبات ويسبت فعليا لهذه المدة ثم يعود ليظهر رسـالة أخرى تشـير إلى أن النيسـب قد أنهى السـبات، في هذه اللحظة سـوف تنتهي الطريقة Print وسوف ينتقل النيسب إلى حالة الإيقاف، وتتكرر هذه العمليات على النيسبين التاليين. \nلاحظ أنه في هذا المثال سوف ينتهي النيسب ذو الوقت الأقل من السبات أ ولا. سـوف ننـاقش لاحقا كيف نسـتطيع منع النيسـب ذو الوقت الأقل من العودة والخروج أ ولا من حالة السـبات إلى حالة التشغيل. تبين الأفكار التالية ثلاثة تنفيذات مختلفة للبرنامج.',
      'lesson_fourth_image': 'assets/images/lesson_1_fourth_image.jpg',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo'
    });
    await db.insert('lessons', {
      'lesson_name': 'الدرس الثاني',
      'lesson_first_title': 'السيمافور',
      'lesson_first_content':
          'حكي عن السمافور لانو السيمافور ظريف ما هيك الدرس شي ظريف وحلو وبيفيد الصحة لهيك الكل لازم يدرس متل الشاطر',
      'lesson_first_image': 'assets/images/lesson_1_first_image.jpg',
      'lesson_second_title': 'شبعرفني',
      'lesson_second_content': 'هي مثال كرمال نفهم شلون نشتغل',
      'lesson_second_image': 'assets/images/background.jpg',
      'lesson_third_title': 'هي بدنا نحولها sql ونقعد نعبيها متل الحبابين',
      'lesson_third_content': 'تماما متل العنوان >3',
      'lesson_third_image': 'assets/images/network.jpg',
      'lesson_fourth_title': 'ترتيب العمل',
      'lesson_fourth_content': 'واحد بعدين 2 بعدين تالتة',
      'lesson_fourth_image': 'assets/images/background.jpg',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo'
    });
    await db
        .insert('tests', {'lesson_id': 1, 'test_name': 'إختبار الدرس الأول'});
    await db
        .insert('tests', {'lesson_id': 2, 'test_name': 'إختبار الدرس الثاني'});
    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'ما هي ميزة تعددية النيسب في الحاسب:',
      'choice1': 'تنفيذ عملية واحدة في وقت واحد',
      'choice2': 'تنفيذ عدة عمليات بشكل متسلسل',
      'choice3': 'تنفيذ عدة عمليات بشكل متوازي',
      'choice4': 'توقف العمليات حتى انتهاء عملية واحدة',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ماذا يحدث إذا وصل نيسب التشغيل إلى جزء لم يحمله نيسب التحميل بعد:',
      'choice1': 'يوقف نيسب التشغيل حتى انتهاء التحميل',
      'choice2': 'يطلب من المستخدم إعادة التحميل',
      'choice3': 'يتم مزامنة النيسبين',
      'choice4': 'يتم إيقاف نيسب التحميل',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ماذا كانت ميزة تعددية النيسب محصورة على متخصصي برمجة النظم فقط في الماضي:',
      'choice1': 'لعدم توفر الأدوات اللازمة في البرمجة القديمة',
      'choice2': 'لصعوبة استخدام النيسب',
      'choice3': 'لأن البرمجة القديمة كانت تستخدم لغة Ada فقط',
      'choice4': 'لأن ميزة تعددية النيسب غير مفيدة',
      'correct_choice': 1
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي البيئة التي قدمت الأدوات اللازمة للتعامل مع النيسب في الوقت الحاضر:',
      'choice1': 'لغة Ada',
      'choice2': 'بيئة العمل NET',
      'choice3': 'البرمجة القديمة',
      'choice4': 'الأدوات البرمجية القديمة',
      'correct_choice': 2
    });
    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'ما هي الحالة التي يبدأ منها نيسب جديد في دورة حياته:',
      'choice1': 'تشغيل Running',
      'choice2': 'توقف Stopped',
      'choice3': 'عدم الانطلاق Unstarted',
      'choice4': 'انتظار Waiting',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'ماذا يحدث عندما يتم استدعاء الطريقة Start لنيسب:',
      'choice1': 'يصبح النيسب مجمدا Blocked',
      'choice2': 'يبدأ النيسب في حالة التشغيل Running',
      'choice3': 'يدخل النيسب في حالة السبات Sleep',
      'choice4': 'يتم إنهاء النيسب بشكل مفاجئ',
      'correct_choice': 2
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'متى يدخل النيسب في حالة الإيقاف أو الإحباط Stopped or Aborted:',
      'choice1': 'عند الانتهاء من تنفيذ المهمة',
      'choice2': 'عند استدعاء طريقة الإحباط Abort',
      'choice3': 'عند تعذر الوصول إلى المعالج',
      'choice4': 'عند حدوث استثناء Interrupt',
      'correct_choice': 2
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي الحالة التي يصبح فيها النيسب غير قادر على استخدام المعالج:',
      'choice1': 'تشغيل Running',
      'choice2': 'إيقاف Stopped',
      'choice3': 'تجميد Blocked',
      'choice4': 'انتظار Waiting',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'كيف يمكن لنيسب أن يدخل حالة الانتظار Waiting:',
      'choice1': 'عند استدعاء الطريقة Sleep',
      'choice2': 'عند استدعاء الطريقة Join',
      'choice3': 'عند استدعاء الطريقة Wait من الصف Monitor',
      'choice4': 'عند تعذر وصوله إلى قفل Mutex',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي الطريقة التي يمكن لنيسب استخدامها للعودة إلى حالة التشغيل بعد السبات Sleep:',
      'choice1': 'استدعاء الطريقة Pulse',
      'choice2': 'استدعاء الطريقة Join',
      'choice3': 'انتظار انتهاء وقت السبات',
      'choice4': 'استدعاء الطريقة Interrupt',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'متى يعود النيسب إلى حالة التشغيل بعد الإيقاف المؤقت Suspend:',
      'choice1': 'عند استدعاء الطريقة Resume',
      'choice2': 'عند انتهاء وقت السبات',
      'choice3': 'عند استدعاء الطريقة Pulse',
      'choice4': 'عند تنفيذ نيسب ذو أولوية أكبر',
      'correct_choice': 1
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي الحالة التي لا يمكن للنيسب الاستجابة فيها لطلب الإيقاف المؤقت Suspend:',
      'choice1': 'عندما يكون في حالة الإيقاف Stopped',
      'choice2': 'عندما يكون في حالة الانتظار Waiting',
      'choice3': 'عندما يكون في حالة التجميد Blocked',
      'choice4': 'عندما يكون في حالة السبات Sleep',
      'correct_choice': 4
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'ما الذي يسبب تجميد النيسب في حالة التجمد Blocked:',
      'choice1': 'انتظار الحصول على قفل Mutex',
      'choice2': 'انتظار انتهاء وقت السبات',
      'choice3': 'انتظار تنفيذ عملية دخل خروج',
      'choice4': 'انتظار إشعار من نيسب آخر',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'كيف يمكن للنيسب العودة إلى حالة التشغيل بعد انتهاء معالجته لعمليات دخل خروج:',
      'choice1': 'استدعاء الطريقة Pulse',
      'choice2': 'استدعاء الطريقة Join',
      'choice3': 'عودة النيسب من حالة التجمد Blocked',
      'choice4': 'استدعاء الطريقة Interrupt',
      'correct_choice': 3
    });
    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي أعلى درجة أولوية يمكن تعيينها لنيسب ضمن تعداد Thread Priority:',
      'choice1': 'Below Normal',
      'choice2': 'Normal',
      'choice3': 'Above Normal',
      'choice4': 'Highest',
      'correct_choice': 4
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي ميزة نظام تشغيل Windows التي تسمح للنياسب ذات الأولوية المتساوية بمشاركة المعالج:',
      'choice1': 'Time Sharing',
      'choice2': 'Round-Robin Scheduling',
      'choice3': 'Quantum Allocation',
      'choice4': 'Priority Scheduling',
      'correct_choice': 1
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'ماذا يحدث عندما تنتهي الكمة المخصصة لنيسب معين:',
      'choice1': 'يستمر النيسب في التنفيذ حتى ينتهي عمله',
      'choice2': 'يتم تأجيل النيسب حتى ينتهي نيسب آخر بنفس الأولوية',
      'choice3': 'ينتقل المعالج إلى نيسب آخر إذا كان موجودا',
      'choice4': 'يتم إيقاف النيسب بشكل مفاجئ',
      'correct_choice': 3
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ما هي الطريقة التي يستخدمها مجدول النياسب لضمان عمل النياسـب ذات الأولوية العالية:',
      'choice1': 'Round-Robin Fashion',
      'choice2': 'Priority Queuing',
      'choice3': 'Time Slicing',
      'choice4': 'First-Come-First-Served',
      'correct_choice': 1
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ماذا يحدث إذا كانت هناك نياسب جديدة ذات أولوية أعلى عند تنفيذ نياسب ذات أولوية دنيا:',
      'choice1': 'ستستمر النياسب ذات الأولوية الدنيا في التنفيذ حتى تنتهي',
      'choice2': 'سيتم تأجيل تنفيذ النياسب ذات الأولوية الدنيا بشكل غير محدد',
      'choice3': 'سيتم إيقاف النياسب ذات الأولوية العليا',
      'choice4': 'سيتم دمج الأولويات في التنفيذ بشكل متساوي',
      'correct_choice': 2
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text': 'كيف يمكن ضبط أولوية نيسب في .NET:',
      'choice1': 'بإعداد قيمة الخاصية Priority',
      'choice2': 'بإعداد قيمة الخاصية Scheduling',
      'choice3': 'بإعداد قيمة الخاصية Priority Level',
      'choice4': 'بإعداد قيمة الخاصية Thread Level',
      'correct_choice': 1
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'ماذا يحدث إذا تم تعيين أولوية نيسب غير معروفة في تعداد Priority Thread:',
      'choice1': 'يتم تعيين أولوية افتراضية للنيسب',
      'choice2': 'يظهر استثناء Argument Exception',
      'choice3': 'يتم تجاهل تعيين الأولوية',
      'choice4': 'يتم تعيين أولوية دنيا تلقائياً',
      'correct_choice': 2
    });

    await db.insert('questions', {
      'test_id': 1,
      'question_text':
          'كيف يتم معالجة النياسب في الحاسوب ذو معالج واحد عند استخدام طريقة روبن الدائرية:',
      'choice1': 'يتم تنفيذ النياسب بالتتابع حتى ينتهي كل منها',
      'choice2': 'يتم تخصيص وقت محدد لكل نيسب ثم الانتقال إلى نيسب آخر',
      'choice3': 'يتم تنفيذ النياسب ذات الأولوية العالية أولاً',
      'choice4': 'يتم تجاهل الأولويات وتنفيذ النياسب بشكل عشوائي',
      'correct_choice': 2
    });

    await db.insert('questions', {
      'test_id': 2,
      'question_text': ':من خواص الإتصال المرتبط',
      'choice1': 'ممكن أن تضيع الرساالة المرسلة',
      'choice2': 'يشابه الخدمة البريدية',
      'choice3': 'قابل لإرسال رسالتين في مسارين مختلفين',
      'choice4': 'يغلق عند ينتهي الاتصال من أحد الطرفين',
      'correct_choice': 4
    });
  }

  // دالة لجلب الاختبارات
  Future<List<Map<String, dynamic>>> getTests() async {
    Database db = await database;
    return await db.query('tests');
  }

  // دالة لجلب الأسئلة بناءً على معرف الاختبار مرتبة حسب الحالة
  Future<List<Map<String, dynamic>>> getQuestions(int testId) async {
    Database db = await database;
    return await db.query(
      'questions',
      where: 'test_id = ?',
      whereArgs: [testId],
      orderBy: 'state ASC',
    );
  }

  // دالة لتحديث حالة السؤال بناءً على معرفه
  Future<void> updateQuestionState(int questionId, int newState) async {
    Database db = await database;
    await db.update(
      'questions',
      {'state': newState},
      where: 'question_id = ?',
      whereArgs: [questionId],
    );
  }

  // دالة لجلب الدروس
  Future<List<Map<String, dynamic>>> getLessons() async {
    Database db = await database;
    return await db.query('lessons');
  }

  // دالة لجلب الدرس بناءً على معرف الدرس
  Future<Map<String, dynamic>?> getLessonById(int lessonId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'lessons',
      where: 'lesson_id = ?',
      whereArgs: [lessonId],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
