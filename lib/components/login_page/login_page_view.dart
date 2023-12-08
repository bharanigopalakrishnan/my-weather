import 'package:flutter/material.dart';
import 'package:myweather/components/login_page/login_page.dart';
import 'package:myweather/components/login_page/login_page_view_model.dart';
import 'package:myweather/controllers/userController.dart';
import 'package:myweather/model/user.dart';
import 'package:provider/provider.dart';

class LoginPageView extends State<LoginPage> {
  late LoginPageViewModel _viewModel;
  LoginPageView() {
    _viewModel = LoginPageViewModel();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viewModel.loadConfigJson();
    _viewModel.validateUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.streamController.stream,
        builder: (context, snapshot) {
          return Scaffold(
            body: _viewModel.loader == true
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _viewModel.emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _viewModel.passwordController,
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.amber)),
                              onPressed: () {
                                _viewModel.signUp();
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                User? user = await _viewModel.login();
                                if (user?.email != null) {
                                  updateData(user!);
                                } else {}
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  updateData(User user) {
    Provider.of<UserController>(context, listen: false).updateUser(user);
    Navigator.popAndPushNamed(context, "/home");
  }

  @override
  void dispose() {
    super.dispose();
  }
}
