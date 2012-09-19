#!/bin/sh
# see bash parameters process
# 1, http://www.ibm.com/developerworks/library/l-bash-parameters/index.html
# $1 - root input folder [our folder in iphone - /Users/llv22/Documents/i058959_dev/08_techdev/01_zxingportable/zxing]
# $2 - target copy root folder
function cpheader(){
 for file in `find $1 -name *.h`
  do
     # processing file copying logic - 1, get subfolder path; 2, cp all file from current input folder to target
#     rootlen=`expr length $1`
     rootlen=${#1}
     subfile=${file:$rootlen}
     tfullfile=$2$subfile
#http://stackoverflow.com/questions/1529946/linux-copy-and-create-destination-dir-if-it-does-not-exist
     subfolder=`dirname $tfullfile`
     mkdir -p $subfolder && cp -rf $file $subfolder
  done
}

iParamCount="$#"
if [ $iParamCount -ne 1 ]
then
 echo "Static gen usage [executed in iphone folder]: \n\targ1 - static library output directory"
 exit 1
fi
outDir="$1"
if [ ! -d $outDir ]
then
 echo "static libary output directory doesn't exist!"
 exit 1
fi
inDir=`pwd`
inDir=`dirname $inDir`
strProject=$inDir"/iphone/ZXingWidget/ZXingWidget.xcodeproj"
if [ ! -d $strProject ]
then
 echo "ZXingWidget.xcodeproj doesn't exists, please check up"
 exit 1
fi
armRoot=$outDir"/arm.root"
if [ -d $armRoot ]
then
 rm -rf $armRoot
fi
mkdir $armRoot
armObj=$outDir"/arm.obj"
if [ -d $armObj ]
then
 rm -rf $armObj
fi
mkdir $armObj
i386Root=$outDir"/i386.root"
if [ -d $i386Root ]
then
 rm -rf $i386Root
fi
mkdir $i386Root
i386Obj=$outDir"/i386.obj"
if [ -d $i386Obj ]
then
 rm -rf $i386Obj
fi
mkdir $i386Obj
# ios - arm building
# output to /Users/llv22/Documents/i058959_dev/08_techdev/01_zxingportable/arm.root/Release-iphoneos/libZXingWidget.a
xcodebuild -project $strProject -sdk iphoneos5.1 -target ZXingWidget OBJROOT=$armObj SYMROOT=$armRoot -configuration Release
# ios - i386 building [default arch to i386]
# output to /Users/llv22/Documents/i058959_dev/08_techdev/01_zxingportable/i386.root/Release-iphonesimulator/libZXingWidget.a
xcodebuild -project $strProject -sdk iphonesimulator5.0 -target ZXingWidget OBJROOT=$i386Obj SYMROOT=$i386Root -configuration Release -arch i386
#merge for universal file
mergedFolder=$outDir"/merged"
if [ -d $mergedFolder ]
then
 rm -rf $mergedFolder
fi
mkdir $mergedFolder
strMergedFile=$mergedFolder"/libZXingWidget.a"
lipo -create $armRoot"/Release-iphoneos/libZXingWidget.a" $i386Root"/Release-iphonesimulator/libZXingWidget.a" -output $mergedFolder"/libZXingWidget.a"
#cp root header in classes folder
srcMerged=$mergedFolder"/zxingheader"
if [ -d $srcMerged ]
then
 rm -rf $srcMerged
fi
mkdir $srcMerged
# http://stackoverflow.com/questions/3290616/bash-find-chained-to-a-grep-which-then-prints - find without explict control
rootHeader=$inDir"/iphone/ZXingWidget/Classes"
cpheader $rootHeader $srcMerged
mkdir $srcMerged"/zxing"
srcMerged=$srcMerged"/zxing"
rootcoreHeader=$inDir"/cpp/core/src/zxing"
cpheader $rootcoreHeader $srcMerged
