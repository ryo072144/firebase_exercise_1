import 'package:flutter/material.dart';
import 'package:firebase_exercise_1/constants/text_styles.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _idEditingController = TextEditingController();

  String name = '';
  int age = 0;

  void setProfile() async{
  }

  Future<DocumentSnapshot> getProfile()async{
    return FirebaseFirestore.instance.collection('users').doc(_idEditingController.text).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(_idEditingController.text).get(),
          builder: (context, snapshot) {
            if(snapshot.hasData&&snapshot.data!.exists){
              return Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width/2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _idEditingController,
                        decoration: const InputDecoration(labelText: 'ID', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 20,),
                      TextField(
                        controller: _nameEditingController,
                        decoration: const InputDecoration(labelText: '名前', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: (){
                          setProfile();
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))
                        ),
                        child: const Text('データ更新'),
                      ),
                    ],
                  ),
                ),
              );
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          }
      ),
    );
  }
}

