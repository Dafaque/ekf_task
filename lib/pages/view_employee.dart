import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

String url = 'http://51.83.45.126:5000';

class ViewEmployee extends StatefulWidget {
  @override
  _ViewEmployeeState createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  Map<String, dynamic> employee = Map<String, dynamic>();
  List<dynamic> children = List<Map<String, dynamic>>();
  bool errGetRelations = false;
  bool reqDone = false;

  void getRelations() async {
    Response resp;
    try {
      resp = await get("$url/relation/${employee['uuid']}");
    } catch( err ) {
      setState(() {
        errGetRelations = true;
        print( err );
      });
    }

    if ( resp.statusCode == 200 ) {
      Map<String, dynamic> jResp = jsonDecode( resp.body );
      setState(() {
        children = jResp['childs'];
        reqDone = true;
      });
    } else {
      setState(() {
        errGetRelations = true;
      });
    }
  } 
  Widget renderEmployee( context ) {
    if (employee.isEmpty) {
      setState(() {
        employee = ModalRoute.of(context).settings.arguments;
      });
      return SpinKitRing(color: Color.fromARGB(255, 0, 158, 100));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB( 8.0, 8.0, 0.0, 8.0 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ФИО: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("${employee['lastname']} ${employee['firstname']} ${employee['surname']}"),
          SizedBox(height: 8.0,),
          Text(
            'Должность: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text( employee['position'] ),
          SizedBox(height: 8.0,),
          Text( 
            'Дата рождения: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text( employee['birth_date'] ),
        ],
      ),
    );
  }
  Widget renderChilds() {
    if ( this.children.isEmpty && !this.reqDone ) {
      getRelations();
      return Card(child: SpinKitRing(color: Color.fromARGB(255, 0, 158, 100)));
    } else if ( this.children.isEmpty && this.reqDone ) {
      return Center(child: Text( 'Нет детей' ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,child: Text(
            'Дети:',  
            style: TextStyle(
              fontWeight:  FontWeight.bold,
            ),
          )
        ),
        Expanded(flex: 9,child: 
          ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${children[i]['lastname']} ${children[i]['firstname']} ${children[i]['surname']}"),
                  Text(children[i]['birth_date']),
                ],
              ),
            );
          })
        )
      ],
    ); 
  }

  void navToNewChld( BuildContext context ) async {
    final result = await Navigator.pushNamed(context, '/create_child', arguments: employee);
    if ( result != null ) {
      setState(() {
        reqDone = false;
        children.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 158, 100),
        title: Text( 'О сотруднике' ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    child: renderEmployee(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: renderChilds()
            )
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 158, 100),
        onPressed: () {
          navToNewChld( context );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon( Icons.add, size: 15.0, ),
            Icon( Icons.child_care ),
          ],
        ),
      ),
    );
  }
}