import 'package:flutter/material.dart';

import 'features/picker/presentation/pages/pokemon_picker_page.dart';
import 'injection_container.dart' as di;

void main() async {
  // As we're awaiting on main, we need to ensure
  // the biding is initialized in the first line of main
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon Picker',
      theme: ThemeData(
        primaryColor: Colors.cyan,
      ),
      home: PokemonPickerPage(),
    );
  }
}
