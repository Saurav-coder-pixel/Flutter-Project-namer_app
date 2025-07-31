// This is my code

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}



class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favroite= <WordPair>[];

  void toggleFavroite(){
    if(favroite.contains(current)){
      favroite.remove(current);
    }else{
      favroite.add(current);
    }
    notifyListeners();
  }
}


class MyHomePage extends StatefulWidget{
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIdx=0;

  @override
  Widget build(BuildContext context) {

    Widget page;
    switch(selectedIdx){
      case 0:
        page= GeneratorPage();
        break;
      case 1:
        page= FavoritePage();
        break;
      default:
        throw UnimplementedError('no Wigdet for $selectedIdx');
    }

    return Scaffold(
          // appBar: AppBar(
          //     title: Center(child: Text('Namer_ App')),
          //     backgroundColor: Colors.red.shade400,
          // ),

      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
                selectedIndex: selectedIdx,
                extended: false,
                destinations: [
                  NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home')
                  ),
                  NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorite')
                  ),
                ],
              onDestinationSelected: (value){
                setState(() {
                  selectedIdx= value;
                });
              }
            ),
          ),

          Expanded(
          child: Container(
          color: Theme.of(context).colorScheme.onPrimary,
          child: page,
          )
          )
        ],
      ),
    );
  }
}



class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pairs= appState.current;

    IconData icon;
    if(appState.favroite.contains(pairs)){
      icon= Icons.favorite;
    }else{
      icon= Icons.favorite_border;
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(pair: pairs),
            SizedBox(height: 11,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                    onPressed: (){
                      appState.toggleFavroite();
                },
                    icon: Icon(icon),
                  label: Text('Like'),
                ),

                SizedBox(width: 15),

                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            ),

          ],
        ),
      );
  }
}


class BigCard extends StatelessWidget{
  const BigCard({super.key, required this.pair});
  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    final styles= theme.textTheme.displayLarge!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            pair.asPascalCase,
            style: styles,
            semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}



class FavoritePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    var fav= context.watch<MyAppState>();


    if(fav.favroite.isEmpty){
      return Center(
        child:Text('No favourite yet',
            style: TextStyle(fontSize: 30)),
      );
    }

    return ListView(
      children: [
        Center(child: Text('Your ${fav.favroite.length} Favorites are:',
          style: TextStyle(fontSize: 20),
        )
        ),
        for(var pair in fav.favroite)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asPascalCase),
          ),
      ],
    );
  }
}



















