import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(GameStoreApp());
}

class GameStoreApp extends StatelessWidget {
  const GameStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GameStore',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Game> favoriteGames = [];

  final List<Game> games = [
    Game('Forza Horizon 4', 'assets/forza.jpg', 49.99, 'Гоночная игра в открытом мире.'),
    Game('Stardew Valley', 'assets/stardew_valley.jpg', 14.99, 'Симулятор фермы и ролевой игры.'),
    Game('GTA 5', 'assets/gta5.jpg', 29.99, 'Популярная криминальная экшен-игра.'),
    Game('Metro Exodus', 'assets/metro_exodus.jpg', 39.99, 'Шутер с элементами выживания в постапокалиптической России.'),
  ];

  void toggleFavorite(Game game) {
    setState(() {
      if (favoriteGames.contains(game)) {
        favoriteGames.remove(game);
      } else {
        favoriteGames.add(game);
      }
    });
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(GameStoreScreen(games: games, toggleFavorite: toggleFavorite, favoriteGames: favoriteGames));
    _screens.add(FavoriteScreen(favoriteGames: favoriteGames));
    _screens.add(ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class GameStoreScreen extends StatelessWidget {
  final List<Game> games;
  final List<Game> favoriteGames;
  final Function(Game) toggleFavorite;

  GameStoreScreen({
    Key? key,
    required this.games,
    required this.toggleFavorite,
    required this.favoriteGames,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GameStore'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddGameScreen(onAdd: (newGame) {
                    toggleFavorite(newGame);
                  }),
                ),
              );
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          final isFavorite = favoriteGames.contains(game);
          return Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    child: game.imageFilePath != null
                        ? Image.file(
                            File(game.imageFilePath!),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            game.imagePath,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                ListTile(
                  title: Text(game.name),
                  subtitle: Text('${game.price} \$'),
                  trailing: StatefulBuilder(
                    builder: (context, setState) {
                      return IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? const Color.fromARGB(255, 66, 66, 66) : null,
                        ),
                        onPressed: () {
                            toggleFavorite(game);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}



class FavoriteScreen extends StatelessWidget {
  final List<Game> favoriteGames;

  const FavoriteScreen({Key? key, required this.favoriteGames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: favoriteGames.isEmpty
          ? const Center(child: Text('Нет избранных игр'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: favoriteGames.length,
              itemBuilder: (context, index) {
                final game = favoriteGames[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: game.imageFilePath != null
                            ? Image.file(
                                File(game.imageFilePath!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                game.imagePath,
                                fit: BoxFit.cover,
                              ),
                      ),
                      ListTile(
                        title: Text(game.name),
                        subtitle: Text('${game.price} \$'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 66, 66, 66)),
                          onPressed: () {
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'ФИО: Хидиров Карим',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Группа: ЭФБО-03-22',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Номер телефона: +7 123 456 7890',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Email: khidirov@karim.com',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddGameScreen extends StatefulWidget {
  final Function(Game) onAdd;

  const AddGameScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddGameScreenState createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? imageFilePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFilePath = image.path;
      });
    }
  }

  void _submit() {
    if (nameController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        imageFilePath != null) {
      final game = Game(
        nameController.text,
        'assets/new_image.jpg',
        double.parse(priceController.text),
        descriptionController.text,
        imageFilePath: imageFilePath,
      );
      widget.onAdd(game);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить игру'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Цена'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Описание'),
            ),
            const SizedBox(height: 20),
            imageFilePath == null
                ? const Text('Фото не выбрано')
                : Image.file(
                    File(imageFilePath!),
                    width: 100,
                    height: 100,
                  ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Выбрать фото'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}

class Game {
  final String name;
  final String imagePath;
  final double price;
  final String description;
  String? imageFilePath;

  Game(this.name, this.imagePath, this.price, this.description, {this.imageFilePath});
}

