buildscript {
    repositories {
        google()      // ✅ WAJIB ADA
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()       // ✅ tambahkan di sini juga
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
