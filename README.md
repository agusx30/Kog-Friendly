# KOG Friends

App Flutter para Android: muestra cuántos amigos de KOG están conectados y, si están en línea, el servidor y el mapa.

## Funciones

- Pegá comandos `add_friend "nombre" "clan"` de DDNet. Se importa el nombre y se ignora el clan. También acepta `add_player "nombre"`.
- Guarda la lista localmente en el dispositivo.
- Actualiza automáticamente cada 30 segundos mientras está abierta y permite actualizar a mano.
- No incluye anuncios ni analítica.

## Probar en Android

1. Instalá **Android Studio** y, durante la instalación/inicio, instalá el Android SDK recomendado.
2. En Android Studio abrí **More Actions → SDK Manager** y asegurate de tener instalados Android SDK Platform API 36 y Android SDK Platform-Tools.
3. Aceptá las licencias desde una terminal:

   ```powershell
   flutter doctor --android-licenses
   ```

4. Conectá el teléfono por USB, activá las opciones de desarrollador y **Depuración por USB**, y aceptá el permiso que aparece en el teléfono. Alternativamente, iniciá un emulador Android.
5. Desde una terminal en esta carpeta ejecutá:

   ```powershell
   flutter doctor
   flutter pub get
   flutter test
   flutter run
   ```

   Si hay más de un dispositivo conectado, `flutter devices` muestra sus identificadores y podés ejecutar `flutter run -d <id>`.

Para crear un APK de prueba que puedas copiar al teléfono:

```powershell
flutter build apk --debug
```

El APK queda en `build\app\outputs\flutter-apk\app-debug.apk`. Para instalarlo con el teléfono conectado y depuración USB activada:

```powershell
flutter install
```

Si instalás el APK manualmente, Android puede pedir que permitas instalar aplicaciones desde esa fuente. El APK debug es solo para pruebas personales; no es un paquete de publicación.

## Fuente de presencia

La app consulta `https://master1.ddnet.org/ddnet/15/servers.json`, filtra servidores de la comunidad `kog` y compara localmente los nombres sin distinguir mayúsculas. Descarga el listado público completo, no consulta jugadores individualmente. Los nombres visibles no identifican una cuenta de forma única y el estado corresponde a la última actualización correcta.
