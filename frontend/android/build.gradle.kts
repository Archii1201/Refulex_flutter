plugins {
    // No need to apply Android plugin here
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.3.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10")
    }
}

// ✅ Use this for all projects instead of 'allprojects'
subprojects {
    repositories {
        google()
        mavenCentral()
    }

    val newSubprojectBuildDir = rootProject.layout.buildDirectory.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
}

val newBuildDir = rootProject.layout.buildDirectory.dir("../../build")
rootProject.layout.buildDirectory.value(newBuildDir)

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}