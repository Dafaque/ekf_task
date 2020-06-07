import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:http/http.dart';

String url = 'http://51.83.45.126:5000';

class NewEmployee {
  final Map<String,TextEditingController> controllers = {
    'lastname': TextEditingController(),
    'firstname': TextEditingController(),
    'surname': TextEditingController(),
    'position': TextEditingController(),
  };

  Map<String, String> data = Map<String, String>();
  
  void setData( fieldName, value ) {
    this.data[fieldName] = value;
  }

  String getTextValue( String fieldName ){
      return this.controllers[fieldName].text;
  }

  bool isCompleted() {
    bool done = true;
    if ( this.data.length < 5 ) {
      return false;
    }

    for ( MapEntry e in this.data.entries ) {
      if ( e.value.isEmpty ) {
        done = false;
        break;
      }
    }
    return done;
  }

  TextEditingController getCnt( String fieldName ) {
    return this.controllers[fieldName];
  }

  void upload(context) async {
    Response resp = await put( 
      '$url/employee',
      body: jsonEncode( this.data ),
    );

    if (resp.statusCode == 200) {
      Navigator.pop( context, jsonDecode(resp.body) );
    } else {
      AlertDialog(
        title: Text('Нет связи с сервером'),
      );
    }
  }

}

class NewEmp extends StatefulWidget {
  @override
  _NewEmpState createState() => _NewEmpState();
}

class _NewEmpState extends State<NewEmp> {

  NewEmployee emp = NewEmployee();

  @override
  void dispose() {
    super.dispose();
    emp.controllers.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  void initState() {
    super.initState();
    
    emp.controllers.forEach((key, controller) {
      controller.addListener(() {
        setState(() {
          emp.setData( key, emp.getCnt( key ).text );
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 158, 100),
        title: Text( 'Добавить сотрудника' ),
        centerTitle: true,
      ),
      body: Card(
        margin: EdgeInsets.all(5.0),
        child: ListView(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                hintText: 'Фамилия'
              ),
              controller: emp.getCnt('lastname'),
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                hintText: 'Имя'
              ),
              controller: emp.getCnt('firstname'),
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                hintText: 'Отчество'
              ),
              controller: emp.getCnt('surname'),
            ),
            DateField(
              selectedDate: emp.data.containsKey('birth_date') ? DateTime.parse( emp.data['birth_date'] ) : null ,
              lastDate: DateTime(2000),
              label: 'Дата рождения',
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                hintText: 'Дата рождения',
              ),
              onDateSelected: (DateTime date) => {
                setState(() {
                  emp.setData('birth_date', date.toString());
                })
              },
            ),
            TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
                hintText: 'Должность'
              ),
              controller: emp.getCnt('position'),
            ),
            FlatButton(
              onPressed: emp.isCompleted() ? () => {
                emp.upload(context)
              } : null,
              child: Text(
                'Добавить',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Color.fromARGB(255, 0, 158, 100),
              disabledColor: Color.fromARGB(255, 222, 222, 222),
            ),
          ],
        ),
      ),
    );
  }
}