import 'package:covid_tracker/Model/world_states_model.dart';
import 'package:covid_tracker/Services/world_state_service.dart';
import 'package:covid_tracker/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

// color code
  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    WorldStateService worldStateService = WorldStateService();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.010,
            ),
            FutureBuilder(
                future: worldStateService.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ));
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap:  {
                            'Total': double.parse(snapshot.data!.cases!.toString()),
                            'Recovered':
                                double.parse(snapshot.data!.recovered!.toString()),
                            'Death':
                                double.parse(snapshot.data!.deaths!.toString()),
                          },
                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true
                          ),
                          animationDuration: const Duration(seconds: 2),
                          chartType: ChartType.ring,
                          colorList: colorList,
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.06,
                          ),
                          child: Card(
                            child: Column(
                              children: [
                                ReuseableRow(title: "Total", value: snapshot.data!.cases!.toString()),
                                ReuseableRow(title: "Deaths", value: snapshot.data!.deaths!.toString()),
                                ReuseableRow(title: "Recovered", value: snapshot.data!.recovered!.toString()),
                                ReuseableRow(title: "Active", value: snapshot.data!.active!.toString()),
                                ReuseableRow(title: "Critical", value: snapshot.data!.critical!.toString()),
                                ReuseableRow(title: "Todays Death", value: snapshot.data!.todayDeaths!.toString()),
                                ReuseableRow(title: "Todays Recovered", value: snapshot.data!.todayRecovered!.toString()),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesList()));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.green),
                            child: Center(
                              child: Text(
                                "Track Countries",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

// ignore: must_be_immutable
class ReuseableRow extends StatelessWidget {
  String title, value;
  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5, right: 10, top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
