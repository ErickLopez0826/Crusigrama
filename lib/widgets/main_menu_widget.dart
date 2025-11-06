import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../audio_service.dart';
import '../providers.dart';
import 'crossword_puzzle_app.dart';

class MainMenuWidget extends ConsumerWidget {
  const MainMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(sizeProvider);
    final audioServiceAsync = ref.watch(audioServiceProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF151515),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Título
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.grid_4x4,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'CRUCIGRAMA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 8,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Puzzle de Palabras',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 60),

                // Selección de tamaño
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'TAMAÑO DEL PUZZLE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ...CrosswordSize.values.map((size) {
                        final isSelected = size == selectedSize;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () {
                              ref.read(sizeProvider.notifier).setSize(size);
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isSelected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    size: 20,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    size.label,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                                      color: isSelected
                                          ? Theme.of(context).colorScheme.primary
                                          : Theme.of(context).colorScheme.onSurface,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Controles de audio
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: audioServiceAsync.when(
                    data: (_) {
                      final audioService = ref.read(audioServiceProvider.notifier);
                      return Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.volume_up,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'AUDIO',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          _AudioToggle(
                            icon: audioService.isMusicEnabled ? Icons.music_note : Icons.music_off,
                            label: 'Música de Fondo',
                            isEnabled: audioService.isMusicEnabled,
                            onTap: () => audioService.toggleMusic(),
                          ),
                          SizedBox(height: 12),
                          _AudioToggle(
                            icon: audioService.isSFXEnabled ? Icons.volume_up : Icons.volume_off,
                            label: 'Efectos de Sonido',
                            isEnabled: audioService.isSFXEnabled,
                            onTap: () => audioService.toggleSFX(),
                          ),
                        ],
                      );
                    },
                    loading: () => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    error: (_, __) => Text(
                      'Error al cargar audio',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // Botón de jugar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Invalidar los providers para regenerar el puzzle con el nuevo tamaño
                      ref.invalidate(workQueueProvider);
                      ref.invalidate(puzzleProvider);
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CrosswordPuzzleApp(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'JUGAR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AudioToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;
  final VoidCallback onTap;

  const _AudioToggle({
    required this.icon,
    required this.label,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isEnabled
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isEnabled
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: isEnabled ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isEnabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isEnabled ? FontWeight.w500 : FontWeight.w400,
                  color: isEnabled
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            Container(
              width: 44,
              height: 24,
              decoration: BoxDecoration(
                color: isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: AnimatedAlign(
                duration: Duration(milliseconds: 200),
                alignment: isEnabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.all(2),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

