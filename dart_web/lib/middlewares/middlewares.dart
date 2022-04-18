import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/models.dart';
import '../models/app_state.dart';
import '../selectors/selectors.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  return [
    TypedMiddleware<AppState, LoadPeopleAction>(_loadPeople),
    TypedMiddleware<AppState, AddPersonAction>(_addPerson),        
    TypedMiddleware<AppState, UpdatePersonAction>(_updatePerson),
    TypedMiddleware<AppState, PeopleLoadedAction>(_peopleLoaded),
    TypedMiddleware<AppState, DeletePersonAction>(_deletePerson),
  ];
}

List<Person> people = <Person>[];

_loadPeople(Store<AppState> store, LoadPeopleAction action, NextDispatcher next) async {
  try {    
    // load  
    final response = await http.get(Uri.parse('http://192.168.50.101/api/find'));
    final json = jsonDecode(await response.body);
  
    List<Person> people = [];
    if (json.containsKey('docs')) {
      people = (json['docs'] as Iterable).map((person) => Person.fromJson(person)).toList();
    }  

    store.dispatch(PeopleLoadedAction(people));
  } catch (err) {
    store.dispatch(PeopleNotLoadedAction());
  } 
  
  next(action);
}

_addPerson(Store<AppState> store, AddPersonAction action, NextDispatcher next) async {
  next(action);
  
  //create
  final response = await http.post(Uri.parse('http://192.168.50.101/api/insert'),
    body: jsonEncode({
      'people': [action.person.toJson()]
    }));
  final json = jsonDecode(await response.body);

  if (json['success'] == true) {
    people = peopleSelector(store.state);
  }
}

_updatePerson(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //updated
  people = peopleSelector(store.state);
}

_peopleLoaded(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  //loaded
  people = peopleSelector(store.state);
}

_deletePerson(Store<AppState> store, DeletePersonAction action, NextDispatcher next) async {
  next(action);

  //delete
  final response = await http.delete(Uri.parse('http://192.168.50.101/api/remove?id=${action.id}'));
  jsonDecode(await response.body);

  people = peopleSelector(store.state);
}