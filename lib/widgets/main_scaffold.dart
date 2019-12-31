import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  final String appBarTitle;
  final List<Widget> appBarAction;
  final Widget child;
  final FloatingActionButton floatingButton;
  final Widget leading;
  final TabBar tabBar;

  MainScaffold(
      {this.appBarTitle,
      this.appBarAction,
      this.child,
      this.floatingButton,
      this.leading,
      this.tabBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: (tabBar == null) ? null : tabBar,
        title: Text(
          appBarTitle,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: appBarAction,
        leading: (leading == null) ? null : leading,
      ),
      body: child,
      floatingActionButton: (floatingButton == null) ? null : floatingButton,
    );
  }
}
