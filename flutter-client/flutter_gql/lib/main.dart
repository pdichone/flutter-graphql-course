import 'package:flutter/material.dart';
import 'package:flutter_gql/screens/home_screen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final HttpLink link =
      HttpLink('https://graphql-flutter-course.herokuapp.com/graphql');
  ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(link: link, cache: GraphQLCache(store: HiveStore())));

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({Key? key, required this.client}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              textTheme: theme,
              appBarTheme: AppBarTheme(
                  iconTheme: IconThemeData(color: Colors.black87),
                  textTheme: theme)),
          home: HomeScreen(),
        ),
      ),
    );
  }
}
