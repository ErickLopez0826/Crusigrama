# 🎮 Crossword Puzzle Generator

Un generador y juego de crucigramas completamente funcional construido con Flutter, con algoritmos avanzados de backtracking, procesamiento paralelo y características de juego completas.

## ✨ Características

### 🎯 Generación de Crucigramas
- ✅ Algoritmo de backtracking inteligente
- ✅ Paralelización con múltiples workers (1-128)
- ✅ 5 tamaños de puzzle (20×11 hasta 500×500)
- ✅ Generación rápida (~5s para small, ~25s para medium)
- ✅ Validación completa de reglas de crucigrama inglés
- ✅ 267,751 palabras del diccionario SOWPODS

### 🎮 Mecánica de Juego
- ✅ **Sistema de Pistas**: Revela palabras completas (-50 pts cada una)
- ✅ **Temporizador en Tiempo Real**: Actualización cada frame
- ✅ **Sistema de Puntuación**: Basado en velocidad, precisión y pistas
- ✅ **Récords Persistentes**: Guarda mejores puntuaciones y tiempos por tamaño
- ✅ **Palabras Alternativas**: 5 opciones por cada ubicación (1 correcta + 4 alternativas)
- ✅ **Validación Automática**: Solo permite selecciones válidas
- ✅ **Detección de Victoria**: Transición automática a pantalla de victoria

### 🔊 Sistema de Audio
- ✅ **Música de Fondo**: Loop continuo de música relajante (toggle on/off)
- ✅ **Sonido de Victoria**: Orquesta triunfal al completar puzzle
- ✅ **Sonido de Derrota**: Game over (reservado para futuro)
- ✅ **Sonido de Selección**: Feedback al elegir palabra
- ✅ **Sonido de Pista**: Feedback al revelar palabra
- ✅ **Audio Procedural**: Genera sonidos automáticamente con SoLoud si faltan archivos
- ✅ **Controles Independientes**: Música y efectos por separado
- ✅ **Motor SoLoud**: Audio de alto rendimiento y baja latencia

### 🎨 Interfaz
- ✅ Visualización en cuadrícula con scroll bidimensional
- ✅ Animaciones suaves para todas las transiciones
- ✅ Menús contextuales intuitivos
- ✅ Tema moderno azul grisáceo
- ✅ Responsive y fluido (60 FPS)

## 🚀 Inicio Rápido

### Instalación

```bash
# Clonar o navegar al proyecto
cd crusigrama

# Instalar dependencias
flutter pub get

# Generar código
dart run build_runner build --delete-conflicting-outputs

# Ejecutar
flutter run
```

### Ejecutar en diferentes plataformas

```bash
# Web (Chrome)
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows
```

## 🎯 Cómo Jugar

1. **Selecciona un Tamaño**
   - Abre el menú de configuración (⚙️)
   - Elige entre: Small, Medium, Large, XLarge, XXLarge
   - El puzzle se genera automáticamente

2. **Espera la Generación**
   - Verás puntos (•) animándose mientras se genera
   - Visualización en tiempo real del algoritmo
   - Small: ~5s, Medium: ~25s, Large: ~1-2min

3. **Resuelve el Puzzle**
   - Haz clic en cualquier celda con punto
   - Aparece menú con 5 opciones de palabras
   - Selecciona la palabra correcta
   - Completa todas las palabras

4. **Usa Pistas (Opcional)**
   - Clic en celda → "Revelar Palabra (-50 pts)"
   - La palabra correcta se muestra automáticamente
   - Penalización de 50 puntos por pista

5. **¡Gana!**
   - Victoria automática al completar todas las palabras
   - Ve tu puntuación final
   - ¡Intenta batir tus récords!

## 📊 Sistema de Puntuación

### Fórmula

```
Puntuación Base:         1,000 pts
+ Palabras completadas:  100 pts × número de palabras
- Pistas usadas:         50 pts × número de pistas
+ Bonus de velocidad:    500 pts (si < 2 minutos)
- Penalización tiempo:   1 pt por segundo > 30s
────────────────────────────────────────────
= Puntuación Final       (mínimo 0)
```

### Ejemplo

```
Puzzle Medium (35 palabras)
Tiempo: 1:45 (105 segundos)
Pistas: 2

Cálculo:
  1,000  (base)
+ 3,500  (35 palabras)
-   100  (2 pistas)
+   500  (bonus < 2 min)
-    75  (105 - 30 = 75 segundos)
──────
= 4,825 puntos
```

