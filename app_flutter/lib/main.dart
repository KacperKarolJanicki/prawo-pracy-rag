import 'package:backend_connection/backend_connection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prawo_pracy/my_form.dart';
import 'package:prawo_pracy/my_list.dart';
import 'package:prawo_pracy/views/app_info.dart';
import 'package:prawo_pracy/views/notebook.dart';
import 'functions/memory.dart';
import 'package:adaptive_ad_banner/adaptive_ad_banner.dart';

TextEditingController? mainForm;
final String adUnitId = kDebugMode
    ? 'ca-app-pub-3940256099942544/9214589741'
    : 'ca-app-pub-1681515793958876/2436133552';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final String welcomeText = 'Cześć Areczku :) \nJaki masz problem w swoim Januszexie?';
  String userInput = '';
  String debugHost = 'http://192.168.0.226:5000/labour_law';
  String productionHost = 'https://prawo-pracy-rag.onrender.com/labour_law';

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool januszSaySomething = false;

  void loadNotes() async {
    saved = await Memory().loadData();
  }

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: PopupMenuButton(itemBuilder: (context)=>[
          PopupMenuItem(child: Text('Zapisane wiadomości'),
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Notebook()));
          }),
          PopupMenuItem(child: Text('O aplikacji'), onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>AppInfo()));
          }),
        ], child: Icon(Icons.menu)),
        actions: [
          MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  januszSaySomething = !januszSaySomething;
                });
              },
              child: Image.asset('assets/images/${januszSaySomething
                  ? 'janusz_x.png'
                  : 'janusz.png'}', width: 75))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Expanded(
                child: Center(
                    child: messages.isEmpty
                        ? Text(welcomeText,
                        style: TextStyle(fontSize: 45),
                        textAlign: .center).animate().fadeIn(duration: 1.seconds)
                        : Conversation(controller: scrollController)
                )),
            Padding(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: AdaptiveAdBanner(adUnitId: adUnitId)),
            Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: MyForm(
                  controller: textController,
                  submittable: userInput.isNotEmpty,
                  onChanged: (input) {
                    setState(() {
                      userInput = input;
                    });
                  },
                  onSubmit: () async {
                    textController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeOutSine);
                    }

                    setState(() {
                      requestWaiting = true;
                      messages.add({"message": userInput, "type": "request"});
                    });

                    final response = await backend.sendNReturn<String>(
                        debugHost,
                        productionHost,
                        data: {'message': userInput}
                    );

                    setState(() {
                      returnedText = response ?? "Błąd połączenia";
                      messages.add({
                        "message": returnedText,
                        "type": "response",
                        "saving": false,
                        "saved": false
                      });
                      requestWaiting = false;
                      userInput = '';
                    });

                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                          scrollController.position.extentTotal,
                          duration: Duration(seconds: 1),
                          curve: Curves.easeOutSine);
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
