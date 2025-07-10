import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


class UserDocumentsPage extends StatefulWidget {
  const UserDocumentsPage({super.key});

  @override
  State<UserDocumentsPage> createState() => _UserDocumentsPageState();
}

class _UserDocumentsPageState extends State<UserDocumentsPage> {
  final _formKey = GlobalKey<FormState>(); //表單驗證用key

  final TextEditingController _nicknameController = TextEditingController(); //暱稱
  final TextEditingController _introController = TextEditingController(); //概述

  String? _selectedType; //類型
  File? _pickedFile;  //上傳檔案

  String? _validateIntro(String? value) {
    if (value == null || value.isEmpty) {
      return "can't be empty";
    }
    else if(value.length > 300) {
      return "please less than 300 words";
    }
    return null;
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'mp4', 'jpg', 'png'],
    );
    
    if (result != null && result.files.single.size < 10*1024*1024) { //10mb
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("file size must under 10MB")),
      );
    }
  }


  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedType != null && _pickedFile != null){
      final Map<String, dynamic> formDate = {
        'nickname': _nicknameController.text,
        'description': _introController.text,
        'category': _selectedType,
        'file': _pickedFile,
      };
      print("帶儲存資料庫: $formDate");
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incomplete!")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload document'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView( //畫面捲動
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(labelText: 'Nickname'),
                        validator: (value) => value == null || value.isEmpty ? "can't be empty" : null,
                      ),
                      //const SizedBox(height: 6),
                      TextFormField(
                        controller: _introController,
                        decoration: const InputDecoration(labelText: "Description"),
                        maxLines: 2,
                        validator: _validateIntro,
                      ),
                      //const SizedBox(height: 6),
                      DropdownButtonFormField<String>( //下拉選單
                        decoration: const InputDecoration(labelText: "Type"),
                        items: const[
                          DropdownMenuItem(value: "job", child: Text("Apply for job"),),
                          DropdownMenuItem(value: "school",child: Text("Apply for school "),)
                        ],
                        onChanged: (value) => setState(() => _selectedType = value),
                        validator: (value) => value == null ? "choose one" : null,
                      ),
                      //const SizedBox(height: 6,),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: const Text("Select PDF / Vidoe / Image"),
                      ),
                      if (_pickedFile != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text("Selected! => ${_pickedFile!.path.split('/').last}"),
                        ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm, 
                          child: const Text("Submit")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          
        ),
        )
        
        )
      ),
    );
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _introController.dispose();
    super.dispose();
  }
}