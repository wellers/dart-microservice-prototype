import 'package:flutter/material.dart';

import '../containers/active_tab.dart';
import '../containers/people_list_wrapper.dart';
import '../models/models.dart';

class PeopleScreen extends StatefulWidget {
  final void Function() onInit;

  PeopleScreen({required this.onInit}) : super(key: Key('people'));

  @override
  PeopleScreenState createState() => PeopleScreenState();
}

class PeopleScreenState extends State<PeopleScreen> {
  @override
  void initState() {
    widget.onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ActiveTab(
      key: Key('activeTab'),
      builder: (BuildContext context, AppTab activeTab) 
        => PeopleListWrapper(key: Key('listWrapper'))
    );
  }
}