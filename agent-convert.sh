if [ -z "$1" ] 
  then
  echo "INPUT_PATH not supplied."
  echo ""
  echo "Please provide an input path:"
  echo "./agent-convert INPUT_PATH EXPORT_NAME"
  exit 1
fi

if [ -z "$2" ] 
  then
  echo "Please provide a name for the export."
  echo ""
  echo "./agent-convert INPUT_PATH EXPORT_NAME"
  exit 1
fi

INPUT_PATH=$1
OUTPUT_NAME="$2.agent"
OUTPUT_SPRITES_PATH="$OUTPUT_NAME/sprites"
OUTPUT_SOUNDS_PATH="$OUTPUT_NAME/sounds"
SPRITE_MAP_MAX_WIDTH=4096

echo INPUT_PATH: $INPUT_PATH
echo OUTPUT_NAME: $OUTPUT_NAME
echo OUTPUT_SPRITES_PATH: $OUTPUT_SPRITES_PATH
echo OUTPUT_SOUNDS_PATH: $OUTPUT_SOUNDS_PATH
echo SPRITE_MAP_MAX_WIDTH: $SPRITE_MAP_MAX_WIDTH

# Create directory
mkdir -p $OUTPUT_NAME
mkdir -p $OUTPUT_SPRITES_PATH
mkdir -p $OUTPUT_SOUNDS_PATH

# Convert all BMP-files that start with a number to PNG
convert $INPUT_PATH/Images/[0-9]*.bmp -channel rgba -alpha set -fill none -draw 'color 0,0 replace' $OUTPUT_SPRITES_PATH/%04d.png

# Convert Microsoft WAVE to MP3
i=0
for f in $INPUT_PATH/Audio/*.wav
  do ffmpeg -y -i "$f" "${OUTPUT_SOUNDS_PATH}/${OUTPUT_NAME}_${i%.*}.mp3"
  i=$((i+1))
done

# Get sprite width
SPRITE_WIDTH=`identify -format '%w' "${OUTPUT_SPRITES_PATH}/0000.png"`

# Found out, how many sprites fit in one row.
# Maximum width is defined in SPRITE_MAP_MAX_WIDTH
SPRITES_PER_ROW=`expr $SPRITE_MAP_MAX_WIDTH / $SPRITE_WIDTH`

# Create sprite map
montage -tile "${SPRITES_PER_ROW}x0" -geometry +0+0 -background none $OUTPUT_SPRITES_PATH/*.png ${OUTPUT_NAME}/${OUTPUT_NAME}_sprite_map.png
rm -rf $OUTPUT_SPRITES_PATH

# Copy character definitions and convert to something Swift can read
iconv -f ISO-8859-1 -t UTF-8//TRANSLIT $INPUT_PATH/*.acd > ${OUTPUT_NAME}/${OUTPUT_NAME}.acd
