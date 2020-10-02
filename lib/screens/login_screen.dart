import 'dart:io';

import 'package:flutter/material.dart';
import '../providers/auth.dart';
import '../widgets/button.dart';
import '../widgets/text_form_field_style.dart';

import 'package:provider/provider.dart';
import '../models/httpException.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          title: Text('An Error Occured'),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Okay'))
          ],
        );
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      print('not Returning');
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false)
          .signIn(_authData['email'], _authData['password']);
    } on HttpException catch (error) {
      var errormessage = 'Authethication failed';
      if (error.toString().contains('Unknown email address.')) {
        errormessage =
            'Unknown email address. Check again or try your username';
      } else if (error.toString().contains('[jwt_auth] incorrect_password')) {
        errormessage =
            'The password you entered for the email address  is incorrect.';
      } else if (error.toString().contains('[jwt_auth] invalid_username')) {
        errormessage = 'This email is not valid';
      }
      _showErrorDialog(errormessage);
    } catch (error) {
      var errormessage = 'Could not authenticate you. Please try again later';
      print(error);
      _showErrorDialog(errormessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width / 5),
                child: Image.asset('assets/Logo.png'),
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildTextFormStyle(
                        MediaQuery.of(context).size.height / 9,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@'))
                              return 'Invalid email!';
                          },
                          onSaved: (newValue) {
                            _authData['email'] = newValue;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      buildTextFormStyle(
                        MediaQuery.of(context).size.height / 9,
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(5),
                          ),
                          obscureText: true,
                          // ignore: missing_return
                          validator: (value) {
                            if (value.isEmpty || value.length < 5)
                              return 'Password is too short!';
                          },
                          onSaved: (newValue) {
                            _authData['password'] = newValue;
                          },
                        ),
                      ),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        AppButton(name: 'LOGIN', onPressed: _submit),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Text Field Style
