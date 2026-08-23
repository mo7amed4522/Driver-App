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
    lines = content.split('\n')
    result = []
    i = 0
    modified = False

    while i < len(lines):
        line = lines[i]

        # Skip the pluginRegistrar field (3 lines: annotation, annotation, field)
        if '@SuppressWarnings("deprecation")' in line and i + 2 < len(lines):
            if '@Nullable' in lines[i+1] and 'pluginRegistrar' in lines[i+2]:
                i += 3
                modified = True
                continue

        # Skip the registerWith static method (find by signature, skip until matching close brace)
        if 'public static void registerWith(' in line and 'Registrar registrar' in line:
            # Skip backwards to remove leading comment block
            comment_start = i
            while comment_start > 0 and lines[comment_start].strip().startswith('//'):
                comment_start -= 1
            # Skip blank line before comment
            if comment_start > 0 and lines[comment_start].strip() == '':
                comment_start -= 1
            # Skip @SuppressWarnings before comment
            if comment_start > 0 and '@SuppressWarnings' in lines[comment_start]:
                comment_start -= 1
            # Find the matching closing brace
            brace_count = 0
            j = i
            while j < len(lines):
                brace_count += lines[j].count('{') - lines[j].count('}')
                if brace_count == 0 and '{' in lines[i]:
                    break
                j += 1
            i = j + 1
            modified = True
            continue

        # Fix registerListeners method - remove pluginRegistrar branch
        if 'private void registerListeners()' in line:
            # Collect the method body
            method_lines = [line]
            j = i + 1
            brace_count = 1
            while j < len(lines) and brace_count > 0:
                method_lines.append(lines[j])
                brace_count += lines[j].count('{') - lines[j].count('}')
                j += 1
            # Check if it has the pluginRegistrar branch
            method_text = '\n'.join(method_lines)
            if 'pluginRegistrar' in method_text:
                # Replace with simplified version
                new_method = '''  private void registerListeners() {
    if (pluginBinding != null) {
      pluginBinding.addActivityResultListener(this.geolocationManager);
      pluginBinding.addRequestPermissionsResultListener(this.permissionManager);
    }
  }'''
                result.append(new_method)
                i = j
                modified = True
                continue
            else:
                result.extend(method_lines)
                i = j
                continue

        result.append(line)
        i += 1

    if modified:
        java_file.write_text('\n'.join(result))
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
    if (pkg_root / "android").exists():
        continue
    if patch_google_fonts(pkg_root):
        patched_count += 1

print(f"\nPatched {patched_count} plugins")
PYEOF

echo "v1 embedding and namespace patches applied successfully"
