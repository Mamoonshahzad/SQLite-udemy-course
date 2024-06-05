import 'package:flutter/material.dart';
import 'package:sqlite_app_udemy/model/dish_model.dart';
import 'package:sqlite_app_udemy/database/db_helper.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final DbHelper dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    initDb();
  }

  Future<void> initDb() async {
    await dbHelper.initDb();
    setState(() {}); // Refresh the UI after initializing the database
  }

  Future<List<Dish>> getAllDishes() async {
    return await dbHelper.readAllDishes();
  }

  Future<void> createData() async {
    var dish = Dish(
      nameController.text,
      descriptionController.text,
      double.parse(priceController.text),
    );
    await dbHelper.createDish(dish);
    setState(() {}); // Refresh the UI after creating a new dish
  }

  Future<void> readData() async {
    try {
      Dish dish = await dbHelper.readDish(nameController.text);
      print("${dish.name}, ${dish.description}, ${dish.price}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData() async {
    var dish = Dish(
      nameController.text,
      descriptionController.text,
      double.parse(priceController.text),
    );
    await dbHelper.updateDish(dish);
    setState(() {}); // Refresh the UI after updating the dish
  }

  Future<void> deleteData() async {
    await dbHelper.deleteDish(nameController.text);
    setState(() {}); // Refresh the UI after deleting a dish
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'title'),
            ),
            TextField(
              controller: descriptionController,
              minLines: 2,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(hintText: 'description'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'price'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MaterialButton(
                  minWidth: 30,
                  color: Colors.blue,
                  onPressed: () async => await createData(),
                  child: const Text('Create'),
                ),
                MaterialButton(
                  minWidth: 30,
                  color: Colors.green,
                  onPressed: () async => await readData(),
                  child: const Text('Read'),
                ),
                MaterialButton(
                  minWidth: 30,
                  color: Colors.cyan,
                  onPressed: () async => await updateData(),
                  child: const Text('Update'),
                ),
                MaterialButton(
                  minWidth: 30,
                  color: Colors.red,
                  onPressed: () async => await deleteData(),
                  child: const Text('Delete'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name'),
                Text('Description'),
                Text('Price'),
              ],
            ),
            FutureBuilder<List<Dish>>(
              future: getAllDishes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No dishes found');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Row(
                        textDirection: TextDirection.ltr,
                        children: [
                          Expanded(child: Text(snapshot.data![index].name)),
                          Expanded(
                              child: Text(snapshot.data![index].description)),
                          Expanded(
                              child:
                                  Text(snapshot.data![index].price.toString())),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
