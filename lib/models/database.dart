import 'dart:io';

import 'package:caspen/models/category.dart';
import 'package:caspen/models/transaction.dart';
import 'package:caspen/models/transaction_with_category.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, Transactions])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //CRUD Category

  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)
      ..where((tbl) => tbl.type.equals(type))).get();
  }

  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id))).write(
      CategoriesCompanion(name: Value(name), updatedAt: Value(DateTime.now())),
    );
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  //CRUD transaction
  Future<List<TransactionWithCategory>> getAllTransactionWithCategoryRepo(
    int type,
  ) async {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryid)),
    ])..where(categories.type.equals(type));

    final result = await query.get();

    return result.map((row) {
      return TransactionWithCategory(
        row.readTable(transactions),
        row.readTable(categories),
      );
    }).toList();
  }

  // list untuk menampilkan list
  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
    DateTime date,
  ) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryid)),
    ])..where(transactions.transactiondate.equals(date));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  // query untuk mendapatkan total amount
  // Future<int> getTotalAmountByTypeRepo(int type) async {
  //   final query = select(transactions).join([
  //     innerJoin(categories, categories.id.equalsExp(transactions.categoryid)),
  //   ])..where(categories.type.equals(type));

  //   final rows = await query.get();

  //   int total = 0;
  //   for (final row in rows) {
  //     final transaction = row.readTable(transactions);
  //     total += transaction.amount;
  //   }

  //   return total;
  // }

  //query agar otomatis berubah
  Stream<int> watchTotalAmountByTypeRepo(int type) {
    final query = select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.categoryid)),
    ])..where(categories.type.equals(type));

    return query.watch().map((rows) {
      int total = 0;
      for (final row in rows) {
        final transaction = row.readTable(transactions);
        total += transaction.amount;
      }
      return total;
    });
  }

  Stream<int> watchTotalAmountByMonthRepo(int type, DateTime selectedDate) {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    final query =
        select(transactions).join([
            innerJoin(
              categories,
              categories.id.equalsExp(transactions.categoryid),
            ),
          ])
          ..where(categories.type.equals(type))
          ..where(
            transactions.transactiondate.isBetweenValues(firstDay, lastDay),
          );

    return query.watch().map((rows) {
      int total = 0;
      for (final row in rows) {
        final transaction = row.readTable(transactions);
        total += transaction.amount;
      }
      return total;
    });
  }

  Future updateTransactionRepo(
    int id,
    int amount,
    int categoryId,
    DateTime transactionDate,
    String nameDetail,
  ) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
      TransactionsCompanion(
        name: Value(nameDetail),
        amount: Value(amount),
        categoryid: Value(categoryId),
        transactiondate: Value(transactionDate),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));

      return NativeDatabase(file);
    });
  }

  Stream<Transaction> watchTotalAmountByType(int type) {
    return (select(transactions)
      ..where((tbl) => tbl.categoryid.equals(type))).watchSingle();
  }
}
