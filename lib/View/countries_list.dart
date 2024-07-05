import 'package:covid_tracker/Services/world_state_service.dart';
import 'package:covid_tracker/View/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WorldStateService worldStateService = WorldStateService();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search with country name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(69),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: worldStateService.countriesListApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade700,
                          highlightColor: Colors.grey.shade100,
                          child: Column(
                            children: [
                              ListTile(
                                title: Container(
                                  height: 10,
                                  width: 89,
                                  color: Colors.white,
                                ),
                                subtitle: Container(
                                  height: 10,
                                  width: 19,
                                  color: Colors.white,
                                ),
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  } else {
                    var countries = snapshot.data!;
                    return ListView.builder(
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        var country = countries[index];
                        String name = country['country'];
                        if (searchController.text.isEmpty) {
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                              name: country['country'],
                                              image:  country['countryInfo']['flag'],
                                              todayRecovered:  country['todayRecovered'],
                                              test:  country['tests'],
                                              active:  country['active'],
                                              totalCases:  country['cases'],
                                              critical:  country['critical'],
                                              totalDeaths:  country['deaths'],
                                              totalRecovered:  country['recovered'])));
                                },
                                child: ListTile(
                                  title: Text(country['country']),
                                  subtitle: Text(country['cases'].toString()),
                                  leading: Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(
                                          country['countryInfo']['flag'])),
                                ),
                              ),
                            ],
                          );
                        } else if (name
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase())) {
                          return InkWell(
                              onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                          name: country['country'],
                                          image: country['countryInfo']['flag'],
                                          todayRecovered:
                                              country['todayRecovered'],
                                          test: country['tests'],
                                          active: country['active'],
                                          totalCases: country['cases'],
                                          critical: country['critical'],
                                          totalDeaths: country['deaths'],
                                          totalRecovered:
                                              country['recovered'])));
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(country['country']),
                                  subtitle: Text(country['cases'].toString()),
                                  leading: Image(
                                      height: 50,
                                      width: 50,
                                      image: NetworkImage(
                                          country['countryInfo']['flag'])),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
