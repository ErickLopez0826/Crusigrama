# 🔊 Configuración de Audio y Ícono

## 🎵 Archivos de Audio (Opcional)

El juego usa **flutter_soloud** que puede generar sonidos procedurales automáticamente, pero también puedes agregar tus propios archivos de audio para una mejor experiencia.

### Ubicación de Archivos de Audio

Coloca tus archivos en `assets/sounds/`:

```
assets/
└── sounds/
    ├── background.wav     (Música de fondo - opcional)
    ├── victory.wav        (Sonido de victoria - opcional)
    ├── selection.wav      (Sonido de selección - opcional)
    └── hint.wav          (Sonido de pista - opcional)
```

### Sonidos Generados Proceduralmente

Si no agregas archivos, el juego genera sonidos automáticamente usando:
- **Victoria**: Secuencia ascendente de notas (fanfarria)
- **Selección**: Tono cuadrado suave
- **Pista**: Tono triangular
- **Error**: Tono de sierra bajo

### Recursos de Audio Gratuitos

Puedes descargar sonidos gratis de:
- [Freesound.org](https://freesound.org/)
- [OpenGameArt.org](https://opengameart.org/)
- [Mixkit.co](https://mixkit.co/free-sound-effects/)

Formatos soportados: WAV, MP3, OGG, FLAC

## 📱 Configuración del Ícono de la Aplicación

### Opción 1: Usando flutter_launcher_icons (Recomendado)

1. Agrega la dependencia al `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.2
```

2. Agrega configuración en `pubspec.yaml`:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#4A6FA5"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
```

3. Crea tu ícono (1024x1024 px) en `assets/icon/icon.png`

4. Genera los íconos:

```bash
dart run flutter_launcher_icons
```

### Opción 2: Manual

**Android:**
- Coloca íconos en `android/app/src/main/res/mipmap-*/ic_launcher.png`
- Tamaños: hdpi (72x72), mdpi (48x48), xhdpi (96x96), xxhdpi (144x144), xxxhdpi (192x192)

**iOS:**
- Usa Xcode para agregar íconos en `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Opción 3: Online

Usa herramientas online para generar todos los tamaños automáticamente:
- [AppIcon.co](https://www.appicon.co/)
- [MakeAppIcon.com](https://makeappicon.com/)

## 🎮 Controles de Audio en el Juego

En el menú de configuración (⚙️) encontrarás:
- 🎵 **Música de Fondo**: Activa/Desactiva
- 🔊 **Efectos de Sonido**: Activa/Desactiva

Los estados se guardan automáticamente durante la sesión.

## 🎨 Sugerencias de Diseño de Ícono

Para un juego de crucigramas:
- Usa una cuadrícula de letras
- Colores azul grisáceo (matching el tema)
- Letra destacada (ej: "C" de Crossword)
- Fondo simple y limpio
- Versiones light y dark

Ejemplo de concepto:
```
┌─────────────┐
│ C R O S S   │
│   W         │
│   O         │
│   R         │
│   D         │
└─────────────┘
```

