import 'database_helper.dart';

class DatabaseSeeder {
  static Future<void> seedDatabase() async {
    final db = await DatabaseHelper().database;
    // إدراج بيانات عينة للدروس، الاختبارات، والأسئلة
    await db.insert('lessons', {
      'lesson_name': 'الدرس الأول: النياسب 1',
      'lesson_first_title': 'المقدمة',
      'lesson_first_content':
          'إذا أمعن النظر في طبيعة جسم الإنسان، فسوف نلاحظ أنه ينجز الكثير من العمليات مع وبنفس الوقت، فمثلا جميع العمليات الأساسية مثل التنفس والهضم والدورة الدموية هي عمليات لابد لها من أن تتم بنفس الوقت وعلى التوازي. لأنه من غير الممكن أن تنتظر إحدى هـذه العمليـات انتهاء عملية أخرى.\nكذلك، تعمل الحواس الخمس للإنسان في وقت واحد، حيث يمكن له أن يسـمع ويشـاهد، مثلا، في نفس الوقت.\nوعلى غرار ذلك، فإننا إذا أمعنا النظر في الحاسـب وكيفية قيامه عملياته الأسـاسـية، سـنلاحظ أنه قادر على تنفيذ برنامج ما واستبيان بريد الكتروني من شبكة وتنفيذ أمر دخل خرج طباعة مثلا بنفس الوقت وبشكل متوازي\nيستخدم الحاسب يشكل عام عند إنجازه لعدد من العمليات يشكل متوازي ميزة تعددية النيسب Multithreading. فإذا افترضـنا مثلا، وجود ثلاث عمليات مختلفة تتطلب التنفيذ من قبل الحاسـب بنفس الوقت، يشكل الحاسب ثلاثة نياسب Thread، بحيث يكون النيسب مسؤولا عـن تنفيذ عملية معينة، ويتم تنفيذ النياسب الثلاثة في نفس الوقت.\nإذ أنه من غير المنطقي أن تقتصر معالجة الحاسب على عملية واحدة فقط في وقت معين وبقاء جميع العمليات الأخرى معلقة حتى انتهاء هذه العملية.\nولإيضاح أهمية تعددية النياسب لنناقش المثال التالي: عندما يقوم المستخدم بتحميل برنـامج أو ملف معين من الإنترنت ليكن مقطع صوتي أو مقطع فيديو مثلا. يطلب المستخدم تشغيل المقطع قبل انتهاء التحميل كاملا. يحل الحاسـب هذه المشـكلة بتوزيع ميزة تعددية النياسـب، حيث يقوم نيسـب بتحميل المقطع بينما يقوم نيسب آخر بتشغيل المقطع.\nوهنا سيطرح السؤال التالي\nماذا سيحدث إذا وصل نيسب التشغيل إلى جزء لم يحمله نيسب التحميل بعد؟ \nيكمن الحل هنا ما سنرىThreads Synchronization.\n  \nبمزامنة النيسبين\nومن المثير للدهشة أنه رغم الفوائد الواضحة لتعددية النياسب، فقد ان توظيف هـذه الميـزة وبنائها في الماضي لأن الات البرمجة القديمة لم تقدم الأدوات اللازمـة للتعامـل مـع النياسب، وةانت هذه الميزة محصورة على متخصصي برمجة النظم فقط أدرة وازرة الدفاع الأمريكية أهمية تعددية النياسب، فطورت لغه البرمجة Ada التي اسـتخدمتها لخدمة مصـالحها، إلا أنها كانت غير بـائعة الاسـتخدام في المجال التعليمي أو المجال التجاري.\nبعد ذلك ومنذ فترة قريبة قامت بيئة العمل NET بتزويد جميع الات البرمجة الموجودة ضـمنها يالأدوات التي تمكن المبرمجين من بناء النياسب والتعامل معها، ووضعت هذه الأدوات في المكتبة System Thread.\nسـنتحدث في هذا الفصـل عن النياسـب وكيف يتم بنابها والتعامل معها برمجيا وكيف توظف ميزة تعددية النياسب.\n<image>',
      'lesson_first_image': 'assets/images/empty.jpg',
      'lesson_second_title': 'دورة حياة النياسب',
      'lesson_second_content':
          'بعد أن تحدثنا يشـكل عام عن مفهوم النيسـب، سـوف نتحدث بالتفصـيل عن النياسـب ودورة حياتها في.NET. وسوف نتعرف على حالات النياسب Threads States وكيفية الانتقال فيمـا بينها. ومن الجدير بالذكر هنا أن المكتبـة Threading System تحـوي الـصفين Thread وMonitor اللذان يحويان الطرق اللازمة للتحكم في النياسب والتعامل معها.\nتبدأ دورة حياة النيسب من حالة عدم الانطلاق Unstarted وذلك عندما يتم بناؤه بعد تمريـر المفوض Start Thread لباني النيسب Constructor.\nيحدد هذا المفوض Delegate المهام التي يجب أن يقوم بها النيسب خلا فترة حياته. ويكـون عبارة عن طريقة تعيد لا شيء void وليس لها معاملات parameters.\nيبقى النيسـب في الحالة الابتدائية Unstarted حتى يقوم البرنامج باستدعاء الطريقـة Start التي تقوم بتغيير حالة النيسب إلى حالة التشغيل Running. ثم بعد ذلك، يعاد التحكم مباشـرة إلى التعليمة التالية في البرنامج بعدالتعليمة التي استدعت الطريقة Start.\nيمكن في هذه المرحلة، أن تنفذ النياسب الموجودة في حالة التشغيل المتزامن في نظام المعالجات المتعددة أو تتشـارك هذه النياسـب التنفيذ في نظام المعالج الوحيد. مع ملاحظة أنه ليس بالضرورة أن ينفذ النيسـب باستمرار إلا عندما يسند إلى المعالج.\nيدخل النيسـب في حالة الإيقاف أو الإحباط Stopped or Aborted عندما ينهي النيسـب المهمة التي كانت موكلة إليه يشـكل طبيعي، أو عندما يجبر البرنامج النيسـب على ذلك باستدعاء طريقة الإحبا ط أو الإنهاء المفاجئ Abort، والتـي تدخل النيـسب في حالـة طلب الإحبـاط Requested Abort حي لا يتم إنهـاء النيـسب فعليا إلا بعد استقبال لاسـتثناء إحباط النيسب\n Exception Abort Thread. ثم يقوم جامع النفايات Garbage Collector بإزالة النيسب من الذاكرة مالم تسند إليه مهمة أخرى.\nومن الجدير بالذكر أنه عندما يكون النيسـب في حالة أخرى غير حالة التشغيل، سـوف يبقى فـي حالته الحالية ويدخل في حالة طلب الإحباط Requested Abort في نفس الوقت ولكنـه لـن يسـتجيب للاستثناء Exception Abort Thread إلا بعد أن يخرج من حالته الحالية.\n<image>\nيعتبر النيسـب مجمدا Blocked عندما يكون عاجزا عن اسـتخدام أي معالج حتى إذا وجد. فعلى سـبيل المثال: يصـبح النيسـب مجمدا عندما تكون مهمته طلب دخل خرج، حيث يقوم نظام التشـغيل يحجبه ومنعه من متابعة التنفيذ حتى يتمكن نظام التشغيل من إنجاز طلب الدخل الخرج الذي ينتظره النيسب.\nبعد ذلك يعود النيسب إلى حالة التشغيل ويمكن أن يعاود التنفيذ.\nكذلك، فمن الأمثلة على تجميد النيسـب في مزامنة النيسب: عندما يبدأ النيسبب المزامنة يجب أن يكون قفل معين كما سـنرى لاحقا باستدعاء الطريقة Enter الموجودة في الصـف Monitor. فإذا لم يكن القفل موجودا، سيصب النيسب مجمدا إلى أن يتاح القفل المطلوبة. يجب الملاحظة هنا أن حالة التجميد ليس حالة حبيبية فعلية في بيئة العمل NET إلا أنه مفهـوم أو تعبير يطلق على النيسب عندما لا يكون في حالة التشغيل.\nأما حالة انتظار استضم Join Sleep Wait يمكن أن يصل النيسب لها بثلاثة طرق:\nالطريقة الأولى: عندما يواجه النيسب تعليمة لا يمكن تنفيذها حاليا كأن تتطلب التعليمة حالة لم تتحقق بعد مثلا يتم استدعاء الطريقة Wait من الصف Monitor، وبالتالي يدخل النيسب في حالة الانتظار Wait. بعدها، يعود النيسب إلى حالة التشغيل عندما يستدعي نيسب آخر طريقة الإنعاش النبضة Pulse أو إنعاش الكل All Pulse من الصف Monitor. لاحظ أن طريقة الإنعاش Pulse تقوم بتغيير حالة النيسب المنتظر التالي إلى حالة التش يل بينما تقوم طريقة All Pulse بتغيير حالات جميع النياسب المنتظرة إلى حالة التشغيل.\nالطريقة الثانية: يمكن للنيسب الموجود في حالة التشغيل أن يستدعي طريقة السبات Sleep ليصب في حالة انتظارساتضم Join Sleep Wait لفترة زمنية محددة تكون الوحدة الميلي ثانية ﹸتعرف تدخل في الطريقة Sleep. ويعود النيسب من حالة السبات إلى حالة التش يل عندما ينتهي وقت السبات. لاحظ أن النيسب الذي يكون في حالة السبات لا يمكن أن يستخدم المعالج حتى وإن كان متاحا.\nالطريقة الثالثة: من الممكن أن يعتمد تنفيذ نيسب على نيسب آخر. وفي هذه الحالة يدخل النيسب حالة انتظارساتضم Join Sleep Wait حتى يستدعى النيسب المعتمد على نيسب آخر الطريقة Join والتي تقوم بربط وضم النيسبين وبعدها يخرج النيسب من تلك الحالة.\nتعود النيسب الموجودة في حالة الانتظار Wait أو في حالة الـسبات Sleep إلى حالـة التشغيل عندما تسـتدعى طريقة المقاطعة Interrupt من قبل نيسـب آخر في البرنامج. تقوم هذه الطريقة إرسال اسـتثناء مقاطعة النيسـب Exception Interruption Thread إلى النيسـب الأول. عندما يتم اسـتدعاء طريقة الإيقاف المؤقت Suspend، سـوف تنتقل حالة النيسـب من التشغيل إلى الإيقاف المؤقت.\nويمكن إعادة النيسـب إلى حالة التشغيل مرة أخرى عندما يسـتدعى البرنامج طريقة الاسـتئناف أو المتابعة\nوفي الواقع، فإنه عندما تستدعى طريقة الإيقاف المؤقت Suspend يدخل النيسب فعلي ا فـي حالة طلـب الإيقـاف المؤقـت Requested Suspend. فـإذا كان النيسب في حالـة Join Sleep Wait أو في حالة التجميد عند استدعاء طلب الإيقاف المؤقت، فسـوف يبقى النيسـب في حالته السـابقة وفي حالة انتظـار الإيقـاف المؤقـت Requested Suspend ولا يمكنه الاستجابة لطلب الإيقاف المؤقت تماما إلا بعد أن يغادر حالته الحالية. سوف نتكلم لاحقا عن كيفية التحويل لهذه الحالة يالتفصيل في مزامنة النياسب.\nوبشكل مختصر يبقى النيسب في حالة التشغيل إلا إذا صادفته أحد الحالات التالية:\nA. أن يصل إلى النهاية ويفنى.\nB. أن يجمد يسبب عمليات دخل خرج أو أي سبب آخر.\nC. أن يحو ل إلى حالة السبات أو يستدعي من الصف Monitor الطرائق الانتظار Wait أو الضم Join أو السبات Sleep.\nD. أن يتسبب نيسب آخر ذو أفضلية في إيقاف عمله مؤقتا.\nE. انتهاء الكمة الزمنية Quantum المخصصة له.\nF. كذلك يمكن أن يعمل نيسـب ويحول إلى حالة التشغيل، على الرغم من وجود نيسب آخر في حالة التشغيل. وذلك بتأجيل عمل النيسب اخر في الحالات التالية:\nإذا تم إعادة نيسب إلى حالة التشغيل بعد أن كان في حالة السبات.\nإذا انتهت معالجة عمليات دخل خرج النيسب كان قد جمد يسببها.\nإذا تم استدعاء الطرق النبضة Pulse أو All Pulse النيسب كان في حالة الانتظار.\nعندما يعود نيسب للعمل بعد خروجه من حالة الإيقاف المؤقت.\nأو بعد انتهاء تنفيذ نيسب ذو أولوية أكبر من النيسب الحالي.',
      'lesson_second_image': 'assets/images/lesson_1_second_image.jpg',
      'lesson_third_title': 'أفضليات تنظيم النياسب',
      'lesson_third_content':
          'يملك النيسب درجة أفضلية Priority معينة من بـين الأفـضليات المتـوفرة فـي التعـداد Thread Priority enumeration وتتراوح درجة هذه الأفضليات بين:\nأفضلية دنيا Lowest\n أقل من الطبيعي Below Normal. \nطبيعي Normal، وهو الوضع الافتراضي للنياسب. \nAbove Normal فوق الطبيعي. \nأفضلية العليا Highest. \nيدعم نظام التشغيل Windows ميزة اقتسام الوقت Times licing، والذي يمكن النياسـب ذات الأولوية المتساوية الفرصة في مشاركة المعالج. لاحظ أنه بدون هذه الميزة سيعمل النيـسب حتى انتهاء عمله إلا إذا تغيرت حالة النيسـب عن حالة التشـغيل دون أن يمن فرصـة للنيسب الأخرى التي تملك نفس الأولوية بالتنفيذ. أما مع ميزة تجزئة الوقت، فسيخصص لكـل نيـسب وقت معين من وقت المعالج يطلق عليه اسـم الكمة Quantum يمكن أن ينفـذ خلالهـا النيـسـب جزءا من عمله. وعند انتهاء الكمة المخصصة لنيسب، يمنع هذا النيسب من استخدام المعـالج، لتنتقل الفرصة أو الكمة إلى نيسب آخر إذا وجد وحتى لو لم ينتهي عمل النيسب الأول. \nيتلخص عمل مجدو النياسب Thread Scheduler في أنه يحرص على أن تكـون النياسـب الأكثر أولوية في حالة التشـغيل دائما. وإذا وجد أكثر من نيسـب له الأولوية الكبرى يعمل مجددا النياسـب على ضمان عملها في طريقة تسمى طريقة روبـن الدائريـة Round-Robin Fashion. \nيبين الشكل التالي تعدد مستويات الأولوية للنياسب يفرض أنها تعالج في حاسب ذو معالج وحيد. \n تتم معالجة النيسب A والنيسب B بطريق روبن الدائرية وذلك حتى تنتهي مهمة كل منهما. أي أن النيسـب A سـيأخذ من الوقت ليعمل ثم يأخذ النيسـب B مهمة ثم يعود النيـسـب A ليأخذ مهمة أخرى وهكذا حتى ينتهي عملها منهما. \nيخصص المعالج بعد ذلك كل طاقاته للنياسب المتببية في الأولويات الأدنى إلا إذا بدأ عمل نيسب آخر في نفس الأولوية الأعلى. حي يعمل النيسـب C حتى ينتهي ثم تعمل النياسـب D وE وF بنفس الطريقة الدائرية حتى تنتهي من التنفيذ. \nوهنا يجب أن نلاحظ أن الاعتماد على نظام التشغيل في جدولة النياسـب وتنفيذها حسـب أولويتها سـوف يمن النياسب الجديدة ذات الأولوية الكبرى القدرة على تأجيل تنفيذ النياسب ذات الأولوية الدنيا. مما قد يؤدي هذا التأجيل غير المحدود في بعض الأحيان إلـى تحطيم حـظ وفرصـة النياسب ذات الأولوية الدنيا من التنفيذ. \nيمكن ضبط وتعيير أولوية النياسب من الخاصية Priority والتي تأخذ قيمها من مجموعـة التعداد Priority Thread. وفي حال تم تعري هيمه غير معرفة تحت هذا التعداد سـوف يظهر اسـتثناء أو خطأ في القيمة التي تم تمريرها Exception Argument.\n<image>',
      'lesson_third_image': 'assets/images/lesson_1_third_image.jpg',
      'lesson_fourth_title': 'بناء تنفيذ النياسب',
      'lesson_fourth_content':
          'لنبدأ بالرنامج البسيط التالي والذي يقوم بتطبيق الطريقة Sleep على النياسـب. يقـوم هذا البرنامج ببناء ثلاثة نياسب مختلفة، لكل منها درجة الأولوية الافتراضية الأولوية العاديـة.\nيظهر النيسـب في البداية رسـالة تشـير إلى أن النيسـب سـوف يتحول إلى حالة السـبات Sleep وذلك لفترة زمنية عشوائية ضـمن المجال 0-5000 ميللي ثانية. ثم يذهب فعليا إلى حالة السـبات. وعند انتهاء الفترة الزمنية، سوف يظهر رسالة أخر ى تبين اسم النيسب وأنه قد خرج من حال \nـة السبات، ثم ينتقل النيسـب إلى حالة الإيقاف، سـوف نلاحظ هنا أن تنفيذ البرنامج الفعلي ينتهي قبل انتهاء النياسـب من تنفيذ مهماتها. \n\nيتكون البرنامج من صفين: \nالصف Tester Thread في السطور 7-35، والذي مهمته بناء النياسب الثلاثة. \nالصـف Printer Message في السـطور 38-64، والذي مهمته تعريف الطريقة Print التي تحتوي المهمات التي ستنجزها وتعالجها النياسب. \nيقوم الباني constructor للصف Printer Message بتهيئـة متغيـر زمن الـسبات Time Sleep بإعطائه قيمة عشوائية ضمن المجال 0 - 5000. \nتبدأ الطريقة Print للصـف Printer Message بالوصول إلى النيسـب الحالي النيـسـب الذي استدعى تنفيذ الطريقة Print عن طريق الطريقة Thread Current Thread السطر 54، ثم تظهر رسالة تحتوي اسم النيسب الحالي المنفذ وأنه سوف يقوم بتنفيذ الطريقة Sleep لمدة زمنية معينة السطور 57-58 لاحظ أن التعليمة فـي الـسطر 58 تقوم ياستخدام الخاصية Name للنيسب المنفذ تحدد هذه الخاصية عند بناء النيسب. \nتتغير حالة النيسبب السـطر 59 إلى حالة انتظارسـاتضم Joint Sleep Wait، وفي هذه المرحلة سوف يفقد النيسب المعالج الذي كان يستخدمه للتنفيذ نفس نظام التـشغيل المجال لنيسب آخر إن وجد. وبعد أن يعود النيسب إلى حالة التشغيل ويخرج من حالة السبات، ينتظر حتى يتم إسناده إلى معالج معين عن طريق مجـدو النياسـب، وبعـدها سوف يظهر رسالة جديدة السـطر 62 تتضـمن اسـم النيسـب وإلى أنه قد أتم حالة الـسـبات للفترة الزمنية التي حددت له وخرج منها. \nتكون الطريقة Main المسؤولة عن تنفيذ البرنامج فعليا السـطور 9-34، حيث تبني أولا ثلاثة أغراض من الصف Printer Message السطور 13,71,21. ثم تخلق ثلاثة نياسب السطور 14,81,22 تكون مهمة كل منها تنفيذ الطريقة Print للغرض الموافق. \nيقوم المفوض Start Thread في السـطر14 يإسـناد النيسـب thread1 إلى الطريقـة\nPrint، يدخل بعد ذلك هذا النيسب في حالة التشغيل، مما يجبر الغرض printer1 على تنفيذ المهمة المعرفة في محتوى الطريقة Print، وهكذا سـوف يظهر النيسـب thread1 اسـمه والفترة الزمنية التي سوف يبقى فيها في حالة السبات ويسبت فعليا لهذه المدة ثم يعود ليظهر رسـالة أخرى تشـير إلى أن النيسـب قد أنهى السـبات، في هذه اللحظة سـوف تنتهي الطريقة Print وسوف ينتقل النيسب إلى حالة الإيقاف، وتتكرر هذه العمليات على النيسبين التاليين. \nلاحظ أنه في هذا المثال سوف ينتهي النيسب ذو الوقت الأقل من السبات أ ولا. سـوف ننـاقش لاحقا كيف نسـتطيع منع النيسـب ذو الوقت الأقل من العودة والخروج أ ولا من حالة السـبات إلى حالة التشغيل. تبين الأفكار التالية ثلاثة تنفيذات مختلفة للبرنامج.\n<image>',
      'lesson_fourth_image': 'assets/images/lesson_1_fourth_image.jpg',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo'
    });

    await db.insert('lessons', {
      'lesson_name': 'الدرس الثاني يمكن؟',
      'lesson_first_title': 'مزامنة النياسب :Synchronization Thread',
      'lesson_first_content':
          'إذا كانت لدينا عدة نياسب تتشارك في استخدام نفس البيانات ، فيمكن لهذه النياسب أن تقرأ هــــــذه البيانات أو أن تصـل إلى جزء منها بدون أي مشـكلة\n ولكن عندما تتشارك عدة نياسب في بيانات معينة وتقوم بالتعديل على هذه البيانات، فســتحدث مشــاكل تضــارب collision ما لم يتم مزامنة النياســب التي تشــترك في هذه البيانات\n فمثال: لنفترض وجود نيسبان يقومان بتحديث بيانات معينة في وقــــت واحد ولكن لــــم تــــتم مزامنتهما\n سيتم بالطبع تحديث البيانات عن طريق آخر نيســـــــــب مع تجاهل ما قام به النيســـــــــب الأول من تعديلات\n وإذا كانت هذه البيانات ممثلة بمصـــــفوفة أو أي بنية معطيات أخرى وبحيث تمكن النياسـب من تحديث أجزاء من هذه البيانات يعكس منفصـــــلة من هذه البيانات في نفس الوقت، فمن الممكن أن نلاحـــــــــــــــظ أن جزءا من هذه  بيانات يعكس بيانات من نيسـب والجزء الأخر يعكس بيانات من نيـسـب آخـ ـر، وسـيكون من الصـعب جدا البرنامج متى تم تحدي هذه البيانات\n يتم حل المشاكل السابقة  بمزامنة Synchronization النياسب التي تريد مشاركة بيانات معينــــــــة لقراءتها والتعديل فيها\n حيث نقصـد بالمزامنة هنا، إعطاء الإمكانية لنيسـب واحد فقط بمعالجة البيانات والسـماح له بالتأثير فيها بشـكل حصـري exclusive وخلال هذا الوقت تكــــــــــــون النياسـب الأخرى في حالة الانتظار\n وعندما ينتهي النيسب المتحكم في البيانات، تمـــــنح الفرصـــــة لاحـــــد النياسب المنتظرة للتعامل معها، وبهذه الطريقة سيتعامل كل نيسب مع البيانات بشكل حـصري وستمنع النياسب  الأخرى من التعامل مع البيانات في وقت واحد\n يقدم الصـف (Monitor )عدد امن الطرق التي تمكن من مزامنة النياسـب(مشـاركة نياسـب متعددة لبيانات  معينة)\n عندما يحتاج نيسب معين أن يتعامل مع غرض بشكل حصري، يجب أن يستدعي هذا النيـسب الطريقة( Enter)من الصف (Monitor ),تقوم هذه الطريقة بتثبيت قفل على الغرض وبحيــث يمكن لنيسب واحد فقط التعامل معها\n يكون لكل غرض الخاصية        (Block Sync )التي تحدد حالة قفل الغرض\n وفي حال طلب أي نيسب آخر التعامل مع غرض مقفل فإنه يجمد Blocked\nعندما ينتهي النيسـب من التعامل مع الغرض ينفذ الطريقة Exit لتحرير الغرض من القفل كمــــــــــــا سـيتم تحديث حالة قفل الغرض(Block Sync)   لتشـير بأنه أصـبح حرًا ومتاحا من جديد\nوإذا وجد نيسـب كان قد وضع في حالة التجميد فسوف يعاد إلى حالة التشغيل وتكرر العمليــات الــسابقة، وهكذا، إلى أن تنتهي جميع النياسب التي تريد التعامل مع الأغراض نفسها\nيجب هنا الانتباه إلى الأخطاء البرمجية التالية الشائعة: • يجـب التـأكـد من أن جميع التعليمـات التي تعمـل على تعـديـل الغرض تطلـب قفـل الغرض قبـل التعامل معه\n تظهر حالةDeadlock ))عند عدم قدرة نيسب ما على التنفيذ يسبب انتظاره لنيسب آخر وفي نفس الوقت لا ينفذ النيسب الثاني لأنه في انتظار تنفيذ النيسب الأول ، أي أن هنالك نيسبان في انتظار يعضهما البعض\n لا يمكن لنيســب في حالة انتظار /ســبات/ ضــم أن يعاد إلى حالة التشغيل ليكمل تنفيذ مهمته، إلا إذا قام نيسب آخر باستدعاء طريقة الإنعاش (Pulse )أو إنعاش الكل (Pulse All)، وإلا سيبقى النيسب منتظر ا وهذا عمليا يشبه حالة (Deadlock)\nيمكن أيضا تطبيق المفهوم السابق عمليا (C#) كالتالي: يتم وضع الغرض المراد قفله كدخل للطريقة look:{Lock (object Referenc)}التعليمات التي تطلب المزامنة تكتب هنا\n// تمنح التعليمة الســابقة قفل للنيســب الذي يريد التعامل مع الغرض الذي مرر مرجعه بين القوســين، ويدخل الغرض ذاته وضع حظر القفل حتى لا يمكن لنيسب آخر أن يمنح قفل علـى الغرض نفسه\n ويكون مرجع الغرض هو نفسه الذي يمرر بالعادة إلى طرائق الصف \n(Monitor)دخول ، خروج، إنعاش، خروج\nوالتي تستخدم عند مزامنة النياسب والتي سنتحدث عنها لاحقا\n عند انتهاء وضـع حظر القفل ألي سـبب من الأسباب يحرر C#الغرض من القفل الذي كان قـد من للنيسـب\nفمثلا ، عندما يتوقف عمل النيســـــب الذي يملك القفل على تحقق بـــــر معين ويـدخل حالة الانتظار ســـــــوف يحرر الغرض من القفل\n وعند تحقق الشـروط التي ينتظرها النيسـب ويعود إلى حالة التشغيل يمكنه إعادة طلب قفل على الغرض ليكمل مهمته\n وممـا يجـب أن يلاحظ هنـا أنـه يوجـد فرق بين أن يكون النيسـب منتظرا يكون النيسب في حالة التجميد وليس في حالة الانتظار وأن يكون في حالـة انتظـار /ضم/ سبات عمليا ينتظر تحقق شرط معين\n',
      'lesson_first_image': 'assets/images/background.jpg',
      'lesson_second_title': 'شبعرفني',
      'lesson_second_content': 'هي مثال كرمال نفهم شلون نشتغل\n<image>',
      'lesson_second_image': 'assets/images/background.jpg',
      'lesson_third_title': 'هي بدنا نحولها sql ونقعد نعبيها متل الحبابين',
      'lesson_third_content': 'تماما متل العنوان >3\n<image>',
      'lesson_third_image': 'assets/images/network.jpg',
      'lesson_fourth_title': 'ترتيب العمل',
      'lesson_fourth_content': 'واحد بعدين 2 بعدين تالتة\n<image>',
      'lesson_fourth_image': 'assets/images/background.jpg',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo',
    });
    await db.insert('lessons', {
      'lesson_name': 'الدرس الثالث :برمجة التطبيقات الشبكية زبون/مخدم',
      'lesson_first_title': 'مقدمة',
      'lesson_first_content':
          'يمنح التعامل مع شبكة الإنترنت وعالم الويب الكثير من الإمكانيات، لما تُقدمه من خدمات متنوعة، بالإضافة إلى القدرة على الحصول على المعلومات من أي مكان في العالم\n كما تساهم الشبكات في تحسين الأداء من خلال مشاركة البيانات عبر شبكة الإنترنت\n تُعتبر المكتبة البرمجية (Framework Class Library - FCL) الخاصة بـ \nNET هي الأداة الأساسية التي تساعد في تطوير تطبيقات الويب وتطبيقات الإنترنت\n من خلالها، يمكن للبرامج البحث عن المعلومات في جميع أنحاء العالم، ومشاركة البيانات مع أجهزة أخرى في مناطق بعيدة\n سنقوم في الفصل القادم بدراسة خدمات الويب (Web Services) المستخدمة في بناء التطبيقات الموزعة، وذلك على مستوى عالٍ\n سنبدأ بالتطرق إلى تقنيات الاتصالات المستخدمة في نقل البيانات عبر شبكة الإنترنت، ثم نشرح الطرق الأساسية لإقامة اتصال بين تطبيقين يستخدمان أساليب تدفق البيانات\n سنناقش الاتصال المرتبط (Connection-Oriented) الذي يمكّن برنامجين من التواصل ونقل البيانات، بالإضافة إلى طرق القراءة والكتابة من وإلى الملفات\n بعد ذلك، سنعالج تطبيق محادثة (Chatting) يستخدم هذه التقنيات لتبادل الرسائل بين الزبون والخادم\n سنتناول أيضًا تقنيات الاتصال غير المرتبط (Connectionless) لنقل البيانات بين التطبيقات، والتي تتسم بكونها أقل موثوقية مقارنة بالاتصال المرتبط\n سنستعرض تطبيقات تعتمد على هذه التقنية في نقل البيانات، مثل البث المباشر عبر الإنترنت\n سنركز بعد ذلك على مكون التحكم الجديد (Web Browser)، الذي يعد ضروريًا للتفاعل مع التطبيقات التي تستخدم الويب\n وسنختتم الفصل بالحديث عن تقنية الشبكات عن بُعد (Remoting) في \nNET، التي توفر خدمات مشابهة لخدمات الويب، مما يسمح بتنفيذ عمليات المعالجة الموزعة عبر الشبكة\n',
      'lesson_first_image': 'assets/images/background.jpg',
      'lesson_second_title':
          'مقارنة بين الاتصال المرتبط (Connection-Oriented Communication) والاتصال عديم الارتباط (Connectionless Communication)',
      'lesson_second_content':
          'الاتصال بين التطبيقات: الاتصال المرتبط والاتصال عديم الارتباط توجد رُنكَتان رئيسيتان لتحقيق الاتصال بين التطبيقات الاتصال المرتبط (Connection-Oriented Communicationيشبه هذا النوع من الاتصال الشبكة الهاتفية، حيث يتم تأسيس الاتصال والحفاظ عليه مفتوحًا حتى انتهاء التواصل من قِبل أحد الطرفين\n يبقى الاتصال مفتوحًا لنقل المعلومات بين الطرفين\n في الاتصال المرتبط، يتم إرسال معلومات تحكم بين الحواسيب لتفعيل الاتصال بين الطرفين، وتعرف هذه التقنية بالمصافحة (Handshaking)\n يعتبر الاتصال المرتبط موثوقًا حيث يتم ضمان توصيل الرزم (Packets) بدون فقدان أو تكرار، كما يتم تجميع البيانات بالترتيب الصحيح\n الاتصال عديم الارتباط (Connectionless Communication) يشبه هذا النوع من الاتصال الخدمة البريدية، حيث يمكن إرسال الرسائل من موقع إلى آخر عبر مسارات مختلفة وفي أوقات مختلفة، وقد تتأخر أو تفقد بعض الرزم أثناء النقل\n في الاتصال عديم الارتباط، لا يتم تأسيس اتصال مسبق\n تُرسل البيانات في رزم يمكن أن تتبع مسارات متعددة، وقد تصل الرزم تالفة أو في ترتيب غير صحيح\n يُعتبر هذا النوع من الاتصال غير موثوق، لأنه لا يضمن توصيل البيانات بشكل دقيق\n الملخص: يعتمد اختيار نوع الاتصال على متطلبات التطبيق\n إذا كانت الموثوقية والتسلسل من الأولويات، فإن الاتصال المرتبط يكون الخيار المناسب\n بينما إذا كانت السرعة والكفاءة هي الأكثر أهمية، فإن الاتصال عديم الارتباط قد يكون الأفضل\n الشبكة (مثل الإنترنت) تعتبر شبكة غير موثوقة، مما يعني أن المعلومات والبيانات المرسلة عبرها يمكن أن تفقد أو تتعطل أثناء عملية النقل\n',
      'lesson_second_image': 'assets/images/background.jpg',
      'lesson_third_title': 'بروتوكولات نقل البيانات ',
      'lesson_third_content':
          'هناك العديد من البروتوكولات لنقل البيانات التي تعرّف كيفية الاتصال بين التطبيقات\n يمكن تعريف البروتوكول بأنه مجموعة من القواعد التي تحكم كيفية تبادل البيانات بين مكونين (يمكن أن تكون هذه المكونات عبارة عن حواسب)\n سنقوم في هذا الفصل بالتركيز على بروتوكول التحكم في النقل (Transmission Control Protocol - TCP) المستخدم لنقل البيانات بشكل موثوق، وبروتوكول بيانات المستخدم (User Datagram Protocol - UDP)\nتوفر \nNET إمكانيات التعامل مع البروتوكولات TCP وUDP ضمن فئة الأسماء System\nNet\nSockets\n يعتبر البروتوكول TCP بروتوكولًا مرتبطًا لأنه يضمن توصيل البيانات بشكل موثوق\n يُستخدم البروتوكول TCP في العديد من البروتوكولات العليا مثل البروتوكول HTTP لتبادل المعلومات عبر شبكة الإنترنت بطريقة مشبّعة، حيث يقوم البروتوكول TCP بإعادة إرسال رزم البيانات في حال فقدانها وعدم وصولها إلى الوجهة المقصودة\n كما يمكنه تجميع الرزم بالتسلسل الصحيح وبصورة واضحة للتطبيق المستلم، بالإضافة إلى استبعاد الرزم المكررة في المقابل، يُستخدم الاتصال عديم الارتباط (UDP) من قبل التطبيقات التي لا تتطلب تبادل معلومات موثوق بين الطرفين\n يُمكن البروتوكول UDP من الحد الأدنى من نقل البيانات دون الحاجة إلى التأكيد على عملية الاتصال بين التطبيقات\n لا يقدم البروتوكول UDP ضمانًا لوصول رزم البيانات، والتي تُسمى برقيات البيانات (Datagrams)، إلى الوجهة المقصودة، ولا يأتي ترتيب وصولها كما أرسلت على الرغم من عدم موثوقية UDP، فإن له فوائد عدة يمكن الحصول عليها عند استخدامه بدلاً من TCP\n فعند استخدام البروتوكول UDP، تشكّل عملية نقل البيانات بين طرفي الاتصال حملاً أقل على الشبكة، حيث لا تحتاج رزم البيانات إلى حمل معلومات التحكم التي يحتاجها البروتوكول TCP لضمان موثوقية وصول المعلومات\n في حال عدم وصول البيانات، يمكن استخدام البروتوكول UDP في حالات معينة، مثل الحوارات العملية في بيئات تحتاج إلى سرعة عالية، حيث تكون الوثوقية غير مطلوبة في بعض الأحيان\n بعض التطبيقات، مثل نقل الصوت والفيديو، يمكن أن تتسامح مع فقدان بعض برقيات البيانات، وفي هذه الحالات يكون استخدام البروتوكول UDP أكثر فعالية\n إذا استخدمت التطبيقات البروتوكول TCP، فإن فقدان أي جزء من البيانات قد يؤدي إلى توقف كبير ولاحظ لتشغيل التطبيق، حيث يجب إعادة إرسال الجزء المفقود عند النقل أو استقباله لاستمرار عمل التطبيق\n إضافة إلى ذلك، يمكن لبعض التطبيقات الحاسوبية والتي تحتاج إلى تقنيات موثوقية خاصة أن تقوم بتطوير بروتوكولات تعتمد على UDP\n ',
      'lesson_third_image': 'assets/images/network.jpg',
      'lesson_fourth_title':
          'بناء مخدم TCP باستخدام مقابس تدفق البيانات (Sockets Stream)',
      'lesson_fourth_content':
          'بناء مخدم TCP باستخدام مقابس تدفق البيانات (Sockets Stream)يقوم المخدم عادة باستقبال الطلبات من الزبائن، ويحتوي برنامج المخدم على كتل برمجية تعمل بشكل مستمر لتقبل الطلبات عند وصولها إلى المخدم\n يقوم المخدم بإنشاء اتصال مع الزبون، وبعد ذلك يستخدم هذا الاتصال لمعالجة الطلبات المستقبلة وإرسال المعلومات إليه\n يتم إدارة الاتصالات من خلال استخدام الكائن (Socket)، حيث يقوم البروتوكول TCP بمعالجة البيانات التي تستقبل وترسل كتيار من البايتات (Bytes)\n يتطلب إنشاء مخدم TCP استخدام مقاطع تدفق البيانات (Sockets Stream)، ويتضمن ذلك عدة مراحل: المرحلة الأولى: إنشاء الكائن Listener يجب أولاً إنشاء كائن من النوع TCP Listener باستخدام نظام الأسماء (`System\nNet\nSockets`)\n هذا الكائن يستمع للطلبات المرسلة إليه\n يتم إنشاء كائن جديد من النوع TCP Listener كما يلي:TCPListener server = new TCPListener(IPAddress\nAny, portحيث يتم ربط تطبيق المخدم برقم منفذ محدد (port)\n يمكن أن يتراوح هذا الرقم بين 0 و 65535، إلا أن الأرقام الأقل من 1024 محجوزة عادةً لخدمات معروفة مثل خدمات الويب والبريد الإلكتروني\nالمرحلة الثانية: بدء الاستماع لطلبات الاتصال يجب استدعاء الطريقة `Start` من الكائن TCP Listener ليبدأ في الاستماع لطلبات الاتصال\n المرحلة الثالثة: تأسيس الاتصال بين المخدم والزبون يبقى المخدم مستمراً في الاستماع للطلبات المرسلة إليه، حتى يقوم أحد الزبائن بمحاولة الاتصال\n بعد أن ينشئ المخدم اتصالاً، يتعامل الكائن Socket مع الاتصال مع الزبون\n الطريقة `Accept Socket` من الكائن TCP Listener تُستخدم لقبول الطلب، وتعيد كائن من النوع Socket يمثل الاتصال الجديد Socket connection = server\nAcceptSocket()يبدو أن النص الذي قدمته يحتوي على العديد من الأخطاء الإملائية واللغوية\n سأقوم بإعادة صياغته وتحسينه ليظهر بشكل أفضل: عندما يستقبل المخدم طلب اتصال من عميل، يقوم باستدعاء الدالة `Accept` من كائن `TCP Listener` لجعل الاتصال مفعلًا\n تخفي هذه الدالة في لغة #C التفاصيل المعقدة التي تتم على مستوى الشبكة عن المبرمج، مما يتيح له كتابة كود بسيط وفعّال في برنامج المخدم\n يمكن استخدام المكتبة `System\nNet\nSockets` في C# لمعالجة تفاصيل قبول الطلبات وتأسيس الاتصالات\n المرحلة الرابعة: معالجة الاتصالات يغطي هذا القسم استقبال وإرسال الطلبات والمعلومات بين المخدم والعميل عبر الدالتين `Send` و`Receive` من كائن `Socket`\n يجب ملاحظة أن هاتين الدالتين يمكن استخدامهما فقط في حالة وجود اتصال ثابت بين المخدم والعميل\n أما في حالة استخدام بروتوكولات البيانات مثل UDP، يمكن استخدام دوال `Send To` و`Receive From` في حالة عدم وجود اتصال ثابت\nالمرحلةالخامسة: إنهاء الاتصالعند انتهاء المخدم والعميل من عملية استقبال وإرسال البيانات، يستخدم المخدم الدالة `Close` من كائن `Socket` لإنهاء الاتصال بشكل صحيح\n بعد الانتهاء من الاتصال، يعود المخدم إلى حالة الانتظار لاستقبال اتصالات جديدة من قبل العملاء\n معالجة مشكلات الاتصال توجد مشكلة شائعة عند استخدام طرق الاتصال المتزامنة، حيث قد تتسبب في حجب الطلبات الأخرى أثناء معالجة الطلبات الحالية\n مما يعني أن العملاء الآخرين قد لا يتمكنون من الاتصال بالمخدم في الوقت الذي يكون فيه مشغولًا بمعالجة طلبات سابقة\nلحل هذه المشكلة، يجب استخدام البرمجة متعددة الخيوط (Multi-threading)\n عند استقبال اتصال جديد من قبل المخدم، يقوم بإنشاء خيط (Thread) جديد لمعالجة الطلب الجديد، مما يسمح للمقبس وTCP Listener بالاستمرار في استقبال اتصالات أخرى في نفس الوقت\n',
      'lesson_fourth_image': 'assets/images/background.jpg',
      'lesson_link': 'https://www.youtube.com/watch?v=9ANSu9Cg-Bo',
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
      'test_id': 2,
      'question_text': ':من خواص الإتصال المرتبط',
      'choice1': 'ممكن أن تضيع الرساالة المرسلة',
      'choice2': 'يشابه الخدمة البريدية',
      'choice3': 'قابل لإرسال رسالتين في مسارين مختلفين',
      'choice4': 'يغلق عند ينتهي الاتصال من أحد الطرفين',
      'correct_choice': 4
    });
  }
}
