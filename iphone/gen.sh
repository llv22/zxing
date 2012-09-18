#!/bin/sh
# see bash parameters process
# 1, http://www.ibm.com/developerworks/library/l-bash-parameters/index.html
iParamCount="$#"
if [ $iParamCount -ne 2 ]
then
 echo "Static gen usage: \n\targ0 - zxing iphone project folder;\n\targ1 - static library output directory"
 exit 1
fi
outDir="$2"
if [ ! -d $outDir ]
then
 echo "static libary output directory doesn't exist!"
 exit 1
fi
inDir="$1"
if [ ! -d $inDir ]
then
 echo "zxing iphone input project folder doesn't exist, ZXingWidget.xcodeproj should in this folder"
 exit 1
fi
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
rootHeader=$inDir"/iphone/ZXingWidget/Classes"
#shopt -s globstar
header=$rootHeader"/*.h"
cp -rf $header $srcMerged 
# actions subfolder
mkdir $srcMerged"/actions"
header=$rootHeader"/actions/*.h"
cp -rf $header $srcMerged"/actions"
# parsedResults subfolder 
mkdir $srcMerged"/parsedResults"
header=$rootHeader"/parsedResults/*.h"
cp -rf $header $srcMerged"/parsedResults"
# resultParsers subfolder
mkdir $srcMerged"/resultParsers"
header=$rootHeader"/resultParsers/*.h"
cp -rf $header $srcMerged"/resultParsers"
# cp zxing from .h to target folder
mkdir $srcMerged"/zxing"
header=$inDir"/cpp/core/src/zxing/*.h"
#echo $header
cp -rf $header $srcMerged"/zxing"
mkdir $srcMerged"/zxing/common"
header=$inDir"/cpp/core/src/zxing/common/*.h"
cp -rf $header $srcMerged"/zxing/common"
mkdir $srcMerged"/zxing/common/detector"
header=$inDir"/cpp/core/src/zxing/common/detector/*.h"
cp -rf $header $srcMerged"/zxing/common/detector"
mkdir $srcMerged"/zxing/common/reedsolomon"
header=$inDir"/cpp/core/src/zxing/common/reedsolomon/*.h"
cp -rf $header $srcMerged"/zxing/common/reedsolomon"
mkdir $srcMerged"/zxing/datamatrix"
header=$inDir"/cpp/core/src/zxing/datamatrix/*.h"
cp -rf $header $srcMerged"/zxing/datamatrix"
mkdir $srcMerged"/zxing/datamatrix/decoder"
header=$inDir"/cpp/core/src/zxing/datamatrix/decoder/*.h"
cp -rf $header $srcMerged"/zxing/datamatrix/decoder"
mkdir $srcMerged"/zxing/datamatrix/detector"
header=$inDir"/cpp/core/src/zxing/datamatrix/detector/*.h"
cp -rf $header $srcMerged"/zxing/datamatrix/detector"
#multi
mkdir $srcMerged"/zxing/multi"
header=$inDir"/cpp/core/src/zxing/multi/*.h"
cp -rf $header $srcMerged"/zxing/multi"
mkdir $srcMerged"/zxing/multi/qrcode"
header=$inDir"/cpp/core/src/zxing/multi/qrcode/*.h"
cp -rf $header $srcMerged"/zxing/multi/qrcode"
mkdir $srcMerged"/zxing/multi/qrcode/detector"
header=$inDir"/cpp/core/src/zxing/multi/qrcode/detector/*.h"
cp -rf $header $srcMerged"/zxing/multi/qrcode/detector"
#oned
mkdir $srcMerged"/zxing/oned"
header=$inDir"/cpp/core/src/zxing/oned/*.h"
cp -rf $header $srcMerged"/zxing/oned"
#qrcode
mkdir $srcMerged"/zxing/qrcode"
header=$inDir"/cpp/core/src/zxing/qrcode/*.h"
cp -rf $header $srcMerged"/zxing/qrcode"
mkdir $srcMerged"/zxing/qrcode/decoder"
header=$inDir"/cpp/core/src/zxing/qrcode/decoder/*.h"
cp -rf $header $srcMerged"/zxing/qrcode/decoder"
mkdir $srcMerged"/zxing/qrcode/detector"
header=$inDir"/cpp/core/src/zxing/qrcode/detector/*.h"
cp -rf $header $srcMerged"/zxing/qrcode/detector"

