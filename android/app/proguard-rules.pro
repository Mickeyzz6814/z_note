# ==================================
# Flutter
# ==================================

-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }


# ==================================
# Android Activity
# ==================================

-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application


# ==================================
# 保留注解
# ==================================

-keepattributes *Annotation*
-keepattributes Signature


# ==================================
# Hive
# ==================================

# 保留 Hive Adapter
-keep class ** extends TypeAdapter { *; }

# 保留 Hive 生成文件
-keep class **Adapter { *; }


# ==================================
# package_info_plus
# device_info_plus
# url_launcher
# font_awesome_flutter
# ==================================

# Flutter plugin 会自动处理
# 不需要额外规则

-dontwarn com.google.android.play.core.**