#!/usr/bin/env bash
set -euo pipefail

# Patch outdated plugins in pub cache for Flutter 3.47.1 compatibility
# Fixes: v1 embedding API removal, AGP8.x namespace requirements,
#        deprecated package= in manifests, and google_fonts const issues.

CACHE="$HOME/.pub-cache/hosted/pub.dev"

python3 << 'PYEOF'
import os
import re
from pathlib import Path

CACHE = Path(os.environ.get("CACHE", os.path.expanduser("~/.pub-cache/hosted/pub.dev")))

def patch_namespace(pkg_dir):
    """Add namespace to build.gradle if missing."""
    bg = pkg_dir / "build.gradle"
    if not bg.exists():
        return False
    content = bg.read_text()
    if "namespace" in content:
        return False
    if "android {" in content:
        group_match = re.search(r"group\s+'([^']+)'", content)
        namespace = group_match.group(1) if group_match else "com.example.plugin"
        content = content.replace(
            "android {\n",
            f"android {{\n    namespace '{namespace}'\n",
            1
        )
        bg.write_text(content)
        print(f"  Patched namespace in {pkg_dir.name}")
        return True
    return False

def patch_manifest(pkg_dir):
    """Remove package= attribute from AndroidManifest.xml."""
    manifest = pkg_dir / "src/main/AndroidManifest.xml"
    if not manifest.exists():
        return False
    content = manifest.read_text()
    if 'package=' not in content:
        return False
    content = re.sub(r'\s+package="[^"]+"', '', content)
    manifest.write_text(content)
    print(f"  Patched manifest in {pkg_dir.name}")
    return True

def patch_geolocator(pkg_dir):
    """Remove v1 embedding registerWith and pluginRegistrar."""
    java_file = pkg_dir / "src/main/java/com/baseflow/geolocator/GeolocatorPlugin.java"
    if not java_file.exists():
        return False
    content = java_file.read_text()
    modified = False

    old_field = '''  @SuppressWarnings("deprecation")
  @Nullable
  private io.flutter.plugin.common.PluginRegistry.Registrar pluginRegistrar;
'''
    if old_field in content:
        content = content.replace(old_field, '')
        modified = True

    pattern = r'''  // This static function is optional and equivalent to onAttachedToEngine\..*?
  public static void registerWith\(io\.flutter\.plugin\.common\.PluginRegistry\.Registrar registrar\) \{[^}]*\{[^}]*\}[^}]*\}
'''
    content_new = re.sub(pattern, '', content, flags=re.DOTALL)
    if content_new != content:
        content = content_new
        modified = True

    old_method = '''  private void registerListeners() {
    if (pluginRegistrar != null) {
      pluginRegistrar.addActivityResultListener(this.geolocationManager);
      pluginRegistrar.addRequestPermissionsResultListener(this.permissionManager);
    } else if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }'''
    new_method = '''  private void registerListeners() {
    if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }'''
    if old_method in content:
        content = content.replace(old_method, new_method)
        modified = True

    if modified:
        java_file.write_text(content)
        print(f"  Patched GeolocatorPlugin.java in {pkg_dir.name}")
    return modified

def patch_google_fonts(pkg_root):
    """Fix const map using FontWeight in pure Dart package."""
    variant_file = pkg_root / "lib" / "src" / "google_fonts_variant.dart"
    if not variant_file.exists():
        return False
    content = variant_file.read_text()
    if "const _fontWeightToFilenameWeightParts" in content:
        content = content.replace("const _fontWeightToFilenameWeightParts", "final _fontWeightToFilenameWeightParts")
        variant_file.write_text(content)
        print(f"  Patched google_fonts_variant.dart in {pkg_root.name}")
        return True
    return False

patched_count = 0

# 1. Patch Android plugin packages (those with android/ directory)
for pkg_dir in sorted(CACHE.glob("*-*/android")):
    pkg_name = pkg_dir.parent.name
    try:
        modified = False
        bg = pkg_dir / "build.gradle"
        if bg.exists() and "com.android.library" in bg.read_text():
            if patch_namespace(pkg_dir):
                modified = True
            if patch_manifest(pkg_dir):
                modified = True
        if "geolocator_android" in pkg_name and patch_geolocator(pkg_dir):
            modified = True
        if modified:
            patched_count += 1
    except Exception as e:
        print(f"  Warning: failed to patch {pkg_name}: {e}")

# 2. Patch pure Dart packages that have known issues
for pkg_root in sorted(CACHE.glob("*-*/")):
    if not pkg_root.is_dir():
        continue
    # Skip if already handled above (has android dir)
    if (pkg_root / "android").exists():
        continue
    if patch_google_fonts(pkg_root):
        patched_count += 1

print(f"\nPatched {patched_count} plugins")
PYEOF

echo "v1 embedding and namespace patches applied successfully"
