import 'package:Handouts/pages/create_child.dart';
import 'package:Handouts/pages/view_employee.dart';
import 'package:flutter/material.dart';

import 'package:Handouts/pages/home.dart';
import 'package:Handouts/pages/create_employee.dart';
void main() => runApp(MaterialApp(
  initialRoute: '/home',
  routes: {
    '/home': (context) => Home(),
    '/create_employee': (context) => NewEmp(),
    '/create_child': (context) => NewChld(),
    '/view_employee': (context) => ViewEmployee(),
  },
));