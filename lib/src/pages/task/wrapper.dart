import 'package:flutter/material.dart';

class TabDataHolder extends StatefulWidget {
  final Widget child;

  const TabDataHolder({super.key, required this.child});

  static TabDataHolderState of(BuildContext context) {
    final state = context.findAncestorStateOfType<TabDataHolderState>();
    assert(state != null, 'No TabDataHolder found in context');
    return state!;
  }

  @override
  TabDataHolderState createState() => TabDataHolderState();
}

class TabDataHolderState extends State<TabDataHolder> {
  Map? data;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}