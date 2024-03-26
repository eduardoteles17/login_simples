import 'package:flutter/material.dart';
import 'package:login_simples/controllers/auth_controller.dart';
import 'package:lottie/lottie.dart';

class FormData {
  String username;
  String password;

  FormData({
    required this.username,
    required this.password,
  });
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthController _authController = AuthController.instance;

  final FormData _formData = FormData(username: '', password: '');

  @override
  void initState() {
    super.initState();
    _authController.init().then((successInitAuthController) {
      if (!context.mounted) {
        return null;
      }
      if (successInitAuthController) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    final successLogin =
        await _authController.login(_formData.username, _formData.password);
    if (!context.mounted) {
      return null;
    }
    if (successLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login realizado com sucesso!'),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha inválidos!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    "assets/lottie/login.json",
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Nome de usuário',
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nome de usuário é obrigatório';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData.username = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Senha', border: OutlineInputBorder()),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha é obrigatória';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _formData.password = value!;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onLogin,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Não tem uma conta?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
