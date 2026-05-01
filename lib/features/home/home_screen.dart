import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_widgets.dart';
import 'home_provider.dart';

/// HomeScreen - Displays trending anime with glassmorphism cards
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load trending anime on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadTrendingAnime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'AnimeGram',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearch(),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _navigateToFavorites(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppTheme.accentBlue,
            ),
          );
        }

        if (provider.error != null) {
          return Center(
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading anime',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  GlassButton(
                    text: 'Retry',
                    onPressed: () => provider.loadTrendingAnime(),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.trendingAnime.isEmpty) {
          return const Center(
            child: Text(
              'No anime found',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          );
        }

        return RefreshIndicator(
          color: AppTheme.accentBlue,
          onRefresh: () => provider.loadTrendingAnime(),
          child: CustomScrollView(
            slivers: [
              // Featured Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending Now',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover the most popular anime this season',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

              // Anime Grid
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final anime = provider.trendingAnime[index];
                      return AnimeCard(
                        title: anime.title,
                        imageUrl: anime.imageUrl.isNotEmpty
                            ? anime.imageUrl
                            : 'https://via.placeholder.com/300x450?text=No+Image',
                        episodeCount: anime.episodeCount != null
                            ? '${anime.episodeCount} Episodes'
                            : null,
                        onTap: () => _navigateToDetail(anime),
                      );
                    },
                    childCount: provider.trendingAnime.length,
                  ),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearch() {
    showSearch(
      context: context,
      delegate: AnimeSearchDelegate(),
    );
  }

  void _navigateToFavorites() {
    // TODO: Navigate to favorites screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Favorites coming soon!')),
    );
  }

  void _navigateToDetail(Anime anime) {
    // TODO: Navigate to detail screen
    Navigator.pushNamed(
      context,
      '/detail',
      arguments: anime,
    );
  }
}

/// Search Delegate for anime search
class AnimeSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final results = provider.searchAnime(query);

    if (results.isEmpty) {
      return const Center(
        child: Text('No results found'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final anime = results[index];
        return ListTile(
          title: Text(anime.title),
          subtitle: Text(anime.description),
          onTap: () {
            close(context, null);
            // Navigate to detail
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final provider = context.read<HomeProvider>();
    final suggestions = provider.searchAnime(query);

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final anime = suggestions[index];
        return ListTile(
          title: Text(anime.title),
          onTap: () {
            query = anime.title;
            showResults(context);
          },
        );
      },
    );
  }
}