## 🏆 Récords

El juego guarda automáticamente:
- 🎯 **Mejor Puntuación** por cada tamaño
- ⏱️ **Mejor Tiempo** por cada tamaño
- 💾 **Persistencia** con SharedPreferences
- ⭐ **Indicadores** de nuevos récords

## 🎵 Configuración de Audio

### Controles en el Menú

- 🎵 **Música de Fondo**: Toggle on/off
- 🔊 **Efectos de Sonido**: Toggle on/off

### Sonidos Incluidos

1. **Victoria** - Fanfarria ascendente (4 notas)
2. **Selección** - Tono cuadrado suave
3. **Pista** - Tono triangular
4. **Música de Fondo** - Loop continuo (opcional)

### Agregar Sonidos Personalizados

Coloca archivos WAV/MP3 en `assets/sounds/`:
- `background.wav` - Música de fondo
- `victory.wav` - Sonido de victoria
- `selection.wav` - Sonido de selección
- `hint.wav` - Sonido de pista

Ver `AUDIO_SETUP.md` para más detalles.

## 🎨 Personalizar Ícono

1. Crea un ícono 1024×1024 px
2. Guárdalo como `assets/icon/icon.png`
3. Ejecuta: `dart run flutter_launcher_icons`

Ver `assets/icon/ICON_INSTRUCTIONS.md` para guía detallada.

## 🏗️ Arquitectura Técnica

### Tecnologías Clave

- **Flutter 3.35.6** - Framework UI
- **Riverpod 2.6.1** - Gestión de estado
- **built_value/built_collection** - Estructuras inmutables
- **flutter_soloud 3.4.1** - Motor de audio
- **shared_preferences** - Persistencia local
- **two_dimensional_scrollables** - Cuadrícula de alto rendimiento

### Patrones Implementados

- ✅ **Backtracking con Cola de Trabajo** - Búsqueda inteligente
- ✅ **Procesamiento Paralelo** - Múltiples isolates
- ✅ **Estructuras Inmutables** - Eficiencia de memoria
- ✅ **Provider Pattern** - Estado reactivo
- ✅ **Trampoline Functions** - Evitar closures en isolates
- ✅ **Optimización de Renderizado** - Límites de actualización con .select()

### Estructura del Proyecto

```
lib/
├── audio_service.dart           # Gestión de audio con SoLoud
├── game_stats.dart              # Temporizador y récords
├── isolates.dart                # Algoritmo de backtracking paralelo
├── model.dart                   # Modelos de datos inmutables
├── providers.dart               # Providers de Riverpod
├── utils.dart                   # Extensiones útiles
├── main.dart                    # Punto de entrada
└── widgets/
    ├── crossword_puzzle_app.dart        # App principal
    ├── crossword_generator_widget.dart  # Pantalla de generación
    ├── crossword_puzzle_widget.dart     # Pantalla de juego
    ├── puzzle_completed_widget.dart     # Pantalla de victoria
    ├── game_timer_widget.dart           # Widget de cronómetro
    └── hint_system_widget.dart          # Panel de pistas

assets/
├── words.txt                    # 267,751 palabras SOWPODS
├── sounds/                      # Archivos de audio (opcional)
└── icon/                        # Íconos de la app (generados)
```

## 🧠 Algoritmo de Generación

### Proceso de Backtracking

1. **Inicialización**: Crea `WorkQueue` con primera palabra
2. **Búsqueda Dirigida**: Identifica puntos de intersección válidos
3. **Procesamiento Paralelo**: N workers buscan palabras simultáneamente
4. **Validación**: Solo agrega palabras que cumplen restricciones
5. **Actualización**: Regenera cola de trabajo con nuevas ubicaciones
6. **Repetición**: Continúa hasta llenar ~54% de la cuadrícula

### Optimizaciones

- 🎯 Solo busca en ubicaciones con potencial de intersección
- 🔍 Filtra palabras por carácter requerido
- 💾 Comparte memoria entre estados (inmutabilidad)
- ⚡ Usa compute() para evitar bloquear UI
- 🔄 Múltiples workers exploran en paralelo

## 📈 Rendimiento

### Tiempos de Generación (4 workers)

