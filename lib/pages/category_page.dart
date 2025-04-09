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

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController categoryNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void openDialog({Category? category, required int type}) {
    if (category != null) {
      categoryNameController.text = category.name;
    }

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    (type == 2) ? "Add Expense" : "Add Income",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (type == 2) ? Colors.red : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: categoryNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (category == null) {
                        Provider.of<CategoryProvider>(
                          context,
                          listen: false,
                        ).insertCategory(categoryNameController.text, type);
                      } else {
                        Provider.of<CategoryProvider>(
                          context,
                          listen: false,
                        ).updateCategory(
                          category.id,
                          categoryNameController.text,
                        );
                      }

                      Navigator.of(context, rootNavigator: true).pop();
                      categoryNameController.clear();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambah kategori sesuai tab yang aktif
          final currentTab = _tabController.index;
          final categoryType = currentTab == 0 ? 1 : 2;
          openDialog(type: categoryType);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.black,
                tabs: const [Tab(text: "Income"), Tab(text: "Expense")],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  CategoryList(type: 1, openDialog: openDialog),
                  CategoryList(type: 2, openDialog: openDialog),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  final int type;
  final Function({Category? category, required int type}) openDialog;

  const CategoryList({super.key, required this.type, required this.openDialog});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: Provider.of<CategoryProvider>(
        context,
      ).getAllCategoriesByType(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No categories"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final cat = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                elevation: 6,
                child: ListTile(
                  leading: Icon(
                    type == 2 ? Icons.upload : Icons.download,
                    color: type == 2 ? Colors.red : Colors.green,
                  ),
                  title: Text(cat.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openDialog(category: cat, type: type),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (_) => AlertDialog(
                                  title: const Text("Confirm"),
                                  content: Text(
                                    "Delete category '${cat.name}'?",
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        Provider.of<CategoryProvider>(
                                          context,
                                          listen: false,
                                        ).deleteCategory(cat.id);
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text("Category deleted"),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
