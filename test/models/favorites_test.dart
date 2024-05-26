import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:testing_app/models/favorites.dart';
import 'package:testing_app/screens/favorites.dart';

late Favorites favoritesList;

Widget createFavoritesScreen() => ChangeNotifierProvider<Favorites>(
      create: (context) {
        favoritesList = Favorites();
        return favoritesList;
      },
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    );

void addItems() {
  for (var i = 0; i < 10; i += 2) {
    favoritesList.add(i);
  }
}

void main() {  

test.group('Favorites Page Widget Tests', () {
    testWidgets('Test if ListView shows up', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      test.expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Testing Remove Button', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      addItems();
      await tester.pumpAndSettle();
      var totalItems = tester.widgetList(find.byIcon(Icons.close)).length;
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pumpAndSettle();
      test.expect(tester.widgetList(find.byIcon(Icons.close)).length,
          lessThan(totalItems));
      test.expect(find.text('Removed from favorites.'), findsOneWidget);
    });
  });
  
  test.group('Testing App Provider', () {
    var favorites = Favorites();

    test.test('A new item should be added', () {
      var number = 35;
      favorites.add(number);
      test.expect(favorites.items.contains(number), true);
    });    

    test.test('An item should be removed', () {
  var number = 45;
  favorites.add(number);
  test.expect(favorites.items.contains(number), true);
  favorites.remove(number);
  test.expect(favorites.items.contains(number), false);
});
});
}