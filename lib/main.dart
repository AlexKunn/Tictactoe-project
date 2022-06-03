import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictactoe/utils.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  static final String title = 'Tic Tac Toe';
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: MainPage(title: title),
      );
}
class MainPage extends StatefulWidget {
  final String title;

  const MainPage({
    required this.title,
  });
  @override
  _MainPageState createState() => _MainPageState();
}
class Player {
  static const none = '';
  static const X = 'X';
  static const O = 'O';
}
class _MainPageState extends State<MainPage> {
  static final nrcampuri = 3;
  static final double size = 92;

  String miscare = Player.none;
  late List<List<String>> tabla;
  @override
  void initState() {
    super.initState();
    setEmptyFields();
  }
  void setEmptyFields() => setState(() => tabla = List.generate(
        nrcampuri,
        (_) => List.generate(nrcampuri, (_) => Player.none),
      ));

  Color getBackgroundColor() {
    final thisMove = miscare == Player.X ? Player.O : Player.X;

    return getFieldColor(thisMove).withAlpha(150);
  }
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: getBackgroundColor(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: Utils.modelBuilder(tabla, (x, value) => buildRow(x)),
        ),
      );

  Widget buildRow(int x) {
    final values = tabla[x];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        values,
        (y, value) => buildField(x, y),
      ),
    );
  }

  Color getFieldColor(String value) {
    switch (value) {
      case Player.O:
        return Colors.purple;
      case Player.X:
        return Colors.red;
      default:
        return Colors.white;
    }
  }
  Widget buildField(int x, int y) {
    final value = tabla[x][y];
    final color = getFieldColor(value);

    return Container(
      margin: EdgeInsets.all(4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(size, size),
          primary: color,
        ),
        child: Text(value, style: TextStyle(fontSize: 32)),
        onPressed: () => selectField(value, x, y),
      ),
    );
  }

  void selectField(String value, int x, int y) {
    if (value == Player.none) {
      final newValue = miscare == Player.X ? Player.O : Player.X;
      setState(() {
        miscare = newValue;
        tabla[x][y] = newValue;
      });

      if (isWinner(x, y)) {
        showEndDialog('Jucatorul $newValue a castigat');
      } else if (isEnd()) {
        showEndDialog('Remiza');
      }
    }
  }

  bool isEnd() =>
      tabla.every((values) => values.every((value) => value != Player.none));

 
  bool isWinner(int x, int y) {
    var col = 0, row = 0, diag = 0, rdiag = 0;
    final player = tabla[x][y];
    final n = nrcampuri;

    for (int i = 0; i < n; i++) {
      if (tabla[x][i] == player) col++;
      if (tabla[i][y] == player) row++;
      if (tabla[i][i] == player) diag++;
      if (tabla[i][n - i - 1] == player) rdiag++;
    }
    return row == n || col == n || diag == n || rdiag == n;
  }
  Future showEndDialog(String title) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text('Restart'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setEmptyFields();
                Navigator.of(context).pop();
              },
              child: Text('Restart'),
            )
          ],
        ),
      );
}
