import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String url = 'http://51.83.45.126:5000';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> employees = [];
  bool errGetEmployee = false;

  void getEmployees() async {
    Response resp;
    try {
      resp = await get("$url/employee");
    } catch( err ) {
      setState(() {
        errGetEmployee = true;
        print( err );
      });
    }
    if ( resp.statusCode == 200 ) {
      List<dynamic> jResp = jsonDecode( resp.body );
      setState(() {
        employees = jResp;
      });
    } else {
      setState(() {
        errGetEmployee = true;
      });
    }
  }

  Widget render() {
    Widget layout;
    if ( errGetEmployee ) {
      layout = Container(
        child: Text('Нет связи с сервером'),
      );
    } else if ( employees.isEmpty ) {
      getEmployees();
      layout = SpinKitRing(color: Color.fromARGB(255, 0, 158, 100));
    } else {
      layout = ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, i) {
          return Card(
            child: ListTile(
              title: Text( 
                "${employees[i]['lastname']} ${employees[i]['firstname']} ${employees[i]['surname']}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              subtitle: Text( 
                "${employees[i]['position']}",
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/view_employee', arguments: employees[i]);
              },              
            ),
          );
        },
      );
    }
    return layout;
  }

  @override
  Widget build(BuildContext context) {

    void navToNewEmp( BuildContext context ) async {
      final result = await Navigator.pushNamed(context, '/create_employee');
      if ( result != null ) {
        setState(() {
            employees.clear();
        });
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
          child: render()
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 158, 100),
        onPressed: () {
          navToNewEmp(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

