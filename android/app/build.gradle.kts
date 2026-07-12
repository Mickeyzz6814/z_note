import java.io.FileInputStream
import java.util.Properties


plugins {

    id("com.android.application")

    id("dev.flutter.flutter-gradle-plugin")
}



// --------------------------------
// Load keystore properties
// --------------------------------

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



// --------------------------------
// Android
// --------------------------------

android {


    namespace =
        "com.mickeyzz.z_note"


    compileSdk =
        flutter.compileSdkVersion


    ndkVersion =
        flutter.ndkVersion



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



    // --------------------------------
    // Signing Config
    // --------------------------------

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



                println(
                    "===== Release APK will be signed ====="
                )


            } else {


                println(
                    "===== WARNING: No release keystore, building unsigned APK ====="
                )

            }
        }
    }





    // --------------------------------
    // Build Types
    // --------------------------------

    buildTypes {


        getByName("release") {



            if (hasReleaseKeystore) {


                signingConfig =
                    signingConfigs.getByName("release")


            } else {


                // 不设置 signingConfig
                // 输出 unsigned release APK

                println(
                    "===== Release APK is unsigned ====="
                )
            }





            // R8 optimization

            isMinifyEnabled =
                true



            // Remove unused resources

            isShrinkResources =
                true





            proguardFiles(

                getDefaultProguardFile(
                    "proguard-android-optimize.txt"
                ),


                "proguard-rules.pro"
            )
        }
    }
}




// --------------------------------
// Kotlin
// --------------------------------

kotlin {


    compilerOptions {


        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17

    }
}




// --------------------------------
// Flutter
// --------------------------------

flutter {


    source =
        "../.."

}
