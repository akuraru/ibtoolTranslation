DIR=YuorProject
ORIGIN=en
lprojs=(ja)

TARGET=$1
ORIGIN=$DIR/$ORIGIN.lproj
for lp in "${lprojs[@]}"
do
  LPROJ=$DIR/$lp.lproj
  ibtool --generate-stringsfile $LPROJ/$TARGET.strings $ORIGIN/$TARGET.storyboard
  java -jar ibtoolTranslation/listUpper.jar $LPROJ/$TARGET.strings $LPROJ/Translation.strings $LPROJ/Translation.strings
  java -jar ibtoolTranslation/ibtoolTranslation.jar $LPROJ/$TARGET.strings $LPROJ/Translation.strings $LPROJ/$TARGET.strings
  ibtool --write $LPROJ/$TARGET.storyboard -d $LPROJ/$TARGET.strings $ORIGIN/$TARGET.storyboard
done