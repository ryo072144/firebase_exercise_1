import 'package:firebase_exercise_1/constants/text_styles.dart';
import 'package:firebase_exercise_1/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePractice extends StatefulWidget {
  const FirestorePractice({super.key});

  @override
  FirestorePracticeState createState() => FirestorePracticeState();
}

class FirestorePracticeState extends State<FirestorePractice> {

  final FirestoreService _firestoreService = FirestoreService();
  late Future<QuerySnapshot> _usersFuture;
  late String _username;

  Future<QuerySnapshot> _getUsers(){
    return _firestoreService.getUsers();
  }

  Future<void> _addUser() async {
    // tryの中でエラーが発生したら、catchの中が実行される。
    try {
      await _firestoreService.addUser(_username);
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ユーザーを追加しました'))
      );
    } catch (e) {
      if(!mounted)return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('エラーが発生しました'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _usersFuture = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Practice', style: AppTextStyles.title,),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
              decoration: const InputDecoration(hintText: 'ユーザー名を入力してください'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addUser();
              },
              child: const Text('ユーザーを追加'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _usersFuture = _getUsers();
                });
              },
              child: const Text('リロード'),
            ),
            const SizedBox(height: 16.0),
            const Text('ユーザー一覧', style: TextStyle(fontSize: 18.0)),
            const SizedBox(height: 16.0),
            Flexible(
              child: FutureBuilder<QuerySnapshot>(
                future: _usersFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('エラーが発生しました', style: AppTextStyles.headline.copyWith(color: Colors.red),);
                  }
                  if (snapshot.hasData) {
                    final users = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(user['name']),
                        );
                      },
                    );
                  }else{
                    return const SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator()
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

