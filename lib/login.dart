import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/social_login_button.dart';
import 'widgets/divider_with_text.dart';
import 'widgets/custom_button.dart';
import 'widgets/blurred_background.dart';
import 'utils/snackbar_utils.dart';

class LoginPage extends StatefulWidget {
  final Function? onLoginSuccess;
  const LoginPage({super.key, this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _login() {
    final emailPattern = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      SnackBarUtils.showSnackBar(context, 'Veuillez remplir tous les champs');
      return;
    }

    if (!emailPattern.hasMatch(_emailController.text)) {
      SnackBarUtils.showSnackBar(context, 'Adresse e-mail invalide');
      return;
    }

    if (kDebugMode) {
      print('Tentative de connexion avec ${_emailController.text}');
    }

    _handleLogin();
  }

  void _handleLogin() {
    if (widget.onLoginSuccess != null) {
      widget.onLoginSuccess!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Connexion'),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const BlurredBackground(imagePath: 'assets/images/food-iphone.jpg'),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bienvenue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Adresse e-mail',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Mot de passe',
                        prefixIcon: Icons.lock,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'Se connecter',
                        onPressed: _login,
                        backgroundColor: Colors.orange,
                        textColor: Colors.black,
                      ),

                      const SizedBox(height: 16),

                      const DividerWithText(text: 'Ou'),

                      const SizedBox(height: 12),

                      SocialLoginButton(
                        text: 'Connexion avec Google',
                        icon: Icons.g_mobiledata,
                        iconColor: Colors.red,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        onPressed: () {
                          if (kDebugMode) {
                            print('Connexion avec Google');
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      SocialLoginButton(
                        text: 'Connexion avec Facebook',
                        icon: Icons.facebook,
                        iconColor: Colors.white,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          if (kDebugMode) {
                            print('Connexion avec Facebook');
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          if (kDebugMode) {
                            print('Mot de passe oublié');
                          }
                        },
                        child: const Text(
                          'Mot de passe oublié?',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Vous n'avez pas de compte? ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Scaffold(),
                                ),
                              );
                            },
                            child: const Text(
                              'Inscrivez-vous',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}