import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';

class CategoriesTab extends StatelessWidget {
  final AppState appState;
  const CategoriesTab({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Categories Tab', style: WrapItText.heading()),
    );
  }
}
