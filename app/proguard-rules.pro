# AvaCore ProGuard/R8 Rules

# Preserve Sherpa-ONNX JNI interfaces
-keep class com.k2fsa.sherpa.onnx.** { *; }
-keepclassmembers class com.k2fsa.sherpa.onnx.** { *; }

# Preserve Android TTS Service methods
-keep class com.github.opscalehub.avacore.service.AvaTtsService { *; }

# General optimizations
-dontwarn com.k2fsa.sherpa.onnx.**

# --- Fix: crash ("app jumps out") on every default-pitch speak() in release builds ---
# Sherpa-ONNX's native generateWithCallbackImpl looks the callback up by name via JNI:
#   GetMethodID(cls, "invoke", "([F)Ljava/lang/Integer;")
# R8 was renaming that method (to "b") and dropping the specialised overload, so the
# lookup failed and the process died in native code. Keep every Kotlin function-type
# implementation's invoke() exactly as compiled.
-keep interface kotlin.jvm.functions.Function1 { *; }
-keepclassmembers class * implements kotlin.jvm.functions.Function1 {
    *** invoke(...);
}
