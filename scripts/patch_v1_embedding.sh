#!/usr/bin/env bash
set -euo pipefail

# Patch outdated plugins in pub cache for Flutter 3.47.1 compatibility
# Fixes: v1 embedding API removal (PluginRegistry.Registrar deleted)
#        and AGP8.x namespace requirements

CACHE="$HOME/.pub-cache/hosted/pub.dev"

echo "Patching geolocator_android..."
python3 - "$CACHE" << 'PYEOF'
from pathlib import Path
import sys
cache = sys.argv[1]
p = Path(f"{cache}/geolocator_android-4.3.1/android/src/main/java/com/baseflow/geolocator/GeolocatorPlugin.java")
if p.exists():
    c = p.read_text()
    c = c.replace('''  @SuppressWarnings("deprecation")
  @Nullable
  private io.flutter.plugin.common.PluginRegistry.Registrar pluginRegistrar;
''', '')
    c = c.replace('''  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    GeolocatorPlugin geolocatorPlugin = new GeolocatorPlugin();
    geolocatorPlugin.pluginRegistrar = registrar;
    geolocatorPlugin.registerListeners();

    MethodCallHandlerImpl methodCallHandler =
        new MethodCallHandlerImpl(
            geolocatorPlugin.permissionManager,
            geolocatorPlugin.geolocationManager,
            geolocatorPlugin.locationAccuracyManager);
    methodCallHandler.startListening(registrar.context(), registrar.messenger());
    methodCallHandler.setActivity(registrar.activity());

    StreamHandlerImpl streamHandler = new StreamHandlerImpl(geolocatorPlugin.permissionManager);
    streamHandler.startListening(registrar.context(), registrar.messenger());

    LocationServiceHandlerImpl locationServiceHandler = new LocationServiceHandlerImpl();
    locationServiceHandler.startListening(registrar.context(), registrar.messenger());
    locationServiceHandler.setContext(registrar.activeContext());
    geolocatorPlugin.bindForegroundService(registrar.activeContext());
  }

''', '')
    c = c.replace('''  private void registerListeners() {
    if (pluginRegistrar != null) {
      pluginRegistrar.addActivityResultListener(this.geolocationManager);
      pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
    } else if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }''', '''  private void registerListeners() {
    if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }''')
    p.write_text(c)
    print("Patched geolocator_android-4.3.1")

p2 = Path(f"{cache}/flutter_compass-0.7.0/android/build.gradle")
if p2.exists():
    c = p2.read_text()
    c = c.replace('    compileSdkVersion 30', "    namespace 'com.hemanthraj.fluttercompass'\n    compileSdkVersion 34")
    p2.write_text(c)
    print("Patched flutter_compass-0.7.0 build.gradle")

p3 = Path(f"{cache}/flutter_compass-0.7.0/android/src/main/AndroidManifest.xml")
if p3.exists():
    c = p3.read_text()
    c = c.replace('  package="com.hemanthraj.fluttercompass">', '>')
    p3.write_text(c)
    print("Patched flutter_compass-0.7.0 manifest")
PYEOF

echo "v1 embedding and namespace patches applied successfully"
