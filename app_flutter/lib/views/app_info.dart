import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({super.key});

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  String _version = '';
  final String _description =
      "Idealna aplikacja dla wszystkich zapracowanych Areczków, których nasze "
      "polskie Janusze i Grażyny biznesu wykorzystują bez żadnych skrupułów żerując na "
      "nieświadomości z zakresu prawa pracy. Ten chatbot może być przydatnym narzędziem "
      "w momencie, gdy pracodawca poraz kolejny będzie liczył na nieznajomość Twoich praw. "
      "Wystarczy, że opiszesz swój problem, a w odpowiedzi otrzymasz opis podparty konkretnymi przepisami.";

  void _appVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
    });
  }

  @override
  void initState() {
    super.initState();
    _appVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Info'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 15,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/janusz_z.png', width: 250)
                  .animate()
                  .fadeIn(duration: 1.seconds),
              _infoTile('App Developer', 'Kacper Janicki')
                  .animate()
                  .fadeIn(duration: 1.seconds),
              _infoTile('App Version', _version)
                  .animate()
                  .fadeIn(duration: 1.seconds),
              Text(
                _description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(duration: 3.seconds),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 20)),
      ],
    );
  }
}
