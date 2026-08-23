#!/usr/bin/env bash
set -euo pipefail

# Patch outdated plugins in pub cache for Flutter 3.47.1 compatibility
# Fixes: v1 embedding API removal, AGP8.x namespace requirements,
#        deprecated package= in manifests, and google_fonts const issues.

CACHE="$HOME/.pub-cache/hosted/pub.dev"

python3 << 'PYEOF'
import os
import re
import subprocess
import sys
from pathlib import Path

CACHE = Path(os.environ.get("CACHE", os.path.expanduser("~/.pub-cache/hosted/pub.dev")))
PROJECT_DIR = Path("/Volumes/Untitled/projects/Driver-App")

def get_locked_packages():
    """Get list of packages in pubspec.lock that have Android sources."""
    result = subprocess.run(
        ["flutter", "pub", "deps", "--no-dev"],
        capture_output=True, text=True, cwd=PROJECT_DIR
    )
    # Also include dev dependencies for packages that might have Android code
    result2 = subprocess.run(
        ["flutter", "pub", "deps"],
        capture_output=True, text=True, cwd=PROJECT_DIR
    )
    all_output = result.stdout + result2.stdout
    
    # Parse package names from lockfile
    lockfile = PROJECT_DIR / "pubspec.lock"
    packages = set()
    if lockfile.exists():
        content = lockfile.read_text()
        for match in re.finditer(r'^  (\S+):', content, re.MULTILINE):
            name = match.group(1).split('@')[0]
            if name != 'flutter':
                packages.add(name)
    return packages

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

def patch_google_fonts(pkg_dir):
    """Fix const map using FontWeight."""
    variant_file = pkg_dir / "lib/src/google_fonts_variant.dart"
    if not variant_file.exists():
        return False
    content = variant_file.read_text()
    if "const _fontWeightToFilenameWeightParts" in content:
        content = content.replace("const _fontWeightToFilenameWeightParts", "final _fontWeightToFilenameWeightParts")
        variant_file.write_text(content)
        print(f"  Patched google_fonts_variant.dart in {pkg_dir.name}")
        return True
    return False

# Get packages used by this project
packages = get_locked_packages()
print(f"Found {len(packages)} packages in lockfile")

patched_count = 0
for pkg_dir in sorted(CACHE.glob("*-*/android")):
    pkg_name = pkg_dir.parent.name
    # Only patch packages used by this project
    base_name = pkg_name.split('-')[0]
    if base_name not in packages and pkg_name not in packages:
        # Quick check: see if any package prefix matches
        found = False
        for p in packages:
            if pkg_name.startswith(p) or p.startswith(pkg_name.split('-')[0]):
                found = True
                break
        if not found:
            continue

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
        if "google_fonts" in pkg_name and patch_google_fonts(pkg_dir):
            modified = True
        if modified:
            patched_count += 1
    except Exception as e:
        print(f"  Warning: failed to patch {pkg_name}: {e}")

print(f"\nPatched {patched_count} plugins")
PYEOF

echo "v1 embedding and namespace patches applied successfully"
