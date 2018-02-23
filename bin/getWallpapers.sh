WALLS_DIR='/Users/njones/Pictures'
curl "www.reddit.com/r/wallpapers/" 2>/dev/null | tr \< \\n | grep -E 'https?://[^"]*\.[jpng]*"' |sed 's#.*http#http#'|sed 's#".*##' | sort -u | while read line; do
  FILENAME="$(basename $line)"
  /usr/local/bin/wget "$line" -O "${WALLS_DIR}/${FILENAME}"
done

