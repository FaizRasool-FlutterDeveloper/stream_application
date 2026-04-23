import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final title = movie['title'] ?? movie['name'] ?? 'Unknown';
    final posterPath = movie['poster_path'];
    final poster = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : (movie['poster'] ?? '');

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: poster.isNotEmpty
                ? Image.network(poster,
                    width: double.infinity, fit: BoxFit.cover)
                : Container(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 6),
        Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center),
      ],
    );
  }
}
