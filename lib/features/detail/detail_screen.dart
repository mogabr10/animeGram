import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_widgets.dart';
import '../home/home_provider.dart';

/// DetailScreen - Displays anime details with glassmorphism and video player
class DetailScreen extends StatelessWidget {
  final Anime anime;
  
  const DetailScreen({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          // Blurred background image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: anime.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
              ),
            ),
          ),
          
          // Overlay gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppTheme.primaryDark.withOpacity(0.8),
                    AppTheme.primaryDark,
                  ],
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildContent(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.glassWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.glassWhite,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border, size: 20),
          ),
          onPressed: () => _toggleFavorite(context),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and rating section
          GlassCard(
            blur: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  anime.title,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                ),
                const SizedBox(height: 12),
                
                // Rating and metadata row
                Row(
                  children: [
                    _buildRatingBadge(),
                    const SizedBox(width: 12),
                    if (anime.status != null)
                      _buildInfoChip(Icons.info_outline, anime.status!),
                    const SizedBox(width: 12),
                    if (anime.episodeCount != null)
                      _buildInfoChip(
                        Icons.play_circle_outline,
                        '${anime.episodeCount} EP',
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Play button
          GlassButton(
            text: '▶ Play Now',
            onPressed: () => _playVideo(context),
            isPrimary: true,
          ),
          
          const SizedBox(height: 24),
          
          // Description section
          GlassCard(
            blur: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Synopsis',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  anime.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.6,
                      ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Genres section
          if (anime.genres.isNotEmpty) ...[
            GlassCard(
              blur: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Genres',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: anime.genres.map((genre) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          genre,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          
          // Episodes list (placeholder)
          GlassCard(
            blur: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Episodes',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                _buildEpisodeList(context),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            anime.rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.glassWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.accentBlue),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeList(BuildContext context) {
    // Placeholder episode list
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(
        color: AppTheme.glassBorder,
      ),
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 60,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.secondaryDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white54),
          ),
          title: Text('Episode ${index + 1}'),
          subtitle: const Text('24 min'),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
          onTap: () => _playEpisode(context, index + 1),
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context) {
    // TODO: Implement favorite toggle with Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to favorites!')),
    );
  }

  void _playVideo(BuildContext context) {
    // TODO: Navigate to video player
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening video player...')),
    );
  }

  void _playEpisode(BuildContext context, int episodeNumber) {
    // TODO: Play specific episode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing Episode $episodeNumber')),
    );
  }
}