| Tamaño | Dimensiones | Palabras | Tiempo Típico |
|--------|-------------|----------|---------------|
| Small | 20 × 11 | ~15 | 5s |
| Medium | 40 × 22 | ~35 | 25s |
| Large | 80 × 44 | ~70 | 1:30 |
| XLarge | 160 × 88 | ~140 | 5:00 |
| XXLarge | 500 × 500 | ~1000 | 30:00 |

### Escalabilidad de Workers

- **1 worker**: Baseline (1x)
- **4 workers**: ~3x más rápido ⭐ Recomendado
- **8 workers**: ~5x más rápido
- **16+ workers**: ~6x más rápido (rendimientos decrecientes)

## 🎮 Características del Juego

### Modos de Juego

- **Modo Casual**: Usa pistas libremente
- **Modo Desafío**: Sin pistas para máxima puntuación
- **Modo Velocidad**: Completa lo más rápido posible

### Estadísticas Guardadas

- Récord de puntuación (por tamaño)
- Mejor tiempo (por tamaño)
- Total de partidas jugadas
- Promedio de pistas usadas

## 🛠️ Desarrollo

### Generar Código

```bash
# Modo watch (regenera automáticamente)
dart run build_runner watch -d

# Build único
dart run build_runner build --delete-conflicting-outputs
```

### Análisis de Código

```bash
flutter analyze
```

### Tests

```bash
flutter test
```

## 📱 Configuración de Ícono

1. Crea `assets/icon/icon.png` (1024×1024 px)
2. Ejecuta:
```bash
dart run flutter_launcher_icons
```

Ver `assets/icon/ICON_INSTRUCTIONS.md` para más detalles.

## 🔊 Configuración de Audio

### Archivos de Audio Incluidos

El proyecto ya incluye archivos de audio profesionales:
- 🎵 `assets/music/audio_soloud_step_06_assets_music_looped-song.ogg` - Música de fondo
- 🏆 `assets/sounds/orchestral-win-331233.mp3` - Sonido de victoria
- 💥 `assets/sounds/game-over-38511.mp3` - Sonido de derrota

Los sonidos de selección y pistas se generan proceduralmente con SoLoud.

### Controles de Audio

En el menú de configuración (⚙️):
- 🎵 **Música de Fondo**: Activa/Desactiva
- 🔊 **Efectos de Sonido**: Activa/Desactiva

Ver `AUDIO_SETUP.md` para personalizar sonidos.

## 🤝 Contribuir

Este proyecto es un ejemplo educativo del codelab de Flutter. Siéntete libre de:
- Mejorar el algoritmo de generación
- Agregar más niveles de dificultad
- Crear temas visuales
- Optimizar el sistema de puntuación
- Agregar modo multijugador
- Implementar tutorial interactivo

## 📚 Aprendizajes Técnicos

Este proyecto demuestra:
- ✅ Procesamiento en background con isolates
- ✅ Gestión de estado avanzada con Riverpod
- ✅ Estructuras de datos inmutables eficientes
- ✅ Algoritmos de backtracking
- ✅ Optimización de rendimiento en Flutter
- ✅ Audio con flutter_soloud
- ✅ Persistencia con SharedPreferences
- ✅ Pattern matching y records de Dart 3

## 📄 Licencia

Este proyecto se basa en el codelab oficial de Flutter sobre generación de crucigramas.

## 🎉 Créditos

- **Lista de Palabras**: SOWPODS de Peter Norvig
- **Framework**: Flutter & Dart
- **Audio**: flutter_soloud
- **Tutorial Base**: Flutter Codelab - Crossword Generator

---

¡Disfruta creando y resolviendo crucigramas! 🎯🎮

## 🚀 Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en modo release (más rápido)
flutter run --release

# Ejecutar en web
flutter run -d chrome

# Limpiar build
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Ver dispositivos disponibles
flutter devices
```

## 💡 Tips y Trucos

### Para Mejor Rendimiento
- Usa 4-8 workers para generación óptima
- Empieza con puzzles Small o Medium
- Desactiva música si necesitas mejor rendimiento

### Para Máxima Puntuación
- No uses pistas
- Completa en menos de 2 minutos (bonus de 500 pts)
- Sé rápido pero preciso

### Para Depuración
- Observa la consola para logs de generación
- Activa el panel de estadísticas durante generación
- Usa flutter DevTools para análisis de rendimiento
