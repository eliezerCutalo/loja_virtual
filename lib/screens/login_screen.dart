import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/singup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Criar conta",
              style: TextStyle(fontSize: 15.0),
            ),
            textColor: Colors.white,
            onPressed: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context)=> SingupScreen())
              );
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email"
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (text){
                if(text.isEmpty || !text.contains("@")) return "E-maill inválido";

              },
            ),
            SizedBox(height: 16.0,),
            TextFormField(
              controller: _passController,
              decoration: InputDecoration(
                hintText: "Senha"
              ),
              obscureText: true,
              validator: (text){
                if(text.isEmpty || text.length < 6) return "Senha inválida";
              },
            ),
            Align(
              alignment:Alignment.centerRight,
              child: FlatButton(
                onPressed: (){
                  if(_emailController.text.isEmpty){
_scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text("Insira seu email para"),)
                    );
                  }else{
                    model.recoverPass();
                  }
                    
                
                },
                child: Text("Esqueci minha senha",
                  textAlign: TextAlign.right,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            SizedBox(height: 16.0,),
            SizedBox(
              height: 44.0,
              child: RaisedButton(
              child: Text("Entrar",
                style: TextStyle(
                  fontSize: 18.0
                ),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                if(_formKey.currentState.validate()){
                  model.signIn(
                    email: _emailController.text,
                    pass: _passController.text,
                    onSuccess: _onSuccess,
                    onFail: _onFail
                  );
                }
                
              },
            ),
            )
          ],
        ),
      );
        },
      )
    );
  }

    void _onSuccess(){

      Navigator.of(context).pop();
    }

  void _onFail(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text("Falha ao entrar"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      )
    );
  }
}