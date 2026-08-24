// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license.
// found in the LICENSE file.

pluginManagement {
    val flutterSdkPath =
        run {
            val env = System.getenv("FLUTTER_ROOT")
            if (env != null) {
                env
            } else {
                val properties = java.util.Properties()
                file("local.properties").inputStream().use { properties.load(it) }
                val sdk = properties.getProperty("flutter.sdk")
                require(sdk != null) { "flutter.sdk not set in local.properties or environment" }
                sdk
            }
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

buildscript {
    dependencyLocking {
        lockFile = file("${rootProject.projectDir}/buildscript-gradle.lockfile")
        lockAllConfigurations()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.12.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
    id("com.google.firebase.crashlytics") version "3.0.8" apply false
}

include(":app")
