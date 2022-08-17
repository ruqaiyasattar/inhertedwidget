import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue
      ),
      home: ApiProvider(
        api: Api(),
        child: const HomePage(),
      ),
    ),
  );
}

class ApiProvider extends InheritedWidget{
  final Api api;
  final String uuid;

  ApiProvider({
    Key? key,
    required this.api,
    required Widget child,
  }) : uuid = const Uuid().v4(),
        super(
        key: key,
        child: child,
      );

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid != oldWidget.uuid; //condition either child needs to redrown or not
  }

  static ApiProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This widget is the root of your application.

  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApiProvider.of(context).api.dateAndime ?? '',
          style:const TextStyle(fontSize: 24),
        ),
      ),
      body: GestureDetector(
        onTap: () async{

          final api = ApiProvider.of(context).api;
          final dateAndTime = await api.getDateAndTime();

          setState(() {
            //for updating datetime widget
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            height: 40,
            color: Colors.red,
            child: DateTimeWidget(key: _textKey),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        api.dateAndime ?? 'Tap on screen to fetch date and time',
        style: const TextStyle(fontSize: 24, backgroundColor: Colors.lightGreenAccent),
      ),
    );
  }
}

class Api{
  String? dateAndime;

  Future<String> getDateAndTime(){
    return Future.delayed(
      const Duration(seconds: 1),
          () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndime = value;
      return value;
    });
  }
}