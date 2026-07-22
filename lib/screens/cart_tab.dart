import 'package:flutter/material.dart';
import 'package:wrapit/theme/theme.dart';
import 'package:wrapit/state/app_state.dart';

class CartTab extends StatelessWidget {
  final AppState appState;
  const CartTab({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Cart Tab', style: WrapItText.heading()),
    );
  }
}
