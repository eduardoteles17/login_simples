import 'package:flutter/material.dart';
import 'package:login_simples/controllers/auth_controller.dart';
import 'package:login_simples/screens/generic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late List<Widget> pages;

  int _bottomNavIndex = 0;

  final AuthController _authController = AuthController.instance;

  _onLogout() async {
    await _authController.logout();
    if (!context.mounted) {
      return null;
    }
    Navigator.pushReplacementNamed(context, '/');
  }


  @override
  void initState() {
    super.initState();
    pages = [
      const GenericScreen(
        key: ValueKey('home'),
        title: 'Home',
        content: Text('Home Screen'),
      ),
      const GenericScreen(
        key: ValueKey('favorites'),
        title: 'Favoritos',
        content: Text('Favoritos Screen'),
      ),
      GenericScreen(
        key: const ValueKey('settings'),
        title: 'Configurações',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Configurações Screen'),
            ElevatedButton(
              onPressed: _onLogout,
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    ];
  }

  _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Add Transitions on Navigation
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: pages[_bottomNavIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _bottomNavIndex,
        onDestinationSelected: _onBottomNavTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_outlined),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
