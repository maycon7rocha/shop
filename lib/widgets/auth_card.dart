import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Ocorreu um erro!"),
        content: Text(msg),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Fechar"),
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    // nao faz nada, caso nao esteja validado
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    final auth = Provider.of<Auth>(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        // logn
        await auth.login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // registrar
        await auth.signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog("Ocorreu um erro inesperado!");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _swithAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: SingleChildScrollView(
        child: Container(
          height: _authMode == AuthMode.Login ? 330 : 380,
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return "Informe um e-mail válido!";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return "Informe uma senha válida!";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value,
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Confirmar Senha'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "Senhas são diferentes!";
                            }
                            return null;
                          }
                        : null,
                  ),
                Spacer(),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 30.0,
                    ),
                    child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                    ),
                    onPressed: _submit,
                  ),
                FlatButton(
                  onPressed: _swithAuthMode,
                  child: Text(
                    _authMode == AuthMode.Login ? 'REGISTRAR' : 'ENTRAR',
                  ),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
