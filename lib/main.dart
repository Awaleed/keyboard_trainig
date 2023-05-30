import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final node = FocusNode();

  List<String> testedChar = [];
  String currentChar = '';

  int count = 1;
  int wrongCount = 0;
  int correctCount = 0;

  bool useSymbols = true,
      useBracts = true,
      useMath = true,
      useNumbers = true,
      useLowerCase = true,
      useUpperCase = true;

  @override
  void initState() {
    super.initState();
    node.requestFocus();
    getRandomChar();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: node,
      onKeyEvent: (value) async {
        final pressedKey = value.character;

        if (pressedKey == null) {
          return;
        }

        ScaffoldMessenger.of(context).clearSnackBars();

        if (pressedKey == currentChar) {
          showCorrect();
          getRandomChar();
          setState(() => correctCount++);
        } else {
          showWrong();
          setState(() => wrongCount++);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keyboard Training'),
          actions: [
            IconButton(
              onPressed: reset,
              icon: const Icon(Icons.restart_alt),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _bCS(
                  'useSymbols',
                  useSymbols,
                  () => useSymbols = !useSymbols,
                ),
                _bCS(
                  'useBracts',
                  useBracts,
                  () => useBracts = !useBracts,
                ),
                _bCS(
                  'useMath',
                  useMath,
                  () => useMath = !useMath,
                ),
                _bCS(
                  'useNumbers',
                  useNumbers,
                  () => useNumbers = !useNumbers,
                ),
                _bCS(
                  'useLowerCase',
                  useLowerCase,
                  () => useLowerCase = !useLowerCase,
                ),
                _bCS(
                  'useUpperCase',
                  useUpperCase,
                  () => useUpperCase = !useUpperCase,
                ),
              ],
            ),
            Text(
              'Wrong Count: $wrongCount',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'Correct Count: $correctCount',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Row(
              children: [
                Expanded(
                  flex: correctCount,
                  child: Container(height: 25, color: Colors.green),
                ),
                Expanded(
                  flex: wrongCount,
                  child: Container(height: 25, color: Colors.red),
                )
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  currentChar,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void reset() {
    ScaffoldMessenger.of(context).clearSnackBars();
    node.requestFocus();
    count = 1;
    wrongCount = 0;
    correctCount = 0;
    testedChar = [];
    getRandomChar();
  }

  void getRandomChar() {
    const symbols = '"\'\$!^&%.,;:`|?';
    const bracts = '[]{}()<>';
    const math = '+-*/=';
    const numbers = '0123456789';
    const lowerCase = 'abcdefghijklmnopqrstuvwxyz';
    final upperCase = lowerCase.toUpperCase();

    final List<String> chars = [
      if (useSymbols) symbols,
      if (useBracts) bracts,
      if (useMath) math,
      if (useNumbers) numbers,
      if (useLowerCase) lowerCase,
      if (useUpperCase) upperCase,
    ].join('').characters.map((e) => e.toString()).toList();

    chars.removeWhere((element) => testedChar.contains(element));
    if (chars.isEmpty) {
      testedChar = [];
      getRandomChar();
      return;
    }

    chars.shuffle();
    currentChar = chars.first;
    testedChar.add(currentChar);

    if (mounted) setState(() {});
  }

  void showCorrect() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Correct'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showWrong() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wrong'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _bCS(String label, bool value, bool Function() onTap) {
    return OutlinedButton(
      onPressed: () => setState(onTap),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          Switch(
            value: value,
            onChanged: (_) => setState(onTap),
          )
        ],
      ),
    );
  }
}
