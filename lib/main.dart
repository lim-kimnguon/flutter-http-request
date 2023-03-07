import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  const DataFromAPI({super.key});

  @override
  State<DataFromAPI> createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getUserData() async {
    var response = await http.get(Uri.https('jsonplaceholder.ir', 'users'));

    var jsonData = jsonDecode(response.body);

    List<User> users = [];

    for (var userData in jsonData) {
      User user =
          User(userData['name'], userData['email'], userData['username']);

      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        centerTitle: true,
      ),
      body: Container(
        child: Card(
          child: FutureBuilder(
            // promise function
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: const Center(
                    child: Text('Loading.....'),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snapshot.data[i].username),
                      subtitle: Text(snapshot.data[i].name),
                      trailing: Text(snapshot.data[i].email),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     child: const Text('Get User Data From API'),
      //     onPressed: () {
      //       getUserData();
      //     },
      //   ),
      // ),
    );
  }
}

class User {
  final String name, email, username;

  User(this.name, this.email, this.username);
}
