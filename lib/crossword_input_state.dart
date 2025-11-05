import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'model.dart' as model;

part 'crossword_input_state.g.dart';

/// Estado para la celda seleccionada actual y la dirección de entrada
class CrosswordInputState {
  final model.Location? selectedCell;
  final model.Direction direction;
  
  const CrosswordInputState({
    this.selectedCell,
    this.direction = model.Direction.across,
  });
  
  CrosswordInputState copyWith({
    model.Location? selectedCell,
    model.Direction? direction,
  }) {
    return CrosswordInputState(
      selectedCell: selectedCell ?? this.selectedCell,
      direction: direction ?? this.direction,
    );
  }
  
  CrosswordInputState clearSelection() {
    return const CrosswordInputState();
  }
  
  CrosswordInputState toggleDirection() {
    return CrosswordInputState(
      selectedCell: selectedCell,
      direction: direction == model.Direction.across 
          ? model.Direction.down 
          : model.Direction.across,
    );
  }
}

@Riverpod(keepAlive: true)
class CrosswordInput extends _$CrosswordInput {
  @override
  CrosswordInputState build() {
    return const CrosswordInputState();
  }
  
  void selectCell(model.Location location) {
    debugPrint('📍 Celda seleccionada: ${location.prettyPrint()}');
    state = state.copyWith(selectedCell: location);
  }
  
  void toggleDirection() {
    debugPrint('🔄 Dirección cambiada: ${state.direction == model.Direction.across ? "down" : "across"}');
    state = state.toggleDirection();
  }
  
  void clearSelection() {
    debugPrint('❌ Selección limpiada');
    state = state.clearSelection();
  }
  
  void setDirection(model.Direction direction) {
    if (state.direction != direction) {
      state = state.copyWith(direction: direction);
    }
  }
}

