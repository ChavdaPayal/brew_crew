import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey =GlobalKey<FormState>();
  final List<String> suger=['0','1','2','3','4'];

  //form values
  String _currentName;
  String _currentSuger;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          UserData userData=snapshot.data;

         return Form(
          key: _formKey,
          child: Column(
            children:<Widget>[
              Text('Update your brew Settings',style: TextStyle(fontSize:18.0),
              ),
              SizedBox(height:20.0),
              TextFormField(
                initialValue: userData.name,
                decoration: textInputDecoration,
                validator: (val) => val.isEmpty ? 'please enter a name':null,
                onChanged: (val) => setState(() => _currentName = val),
              ),
              SizedBox(height:20.0),
              //dropdown
              DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currentSuger ?? userData.suger,
                items: suger.map((suger){
                  return DropdownMenuItem(
                  value: suger,
                  child: Text('$suger suger'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentSuger = val)
              ),
              Slider(
              value: (_currentStrength ?? userData.strength).toDouble(),
              activeColor: Colors.brown[_currentStrength ?? userData.strength],
              inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
              min: 100,
              max: 900,
              divisions: 8,
              onChanged: (val) => setState(() => _currentStrength = val.round()),
              ),
              //slider
              RaisedButton(
                color: Colors.pink[400],
                child: Text('Update',style: TextStyle(color:Colors.white),
                ),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: user.uid).updateUserData(
                      _currentSuger ?? userData.suger,
                      _currentName ?? userData.name,
                      _currentStrength ?? userData.strength
                    );
                    Navigator.pop(context);
                  }
                }
              ),
            ],
          ),
        );
        }else{
         return Loading();
        }
         }
    );
  }
}