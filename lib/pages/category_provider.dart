import 'package:flutter/material.dart';
import 'package:caspen/models/database.dart';

class CategoryProvider with ChangeNotifier {
  final AppDb db;
  CategoryProvider(this.db);

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool isExpense = true;
  int get type => isExpense ? 2 : 1;

  void switchType(bool value) {
    isExpense = value;
    loadCategories();
  }

  Future<void> loadCategories() async {
    _categories = await db.getAllCategoryRepo(type);
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    final now = DateTime.now();
    await db
        .into(db.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await loadCategories();
  }

  Future<void> updateCategory(int id, String name) async {
    await db.updateCategoryRepo(id, name);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await db.deleteCategoryRepo(id);
    await loadCategories();
  }

  Future<List<Category>> getAllCategoriesByType(int type) async {
    return await (db.select(db.categories)
      ..where((tbl) => tbl.type.equals(type))).get();
  }

  Future<void> insertCategory(String name, int type) async {
    final now = DateTime.now();
    await db
        .into(db.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now,
          ),
        );
    notifyListeners();
  }
}
