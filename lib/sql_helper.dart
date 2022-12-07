import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static const budgetTable = """
CREATE TABLE budget(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  budget_name TEXT,
  budget_amount FLOAT
);""";

  static const outcomeTable = """
CREATE TABLE outcome(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  date TEXT,
  outcome_name TEXT,
  outcome_amount FLOAT,
  budget_id INTEGER
);

""";

  static Future<sql.Database> dbInit() async {
    return sql.openDatabase('outrack.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await database.execute("PRAGMA foreign_keys=ON");
      await database.execute(budgetTable);
      await database.execute(outcomeTable);
    });
  }

  static Future<int> addBudget(String budgetName, double budgetAmount) async {
    final db = await SQLHelper.dbInit();
    final data = {'budget_name': budgetName, 'budget_amount': budgetAmount};
    return await db.insert('budget', data);
  }

  static Future<void> updateBudget(int id, var budgetJson) async {
    final db = await SQLHelper.dbInit();
    await db.update('budget', budgetJson, where: "id =$id");
  }

  static Future<List<Map<String, dynamic>>> getBudget() async {
    final db = await SQLHelper.dbInit();
    return db.query('budget');
  }

  static Future<void> deleteBudget(int id) async {
    final db = await SQLHelper.dbInit();
    await db.delete('budget', where: "id =$id");
    await db.delete('outcome', where: "budget_id =$id");
  }

  static Future<int> addOutcome(String outcomeName, double outcomeAmount,
      int budgetID, String date) async {
    final db = await SQLHelper.dbInit();
    final data = {
      'outcome_name': outcomeName,
      'outcome_amount': outcomeAmount,
      'budget_id': budgetID,
      'date': date
    };
    return await db.insert('outcome', data);
  }

  static Future<List<Map<String, dynamic>>> getOutcome() async {
    final db = await SQLHelper.dbInit();
    return db.query('outcome');
  }

  static Future<void> deleteOutcome(int id) async {
    final db = await SQLHelper.dbInit();
    await db.delete('outcome', where: "id =$id");
  }
}
