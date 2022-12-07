import 'package:flutter/material.dart';
import 'package:outrack/history/history_state.dart';
import 'package:outrack/widgets/format_currency.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (context) => HistoryState(),
        child: Consumer<HistoryState>(
          builder: (context, historyState, child) => Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(child: Text("Date")),
                      Expanded(child: Text("Outcome Name")),
                      Expanded(
                          child:
                              Text("Outcome Amount", textAlign: TextAlign.end)),
                    ],
                  ),
                  Divider(
                    height: 20,
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                      itemCount: historyState.outcome.length,
                      itemBuilder: (context, index) {
                        return Row(children: [
                          Expanded(
                              child: Text(historyState.outcome[index]['date'])),
                          Expanded(
                              child: Text(
                                  historyState.outcome[index]['outcome_name'])),
                          Expanded(
                              child: Text(
                            formatCurrency(historyState.outcome[index]
                                    ['outcome_amount']
                                .toInt()),
                            textAlign: TextAlign.end,
                          )),
                        ]);
                      }),
                  const Divider(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text("Total: ")),
                      Expanded(
                          child: Text(
                        historyState.totalOutcome,
                        textAlign: TextAlign.end,
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
