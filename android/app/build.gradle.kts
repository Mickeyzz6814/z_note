import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}


val useReleaseKeystore =
    System.getenv("USE_RELEASE_KEYSTORE") == "true"


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")


if (useReleaseKeystore && keystorePropertiesFile.exists()) {
    keystoreProperties.load(
        FileInputStream(keystorePropertiesFile)
    )
}


android {

    namespace = "com.mickeyzz.z_note"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }


    defaultConfig {

        applicationId = "com.mickeyzz.z_note"

        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode

        versionName = flutter.versionName
    }



    signingConfigs {


        create("release") {


            if (useReleaseKeystore) {


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
            }
        }
    }



    buildTypes {


        getByName("release") {


            if (useReleaseKeystore) {

                signingConfig =
                    signingConfigs.getByName("release")

            } else {

                signingConfig =
                    signingConfigs.getByName("debug")
            }


            // 开启 R8 混淆
            isMinifyEnabled = true

            // 删除无用资源
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



kotlin {
    compilerOptions {
        jvmTarget =
            org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}



flutter {
    source = "../.."
}
