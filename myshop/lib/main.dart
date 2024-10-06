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

  void _addNewGame(Game game) {
    setState(() {
      games.add(game);
    });
  }

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.add(GameStoreScreen(games: games, toggleFavorite: toggleFavorite, favoriteGames: favoriteGames, onAddGame: _addNewGame));
    _screens.add(FavoriteScreen(favoriteGames: favoriteGames, toggleFavorite: toggleFavorite));
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
  final Function(Game) onAddGame;

  GameStoreScreen({
    Key? key,
    required this.games,
    required this.toggleFavorite,
    required this.favoriteGames,
    required this.onAddGame,
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
                  builder: (context) => AddGameScreen(
                    onAdd: (game) {
                      games.add(game);
                    },
                  ),
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameDetailScreen(game: game),
                ),
              );
            },
            child: Card(
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
                      icon: Icon(
                        favoriteGames.contains(game) ? Icons.favorite : Icons.favorite_border,
                        color: favoriteGames.contains(game) ? const Color.fromARGB(255, 66, 66, 66) : null,
                      ),
                      onPressed: () {
                        toggleFavorite(game);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteScreen extends StatelessWidget {
  final List<Game> favoriteGames;
  final Function(Game) toggleFavorite;

  const FavoriteScreen({Key? key, required this.favoriteGames, required this.toggleFavorite}) : super(key: key);

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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameDetailScreen(game: game),
                      ),
                    );
                  },
                  child: Card(
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
                              toggleFavorite(game);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: game.imageFilePath != null
                    ? Image.file(
                        File(game.imageFilePath!),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        game.imagePath,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  game.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  '${game.price} \$',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  game.description,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
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
      Navigator.pop(context);
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
              decoration: const InputDecoration(labelText: 'Название игры'),
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
            const SizedBox(height: 10),
            imageFilePath != null
                ? Image.file(File(imageFilePath!), height: 150)
                : const Text('Изображение не выбрано'),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Выбрать изображение'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Добавить игру'),
            ),
          ],
        ),
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

class Game {
  final String name;
  final String imagePath;
  final double price;
  final String description;
  final String? imageFilePath;

  Game(this.name, this.imagePath, this.price, this.description, {this.imageFilePath});
}
