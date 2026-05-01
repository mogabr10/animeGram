import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// GlassCard - A reusable glassmorphism card widget
/// Creates a frosted glass effect with customizable properties
class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final Color? color;
  final EdgeInsets padding;
  final double borderWidth;
  final Gradient? gradient;
  
  const GlassCard({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.borderRadius = 16.0,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.borderWidth = 1.0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: gradient,
            color: color ?? AppTheme.glassWhite,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppTheme.glassBorder,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// GlassButton - A glassmorphism styled button
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final double width;
  
  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GlassCard(
        blur: 8,
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(vertical: 16),
        gradient: isPrimary ? AppTheme.accentGradient : null,
        color: isPrimary ? null : AppTheme.glassWhite,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : AppTheme.accentBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// AnimeCard - Specialized glass card for anime display
class AnimeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? episodeCount;
  final VoidCallback onTap;
  
  const AnimeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.episodeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 20,
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Anime poster with gradient overlay
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.secondaryDark,
                          child: const Icon(
                            Icons.anime_outlined,
                            size: 50,
                            color: Colors.white54,
                          ),
                        );
                      },
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (episodeCount != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.play_circle_outline,
                            size: 14,
                            color: AppTheme.accentBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            episodeCount!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
