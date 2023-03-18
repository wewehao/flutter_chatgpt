#Specify the compression level
-optimization passes 5

# Do not skip class members of non-public libraries
-dontskipnonpubliclibraryclassmembers

# The algorithm used when confusing
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

# Confuse the method names in the obfuscated class
-useuniqueclassmembernames

#Specify not to ignore classes of non-public libraries
-dontskipnonpubliclibraryclasses

#Do not do pre-inspection, preverify is one of the four major steps of proguard, which can speed up the confusion
#-dontpreverify

# ignore warning(?)
#-ignorewarnings

#Do not use mixed case when confusing, the class name after confusion is lowercase (case confusion can easily cause class files to overwrite each other)
-dont use mixed case classnames

#Optimization allows access and modification of classes and members of classes with modifiers
-allow access modification

#Rename the file source to the "SourceFile" string
#-renamesourcefileattribute SourceFile
# keep the line number
-keepattributes SourceFile,LineNumberTable
#keep generic
-keepattributes Signature
# keep annotations
-keepattributes *Annotation*,InnerClasses

# Keep test related code
-dontnote junit.framework.**
-dontnote junit.runner.**
-dont warn android.test.**
-dont warn android.support.test.**
-dont warn org.junit.**