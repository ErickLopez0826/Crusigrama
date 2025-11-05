# 🚀 Inicio Rápido - Crossword Puzzle Game

## ⚡ Instalación y Ejecución (3 pasos)

### 1️⃣ Instalar Dependencias

```bash
flutter pub get
```

### 2️⃣ Generar Código

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3️⃣ Ejecutar

```bash
# En Chrome (Web)
flutter run -d chrome

# En Android/iOS
flutter run

# En Windows
flutter run -d windows
```

## 🎮 Primeros Pasos

### Al Iniciar la App

1. **Verás la generación del puzzle**
   - Puntos (•) animándose
   - Música de fondo empezará automáticamente
   - Espera 5-30 segundos según tamaño

2. **Cuando esté listo**
   - Cronómetro inicia automáticamente
   - Panel de pistas en esquina superior izquierda
   - Cuadrícula lista para jugar

3. **Para Jugar**
   - Haz click en cualquier celda
   - Selecciona una palabra del menú
   - Completa todas las palabras

4. **¡Victoria!**
   - Sonido orquestal de victoria
   - Estadísticas completas
   - Verifica si batiste récords

## 🎵 Controles de Audio

### Desactivar/Activar Audio

1. Click en el icono ⚙️ (configuración)
2. Selecciona:
   - "Desactivar Música" / "Activar Música"
   - "Desactivar Efectos" / "Activar Efectos"

## 🎯 Cambiar Tamaño del Puzzle

1. Click en ⚙️
2. Selecciona tamaño:
   - **Small** (20×11) - Ideal para principiantes - ~5s de generación
   - **Medium** (40×22) - Balanceado - ~25s de generación ⭐ Recomendado
   - **Large** (80×44) - Desafío - ~1-2 min de generación
   - **XLarge** / **XXLarge** - Para expertos

## 💡 Usar Pistas

1. Click en cualquier celda del puzzle
2. Selecciona "Revelar Palabra (-50 pts)"
3. La palabra correcta aparecerá automáticamente
4. Penalización de 50 puntos por pista

## 🏆 Batir Récords

### Estrategias para Máxima Puntuación

1. **No Usar Pistas**: Cada pista = -50 puntos
2. **Ser Rápido**: 
   - Bonus de +500 pts si completas en < 2 minutos
   - -1 punto por cada segundo después de 30s
3. **Empezar con Small/Medium**: Más fácil batir récords

### Ver Récords Actuales

Los récords se muestran:
- En el cronómetro durante el juego
- En la pantalla de victoria después de completar
- Separados por tamaño de puzzle

## 🔧 Solución de Problemas

### No Suena el Audio

1. Verifica que el audio esté activado en el menú
2. Revisa el volumen del dispositivo
3. Reinicia la app

### Generación Muy Lenta

1. Prueba con tamaños más pequeños (Small o Medium)
2. El tamaño Large+ puede tomar varios minutos
3. Es normal - el algoritmo es complejo

### App No Inicia

```bash
# Limpiar y reconstruir
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## 📊 Ejemplo de Sesión de Juego

```
1. Inicio → Música de fondo comienza
2. Generación → 25s (Medium)
3. Puzzle listo → Cronómetro inicia
4. Juego → Completas 30/35 palabras
5. Usas 2 pistas → -100 puntos
6. Tiempo final → 1:45
7. Puntuación → 4,525 puntos
8. ¡Nuevo récord! ⭐
9. Sonido de victoria → 🎺
10. Click "Nuevo Puzzle" → Repite
```

## 🎨 Interfaz Rápida

```
┌──────────────────────────────────────┐
│  Crossword Puzzle           ⚙️      │
├──────────────────────────────────────┤
│                                      │
│  💡 Pistas: 2         ⏱️ 1:45       │
│  -100 pts           Récord: 1:20    │
│                                      │
│     [Cuadrícula del Crucigrama]     │
│                                      │
│  Click en celda → Menú aparece      │
│                                      │
└──────────────────────────────────────┘
```

## 🎯 Tips Rápidos

- 💡 Usa pistas estratégicamente (solo cuando estés atascado)
- ⏱️ El cronómetro corre - ¡sé eficiente!
- 🎵 La música ayuda a concentrarse
- 📊 Los récords son por tamaño - cada tamaño es un desafío diferente
- 🔄 Practica con Small antes de intentar Large+

---

¡Diviértete jugando! 🎮🎯

