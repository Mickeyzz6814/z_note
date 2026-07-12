import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}


// -------------------------
// Load keystore properties
// -------------------------

val keystoreProperties = Properties()

val keystorePropertiesFile =
    rootProject.file("key.properties")


val hasReleaseKeystore =
    keystorePropertiesFile.exists()


if (hasReleaseKeystore) {

    keystoreProperties.load(
        FileInputStream(keystorePropertiesFile)
    )
}


// -------------------------
// Android
// -------------------------

android {

    namespace = "com.mickeyzz.z_note"

    compileSdk = flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion


    compileOptions {

        sourceCompatibility =
            JavaVersion.VERSION_17

        targetCompatibility =
            JavaVersion.VERSION_17
    }



    defaultConfig {

        applicationId =
            "com.mickeyzz.z_note"

        minSdk =
            flutter.minSdkVersion

        targetSdk =
            flutter.targetSdkVersion

        versionCode =
            flutter.versionCode

        versionName =
            flutter.versionName
    }



    // -------------------------
    // Signing
    // -------------------------

    signingConfigs {


        create("release") {


            if (hasReleaseKeystore) {


                keyAlias =
                    keystoreProperties["keyAlias"] as String


                keyPassword =
                    keystoreProperties["keyPassword"] as String


                storePassword =
                    keystoreProperties["storePassword"] as String


                storeFile =
                    file(
                        keystoreProperties["storeFile"] as String
                    )


                enableV1Signing = true

                enableV2Signing = true

                enableV3Signing = true

            } else {

                throw GradleException(
                    """
                    Release keystore not found.

                    Please create key.properties
                    or provide keystore in CI.
                    """.trimIndent()
                )
            }
        }
    }



    // -------------------------
    // Build Types
    // -------------------------

    buildTypes {


        getByName("release") {


            signingConfig =
                signingConfigs.getByName("release")


            // R8
            isMinifyEnabled = true


            // Remove unused resources
            isShrinkResources = true



            proguardFiles(

                getDefaultProguardFile(
                    "proguard-android-optimize.txt"
                ),

                "proguard-rules.pro"
            )
        }
    }
}




// -------------------------
// Kotlin
// -------------------------

kotlin {

    compilerOptions {

        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}




// -------------------------
// Flutter
// -------------------------

flutter {

    source = "../.."
}
