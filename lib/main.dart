import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/search_provider.dart';
import 'package:flutter_application_1/repository.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchProvider(repository: UniversityRepositoryImpl()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Поиск университетов',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const UniversitySearchPage(),
    );
  }
}

class UniversitySearchPage extends StatefulWidget {
  const UniversitySearchPage({super.key});

  @override
  State<UniversitySearchPage> createState() => _UniversitySearchPageState();
}

class _UniversitySearchPageState extends State<UniversitySearchPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final provider = context.read<SearchProvider>();
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      provider.reset();
    } else {
      provider.search(name: name, country: _countryController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск университетов')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Введите название',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _nameController.clear();
                    provider.reset();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _countryController,
              onChanged: (_) => _onSearchChanged(),
              decoration: InputDecoration(
                hintText: 'Введите страну',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _countryController.clear();
                    _onSearchChanged();
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: provider.isInitialLoad
                  ? const Center(child: CircularProgressIndicator())
                  : provider.universities.isEmpty
                  ? const Center(child: Text('Нет результатов'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          provider.universities.length +
                          (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < provider.universities.length) {
                          final university = provider.universities[index];
                          return ListTile(
                            title: Text('$index - ${university.name}'),
                            subtitle: Text(university.country ?? 'Без страны'),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(child: CircularProgressIndicator()),
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

  void scrollListener() {
    final provider = context.read<SearchProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoading &&
        provider.hasMore) {
      provider.loadMore();
    }
  }
}
