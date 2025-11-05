# 📱 Instrucciones para Crear el Ícono de la App

## Paso 1: Crear el Ícono

Crea una imagen de 1024x1024 px con tu diseño de ícono y guárdala como `icon.png` en este directorio.

### Sugerencias de Diseño para Crucigramas:

**Opción 1: Cuadrícula Simple**
- Fondo azul grisáceo (#607D8B)
- Cuadrícula blanca 3x3
- Letra "C" destacada en el centro

**Opción 2: Letras Cruzadas**
- Letras "CROSS" horizontal
- Letra "WORD" vertical cruzándose
- Fondo gradiente

**Opción 3: Puzzle Visual**
- Cuadrícula de crucigrama minimalista
- Algunas celdas llenas, otras vacías
- Estilo moderno y limpio

## Paso 2: Configurar pubspec.yaml

Ya está configurado en el archivo principal. Deberías ver:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
  adaptive_icon_background: "#607D8B"
  adaptive_icon_foreground: "assets/icon/icon_foreground.png"
```

## Paso 3: Generar los Íconos

Una vez que tengas tu `icon.png`, ejecuta:

```bash
dart run flutter_launcher_icons
```

Esto generará automáticamente todos los tamaños necesarios para:
- Android (todas las densidades)
- iOS (todos los tamaños)

## 🎨 Herramientas Recomendadas

### Para Crear Íconos:
- **Figma** (online, gratis)
- **Canva** (online, gratis)
- **Photoshop** / **GIMP** (desktop)
- **Inkscape** (vector, gratis)

### Para Generar desde Diseño:
- [AppIcon.co](https://www.appicon.co/) - Genera todos los tamaños
- [MakeAppIcon.com](https://makeappicon.com/) - Generador automático

## 📐 Especificaciones Técnicas

### Android:
- **Ícono Adaptivo**: Soportado (foreground + background)
- **Tamaños**: mdpi a xxxhdpi
- **Formato**: PNG con transparencia

### iOS:
- **Tamaños**: 20pt a 1024pt
- **Múltiples densidades**: @1x, @2x, @3x
- **Formato**: PNG sin transparencia (iOS App Store)

## 🚀 Inicio Rápido

Si no tienes un diseño personalizado, usa un generador online:

1. Ve a https://www.appicon.co/
2. Sube un logo simple o texto
3. Descarga el paquete generado
4. Copia `icon.png` a este directorio
5. Ejecuta `dart run flutter_launcher_icons`

¡Listo! 🎉

