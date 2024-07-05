import 'package:covid_tracker/View/world_stats.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  String name;
  String image;
  int totalCases,
      totalDeaths,
      totalRecovered,
      active,
      critical,
      todayRecovered,
      test;

  DetailsScreen({
    super.key,
    required this.name,
    required this.image,
    required this.todayRecovered,
    required this.test,
    required this.active,
    required this.totalCases,
    required this.critical,
    required this.totalDeaths,
    required this.totalRecovered,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title:  Text(widget.name),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.067 ),
                child: Card(
                  child: Column(
                    children: [
                      SizedBox(height:  MediaQuery.of(context).size.height * 0.06),
                      ReuseableRow(title: 'Cases', value: widget.totalCases.toString()),
                      ReuseableRow(title: 'Recovered', value: widget.totalRecovered.toString()),
                      ReuseableRow(title: 'Active', value: widget.active.toString()),
                      ReuseableRow(title: 'Tests', value: widget.test.toString()),
                      ReuseableRow(title: 'Critical', value: widget.critical.toString()),
                      ReuseableRow(title: 'Deaths', value: widget.totalDeaths.toString()),
                      ReuseableRow(title: 'Today Recovered', value: widget.todayRecovered.toString()),
                
                    ],
                  ),
                ),
              ),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.image),
              )
            ],
          )
        ],
      ),
    );
  }
}
