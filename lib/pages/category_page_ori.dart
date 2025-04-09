import 'package:caspen/models/database.dart';
import 'package:caspen/pages/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  int type = 2; // 1 = income, 2 = expense
  TextEditingController categoryNameController = TextEditingController();

  Future<List<Category>> getAllCategory(int type) async {
    //return await db.getAllCategoryRepo(type);
    return Provider.of<CategoryProvider>(context).getAllCategoriesByType(type);
  }

  Future update(int categoryId, String newName) async {
    //return await db.updateCategoryRepo(categoryId, newName);
    return Provider.of<CategoryProvider>(
      context,
    ).updateCategory(categoryId, newName);
  }

  void openDialog(Category? category) {
    if (category != null) {
      categoryNameController.text = category.name;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense) ? "Add Expense" : "Add Income",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        // insert(categoryNameController.text, isExpense ? 2 : 1);
                        Provider.of<CategoryProvider>(
                          context,
                          listen: false,
                        ).insertCategory(
                          categoryNameController.text,
                          isExpense ? 2 : 1,
                        );
                      } else {
                        Provider.of<CategoryProvider>(
                          context,
                          listen: false,
                        ).updateCategory(
                          category.id,
                          categoryNameController.text,
                        );
                      }

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      categoryNameController.clear();
                    },
                    child: Text("Save"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpense,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                      type = value ? 2 : 1;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    openDialog(null);
                  },
                  icon: Icon(Icons.add), // icon tambah kategori
                ),
              ],
            ),
          ),

          FutureBuilder<List<Category>>(
            future: getAllCategory(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 10,
                            child: ListTile(
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirm"),
                                            content: Text(
                                              "Delete category '${snapshot.data![index].name}'?",
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text("Cancel"),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                              ),
                                              TextButton(
                                                child: Text("Delete"),
                                                onPressed: () {
                                                  Provider.of<CategoryProvider>(
                                                    context,
                                                    listen: false,
                                                  ).deleteCategory(
                                                    snapshot.data![index].id,
                                                  );
                                                  Navigator.of(context).pop();

                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "Category deleted",
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      openDialog(snapshot.data![index]);
                                    },
                                  ),
                                ],
                              ),
                              leading: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:
                                    (isExpense)
                                        ? Icon(
                                          Icons.upload,
                                          color: Colors.redAccent[400],
                                        )
                                        : Icon(
                                          Icons.download,
                                          color: Colors.greenAccent[400],
                                        ),
                              ),
                              title: Text(snapshot.data![index].name),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No has data"));
                  }
                } else {
                  return Center(child: Text("No has data"));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
