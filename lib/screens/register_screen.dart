import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_atv_final/models/user_created_response.dart';
import 'package:flutter_atv_final/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final fieldNameController = TextEditingController();
  final fieldLoginController = TextEditingController();
  final fieldPasswordController = TextEditingController();
  final fieldEmailController = TextEditingController();

  final _apiService = ApiService();
  Future<UserCreateResponse>? _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 16),
          child: Container(
            width: 500,
            child: _formRegister(context),
          ),
        ),
      ),
    );
  }

  Widget _formRegister(BuildContext context) {
    return Column(
      children: [
        Text(
          'Registro de usuário',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: fieldNameController,
          decoration: InputDecoration(
            hintText: 'Digite seu nome',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          controller: fieldLoginController,
          decoration: InputDecoration(
            hintText: 'Digite seu username (login)',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 30),
        TextField(
          controller: fieldPasswordController,
          decoration: InputDecoration(
            hintText: 'Senha',
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
        ),
        SizedBox(height: 30),
        TextField(
          controller: fieldEmailController,
          decoration: InputDecoration(
            hintText: 'Email',
            filled: true,
            fillColor: Colors.blueGrey[50],
            labelStyle: TextStyle(fontSize: 12),
            contentPadding: EdgeInsets.only(left: 30),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey[50]!),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        SizedBox(height: 40),
        (_future == null) ? buildRegisterButton() : buildFutureBuilder(),
        SizedBox(height: 40),
      ],
    );
  }

  void callRegisterUser() {
    setState(() {
      _future = _apiService.registerUser(
        name: fieldNameController.text,
        login: fieldLoginController.text,
        password: fieldPasswordController.text,
        email: fieldEmailController.text,
      );
    });
  }

  Widget buildRegisterButton({bool hasError = false}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent,
                spreadRadius: 5,
                blurRadius: 10,
              ),
            ],
          ),
          child: ElevatedButton(
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Registrar"))),
            onPressed: () => callRegisterUser(),
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 68, 209, 155),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        hasError
            ? Text(
                'Não foi possível registrar o usuário. Tente novamente mais tarde.',
                style: TextStyle(color: Colors.red),
              )
            : SizedBox()
      ],
    );
  }

  FutureBuilder<UserCreateResponse> buildFutureBuilder() {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Column(
            children: [CircularProgressIndicator.adaptive()],
          );
        }

        if (snapshot.hasData) {
          backToLogin();
          return buildRegisterButton();
        } else if (snapshot.hasError) {
          return buildRegisterButton(hasError: true);
        }

        return buildRegisterButton();
      },
    );
  }

  void backToLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //When finish, call actions inside
      showSnackbarUserRegistered(context);
      Navigator.pop(context);
    });
  }

  void showSnackbarUserRegistered(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Usuário cadastrado com sucesso!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
