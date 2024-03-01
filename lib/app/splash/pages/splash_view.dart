import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/app/layout/layout_view.dart';
import 'package:todo_app/config/constants/constants.dart';
import 'package:todo_app/config/cubits/settings_cubit/settings_cubit.dart';
import 'package:todo_app/config/cubits/settings_cubit/settings_state.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  static const String id = 'SplashView';

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, LayoutView.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = BlocProvider.of<CubitSettings>(context);

    return BlocBuilder<CubitSettings, StatesSettings>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
              vm.isLight() ? lightScaffoldBgColor : darkScaffoldBgColor,
          body: Center(
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
