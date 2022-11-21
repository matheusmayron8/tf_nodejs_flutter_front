import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_atv_final/models/user_data.dart';
import 'package:flutter_atv_final/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_atv_final/screens/home_screen.dart';
import 'package:flutter_atv_final/screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Atv Final NodeJS',
      scrollBehavior: MaterialScrollBehavior()
          .copyWith(dragDevices: {PointerDeviceKind.mouse}),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 16),
        children: [
          MediaQuery.of(context).size.width >= 980
              ? Menu()
              : SizedBox(), // Responsive
          Body()
        ],
      ),
    );
  }
}

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _menuItem(title: 'Entrar', isActive: true),
              _registerButton(context)
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuItem({String title = 'Title Menu', isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color:
                    isActive ? Color.fromARGB(255, 68, 209, 155) : Colors.grey,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 68, 209, 155),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const RegisterScreen()))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                spreadRadius: 10,
                blurRadius: 12,
              ),
            ],
          ),
          child: Text(
            'Registrar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ));
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _fieldEmailController = TextEditingController();
  final _fieldPasswordController = TextEditingController();

  final _apiService = ApiService();
  Future<UserData>? _futureUserData;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 360,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atividade Final\n NodeJS',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Ainda não tem conta?",
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    "Você pode se",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const RegisterScreen())));
                    },
                    child: Text(
                      "Registrar aqui!",
                      style: TextStyle(
                          color: Color.fromARGB(255, 68, 209, 155),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              MediaQuery.of(context).size.width >= 1300 //Responsive
                  ? SizedBox()
                  : Image.asset(
                      'images/illustration-1.png',
                      width: 300,
                    ),
            ],
          ),
        ),

        //Image.asset(
        //  'images/illustration-1.png',
        //  width: 300,
        //),
        MediaQuery.of(context).size.width >= 1300 //Responsive
            ? Image.asset(
                'images/illustration-1.png',
                width: 350,
              )
            : SizedBox(),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height / 16),
          child: Container(
            width: 320,
            child: _formLogin(context),
          ),
        )
      ],
    );
  }

  Widget _formLogin(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _fieldEmailController,
          decoration: InputDecoration(
            hintText: 'Digite seu username',
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
          controller: _fieldPasswordController,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          decoration: InputDecoration(
            hintText: 'Senha',
            counterText: 'Esqueceu a senha?',
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
        ),
        SizedBox(height: 40),
        (_futureUserData == null) ? buildSignInButon() : buildFutureBuilder(),
        SizedBox(height: 40),
      ],
    );
  }

  Widget buildSignInButon({bool hasError = false}) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Container(
                    width: double.infinity,
                    height: 50,
                    child: Center(child: Text("Entrar"))),
                onPressed: () => callLogin(),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 68, 209, 155),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ],
          ),
        ),
        hasError
            ? Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Verifique seu login e senha',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              )
            : SizedBox(),
      ],
    );
  }

  void callLogin() {
    setState(() {
      //_futureUserData = null;
      if (_fieldEmailController.text.isEmpty ||
          _fieldPasswordController.text.isEmpty) {
        showSnackbarMandatoryFields(context);
        return;
      }

      _futureUserData = _apiService.getToken(
          login: _fieldEmailController.text,
          password: _fieldPasswordController.text);
    });
  }

  void goToHomeScreen(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //When finish, call actions inside
      _fieldEmailController.clear();
      _fieldPasswordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: ((context) => const HomeScreen())),
      );
    });
  }

  void showSnackbarMandatoryFields(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Campos login e senha são obrigatórios.',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  FutureBuilder<UserData> buildFutureBuilder() {
    return FutureBuilder<UserData>(
      future: _futureUserData,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator.adaptive();
        }

        if (snapshot.hasData) {
          goToHomeScreen(context);
          return buildSignInButon();
        } else if (snapshot.hasError) {
          return buildSignInButon(hasError: true);
        }

        return buildSignInButon();
      },
    );
  }
}
