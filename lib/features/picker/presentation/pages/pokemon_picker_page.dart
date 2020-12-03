import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_picker/features/picker/presentation/widgets/pokemon_control.dart';

import '../../../../injection_container.dart';
import '../bloc/pokemon_info_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/pokemon_display.dart';

class PokemonPickerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon Picker'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<PokemonInfoBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PokemonInfoBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              // Pokemon Information
              BlocBuilder<PokemonInfoBloc, PokemonInfoState>(
                builder: (context, state) {
                  if (state is Empty)
                    return MessageDisplay(text: 'Pick a random Pokemon!');
                  else if (state is Loading)
                    return LoadingWidget();
                  else if (state is Loaded)
                    return PokemonDisplay(pokemonInfo: state.pokemonInfo);
                  else if (state is Error)
                    return MessageDisplay(
                        text: 'Something went wrong...\n${state.message}');

                  return MessageDisplay(text: 'Start searching!');
                },
              ),
              SizedBox(height: 80),
              PokemonControl(),
            ],
          ),
        ),
      ),
    );
  }
}
