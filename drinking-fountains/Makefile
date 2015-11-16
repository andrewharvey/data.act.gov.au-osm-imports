# Author: Andrew Harvey (http://andrewharvey4.wordpress.com/)
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/


FILE_NAME=drinking_water
all : clean download convert

clean :
	rm -fr opendata_${FILE_NAME}.xml
	rm -f opendata_${FILE_NAME}.osm

opendata-download :
	wget -O opendata_${FILE_NAME}.xml "https://www.data.act.gov.au/api/views/8eg4-uskm/rows.xml?accessType=DOWNLOAD"

opendata-convert :
	xsltproc src/xml2osm.xsl - < opendata_${FILE_NAME}.xml > opendata_${FILE_NAME}.osm
	xsltproc src/osm-add-ids.xsl - < opendata_${FILE_NAME}.osm > opendata_${FILE_NAME}-with-id.osm
	mv opendata_${FILE_NAME}-with-id.osm opendata_${FILE_NAME}.osm

osm-dowload :
	curl --data-urlencode data@src/overpass-query.oql http://overpass-api.de/api/interpreter --output osm_${FILE_NAME}.osm

osm-convert :
	xsltproc src/osm-add-version.xsl - < osm_${FILE_NAME}.osm > osm_${FILE_NAME}_with_version.osm

to-geojson :
	osmtogeojson osm_drinking_water.osm > osm_drinking_water.geojson
	osmtogeojson opendata_drinking_water.osm > opendata_drinking_water.geojson
