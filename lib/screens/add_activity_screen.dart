import 'package:app_projet/classifier/classifier.dart';
import 'package:app_projet/models/activity.dart';
import 'package:app_projet/widgets/field/miage_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  String title = '';
  String category = '';
  String place = '';
  int minPeople = 1;
  double price = 0.0;
  bool isLoading = false;
  String _imageExtension = '';
  final titleController = TextEditingController();
  final placeController = TextEditingController();
  final minPeopleController = TextEditingController();
  final priceController = TextEditingController();
  final classifier = Classifier();

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await classifier.loadModel();
  }

  Future getImageAndPredict() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageExtension = path.extension(pickedFile.path);
      });
      predictImage(_image!);
    }
  }

  String formatEnumToString(DetectionClasses detectionClass) {
    String rawValue = detectionClass.toString().split('.').last;
    return '${rawValue[0].toUpperCase()}${rawValue.substring(1)}';
  }

  void predictImage(File image) async {
    img.Image imageTemp = img.decodeImage(image.readAsBytesSync())!;
    DetectionClasses results = await classifier.predict(imageTemp);
    String formattedResult = formatEnumToString(results);
    setState(() {
      category = formattedResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une activité"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              if (_image != null)
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.purple),
                          onPressed: getImageAndPredict,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              if (_image == null)
                IconButton(
                  onPressed: getImageAndPredict,
                  icon: const Icon(Icons.add_a_photo),
                ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButtonFormField(
                    value: category.isEmpty ? null : category,
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    items: <String>['Boxe', 'Tennis', 'Cyclisme', 'Lecture']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.category,
                        color: Colors.purple,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: "Catégorie",
                    )),
              ),
              MiageTextField(
                icon: Icons.title,
                text: "Titre de l'activité",
                controller: titleController,
              ),
              MiageTextField(
                  icon: Icons.euro, text: "Prix", controller: priceController),
              MiageTextField(
                  icon: Icons.people,
                  text: "Nombre de personne minimum",
                  controller: minPeopleController),
              MiageTextField(
                  icon: Icons.place,
                  text: "Ville de l'activité",
                  controller: placeController),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          String imageUrl = '';
                          if (_image != null) {
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('activity_images')
                                .child(
                                    "${DateTime.now().toIso8601String()}$_imageExtension");
                            await ref.putFile(_image!);
                            imageUrl = await ref.getDownloadURL();
                          } else {
                            return;
                          }

                          Activity article = Activity(
                            title: titleController.text,
                            price: double.parse(priceController.text),
                            minParticipants:
                                int.parse(minPeopleController.text),
                            place: placeController.text,
                            category: category,
                            preview: imageUrl,
                          );

                          await FirebaseFirestore.instance
                              .collection('activities')
                              .add(article.toMap());

                          Navigator.pop(context, true);
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                child: const Text('Valider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
