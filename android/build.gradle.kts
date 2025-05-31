allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
}

// Remove the problematic build directory mapping
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
    