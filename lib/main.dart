//flutter emulators --launch flutter_emulator

import 'package:flutter/material.dart';
import 'pages/user_documents.dart';

void main() {
  runApp(const RecoRankApp());
}


class RecoRankApp extends StatelessWidget {
  const RecoRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RecoRank',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RecoRank')),
      body: Column(
        children: [
          //const SizedBox(height: 40),
          Center(
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.white,
              fillColor: Colors.indigo,
              color: Colors.indigo,
              borderColor: Colors.indigo,
              selectedBorderColor: Colors.indigo,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              isSelected: isSelected,
              onPressed: (int index){
                setState(() {
                  for (int i=0; i< isSelected.length;i++){
                    isSelected[i]= (i == index);
                  }
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Contrubutor'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text('Reviewer'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
/*
          Center(
            child: Text(
              isSelected[0]
                  ?"I'm Contributor"
                  :"I'm Reviewer",
              style: const TextStyle(fontSize: 18), 
            ),
          ),
*/
          Expanded(
            child: isSelected[0]
              ? const UserDocumentsPage()
              : const ReviewerView(),
          ),

        ],
      ),
    );
  }

}




class ReviewerView extends StatefulWidget {
  const ReviewerView({super.key});

  @override
  State<ReviewerView> createState() => _ReviewerViewState();
}
class _ReviewerViewState extends State<ReviewerView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "I'm Reviewer",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}