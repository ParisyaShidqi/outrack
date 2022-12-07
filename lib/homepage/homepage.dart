import 'package:flutter/material.dart';
import 'package:outrack/history/history.dart';
import 'package:outrack/homepage/home_state.dart';
import 'package:outrack/widgets/button.dart';
import 'package:outrack/widgets/dialog.dart';
import 'package:outrack/widgets/format_currency.dart';
import 'package:outrack/widgets/textfield.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeState(),
      child: Consumer<HomeState>(builder: (context, homeState, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              outrackButton(() {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const History())));
              }, "History")
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              outrackDialog(context, homeState.budgetNameController,
                  homeState.budgetAmountController, () {
                homeState.addBudget();
                Navigator.pop(context);
              });
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Savings: " + "0"),
                        const SizedBox(
                          height: 10,
                        ),
                        Text("Income Left: " + homeState.monthlyIncome),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: homeState.isLoading
                              ? const CircularProgressIndicator()
                              : ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: homeState.budget.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 3,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final item = homeState.budgetItems[index];
                                    return Dismissible(
                                      background: Container(color: Colors.red),
                                      key: Key(item),
                                      onDismissed: (direction) async {
                                        await homeState.deleteBudget(index);
                                      },
                                      child: Card(
                                        child: ListTile(
                                          dense: true,
                                          leading: Text(
                                            homeState.budget[index]
                                                        ['budget_name']
                                                    .toString() +
                                                " : ",
                                          ),
                                          trailing: Text(
                                            formatCurrency(homeState
                                                .budget[index]['budget_amount']
                                                .toInt()),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        const Divider(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(child: Text("Today Outcome: ")),
                            Expanded(
                                child: Text(
                              homeState.totalOutcome,
                              textAlign: TextAlign.end,
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 15,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Outcome List"),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: homeState.isLoading
                              ? const CircularProgressIndicator()
                              : ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: homeState.todayOutcome.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final item = homeState.outcomeItems[index];
                                    return Dismissible(
                                      background: Container(color: Colors.red),
                                      key: Key(item),
                                      onDismissed: (direction) async {
                                        await homeState.deleteOutcome(index);
                                        
                                      },
                                      child: Card(
                                        child: ListTile(
                                          dense: true,
                                          leading: Text(
                                            homeState.todayOutcome[index]
                                                        ['outcome_name']
                                                    .toString() +
                                                " : ",
                                          ),
                                          trailing: Text(
                                            formatCurrency(homeState
                                                .todayOutcome[index]
                                                    ['outcome_amount']
                                                .toInt()),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: textField(
                            homeState.setOutcomeNameController, "Outcome Name"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: numField(homeState.setOutcomeAmountController,
                            "Outcome Amount"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                    value: homeState.dropdownValue,
                    icon: Container(),
                    isExpanded: true,
                    elevation: 16,
                    onChanged: (String? value) {
                      setState(() {
                        homeState.dropdownValue = value!;
                        homeState.idSeeker(value);
                      });
                    },
                    items: homeState.budgetList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: outrackButton(() {
                        homeState.addOutcome();
                      }, "Input Outcome"))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
