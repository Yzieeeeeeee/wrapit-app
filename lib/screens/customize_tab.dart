import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';

class CustomizeTab extends StatelessWidget {
  final AppState appState;
  const CustomizeTab({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Customize Tab', style: WrapItText.heading()),
    );
  }
}
