import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_firebase_demo/app_view.dart';
import 'package:login_firebase_demo/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(userRepository: userRepository),
      child: const MyAppView(),
    );
  }
}
