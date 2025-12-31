import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to hold the main scaffold key for opening the drawer from any screen
final mainScaffoldKeyProvider = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});

/// Helper function to open the main drawer from any screen
void openMainDrawer(WidgetRef ref) {
  ref.read(mainScaffoldKeyProvider).currentState?.openDrawer();
}
