#!/usr/bin/env bash
# Patch outdated plugins that reference deleted v1 embedding APIs.
# Run this after `flutter pub get` to fix "Build failed due to use of deleted Android v1 embedding".

set -euo pipefail

PUB_CACHE="${PUB_CACHE:-$HOME/.pub-cache}"
HOSTED="$PUB_CACHE/hosted/pub.dev"

patch_geolocator() {
  local dir="$HOSTED/geolocator_android-4.3.1"
  [ -d "$dir" ] || return 0
  local src="$dir/android/src/main/java/com/baseflow/geolocator/GeolocatorPlugin.java"
  [ -f "$src" ] || return 0

  # Remove the pluginRegistrar field
  sed -i '' '/@SuppressWarnings("deprecation")/,/private io\.flutter\.plugin\.common\.PluginRegistry\.Registrar pluginRegistrar;/d' "$src"
  # Remove the registerWith static method (from "public static void registerWith" to the closing brace)
  # Use a Python script for multi-line removal
  python3 - "$src" << 'PY'
import sys, re
path = sys.argv[1]
with open(path) as f:
    content = f.read()
# Remove the registerWith static method block
content = re.sub(
    r'  @SuppressWarnings\("deprecation"\)\s*\n\s*public static void registerWith\(.*?\n  \}\n',
    '',
    content,
    flags=re.DOTALL
)
# Remove the pluginRegistrar usage in registerListeners - replace the if/else with just the else branch
content = re.sub(
    r'  private void registerListeners\(\) \{\n    if \(pluginRegistrar != null\) \{\n      pluginRegistrar\.addActivityResultListener\(this\.geolocationManager\);\n      pluginRegistrar\.addRequestPermissionsResultListener\(this\.permissionManager\);\n    \} else if \(pluginBinding != null\) \{\n      pluginBinding\.addActivityResultListener\(this\.geolocationManager\);\n      pluginBinding\.addRequestPermissionsResultListener\(this\.permissionManager\);\n    \}\n  \}',
    '''  private void registerListeners() {
    if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }''',
    content
)
with open(path, 'w') as f:
    f.write(content)
PY
  echo "Patched geolocator_android-4.3.1"
}

patch_device_info() {
  local dir="$HOSTED/device_info-2.0.3"
  [ -d "$dir" ] || return 0
  local src="$dir/android/src/main/java/io/flutter/plugins/deviceinfo/DeviceInfoPlugin.java"
  [ -f "$src" ] || return 0

  python3 - "$src" << 'PY'
import sys, re
path = sys.argv[1]
with open(path) as f:
    content = f.read()
# Remove the registerWith static method
content = re.sub(
    r'  /\*\* Plugin registration\. \*/\s*\n  @SuppressWarnings\("deprecation"\)\s*\n  public static void registerWith\(.*?\n  \}\n',
    '',
    content,
    flags=re.DOTALL
)
with open(path, 'w') as f:
    f.write(content)
PY
  echo "Patched device_info-2.0.3"
}

patch_geolocator
patch_device_info
echo "v1 embedding patches applied successfully"
