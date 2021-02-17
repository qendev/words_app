import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(WordsApp());

class WordsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white

      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  // This Set stores the word pairings that the user favorited.
  // Set is preferred to List because a properly implemented Set doesn't allow duplicate entries.
  final _saved = Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Name Generator'),
        /*Here you add a list icon to the AppBar in the build method for _RandomWordsState.
        When the user clicks the list icon, a new route that contains the saved favorites is pushed to the Navigator, displaying the icon.*/
        actions: [
          IconButton(icon: Icon(Icons.list,),
              onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  /*The _buildSuggestions() function calls _buildRow() once per word pair.*/
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),

        /*1*/
        //The itemBuilder callback is called once per suggested word pairing, and places each suggestion into a ListTile row.
        // For even rows, the function adds a ListTile row for the word pairing. For odd rows,
        // the function adds a Divider widget to visually separate the entries. Note that the divider might be difficult to see on smaller devices.
        itemBuilder: (context, i) {
          /*2*/ //Add a one-pixel-high divider widget before each row in the ListView.

          if (i.isOdd) return Divider();
          /*3*/ //The expression i ~/ 2 divides i by 2 and returns an integer result.
          // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
          // This calculates the actual number of word pairings in the ListView, minus the divider widgets.
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            /*4*/ //If you’ve reached the end of the available word pairings, then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    //check to ensure that a word pairing has not already been added to favorites.
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      //add heart-shaped icons to the ListTile objects to enable favoriting.
      // Here, you'll add the ability to interact with the heart icons.
      trailing: Icon(
        // NEW from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      //When the user taps an entry in the list, toggling its favorited state, that word pairing is added or removed from a set of saved favorites.
      // When a tile has been tapped, the function calls setState() to notify the framework that state has changed.
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  /* build a route and push it to the Navigator's stack.
  That action changes the screen to display the new route.
  The content for the new page is built in MaterialPageRoute's builder property in an anonymous function.*/

  /*For now, add the code that generates the ListTile rows.
  The divideTiles() method of ListTile adds horizontal spacing between each ListTile.
  The divided variable holds the final rows converted to a list by the convenience function, toList().*/
  void _pushSaved() {
    //Navigator.push, pushes the route to the Navigator's stack
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final divided = ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList();
        /*The builder property returns a Scaffold containing the app bar for the new route.
        The body of the new route consists of a ListView containing the ListTiles rows. Each row is separated by a divider.*/
        return Scaffold(
          appBar: AppBar(
            title: Text('My Fourite WordPairs'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }
}
